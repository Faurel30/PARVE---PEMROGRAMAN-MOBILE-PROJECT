import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../models/auth_store.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  static const Color _bgDark = Color(0xFF15130F);
  static const Color _gold = Color(0xFFC9A86A);
  static const Color _mutedText = Color(0xFFA29E95);

  final PageController _cardController = PageController();
  int _currentSlide = 0;

  static const List<_ValetPassPreviewData> _slides = [
    _ValetPassPreviewData(
      mallName: 'SENAYAN CITY',
      area: 'LOBI UTAMA',
      badgeText: 'Live Terparkir Aman',
      footerLeft: 'Timer: 01:15:20',
      footerRight: 'Rp5.000/jam',
    ),
    _ValetPassPreviewData(
      mallName: 'GRAND INDONESIA',
      area: 'EAST MALL',
      badgeText: 'Petugas Terverifikasi',
      footerLeft: 'Area: VIP Valet B1',
      footerRight: 'Serah terima resmi',
    ),
    _ValetPassPreviewData(
      mallName: 'PIM 2',
      area: 'NORTH SKYWALK',
      badgeText: 'Siap Diantar ±5 Menit',
      footerLeft: 'Panggil 1-Tap',
      footerRight: 'QRIS & Bank',
    ),
  ];

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

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
        backgroundColor: _bgDark,
        body: Stack(
          children: [
            // Pendaran emas hangat di bagian atas layar
            Positioned(
              top: -140,
              left: -60,
              right: -60,
              child: IgnorePointer(
                child: Container(
                  height: 420,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 0.85,
                      colors: [
                        _gold.withValues(alpha: 0.42),
                        _gold.withValues(alpha: 0.12),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.45, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(22, 14, 22, 22),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildTopSection(),
                                  const SizedBox(height: 28),
                                  _buildCopySection(),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  _buildBottomSheet(context, bottomPadding),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header (logo kiri atas + pill lokasi) + kartu 3D + indikator slide
  Widget _buildTopSection() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _gold.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo_parve.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'PARVE',
              style: TextStyle(
                fontFamily: 'serif',
                color: Color(0xFFF3EEE4),
                fontSize: 22,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF26231E).withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.14),
                ),
              ),
              child: const Text.rich(
                TextSpan(
                  style: TextStyle(
                    color: Color(0xFFEDE9E1),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(text: 'ID '),
                    TextSpan(
                      text: '•',
                      style: TextStyle(color: _gold),
                    ),
                    TextSpan(text: ' Jakarta'),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _cardController,
            clipBehavior: Clip.none,
            itemCount: _slides.length,
            onPageChanged: (index) {
              setState(() {
                _currentSlide = index;
              });
            },
            itemBuilder: (context, index) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: _Tilted3DValetPass(data: _slides[index]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_slides.length, (index) {
            final isSelected = index == _currentSlide;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 3.5),
              width: isSelected ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.28),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  // Overline + headline + subtitle + 2 kartu fitur profesional
  Widget _buildCopySection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 1,
              color: _gold.withValues(alpha: 0.55),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'PENGALAMAN VALET MODERN',
                style: TextStyle(
                  color: _gold,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.4,
                ),
              ),
            ),
            Container(
              width: 40,
              height: 1,
              color: _gold.withValues(alpha: 0.55),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          'Parkir harap tenang.\nPergi tanpa repot.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            height: 1.2,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Serahkan kunci di lobi utama, pantau timer real-time,\ndan panggil mobil 1-tap.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _mutedText,
            fontSize: 12.2,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 18),
        const Row(
          children: [
            Expanded(
              child: _ProfessionalTrustPill(
                icon: Icons.check_circle_outline_rounded,
                title: 'Petugas Resmi',
                subtitle: 'Serah terima terjamin',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _ProfessionalTrustPill(
                icon: Icons.timer_outlined,
                title: 'Pantau Real-Time',
                subtitle: 'Tiket QR & timer aktif',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Bottom sheet ivory: tombol pil emas + tombol teks daftar
  Widget _buildBottomSheet(BuildContext context, double bottomPadding) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgPage,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        bottomPadding > 0 ? bottomPadding + 6 : 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: AppColors.goldButton,
            shape: const StadiumBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => _openAuthOrMain(context, isRegister: false),
              child: const SizedBox(
                height: 54,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Masuk ke PARVE',
                      style: TextStyle(
                        color: AppColors.onGold,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 19,
                      color: AppColors.onGold,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Material(
            color: Colors.transparent,
            shape: const StadiumBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => _openAuthOrMain(context, isRegister: true),
              child: SizedBox(
                height: 48,
                child: Center(
                  child: Text(
                    'Daftar akun baru',
                    style: TextStyle(
                      color: AppColors.darkPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ValetPassPreviewData {
  final String mallName;
  final String area;
  final String badgeText;
  final String footerLeft;
  final String footerRight;

  const _ValetPassPreviewData({
    required this.mallName,
    required this.area,
    required this.badgeText,
    required this.footerLeft,
    required this.footerRight,
  });
}

/// Kartu tiket valet digital bergaya logam (brushed metal) dengan tepi emas,
/// dimiringkan secara 3D dan diberi lapisan "ketebalan" di belakangnya.
class _Tilted3DValetPass extends StatelessWidget {
  final _ValetPassPreviewData data;

  const _Tilted3DValetPass({required this.data});

  static const Color _gold = Color(0xFFC9A86A);

  @override
  Widget build(BuildContext context) {
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.0012)
      ..rotateX(0.30)
      ..rotateY(-0.16)
      ..rotateZ(-0.13);

    return Transform(
      alignment: Alignment.center,
      transform: transform,
      child: AspectRatio(
        aspectRatio: 1.62,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Lapisan ketebalan kartu (tepi emas di bawah)
            Positioned.fill(
              top: 7,
              bottom: -7,
              left: -2,
              right: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF8A6E3E),
                      Color(0xFFD9BC82),
                      Color(0xFF6E5530),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.65),
                      blurRadius: 28,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
              ),
            ),
            // Permukaan kartu
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 18, 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _gold.withValues(alpha: 0.75),
                    width: 1.4,
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF45443F),
                      Color(0xFF302F2B),
                      Color(0xFF1F1E1B),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          color: Color(0xFFF1EEE8),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                        children: [
                          TextSpan(text: data.mallName),
                          const TextSpan(
                            text: '  •  ',
                            style: TextStyle(color: _gold),
                          ),
                          TextSpan(text: data.area),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: _LiveBadge(text: data.badgeText),
                            ),
                          ),
                          const SizedBox(width: 10),
                          AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/qr_code.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          color: Color(0xFFD9D5CC),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(text: data.footerLeft),
                          const TextSpan(
                            text: '  •  ',
                            style: TextStyle(color: _gold),
                          ),
                          TextSpan(text: data.footerRight),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
}

class _LiveBadge extends StatelessWidget {
  final String text;

  const _LiveBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF173A2A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF2FA86E).withValues(alpha: 0.7),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF3DDC8E),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF6BE5A8),
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfessionalTrustPill extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ProfessionalTrustPill({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  static const Color _gold = Color(0xFFC9A86A);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 13, 10, 13),
      decoration: BoxDecoration(
        color: const Color(0xFF211E19),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _gold.withValues(alpha: 0.38)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _gold.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: _gold, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF9E9A91),
                    fontSize: 10.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
