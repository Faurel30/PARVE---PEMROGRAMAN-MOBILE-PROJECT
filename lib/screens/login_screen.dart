import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../models/auth_store.dart';
import '../widgets/booking_step_header.dart';
import '../widgets/parve_text_field.dart';
import 'beranda_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final String? initialPhone;
  final String? initialEmail;
  final String? initialPassword;

  const LoginScreen({
    super.key,
    this.initialPhone,
    this.initialEmail,
    this.initialPassword,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isEmailMode = false;
  bool _obscurePassword = true;

  late final TextEditingController _phoneController = TextEditingController(
    text: widget.initialPhone ?? '+62 812 3456 7890',
  );
  late final TextEditingController _emailController = TextEditingController(
    text: widget.initialEmail ?? 'dimas.pratama@example.com',
  );
  late final TextEditingController _passwordController = TextEditingController(
    text: widget.initialPassword ?? 'parve2026',
  );

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (!AuthStore.hasRegisteredAccount) {
      _showMessage(
        'Belum ada akun terdaftar. Silakan daftar akun terlebih dahulu.',
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
      );
      return;
    }

    final identifier = _isEmailMode
        ? _emailController.text.trim()
        : _phoneController.text.trim();
    final password = _passwordController.text;

    if (identifier.isEmpty || password.isEmpty) {
      _showMessage('Mohon isi kredensial dan kata sandi Anda.');
      return;
    }

    final user = AuthStore.login(
      identifier: identifier,
      password: password,
      isEmailMode: _isEmailMode,
    );

    if (user == null) {
      _showMessage(
        _isEmailMode
            ? 'Email atau kata sandi tidak sesuai dengan akun yang didaftarkan.'
            : 'Nomor ponsel atau kata sandi tidak sesuai dengan akun yang didaftarkan.',
      );
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: '/home'),
        builder: (context) => const BerandaScreen(),
      ),
      (_) => false,
    );
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Atur Ulang Kata Sandi',
          style: TextStyle(color: AppColors.darkPrimary),
        ),
        content: Text(
          'Tautan pemulihan kata sandi akan dikirimkan ke '
          '${_isEmailMode ? _emailController.text : _phoneController.text}.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
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
                const BookingTopBar(title: 'Masuk'),
                const SizedBox(height: 22),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.navPillBg,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.key_outlined,
                      color: AppColors.navActive,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Selamat datang\nkembali.',
                  style: TextStyle(
                    color: AppColors.darkPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    height: 1.18,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Masuk untuk memesan valet dan mengelola\nperjalanan Anda.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13.2,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                _buildLoginMethodToggle(),
                const SizedBox(height: 14),
                if (_isEmailMode)
                  ParveTextField(
                    label: 'Alamat email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    suffixIcon: Icons.mail_outline_rounded,
                  )
                else
                  ParveTextField(
                    label: 'Nomor ponsel',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    suffixIcon: Icons.call_outlined,
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
                const SizedBox(height: 11),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _showForgotPasswordDialog,
                    child: Text(
                      'Lupa kata sandi?',
                      style: TextStyle(
                        color: AppColors.navActive,
                        fontSize: 12.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _buildSubmitButton(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.5,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      ),
                      child: Text(
                        'Daftar sekarang',
                        style: TextStyle(
                          color: AppColors.navActive,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _buildSecurityNoticeCard(),
                const SizedBox(height: 18),
                Text(
                  'Butuh bantuan? Hubungi layanan PARVE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginMethodToggle() {
    return Container(
      padding: const EdgeInsets.all(3.5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isEmailMode = false),
              child: Container(
                height: 31,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !_isEmailMode
                      ? AppColors.heroDark
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  'Nomor ponsel',
                  style: TextStyle(
                    color: !_isEmailMode
                        ? Colors.white
                        : AppColors.textSecondary,
                    fontSize: 12.2,
                    fontWeight: !_isEmailMode
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isEmailMode = true),
              child: Container(
                height: 31,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _isEmailMode
                      ? AppColors.heroDark
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  'Alamat email',
                  style: TextStyle(
                    color: _isEmailMode
                        ? Colors.white
                        : AppColors.textSecondary,
                    fontSize: 12.2,
                    fontWeight: _isEmailMode
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
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
        onTap: _handleLogin,
        borderRadius: BorderRadius.circular(11),
        child: const SizedBox(
          height: 49,
          child: Center(
            child: Text(
              'Masuk',
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

  Widget _buildSecurityNoticeCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.softGoldBanner,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(
              Icons.verified_user_outlined,
              color: AppColors.navActive,
              size: 17,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Data dan transaksi Anda dilindungi. Jangan bagikan '
              'kata sandi kepada siapa pun.',
              style: TextStyle(
                color: AppColors.navActive,
                fontSize: 11.4,
                height: 1.38,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
