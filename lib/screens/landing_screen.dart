import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../models/auth_store.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void _openAuthOrMain(BuildContext context, {required bool isRegister}) {
    if (isRegister) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
      );
      return;
    }

    if (!AuthStore.hasRegisteredAccount) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Anda belum memiliki akun. Silakan daftar akun terlebih dahulu.',
            ),
          ),
        );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.bgPage,
        systemNavigationBarIconBrightness:
            AppColors.isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF20231F),
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/logo_parve_banner.png',
                          width: double.infinity,
                          height: 228,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 26),
                      const Text(
                        'LAYANAN VALET PRIBADI ANDA',
                        style: TextStyle(
                          color: AppColors.goldText,
                          fontSize: 11.2,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.85,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Parkir harap tenang.\nPergi tanpa repot',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          height: 1.18,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Serahkan kunci, nikmati waktu Anda. PARVE\nmengurus parkir hingga mobil siap kembali.',
                        style: TextStyle(
                          color: Color(0xFFA0A39E),
                          fontSize: 13.5,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Row(
                        children: [
                          _FeaturePoint(label: 'Petugas tepercaya'),
                          SizedBox(width: 18),
                          _FeaturePoint(label: 'Tarif transparan'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.bgPage,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(
                  21,
                  22,
                  21,
                  bottomPadding > 0 ? bottomPadding + 12 : 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Material(
                      color: AppColors.goldButton,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () =>
                            _openAuthOrMain(context, isRegister: false),
                        borderRadius: BorderRadius.circular(12),
                        child: const SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 19,
                                color: AppColors.onGold,
                              ),
                              SizedBox(width: 9),
                              Text(
                                'Masuk ke PARVE',
                                style: TextStyle(
                                  color: AppColors.onGold,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 11),
                    Material(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () =>
                            _openAuthOrMain(context, isRegister: true),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.cardBorder,
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            'Daftar akun baru',
                            style: TextStyle(
                              color: AppColors.darkPrimary,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Valet lebih mudah, mulai dari Jakarta.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturePoint extends StatelessWidget {
  final String label;

  const _FeaturePoint({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.verified_user_outlined,
          color: AppColors.goldText,
          size: 16,
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFD5D7D2),
            fontSize: 12.2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
