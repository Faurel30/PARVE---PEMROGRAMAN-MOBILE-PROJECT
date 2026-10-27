import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../models/auth_store.dart';
import '../widgets/booking_step_header.dart';
import '../widgets/parve_text_field.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController(text: 'Dimas Pratama');
  final _phoneController = TextEditingController(text: '+62 812 3456 7890');
  final _emailController = TextEditingController(
    text: 'dimas.pratama@example.com',
  );
  final _passwordController = TextEditingController(text: 'parve2026');

  bool _obscurePassword = true;
  bool _agreedToTerms = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || phone.isEmpty || email.isEmpty) {
      _showMessage('Mohon lengkapi nama, nomor ponsel, dan alamat email.');
      return;
    }

    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(password);
    final hasDigit = RegExp(r'\d').hasMatch(password);
    if (password.length < 8 || !hasLetter || !hasDigit) {
      _showMessage('Kata sandi minimal 8 karakter kombinasi huruf dan angka.');
      return;
    }

    if (!_agreedToTerms) {
      _showMessage('Anda harus menyetujui Syarat & Ketentuan PARVE.');
      return;
    }

    AuthStore.register(
      fullName: name,
      phone: phone,
      email: email,
      password: password,
    );

    _showMessage('Pendaftaran berhasil! Silakan masuk menggunakan akun Anda.');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          initialPhone: phone,
          initialEmail: email,
          initialPassword: password,
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppColors.pageOverlayStyle,
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(21, 12, 21, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const BookingTopBar(title: 'Daftar akun'),
                const SizedBox(height: 22),
                Text(
                  'Parkir nyaman dimulai di\nsini.',
                  style: TextStyle(
                    color: AppColors.darkPrimary,
                    fontSize: 25.5,
                    fontWeight: FontWeight.w700,
                    height: 1.18,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Buat akun pribadi Anda. Satu akun untuk kendaraan, tiket,\ndan dompet.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13.0,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 22),
                ParveTextField(
                  label: 'Nama lengkap',
                  controller: _nameController,
                  hintText: 'Masukkan nama lengkap',
                ),
                const SizedBox(height: 16),
                ParveTextField(
                  label: 'Nomor ponsel',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  suffixIcon: Icons.call_outlined,
                ),
                const SizedBox(height: 16),
                ParveTextField(
                  label: 'Alamat email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  suffixIcon: Icons.mail_outline_rounded,
                ),
                const SizedBox(height: 16),
                ParveTextField(
                  label: 'Kata sandi',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  suffixIcon: _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  onSuffixTap: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                const SizedBox(height: 7),
                Text(
                  'Minimal 8 karakter, kombinasi huruf dan angka.',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11.4,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTermsCheckbox(),
                const SizedBox(height: 20),
                _buildSubmitButton(),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.6,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      ),
                      child: Text(
                        'Masuk',
                        style: TextStyle(
                          color: AppColors.navActive,
                          fontSize: 12.6,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return GestureDetector(
      onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: _agreedToTerms ? AppColors.goldButton : AppColors.surface,
              borderRadius: BorderRadius.circular(5.5),
              border: Border.all(
                color: _agreedToTerms
                    ? AppColors.goldButton
                    : AppColors.cardBorder,
                width: 1.4,
              ),
            ),
            child: _agreedToTerms
                ? const Icon(
                    Icons.check_rounded,
                    size: 15,
                    color: AppColors.onGold,
                  )
                : null,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              'Saya menyetujui Syarat & Ketentuan serta Kebijakan Privasi PARVE.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.0,
                height: 1.38,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Material(
      color: AppColors.goldButton,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: _handleRegister,
        borderRadius: BorderRadius.circular(11),
        child: const SizedBox(
          height: 49,
          child: Center(
            child: Text(
              'Buat akun',
              style: TextStyle(
                color: AppColors.onGold,
                fontSize: 14.2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
