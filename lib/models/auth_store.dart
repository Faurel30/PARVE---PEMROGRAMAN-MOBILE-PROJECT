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

  static const int defaultInitialBalance = 205000;

  static final List<UserAccount> _registeredUsers = [];
  static UserAccount? currentUser;

  static final List<SavedVehicle> savedVehicles = [SavedVehicle.defaultPrimary];
  static ParkingTicket activeTicket = ParkingTicket.sampleActive;

  // State Dompet PARVE & visibilitas ala m-banking
  static int walletBalance = defaultInitialBalance;
  static bool isBalanceVisible = true;
  static final List<WalletTransaction> walletTransactions = [
    ...WalletTransaction.defaultHistory,
  ];

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
        dateGroup: '8 Oktober 2026',
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
        dateGroup: '8 Oktober 2026',
        amount: amount,
        isCredit: false,
      ),
    );
    return true;
  }

  static bool get hasRegisteredAccount => _registeredUsers.isNotEmpty;

  static List<UserAccount> get registeredUsers =>
      List.unmodifiable(_registeredUsers);

  static SavedVehicle get primaryVehicle => savedVehicles.firstWhere(
    (v) => v.isPrimary,
    orElse: () => savedVehicles.first,
  );

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
    if (savedVehicles.length <= 1) return;
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
    walletTransactions
      ..clear()
      ..addAll(WalletTransaction.defaultHistory);
    savedVehicles
      ..clear()
      ..add(SavedVehicle.defaultPrimary);
    activeTicket = ParkingTicket.sampleActive;
  }
}
