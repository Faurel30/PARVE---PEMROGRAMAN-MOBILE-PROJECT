import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../petugas_home_screen.dart';
import 'login_screen.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/auth_primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _officerIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedLocation = 'Pacific Place';
  String _selectedShift = 'Shift 08.00–16.00';
  bool _isObscurePass = true;
  bool _isObscureConfirm = true;
  bool _agreedToTerms = false;
  bool _isLoading = false;

  final List<String> _locations = [
    'Pacific Place',
    'Grand Indonesia',
    'Senayan City',
    'Plaza Indonesia',
    'Central Park',
  ];

  final List<String> _shifts = [
    'Shift 08.00–16.00',
    'Shift 14.00–22.00',
    'Shift 22.00–06.00',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _officerIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap centang persetujuan SOP & Ketentuan Petugas'),
          backgroundColor: Color(0xFFEF4444),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await AuthService.instance.register(
      fullName: _nameController.text,
      officerId: _officerIdController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      location: _selectedLocation,
      shift: _selectedShift,
      password: _passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result.isSuccess && result.officer != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.goldBorder),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.successGreenDark,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.successGreen,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Registrasi Berhasil!',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Akun petugas atas nama ${result.officer!.name} (${result.officer!.officerId}) telah aktif dan siap digunakan bertugas.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldPrimary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetugasHomeScreen(
                          initialOfficer: result.officer,
                        ),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Mulai Bertugas',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage ?? 'Gagal mendaftar akun petugas'),
          backgroundColor: const Color(0xFFEF4444),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Registrasi Petugas',
          style: TextStyle(
            color: AppColors.goldPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.goldDarkBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.goldBorder),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_add_alt_1_rounded,
                        color: AppColors.goldPrimary,
                        size: 14,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'FORMULIR AKUN BARU',
                        style: TextStyle(
                          color: AppColors.goldPrimary,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                const Text(
                  'Daftar Petugas Baru',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Lengkapi data resmi untuk verifikasi identitas sebagai petugas parkir valet PARVE.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13.5,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),

                // Nama Lengkap
                AuthTextField(
                  label: 'Nama Lengkap',
                  hintText: 'contoh: Rizky Saputra',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline_rounded,
                  textCapitalization: TextCapitalization.words,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Nama lengkap wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ID / NIP Petugas
                AuthTextField(
                  label: 'ID Petugas / NIP',
                  hintText: 'contoh: PET-0810-03',
                  controller: _officerIdController,
                  prefixIcon: Icons.badge_outlined,
                  textCapitalization: TextCapitalization.characters,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'ID Petugas wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email Petugas
                AuthTextField(
                  label: 'Email Petugas',
                  hintText: 'contoh: nama.petugas@parve.id',
                  controller: _emailController,
                  prefixIcon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Email wajib diisi';
                    }
                    if (!val.contains('@') || !val.contains('.')) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Nomor Telepon / WA
                AuthTextField(
                  label: 'Nomor WhatsApp / HP',
                  hintText: 'contoh: 081234567890',
                  controller: _phoneController,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Nomor HP wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Dropdown Lokasi Penugasan
                _buildDropdownField(
                  label: 'Lokasi Penugasan',
                  icon: Icons.location_on_outlined,
                  value: _selectedLocation,
                  items: _locations,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedLocation = val);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Dropdown Shift Kerja
                _buildDropdownField(
                  label: 'Shift Kerja',
                  icon: Icons.access_time_rounded,
                  value: _selectedShift,
                  items: _shifts,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedShift = val);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Kata Sandi
                AuthTextField(
                  label: 'Kata Sandi',
                  hintText: 'Minimal 6 karakter',
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                  isObscure: _isObscurePass,
                  onToggleObscure: () {
                    setState(() => _isObscurePass = !_isObscurePass);
                  },
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Kata sandi wajib diisi';
                    }
                    if (val.trim().length < 6) {
                      return 'Kata sandi minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Konfirmasi Kata Sandi
                AuthTextField(
                  label: 'Konfirmasi Kata Sandi',
                  hintText: 'Ulangi kata sandi Anda',
                  controller: _confirmPasswordController,
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                  isObscure: _isObscureConfirm,
                  onToggleObscure: () {
                    setState(() => _isObscureConfirm = !_isObscureConfirm);
                  },
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Konfirmasi kata sandi wajib diisi';
                    }
                    if (val != _passwordController.text) {
                      return 'Konfirmasi kata sandi tidak cocok';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Agreement Checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreedToTerms,
                        activeColor: AppColors.goldPrimary,
                        checkColor: Colors.black,
                        side: const BorderSide(color: AppColors.border, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: (val) {
                          setState(() => _agreedToTerms = val ?? false);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Saya menyatakan data di atas benar & siap mematuhi SOP Keamanan Valet PARVE.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.5,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Submit Button
                AuthPrimaryButton(
                  text: 'Daftar Akun Petugas',
                  leadingIcon: Icons.person_add_rounded,
                  isLoading: _isLoading,
                  variant: AuthButtonVariant.goldFilled,
                  onPressed: _handleRegister,
                ),
                const SizedBox(height: 24),

                // Link to Login
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        'Sudah memiliki akun? ',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Masuk di sini',
                          style: TextStyle(
                            color: AppColors.goldPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.goldPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: AppColors.card,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.goldPrimary,
              ),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Row(
                    children: [
                      Icon(icon, color: AppColors.goldPrimary.withValues(alpha: 0.8), size: 18),
                      const SizedBox(width: 10),
                      Text(
                        item,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

