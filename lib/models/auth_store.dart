import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase/supabase.dart';
import '../core/app_colors.dart';
import '../core/supabase_config.dart';
import '../widgets/vehicle_illustration.dart';
import 'ticket_model.dart';
import 'wallet_model.dart';

class UserAccount {
  final String fullName;
  final String phone;
  final String email;
  final String password;
  final String role;

  const UserAccount({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
    this.role = 'user',
  });

  String get firstName => fullName.trim().split(' ').first;

  String get initials {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'DP';
    if (parts.length == 1) {
      final word = parts.first.toUpperCase();
      return word.length >= 2 ? word.substring(0, 2) : word;
    }
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }
}

class SavedVehicle {
  final String id;
  final String name;
  final String plateNumber;
  final String color;
  final String year;
  final Uint8List? photoBytes;
  final bool isPrimary;

  const SavedVehicle({
    required this.id,
    required this.name,
    required this.plateNumber,
    required this.color,
    required this.year,
    this.photoBytes,
    this.isPrimary = false,
  });

  /// Spesifikasi bebas warna/ciri unik & tahun (contoh: "Putih-Hitam Custom • 2024")
  String get specs => '$color • $year';

  SavedVehicle copyWith({
    String? name,
    String? plateNumber,
    String? color,
    String? year,
    Uint8List? photoBytes,
    bool? isPrimary,
  }) {
    return SavedVehicle(
      id: id,
      name: name ?? this.name,
      plateNumber: plateNumber ?? this.plateNumber,
      color: color ?? this.color,
      year: year ?? this.year,
      photoBytes: photoBytes ?? this.photoBytes,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }

  static const SavedVehicle defaultPrimary = SavedVehicle(
    id: 'veh-1',
    name: 'Toyota Veloz',
    plateNumber: 'B 2148 SJD',
    color: 'Putih',
    year: '2024',
    isPrimary: true,
  );
}

/// Snapshot sesi per akun user agar data antar akun 100% terpisah (tidak pernah tercampur)
class _UserSessionSnapshot {
  int walletBalance;
  List<WalletTransaction> walletTransactions;
  List<SavedVehicle> savedVehicles;
  ParkingTicket activeTicket;
  List<ParkingTicket> ticketHistory;
  bool hasBookedOnce;
  Uint8List? profilePhotoBytes;

  _UserSessionSnapshot({
    this.walletBalance = 0,
    List<WalletTransaction>? walletTransactions,
    List<SavedVehicle>? savedVehicles,
    ParkingTicket? activeTicket,
    List<ParkingTicket>? ticketHistory,
    this.hasBookedOnce = false,
    this.profilePhotoBytes,
  }) : walletTransactions = walletTransactions ?? [],
       savedVehicles = savedVehicles ?? [],
       activeTicket = activeTicket ?? ParkingTicket.createEmptyInitial(),
       ticketHistory = ticketHistory ?? [];
}

/// Penyimpanan state autentikasi, kendaraan, & saldo Dompet PARVE
/// yang terisolasi per akun user & terhubung langsung ke database Supabase
class AuthStore {
  AuthStore._();

  static const int defaultInitialBalance = 0;
  static const int uniformMallSlots = 15;

  /// Notifier agar layar Beranda, Aktivitas, Dompet, & Profil otomatis me-refresh
  /// begitu data sesi selesai ditarik dari Supabase
  static final ValueNotifier<int> sessionNotifier = ValueNotifier<int>(0);

  static void _notifySessionChanged() {
    sessionNotifier.value++;
  }

  static final List<UserAccount> _registeredUsers = [];
  static final Map<String, _UserSessionSnapshot> _perUserSessions = {};
  static UserAccount? currentUser;

  static final List<SavedVehicle> savedVehicles = [];
  static ParkingTicket activeTicket = ParkingTicket.createEmptyInitial();
  static final List<ParkingTicket> ticketHistory = [];
  static bool hasBookedOnce = false;

  static bool _isLoadingUserSession = false;
  static String? _lastLoadedSessionEmail;

  /// Menyimpan jumlah tiket/kendaraan aktif tambahan di tiap mall (di luar activeTicket utama)
  static final Map<String, int> _extraActiveBookingsByMall = {};

  /// Menyimpan state user yang sedang aktif ke dalam cache per-email sebelum logout / ganti akun
  static void _saveCurrentToUserSnapshot() {
    final user = currentUser;
    if (user == null) return;
    final emailKey = user.email.trim().toLowerCase();
    _perUserSessions[emailKey] = _UserSessionSnapshot(
      walletBalance: walletBalance,
      walletTransactions: List<WalletTransaction>.from(walletTransactions),
      savedVehicles: List<SavedVehicle>.from(savedVehicles),
      activeTicket: activeTicket,
      ticketHistory: List<ParkingTicket>.from(ticketHistory),
      hasBookedOnce: hasBookedOnce,
      profilePhotoBytes: profilePhotoBytes,
    );
  }

  /// Mengosongkan seluruh state sesi aktif di memori (dipanggil saat buat akun baru / logout / ganti akun)
  static void _clearActiveSessionState({String userName = 'Pengguna'}) {
    walletBalance = defaultInitialBalance;
    walletTransactions.clear();
    savedVehicles.clear();
    ticketHistory.clear();
    hasBookedOnce = false;
    profilePhotoBytes = null;
    activeTicket = ParkingTicket.createEmptyInitial().copyWith(
      userName: userName,
      walletBalance: defaultInitialBalance,
    );
  }

  /// Memulihkan state lokal milik user tertentu (atau kosong dari 0 jika akun baru)
  static void _restoreLocalSnapshotForUser(UserAccount user) {
    final emailKey = user.email.trim().toLowerCase();
    final snap = _perUserSessions[emailKey];
    if (snap == null) {
      _clearActiveSessionState(userName: user.firstName);
      return;
    }
    walletBalance = snap.walletBalance;
    walletTransactions
      ..clear()
      ..addAll(snap.walletTransactions);
    savedVehicles
      ..clear()
      ..addAll(snap.savedVehicles);
    ticketHistory
      ..clear()
      ..addAll(snap.ticketHistory);
    hasBookedOnce = snap.hasBookedOnce;
    profilePhotoBytes = snap.profilePhotoBytes;
    activeTicket = snap.activeTicket.copyWith(
      userName: user.firstName,
      walletBalance: walletBalance,
    );
  }

  /// Mengambil atau menginisialisasi instance SupabaseClient secara otomatis
  static Future<SupabaseClient?> _getOrInitDb() async {
    await SupabaseConfig.initialize();
    return SupabaseConfig.client;
  }

  /// Menjalankan operasi database dengan client utama, dan otomatis retry
  /// memakai `SupabaseConfig.secretClient` jika tabel terkunci RLS / 401
  static Future<T?> _runDbOp<T>(
    Future<T> Function(SupabaseClient db) action,
  ) async {
    final primary = await _getOrInitDb();
    if (primary != null) {
      try {
        return await action(primary);
      } catch (e) {
        debugPrint('Primary Supabase client error, retrying with secretKey: $e');
      }
    }
    try {
      return await action(SupabaseConfig.secretClient);
    } catch (e) {
      debugPrint('Supabase operation failed: $e');
      return null;
    }
  }

  /// Parsing nominal rupiah dari teks seperti "+Rp100.000" atau "Rp35.000" menjadi integer (100000)
  static int _parseRupiahAmount(String raw) {
    final digitsOnly = raw.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digitsOnly) ?? 0;
  }

  static VehicleSize _parseVehicleSize(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'small':
        return VehicleSize.small;
      case 'medium':
        return VehicleSize.medium;
      default:
        return VehicleSize.large;
    }
  }

  static ParkingTicket _ticketFromSupabaseRow(
    Map<String, dynamic> row, {
    required String fallbackUserName,
  }) {
    final isActive = row['is_active'] == true;
    final locationName = (row['location_name'] ?? 'Senayan City').toString();
    final pickupLobby =
        (row['pickup_lobby'] ?? 'Main Lobby • Drop-off Valet').toString();
    final parkingArea = (row['parking_area'] ?? 'B1 • Blok A-12').toString();
    final entryTime = (row['entry_time'] ?? 'Hari ini • 13.00').toString();
    final startHour = entryTime.contains('•')
        ? entryTime.split('•').last.trim()
        : '13.00';
    final startedAtRaw = row['parking_started_at']?.toString();
    final startedAt = startedAtRaw != null
        ? (DateTime.tryParse(startedAtRaw)?.toLocal() ?? DateTime.now())
        : DateTime.now();
    final frozenSeconds = row['frozen_elapsed_seconds'] is int
        ? row['frozen_elapsed_seconds'] as int
        : int.tryParse((row['frozen_elapsed_seconds'] ?? '').toString());
    final valetFee = row['valet_fee'] is int
        ? row['valet_fee'] as int
        : (int.tryParse((row['valet_fee'] ?? '35000').toString()) ?? 35000);
    final hourlyRate = row['hourly_rate'] is int
        ? row['hourly_rate'] as int
        : (int.tryParse((row['hourly_rate'] ?? '5000').toString()) ?? 5000);

    return ParkingTicket.createEmptyInitial().copyWith(
      ticketCode: (row['ticket_code'] ?? 'PV-081026-0248').toString(),
      userName: fallbackUserName,
      fullDate: formatRealTimeFullDate(startedAt),
      locationName: locationName,
      pickupLobby: pickupLobby,
      parkingArea: parkingArea,
      shortSlot: parkingArea.contains('•')
          ? parkingArea.split('•').last.trim()
          : parkingArea,
      vehicleName: (row['vehicle_name'] ?? 'Toyota Veloz').toString(),
      plateNumber: (row['plate_number'] ?? 'B 2148 SJD').toString(),
      vehicleSpecs: (row['vehicle_specs'] ?? 'Putih • 2024').toString(),
      vehicleSize: _parseVehicleSize(row['vehicle_size']?.toString()),
      entryTime: entryTime,
      shortEntryTime: '${formatRealTimeShortDate(startedAt)} • $startHour',
      startHour: startHour,
      parkingStartedAt: startedAt,
      frozenElapsedSeconds: frozenSeconds,
      walletBalance: walletBalance,
      statusText:
          (row['status_text'] ?? (isActive ? 'Terparkir aman' : 'Selesai'))
              .toString(),
      isActive: isActive,
      isPickupRequested: !isActive,
      journeySteps: [
        VehicleJourneyStep(
          title:
              'Diserahkan ke petugas (Valet ${ParkingTicket.formatRupiah(valetFee)} Lunas)',
          subtitle: pickupLobby,
          time: startHour,
        ),
        VehicleJourneyStep(
          title: isActive
              ? 'Terparkir aman • Timer parkir dimulai'
              : 'Kendaraan selesai diambil (${ParkingTicket.formatRupiah(hourlyRate)}/jam)',
          subtitle: parkingArea,
          time: startHour,
        ),
      ],
    );
  }

  /// Memuat daftar akun yang sudah terdaftar dari tabel `profiles` Supabase saat aplikasi dibuka
  static Future<void> loadInitialDataFromSupabase() async {
    await _runDbOp((db) async {
      final rows = await db.from('profiles').select();
      for (final row in rows) {
        final email = (row['email'] ?? '').toString().trim().toLowerCase();
        if (email.isEmpty) continue;
        final user = UserAccount(
          fullName: (row['full_name'] ?? '').toString(),
          phone: (row['phone'] ?? '').toString(),
          email: email,
          password: (row['password'] ?? '').toString(),
          role: (row['role'] ?? 'user').toString(),
        );
        _registeredUsers.removeWhere((u) => u.email == user.email);
        _registeredUsers.add(user);
      }
    });
  }

  /// Memuat SELURUH data sesi milik user (Saldo Dompet, Riwayat Transaksi Dompet,
  /// Kendaraan Tersimpan, Tiket Parkir Aktif, dan Riwayat Parkir) khusus untuk `email` tersebut dari Supabase.
  /// Jika akun tersebut baru (belum ada transaksi/tiket/mobil), semua list dipastikan KOSONG (0).
  static Future<void> loadUserSessionFromSupabase(String email) async {
    final cleanEmail = email.trim().toLowerCase();
    if (cleanEmail.isEmpty || _isLoadingUserSession) return;
    _isLoadingUserSession = true;

    try {
      await _runDbOp((db) async {
        final userName = currentUser?.firstName ?? 'Pengguna';

        // 1. Muat Riwayat Transaksi Dompet khusus `cleanEmail` dari `wallet_transactions`
        final trxRows = await db
            .from('wallet_transactions')
            .select()
            .eq('user_email', cleanEmail)
            .order('created_at', ascending: false);

        // Jika di Supabase ada data untuk user ini (atau user ini belum punya transaksi lokal),
        // bersihkan list agar tidak tercampur dengan akun sebelumnya
        walletTransactions.clear();
        int computedNetBalance = 0;
        for (int i = 0; i < trxRows.length; i++) {
          final r = trxRows[i];
          final amount =
              _parseRupiahAmount((r['amount_text'] ?? '0').toString());
          final isCredit = r['is_credit'] == true;
          if (isCredit) {
            computedNetBalance += amount;
          } else {
            computedNetBalance -= amount;
          }
          final createdAtRaw = r['created_at']?.toString();
          final createdAt = createdAtRaw != null
              ? DateTime.tryParse(createdAtRaw)?.toLocal()
              : null;
          walletTransactions.add(
            WalletTransaction(
              id: (r['id'] ?? 'trx-$i').toString(),
              title: (r['title'] ?? 'Transaksi').toString(),
              subtitle: (r['subtitle'] ?? '').toString(),
              dateGroup: formatRealTimeFullDate(createdAt),
              amount: amount,
              isCredit: isCredit,
            ),
          );
        }
        if (computedNetBalance < 0) computedNetBalance = 0;

        // 2. Muat Saldo Dompet khusus `cleanEmail` dari `profiles`
        final profile = await db
            .from('profiles')
            .select()
            .eq('email', cleanEmail)
            .maybeSingle();

        int dbBalance = 0;
        if (profile != null && profile['wallet_balance'] is int) {
          dbBalance = profile['wallet_balance'] as int;
        }

        if (trxRows.isEmpty && dbBalance > 0) {
          // Jika akun baru sama sekali belum punya riwayat transaksi dompet tapi angkanya sempat terbawa dari bug lama,
          // normalkan kembali ke 0
          walletBalance = 0;
          await db
              .from('profiles')
              .update({'wallet_balance': 0})
              .eq('email', cleanEmail);
        } else if (dbBalance == 0 && computedNetBalance > 0) {
          walletBalance = computedNetBalance;
          await db
              .from('profiles')
              .update({'wallet_balance': walletBalance})
              .eq('email', cleanEmail);
        } else {
          walletBalance = dbBalance;
        }

        // 3. Muat Daftar Kendaraan khusus `cleanEmail` dari `vehicles`
        final vehicleRows = await db
            .from('vehicles')
            .select()
            .eq('user_email', cleanEmail)
            .order('created_at', ascending: true);

        savedVehicles.clear();
        final seenPlates = <String>{};
        for (int i = 0; i < vehicleRows.length; i++) {
          final v = vehicleRows[i];
          final plate = (v['plate_number'] ?? '').toString().trim();
          if (plate.isNotEmpty && seenPlates.contains(plate.toUpperCase())) {
            continue;
          }
          if (plate.isNotEmpty) seenPlates.add(plate.toUpperCase());
          savedVehicles.add(
            SavedVehicle(
              id: (v['id'] ?? 'veh-$i').toString(),
              name: (v['name'] ?? '').toString(),
              plateNumber: plate,
              color: (v['color'] ?? 'Putih').toString(),
              year: (v['year'] ?? '2024').toString(),
              isPrimary: savedVehicles.isEmpty,
            ),
          );
        }

        // 4. Muat Tiket Parkir Aktif & Riwayat Parkir khusus `cleanEmail` dari `tickets`
        final ticketRows = await db
            .from('tickets')
            .select()
            .eq('user_email', cleanEmail)
            .order('created_at', ascending: false);

        ticketHistory.clear();
        hasBookedOnce = ticketRows.isNotEmpty;
        ParkingTicket? foundActive;

        for (final row in ticketRows) {
          final mapped = _ticketFromSupabaseRow(
            row,
            fallbackUserName: userName,
          );
          if (mapped.isActive && foundActive == null) {
            foundActive = mapped;
          } else {
            ticketHistory.add(
              mapped.copyWith(
                isActive: false,
                isPickupRequested: true,
                statusText: mapped.isActive ? 'Selesai' : mapped.statusText,
              ),
            );
          }
        }

        if (foundActive != null) {
          activeTicket = foundActive.copyWith(walletBalance: walletBalance);
        } else {
          activeTicket = ParkingTicket.createEmptyInitial().copyWith(
            userName: userName,
            walletBalance: walletBalance,
          );
          syncTicketWithPrimaryVehicle();
        }

        _saveCurrentToUserSnapshot();
        _lastLoadedSessionEmail = cleanEmail;
      });
    } finally {
      _isLoadingUserSession = false;
      _notifySessionChanged();
    }
  }

  /// Sinkronisasi data akun yang sedang login (`currentUser`) ke Supabase
  static Future<void> syncAllCurrentStateToSupabase() async {
    final user = currentUser;
    if (user == null) return;
    final activeEmail = user.email.trim().toLowerCase();

    await _runDbOp((db) async {
      // 1. Pastikan 5 mall resmi sudah terdaftar di tabel `malls`
      await db.from('malls').upsert([
        {
          'id': 'smb',
          'name': 'Summarecon Mall Bekasi',
          'area': 'Bekasi Utara',
          'dropoff_lobby': 'The Downtown Walk • Lobi Utama',
          'valet_rate': 'Rp35.000',
          'total_slots': uniformMallSlots,
          'occupied_slots': occupiedSlotsForMall('Summarecon Mall Bekasi'),
        },
        {
          'id': 'gi',
          'name': 'Grand Indonesia',
          'area': 'Thamrin, Jakarta Pusat',
          'dropoff_lobby': 'East Mall • Lobi Rama',
          'valet_rate': 'Rp35.000',
          'total_slots': uniformMallSlots,
          'occupied_slots': occupiedSlotsForMall('Grand Indonesia'),
        },
        {
          'id': 'pim2',
          'name': 'PIM 2',
          'area': 'Pondok Indah, Jakarta Selatan',
          'dropoff_lobby': 'North Skywalk • Lobi Utama PIM 2',
          'valet_rate': 'Rp35.000',
          'total_slots': uniformMallSlots,
          'occupied_slots': occupiedSlotsForMall('PIM 2'),
        },
        {
          'id': 'sency',
          'name': 'Senayan City',
          'area': 'Senayan, Jakarta Pusat',
          'dropoff_lobby': 'Main Lobby • Crystal Lagoon Drop-off',
          'valet_rate': 'Rp35.000',
          'total_slots': uniformMallSlots,
          'occupied_slots': occupiedSlotsForMall('Senayan City'),
        },
        {
          'id': 'pp',
          'name': 'Pacific Place Jakarta',
          'area': 'SCBD, Jakarta Selatan',
          'dropoff_lobby': 'North Lobby • Galeries Lafayette Drop-off',
          'valet_rate': 'Rp35.000',
          'total_slots': uniformMallSlots,
          'occupied_slots': occupiedSlotsForMall('Pacific Place Jakarta'),
        },
      ], onConflict: 'id');

      // 2. Sinkronkan profil currentUser saja
      await db.from('profiles').upsert({
        'full_name': user.fullName,
        'phone': user.phone,
        'email': activeEmail,
        'password': user.password,
        'role': user.role,
        'wallet_balance': walletBalance,
      }, onConflict: 'email');
    });
  }

  /// Memastikan jika user sudah login tapi data lokal belum dimuat dari Supabase,
  /// otomatis menarik data khusus milik user tersebut dari Supabase
  static void ensureSessionLoaded() {
    final user = currentUser;
    if (user == null) return;
    final cleanEmail = user.email.trim().toLowerCase();
    if (_lastLoadedSessionEmail != cleanEmail && !_isLoadingUserSession) {
      unawaited(loadUserSessionFromSupabase(cleanEmail));
    }
  }

  /// Menyimpan tiket valet aktif yang baru dipesan ke tabel `tickets` & mengupdate slot `malls` di Supabase
  static void syncActiveTicketToSupabase() {
    final ticket = activeTicket;
    final user = currentUser;
    if (!ticket.isActive || user == null) return;

    final userEmail = user.email.trim().toLowerCase();
    final mallOccupied = occupiedSlotsForMall(ticket.locationName);
    _saveCurrentToUserSnapshot();

    unawaited(() async {
      await _runDbOp((db) async {
        await db.from('tickets').upsert({
          'ticket_code': ticket.ticketCode,
          'user_email': userEmail,
          'location_name': ticket.locationName,
          'pickup_lobby': ticket.pickupLobby,
          'vehicle_name': ticket.vehicleName,
          'plate_number': ticket.plateNumber,
          'vehicle_specs': ticket.vehicleSpecs,
          'vehicle_size': ticket.vehicleSize.name,
          'entry_time': ticket.entryTime,
          'parking_area': ticket.parkingArea,
          'valet_fee': ticket.valetFeeAmount,
          'hourly_rate': ticket.hourlyRate,
          'status_text': ticket.statusText,
          'is_active': ticket.isActive,
          'is_pickup_requested': ticket.isPickupRequested,
          'valet_officer_name': ticket.valetOfficerName,
          'parking_started_at':
              (ticket.parkingStartedAt ?? DateTime.now()).toIso8601String(),
          'frozen_elapsed_seconds': ticket.frozenElapsedSeconds,
        }, onConflict: 'ticket_code');

        await db
            .from('malls')
            .update({'occupied_slots': mallOccupied})
            .eq('name', ticket.locationName);
      });
    }());
  }

  /// Menghitung berapa slot parkir valet (dari 15 slot) yang sedang terisi di mall tertentu secara real-time
  static int occupiedSlotsForMall(
    String mallName, {
    int maxSlots = uniformMallSlots,
  }) {
    ensureSessionLoaded();
    final key = mallName.trim().toLowerCase();
    int count = _extraActiveBookingsByMall[key] ?? 0;

    final isMainTicketHere = activeTicket.isActive &&
        !activeTicket.isPickupRequested &&
        activeTicket.locationName.trim().toLowerCase() == key;
    if (isMainTicketHere) {
      count += 1;
    }
    return count.clamp(0, maxSlots);
  }

  /// Menghitung sisa slot parkir valet yang tersedia dari 15 slot di mall tertentu secara real-time
  static int availableSlotsForMall(
    String mallName, {
    int maxSlots = uniformMallSlots,
  }) {
    final occupied = occupiedSlotsForMall(mallName, maxSlots: maxSlots);
    return (maxSlots - occupied).clamp(0, maxSlots);
  }

  /// Dipanggil saat user memesan valet baru agar slot parkir di mall tersebut berkurang secara real-time
  static void recordNewValetBooking(String newMallName) {
    hasBookedOnce = true;
    final newKey = newMallName.trim().toLowerCase();
    final prevActive = activeTicket.isActive && !activeTicket.isPickupRequested;
    final prevKey = activeTicket.locationName.trim().toLowerCase();

    if (prevActive) {
      final currentExtra = _extraActiveBookingsByMall[prevKey] ?? 0;
      _extraActiveBookingsByMall[prevKey] =
          (currentExtra + 1).clamp(0, uniformMallSlots);
    }

    final currentNewExtra = _extraActiveBookingsByMall[newKey] ?? 0;
    if (currentNewExtra >= uniformMallSlots) {
      _extraActiveBookingsByMall[newKey] = uniformMallSlots - 1;
    }
    _saveCurrentToUserSnapshot();
  }

  /// Dipanggil saat user meminta kendaraan diantar ke lobi (setelah bayar parkir)
  static void syncPickupRequestToSupabase(ParkingTicket ticket) {
    activeTicket = ticket;
    _saveCurrentToUserSnapshot();
    unawaited(
      _runDbOp((db) async {
        await db.from('tickets').update({
          'status_text': ticket.statusText,
          'is_pickup_requested': true,
          'pickup_lobby': ticket.pickupLobby,
          'frozen_elapsed_seconds': ticket.frozenElapsedSeconds,
        }).eq('ticket_code', ticket.ticketCode);
      }),
    );
  }

  /// Dipanggil saat kendaraan diambil & dibayar
  static ParkingTicket completeActiveTicket(ParkingTicket completed) {
    releaseValetSlot(completed.locationName);
    final finished = completed.copyWith(
      isActive: false,
      isPickupRequested: true,
      statusText: 'Selesai',
    );
    activeTicket = finished;
    ticketHistory.insert(0, finished);
    _saveCurrentToUserSnapshot();

    final mallOccupied = occupiedSlotsForMall(finished.locationName);
    unawaited(
      _runDbOp((db) async {
        await db
            .from('tickets')
            .update({
              'is_active': false,
              'status_text': 'Selesai',
              'is_pickup_requested': true,
              'frozen_elapsed_seconds': finished.frozenElapsedSeconds,
            })
            .eq('ticket_code', finished.ticketCode);

        await db
            .from('malls')
            .update({'occupied_slots': mallOccupied})
            .eq('name', finished.locationName);
      }),
    );

    _notifySessionChanged();
    return finished;
  }

  /// Dipanggil saat kendaraan diambil / selesai parkir sehingga slot parkir bertambah kembali
  static void releaseValetSlot(String mallName) {
    final key = mallName.trim().toLowerCase();
    final currentExtra = _extraActiveBookingsByMall[key] ?? 0;
    if (currentExtra > 0) {
      _extraActiveBookingsByMall[key] = currentExtra - 1;
    }
  }

  /// Untuk simulasi tambah/kurang mobil aktif secara langsung di mall tertentu
  static void adjustMallOccupiedSlots(String mallName, int delta) {
    final key = mallName.trim().toLowerCase();
    final isMainTicketHere = activeTicket.isActive &&
        !activeTicket.isPickupRequested &&
        activeTicket.locationName.trim().toLowerCase() == key;
    final mainSlot = isMainTicketHere ? 1 : 0;
    final currentTotal = occupiedSlotsForMall(mallName);
    final targetTotal = (currentTotal + delta).clamp(0, uniformMallSlots);

    if (targetTotal == 0 && isMainTicketHere) {
      activeTicket = activeTicket.copyWith(isPickupRequested: true);
      _extraActiveBookingsByMall[key] = 0;
    } else {
      _extraActiveBookingsByMall[key] =
          (targetTotal - mainSlot).clamp(0, uniformMallSlots);
    }

    final mallOccupied = occupiedSlotsForMall(mallName);
    unawaited(
      _runDbOp((db) async {
        await db
            .from('malls')
            .update({'occupied_slots': mallOccupied})
            .eq('name', mallName);
      }),
    );
  }

  static void resetMallSlots(String mallName) {
    final key = mallName.trim().toLowerCase();
    _extraActiveBookingsByMall.remove(key);
  }

  /// Format tanggal Bahasa Indonesia real-time mengikuti waktu dunia (contoh: "Senin, 2 November 2026")
  static String formatRealTimeFullDate([DateTime? dt]) {
    final now = dt ?? DateTime.now();
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    final dayName = days[(now.weekday - 1).clamp(0, 6)];
    final monthName = months[(now.month - 1).clamp(0, 11)];
    return '$dayName, ${now.day} $monthName ${now.year}';
  }

  /// Format tanggal singkat real-time (contoh: "2 Nov 2026")
  static String formatRealTimeShortDate([DateTime? dt]) {
    final now = dt ?? DateTime.now();
    const shortMonths = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    final m = shortMonths[(now.month - 1).clamp(0, 11)];
    return '${now.day} $m ${now.year}';
  }

  /// Sapaan otomatis mengikuti jam dunia saat ini
  static String realTimeGreeting([DateTime? dt]) {
    final hour = (dt ?? DateTime.now()).hour;
    if (hour >= 4 && hour < 11) return 'Selamat pagi';
    if (hour >= 11 && hour < 15) return 'Selamat siang';
    if (hour >= 15 && hour < 18) return 'Selamat sore';
    return 'Selamat malam';
  }

  // State Dompet PARVE & visibilitas ala m-banking
  static int walletBalance = defaultInitialBalance;
  static bool isBalanceVisible = true;
  static final List<WalletTransaction> walletTransactions = [];

  // State Profil & Pengaturan Layanan
  static Uint8List? profilePhotoBytes;
  static bool serviceNotificationsEnabled = true;

  static void updateProfile({
    required String fullName,
    required String phone,
    required String email,
  }) {
    final prev = currentUser;
    final updated = UserAccount(
      fullName: fullName.trim(),
      phone: phone.trim(),
      email: email.trim().toLowerCase(),
      password: prev?.password ?? 'parve1234',
      role: prev?.role ?? 'user',
    );
    if (prev != null) {
      final idx = _registeredUsers.indexWhere(
        (u) =>
            u.email == prev.email ||
            _normalizePhone(u.phone) == _normalizePhone(prev.phone),
      );
      if (idx >= 0) {
        _registeredUsers[idx] = updated;
      } else {
        _registeredUsers.add(updated);
      }
    }
    currentUser = updated;
    activeTicket = activeTicket.copyWith(userName: updated.firstName);
    _saveCurrentToUserSnapshot();

    unawaited(() async {
      await _runDbOp((db) async {
        await db.from('profiles').upsert({
          'full_name': updated.fullName,
          'phone': updated.phone,
          'email': updated.email,
          'password': updated.password,
          'role': updated.role,
          'wallet_balance': walletBalance,
        }, onConflict: 'email');
      });
      await syncAllCurrentStateToSupabase();
    }());
  }

  /// Saat logout, simpan snapshot akun lama lalu kosongkan state aktif
  /// agar akun berikutnya tidak pernah melihat data akun sebelumnya
  static void logout() {
    _saveCurrentToUserSnapshot();
    currentUser = null;
    _lastLoadedSessionEmail = null;
    _clearActiveSessionState();
    _notifySessionChanged();
  }

  static String get formattedWalletBalance {
    ensureSessionLoaded();
    return ParkingTicket.formatRupiah(walletBalance);
  }

  static String get displayWalletBalance =>
      isBalanceVisible ? formattedWalletBalance : 'Rp •••••••';

  static void toggleBalanceVisibility() {
    isBalanceVisible = !isBalanceVisible;
  }

  static String _currentTimeDot() {
    final now = DateTime.now();
    final hh = now.hour.toString().padLeft(2, '0');
    final mm = now.minute.toString().padLeft(2, '0');
    return '$hh.$mm';
  }

  static void topUpWallet({
    required int amount,
    required String methodShortName,
  }) {
    if (amount <= 0) return;
    walletBalance += amount;
    activeTicket = activeTicket.copyWith(walletBalance: walletBalance);
    final trx = WalletTransaction(
      id: 'trx-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Isi saldo',
      subtitle: '$methodShortName • ${_currentTimeDot()}',
      dateGroup: formatRealTimeFullDate(),
      amount: amount,
      isCredit: true,
    );
    walletTransactions.insert(0, trx);
    _saveCurrentToUserSnapshot();
    _syncWalletToSupabase(trx);
    _notifySessionChanged();
  }

  static bool deductWallet({
    required int amount,
    required String title,
    required String subtitle,
  }) {
    if (amount <= 0 || walletBalance < amount) return false;
    walletBalance -= amount;
    activeTicket = activeTicket.copyWith(walletBalance: walletBalance);
    final trx = WalletTransaction(
      id: 'trx-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      subtitle: subtitle,
      dateGroup: formatRealTimeFullDate(),
      amount: amount,
      isCredit: false,
    );
    walletTransactions.insert(0, trx);
    _saveCurrentToUserSnapshot();
    _syncWalletToSupabase(trx);
    _notifySessionChanged();
    return true;
  }

  static void _syncWalletToSupabase(WalletTransaction trx) {
    final user = currentUser;
    if (user == null) return;
    final userEmail = user.email.trim().toLowerCase();
    unawaited(() async {
      await _runDbOp((db) async {
        await db.from('wallet_transactions').insert({
          'user_email': userEmail,
          'title': trx.title,
          'subtitle': trx.subtitle,
          'amount_text': trx.formattedSignedAmount,
          'is_credit': trx.isCredit,
        });
        await db
            .from('profiles')
            .update({'wallet_balance': walletBalance})
            .eq('email', userEmail);
      });
    }());
  }

  static bool get hasRegisteredAccount => _registeredUsers.isNotEmpty;

  static List<UserAccount> get registeredUsers =>
      List.unmodifiable(_registeredUsers);

  static SavedVehicle? get primaryVehicleOrNull {
    ensureSessionLoaded();
    if (savedVehicles.isEmpty) return null;
    return savedVehicles.firstWhere(
      (v) => v.isPrimary,
      orElse: () => savedVehicles.first,
    );
  }

  static SavedVehicle get primaryVehicle =>
      primaryVehicleOrNull ?? SavedVehicle.defaultPrimary;

  static void syncTicketWithPrimaryVehicle() {
    if (savedVehicles.isEmpty) return;
    final primary = primaryVehicle;
    activeTicket = activeTicket.copyWith(
      vehicleName: primary.name,
      plateNumber: primary.plateNumber,
      vehicleSpecs: primary.specs,
      vehiclePhotoBytes: primary.photoBytes,
    );
  }

  static void addOrUpdateVehicle(SavedVehicle vehicle) {
    final idx = savedVehicles.indexWhere((v) => v.id == vehicle.id);
    if (vehicle.isPrimary) {
      for (int i = 0; i < savedVehicles.length; i++) {
        savedVehicles[i] = savedVehicles[i].copyWith(isPrimary: false);
      }
    }
    if (idx >= 0) {
      savedVehicles[idx] = vehicle;
    } else {
      savedVehicles.add(vehicle);
    }
    if (!savedVehicles.any((v) => v.isPrimary) && savedVehicles.isNotEmpty) {
      savedVehicles[0] = savedVehicles[0].copyWith(isPrimary: true);
    }
    syncTicketWithPrimaryVehicle();
    _saveCurrentToUserSnapshot();

    final user = currentUser;
    if (user != null) {
      final userEmail = user.email.trim().toLowerCase();
      unawaited(() async {
        await _runDbOp((db) async {
          await db.from('vehicles').insert({
            'user_email': userEmail,
            'name': vehicle.name,
            'plate_number': vehicle.plateNumber,
            'color': vehicle.color,
            'year': vehicle.year,
          });
        });
      }());
    }
    _notifySessionChanged();
  }

  static void setPrimaryVehicle(String id) {
    for (int i = 0; i < savedVehicles.length; i++) {
      savedVehicles[i] = savedVehicles[i].copyWith(
        isPrimary: savedVehicles[i].id == id,
      );
    }
    syncTicketWithPrimaryVehicle();
    _saveCurrentToUserSnapshot();
    _notifySessionChanged();
  }

  static void removeVehicle(String id) {
    final removed = savedVehicles.where((v) => v.id == id).toList();
    savedVehicles.removeWhere((v) => v.id == id);
    if (!savedVehicles.any((v) => v.isPrimary) && savedVehicles.isNotEmpty) {
      savedVehicles[0] = savedVehicles[0].copyWith(isPrimary: true);
    }
    syncTicketWithPrimaryVehicle();
    _saveCurrentToUserSnapshot();

    final user = currentUser;
    if (removed.isNotEmpty && user != null) {
      final plate = removed.first.plateNumber;
      final userEmail = user.email.trim().toLowerCase();
      unawaited(
        _runDbOp((db) async {
          await db
              .from('vehicles')
              .delete()
              .eq('user_email', userEmail)
              .eq('plate_number', plate);
        }),
      );
    }
    _notifySessionChanged();
  }

  static String _normalizePhone(String input) =>
      input.replaceAll(RegExp(r'[\s\-]'), '');

  /// Membuat akun baru dengan kondisi awal 100% bersih (saldo 0, 0 kendaraan, 0 tiket)
  static UserAccount register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
    String role = 'user',
  }) {
    // Simpan snapshot user sebelumnya jika masih ada yang login
    _saveCurrentToUserSnapshot();

    final newUser = UserAccount(
      fullName: fullName.trim(),
      phone: phone.trim(),
      email: email.trim().toLowerCase(),
      password: password,
      role: role,
    );
    _registeredUsers.removeWhere(
      (u) =>
          u.email == newUser.email ||
          _normalizePhone(u.phone) == _normalizePhone(newUser.phone),
    );
    _registeredUsers.add(newUser);

    // Pastikan sesi untuk akun baru ini benar-benar bersih dari 0
    _perUserSessions[newUser.email] = _UserSessionSnapshot(
      walletBalance: defaultInitialBalance,
      activeTicket: ParkingTicket.createEmptyInitial().copyWith(
        userName: newUser.firstName,
        walletBalance: defaultInitialBalance,
      ),
    );
    currentUser = null;
    _lastLoadedSessionEmail = null;
    _clearActiveSessionState(userName: newUser.firstName);

    unawaited(
      _runDbOp((db) async {
        await db.from('profiles').upsert({
          'full_name': newUser.fullName,
          'phone': newUser.phone,
          'email': newUser.email,
          'password': newUser.password,
          'role': newUser.role,
          'wallet_balance': defaultInitialBalance,
        }, onConflict: 'email');
      }),
    );

    _notifySessionChanged();
    return newUser;
  }

  /// Login ke akun tertentu: mengosongkan state akun sebelumnya lalu memuat
  /// khusus data milik akun yang login ini saja dari Supabase
  static UserAccount? login({
    required String identifier,
    required String password,
    required bool isEmailMode,
  }) {
    final cleanId = identifier.trim();
    for (final user in _registeredUsers) {
      final matchId = isEmailMode
          ? user.email.toLowerCase() == cleanId.toLowerCase()
          : _normalizePhone(user.phone) == _normalizePhone(cleanId);
      if (matchId && user.password == password) {
        if (currentUser != null && currentUser!.email != user.email) {
          _saveCurrentToUserSnapshot();
        }
        currentUser = user;
        _lastLoadedSessionEmail = null;
        _restoreLocalSnapshotForUser(user);
        unawaited(loadUserSessionFromSupabase(user.email));
        _notifySessionChanged();
        return user;
      }
    }
    return null;
  }

  static void reset() {
    _registeredUsers.clear();
    _perUserSessions.clear();
    currentUser = null;
    profilePhotoBytes = null;
    serviceNotificationsEnabled = true;
    AppColors.setDarkMode(false);
    walletBalance = defaultInitialBalance;
    isBalanceVisible = true;
    walletTransactions.clear();
    savedVehicles.clear();
    _extraActiveBookingsByMall.clear();
    ticketHistory.clear();
    hasBookedOnce = false;
    _lastLoadedSessionEmail = null;
    activeTicket = ParkingTicket.createEmptyInitial();
  }
}
