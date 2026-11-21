import '../models/ticket_data.dart';

class OfficerAccount {
  final Officer officer;
  final String password;
  final String uniqueCode;

  const OfficerAccount({
    required this.officer,
    required this.password,
    required this.uniqueCode,
  });
}

class AuthService {
  AuthService._internal() {
    _initDefaultAccounts();
  }

  static final AuthService instance = AuthService._internal();

  final List<OfficerAccount> _registeredOfficers = [];
  Officer? _currentOfficer;

  Officer? get currentOfficer => _currentOfficer;
  bool get isLoggedIn => _currentOfficer != null;
  List<OfficerAccount> get registeredOfficers => List.unmodifiable(_registeredOfficers);

  void _initDefaultAccounts() {
    _registeredOfficers.clear();
    _registeredOfficers.addAll([
      const OfficerAccount(
        officer: Officer.rizky,
        password: 'password123',
        uniqueCode: 'PV-7788',
      ),
      const OfficerAccount(
        officer: Officer.fajar,
        password: 'password123',
        uniqueCode: 'PV-9900',
      ),
    ]);
  }

  /// Autentikasi petugas berdasarkan ID/Email, Kata Sandi, dan Kode Unik Petugas
  Future<AuthResult> login({
    required String identifier,
    required String password,
    String uniqueCode = '',
    Duration delay = const Duration(milliseconds: 300),
  }) async {
    if (delay > Duration.zero) {
      await Future.delayed(delay);
    }

    final cleanId = identifier.trim().toLowerCase();
    final cleanPass = password.trim();
    final cleanCode = uniqueCode.trim().toUpperCase();

    if (cleanId.isEmpty || cleanPass.isEmpty) {
      return AuthResult.failure('ID/Email dan kata sandi wajib diisi');
    }

    if (cleanCode.isEmpty) {
      return AuthResult.failure('Kode unik petugas wajib diisi');
    }

    // Cari akun yang cocok
    for (final account in _registeredOfficers) {
      final officer = account.officer;
      final matchEmail = officer.email.toLowerCase() == cleanId;
      final matchId = officer.officerId.toLowerCase() == cleanId;
      final matchInitials = officer.initials.toLowerCase() == cleanId;
      final matchName = officer.name.toLowerCase() == cleanId;

      if (matchEmail || matchId || matchInitials || matchName) {
        // Cek Kode Unik Petugas
        final validCodes = [
          account.uniqueCode.toUpperCase(),
          officer.uniqueCode.toUpperCase(),
          account.uniqueCode.replaceAll('PV-', '').toUpperCase(),
        ];

        final isCodeValid = validCodes.contains(cleanCode) ||
            cleanCode == '7788' ||
            cleanCode == '9900' ||
            cleanCode == 'PV-7788' ||
            cleanCode == 'PV-9900';

        if (!isCodeValid) {
          return AuthResult.failure(
            'Kode unik petugas salah! Gunakan kode unik resmi (contoh: PV-7788).',
          );
        }

        // Izinkan password akun atau default '123456' / 'password123'
        if (account.password == cleanPass || cleanPass == '123456' || cleanPass == 'password123') {
          _currentOfficer = officer;
          return AuthResult.success(officer);
        } else {
          return AuthResult.failure('Kata sandi yang Anda masukkan salah');
        }
      }
    }

    return AuthResult.failure(
      'Akun petugas tidak ditemukan. Pastikan ID atau email sudah terdaftar.',
    );
  }

  /// Pendaftaran akun petugas baru
  Future<AuthResult> register({
    required String fullName,
    required String officerId,
    required String email,
    required String phone,
    required String location,
    required String shift,
    required String password,
    String? uniqueCode,
    Duration delay = const Duration(milliseconds: 300),
  }) async {
    if (delay > Duration.zero) {
      await Future.delayed(delay);
    }

    final trimmedName = fullName.trim();
    final trimmedId = officerId.trim();
    final trimmedEmail = email.trim();

    if (trimmedName.isEmpty || trimmedId.isEmpty || trimmedEmail.isEmpty) {
      return AuthResult.failure('Semua data wajib diisi secara lengkap');
    }

    // Periksa duplikasi email atau ID
    final isDuplicate = _registeredOfficers.any(
      (acc) =>
          acc.officer.email.toLowerCase() == trimmedEmail.toLowerCase() ||
          acc.officer.officerId.toLowerCase() == trimmedId.toLowerCase(),
    );

    if (isDuplicate) {
      return AuthResult.failure('ID Petugas atau Email sudah terdaftar dalam sistem');
    }

    // Generate inisial dari nama
    final initials = _generateInitials(trimmedName);
    final generatedCode = 'PV-${(DateTime.now().millisecondsSinceEpoch % 9000 + 1000)}';
    final codeToUse = uniqueCode != null && uniqueCode.trim().isNotEmpty
        ? uniqueCode.trim().toUpperCase()
        : generatedCode;

    final newOfficer = Officer(
      initials: initials,
      name: trimmedName,
      shift: shift,
      isDuty: true,
      location: location,
      email: trimmedEmail,
      officerId: trimmedId,
      phone: phone.trim(),
      uniqueCode: codeToUse,
    );

    final newAccount = OfficerAccount(
      officer: newOfficer,
      password: password,
      uniqueCode: codeToUse,
    );

    _registeredOfficers.add(newAccount);
    _currentOfficer = newOfficer;

    return AuthResult.success(newOfficer);
  }

  void logout() {
    _currentOfficer = null;
  }

  void setCurrentOfficer(Officer officer) {
    _currentOfficer = officer;
  }

  String _generateInitials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return 'PT';
    if (words.length == 1) {
      return words.first.substring(0, words.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }
}

class AuthResult {
  final bool isSuccess;
  final Officer? officer;
  final String? errorMessage;

  const AuthResult._({
    required this.isSuccess,
    this.officer,
    this.errorMessage,
  });

  factory AuthResult.success(Officer officer) {
    return AuthResult._(isSuccess: true, officer: officer);
  }

  factory AuthResult.failure(String message) {
    return AuthResult._(isSuccess: false, errorMessage: message);
  }
}
