import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../painters/parve_logo_painter.dart';
import 'login_screen.dart';
import 'register_screen.dart';

// =============================================================================
// SCREEN 1: ONBOARDING / LANDING PAGE (PARVE · Selamat datang)
// =============================================================================
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ParveColors.darkBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Scrollable Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Logo Hero Card
                    Container(
                      width: double.infinity,
                      height: 270,
                      decoration: BoxDecoration(
                        gradient: const RadialGradient(
                          center: Alignment(0, -0.2),
                          radius: 1.0,
                          colors: [
                            Color(0xFF282D2A),
                            Color(0xFF1B1E1C),
                            Color(0xFF121413),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.45),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: CustomPaint(
                          size: const Size(260, 190),
                          painter: ParveBrandLogoPainter(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Small Uppercase Header Tag
                    const Text(
                      'LAYANAN VALET PRIBADI ANDA',
                      style: TextStyle(
                        color: ParveColors.gold,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.6,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Main Headline
                    const Text(
                      'Parkir harap tenang.\nPergi tanpa repot',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        height: 1.22,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle Body
                    const Text(
                      'Serahkan kunci, nikmati waktu Anda. PARVE mengurus parkir hingga mobil siap kembali.',
                      style: TextStyle(
                        color: Color(0xFF9EABA2),
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Key Features List
                    Row(
                      children: [
                        _buildFeatureItem('Petugas tepercaya'),
                        const SizedBox(width: 20),
                        _buildFeatureItem('Tarif transparan'),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Bottom White Card with Buttons
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Gold Button: Masuk ke PARVE
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ParveColors.gold,
                          foregroundColor: const Color(0xFF1E1E1E),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_forward, size: 20, color: Color(0xFF1A1A1A)),
                            SizedBox(width: 8),
                            Text(
                              'Masuk ke PARVE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // White Button: Daftar akun baru
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF111827),
                          side: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Daftar akun baru',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Footer text
                    const Text(
                      'Valet lebih mudah, mulai dari Jakarta.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // iOS Home Indicator Bar
                    Container(
                      width: 134,
                      height: 4.5,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildFeatureItem(String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: const [
            Icon(Icons.shield_outlined, color: ParveColors.gold, size: 20),
            Icon(Icons.check, color: ParveColors.gold, size: 11),
          ],
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

