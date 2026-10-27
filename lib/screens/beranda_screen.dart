import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../models/auth_store.dart';
import '../widgets/parve_bottom_nav.dart';
import '../widgets/parve_header.dart';
import 'aktivitas_screen.dart';
import 'dompet_screen.dart';
import 'kendaraan_saya_screen.dart';
import 'notifikasi_screen.dart';
import 'pesan_valet_screen.dart';
import 'profil_screen.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  void _onBottomNavTap(int index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          settings: const RouteSettings(name: '/aktivitas'),
          pageBuilder: (_, _, _) => const AktivitasScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          settings: const RouteSettings(name: '/dompet'),
          pageBuilder: (_, _, _) => const DompetScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          settings: const RouteSettings(name: '/profil'),
          pageBuilder: (_, _, _) => const ProfilScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    }
  }

  void _openDompet() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        settings: const RouteSettings(name: '/dompet'),
        pageBuilder: (_, _, _) => const DompetScreen(),
        transitionDuration: Duration.zero,
      ),
    );
  }

  Future<void> _openPesanValet() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PesanValetScreen()),
    );
    if (mounted) setState(() {});
  }

  Future<void> _openKendaraanSaya() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const KendaraanSayaScreen()),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userName = AuthStore.currentUser?.firstName ?? 'Fahmi';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppColors.pageOverlayStyle,
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(21, 12, 21, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ParveHeader(
                        title: 'PARVE',
                        trailingIcon: Icons.notifications_none_rounded,
                        onHelpTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotifikasiScreen(),
                            ),
                          );
                          if (mounted) setState(() {});
                        },
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Kamis, 8 Oktober 2026',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Selamat siang, $userName',
                        style: TextStyle(
                          color: AppColors.darkPrimary,
                          fontSize: 23.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Mau ke mana hari ini?',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13.2,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildHeroCtaCard(),
                      const SizedBox(height: 14),
                      _buildQuickShortcutsRow(),
                      const SizedBox(height: 22),
                      _buildNearbySectionHeader(),
                      const SizedBox(height: 12),
                      _buildMallCard(),
                    ],
                  ),
                ),
              ),
              ParveBottomNav(
                currentIndex: 0,
                onTap: _onBottomNavTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCtaCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.heroDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nikmati waktu Anda.\nKami urus parkirnya.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19.5,
                        fontWeight: FontWeight.w700,
                        height: 1.24,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Valet mulai Rp35.000',
                      style: TextStyle(
                        color: AppColors.goldText,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Icon(
                Icons.directions_car_outlined,
                color: AppColors.goldText,
                size: 38,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Material(
            color: AppColors.goldButton,
            borderRadius: BorderRadius.circular(11),
            child: InkWell(
              onTap: _openPesanValet,
              borderRadius: BorderRadius.circular(11),
              child: const SizedBox(
                height: 47,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: AppColors.onGold,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Pesan valet',
                      style: TextStyle(
                        color: AppColors.onGold,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickShortcutsRow() {
    return Row(
      children: [
        Expanded(
          child: _ShortcutCard(
            icon: Icons.directions_car_outlined,
            title: 'Kendaraan',
            subtitle: '${AuthStore.savedVehicles.length} tersimpan',
            onTap: _openKendaraanSaya,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ShortcutCard(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Dompet saya',
            subtitle: AuthStore.displayWalletBalance,
            trailingAction: GestureDetector(
              onTap: () => setState(() => AuthStore.toggleBalanceVisibility()),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  AuthStore.isBalanceVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.textMuted,
                  size: 18,
                ),
              ),
            ),
            onTap: _openDompet,
          ),
        ),
      ],
    );
  }

  Widget _buildNearbySectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Valet di dekat Anda',
          style: TextStyle(
            color: AppColors.darkPrimary,
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        GestureDetector(
          onTap: _openPesanValet,
          child: Text(
            'Lihat semua',
            style: TextStyle(
              color: AppColors.navActive,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMallCard() {
    return GestureDetector(
      onTap: _openPesanValet,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.cardBorder, width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                'assets/images/senayan_city.png',
                height: 136,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 13),
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.navPillBg,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: AppColors.navActive,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Senayan City',
                        style: TextStyle(
                          color: AppColors.darkPrimary,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Lobi utama • Pintu selatan',
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
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '1,2 km • Buka hingga 22.00',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11.8,
                  ),
                ),
                Text(
                  'Tersedia',
                  style: TextStyle(
                    color: AppColors.badgeGreen,
                    fontSize: 12.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailingAction;

  const _ShortcutCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailingAction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder, width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: AppColors.navActive, size: 22),
                ?trailingAction,
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: AppColors.darkPrimary,
                fontSize: 13.8,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
