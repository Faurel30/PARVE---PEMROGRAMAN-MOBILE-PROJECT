import 'dart:typed_data';
import '../core/app_colors.dart';
import 'ticket_model.dart';
import 'wallet_model.dart';

class UserAccount {
  final String fullName;
  final String phone;
  final String email;
  final String password;

  const UserAccount({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
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

/// Penyimpanan state autentikasi, kendaraan, & saldo Dompet PARVE in-memory
class AuthStore {
  AuthStore._();

  static const int defaultInitialBalance = 0;
  static const int uniformMallSlots = 15;

  static final List<UserAccount> _registeredUsers = [];
  static UserAccount? currentUser;

  static final List<SavedVehicle> savedVehicles = [];
  static ParkingTicket activeTicket = ParkingTicket.createEmptyInitial();
  static final List<ParkingTicket> ticketHistory = [];
  static bool hasBookedOnce = false;

  /// Menyimpan jumlah tiket/kendaraan aktif tambahan di tiap mall (di luar activeTicket utama)
  static final Map<String, int> _extraActiveBookingsByMall = {};

  /// Menghitung berapa slot parkir valet (dari 15 slot) yang sedang terisi di mall tertentu secara real-time
  static int occupiedSlotsForMall(String mallName, {int maxSlots = uniformMallSlots}) {
    final key = mallName.trim().toLowerCase();
    int count = _extraActiveBookingsByMall[key] ?? 0;

    // Jika tiket aktif utama user berada di mall ini dan belum selesai diambil, otomatis memotong 1 slot
    final isMainTicketHere = activeTicket.isActive &&
        !activeTicket.isPickupRequested &&
        activeTicket.locationName.trim().toLowerCase() == key;
    if (isMainTicketHere) {
      count += 1;
    }
    return count.clamp(0, maxSlots);
  }

  /// Menghitung sisa slot parkir valet yang tersedia dari 15 slot di mall tertentu secara real-time
  static int availableSlotsForMall(String mallName, {int maxSlots = uniformMallSlots}) {
    final occupied = occupiedSlotsForMall(mallName, maxSlots: maxSlots);
    return (maxSlots - occupied).clamp(0, maxSlots);
  }

  /// Dipanggil saat user memesan valet baru agar slot parkir di mall tersebut berkurang secara real-time
  static void recordNewValetBooking(String newMallName) {
    hasBookedOnce = true;
    final newKey = newMallName.trim().toLowerCase();
    final prevActive = activeTicket.isActive && !activeTicket.isPickupRequested;
    final prevKey = activeTicket.locationName.trim().toLowerCase();

    // Jika sebelumnya sudah ada tiket aktif yang belum selesai diambil,
    // pindahkan slot tiket sebelumnya ke daftar ekstra agar slot yang dipakai tetap tercatat real-time
    if (prevActive) {
      final currentExtra = _extraActiveBookingsByMall[prevKey] ?? 0;
      _extraActiveBookingsByMall[prevKey] =
          (currentExtra + 1).clamp(0, uniformMallSlots);
    }

    // Pastikan tidak melebihi kapasitas 15 slot
    final currentNewExtra = _extraActiveBookingsByMall[newKey] ?? 0;
    if (currentNewExtra >= uniformMallSlots) {
      _extraActiveBookingsByMall[newKey] = uniformMallSlots - 1;
    }
  }

  /// Dipanggil saat kendaraan diambil & dibayar:
  /// - Menghapus status aktif tiket (hilang dari tab Tiket Aktif)
  /// - Memindahkan tiket ke urutan teratas Riwayat Parkir
  /// - Mengembalikan 1 slot parkir valet di mall terkait
  static ParkingTicket completeActiveTicket(ParkingTicket completed) {
    releaseValetSlot(completed.locationName);
    final finished = completed.copyWith(
      isActive: false,
      isPickupRequested: true,
      statusText: 'Selesai',
    );
    activeTicket = finished;
    ticketHistory.insert(0, finished);
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
  }

  static void logout() {
    currentUser = null;
  }

  static String get formattedWalletBalance =>
      ParkingTicket.formatRupiah(walletBalance);

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
    walletTransactions.insert(
      0,
      WalletTransaction(
        id: 'trx-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Isi saldo',
        subtitle: '$methodShortName • ${_currentTimeDot()}',
        dateGroup: formatRealTimeFullDate(),
        amount: amount,
        isCredit: true,
      ),
    );
  }

  static bool deductWallet({
    required int amount,
    required String title,
    required String subtitle,
  }) {
    if (amount <= 0 || walletBalance < amount) return false;
    walletBalance -= amount;
    activeTicket = activeTicket.copyWith(walletBalance: walletBalance);
    walletTransactions.insert(
      0,
      WalletTransaction(
        id: 'trx-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        subtitle: subtitle,
        dateGroup: formatRealTimeFullDate(),
        amount: amount,
        isCredit: false,
      ),
    );
    return true;
  }

  static bool get hasRegisteredAccount => _registeredUsers.isNotEmpty;

  static List<UserAccount> get registeredUsers =>
      List.unmodifiable(_registeredUsers);

  static SavedVehicle? get primaryVehicleOrNull {
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
  }

  static void setPrimaryVehicle(String id) {
    for (int i = 0; i < savedVehicles.length; i++) {
      savedVehicles[i] = savedVehicles[i].copyWith(
        isPrimary: savedVehicles[i].id == id,
      );
    }
    syncTicketWithPrimaryVehicle();
  }

  static void removeVehicle(String id) {
    savedVehicles.removeWhere((v) => v.id == id);
    if (!savedVehicles.any((v) => v.isPrimary) && savedVehicles.isNotEmpty) {
      savedVehicles[0] = savedVehicles[0].copyWith(isPrimary: true);
    }
    syncTicketWithPrimaryVehicle();
  }

  static String _normalizePhone(String input) =>
      input.replaceAll(RegExp(r'[\s\-]'), '');

  static UserAccount register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) {
    final newUser = UserAccount(
      fullName: fullName.trim(),
      phone: phone.trim(),
      email: email.trim().toLowerCase(),
      password: password,
    );
    _registeredUsers.removeWhere(
      (u) =>
          u.email == newUser.email ||
          _normalizePhone(u.phone) == _normalizePhone(newUser.phone),
    );
    _registeredUsers.add(newUser);
    return newUser;
  }

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
        currentUser = user;
        activeTicket = activeTicket.copyWith(
          userName: user.firstName,
          walletBalance: walletBalance,
        );
        return user;
      }
    }
    return null;
  }

  static void reset() {
    _registeredUsers.clear();
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
    activeTicket = ParkingTicket.createEmptyInitial();
  }
}
