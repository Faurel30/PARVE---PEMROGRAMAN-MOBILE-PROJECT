import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../models/auth_store.dart';
import '../widgets/booking_step_header.dart';
import '../widgets/parve_bottom_nav.dart';
import 'aktivitas_screen.dart';
import 'beranda_screen.dart';
import 'dompet_screen.dart';

class PengaturanScreen extends StatefulWidget {
  const PengaturanScreen({super.key});

  @override
  State<PengaturanScreen> createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreen> {
  void _onBottomNavTap(int index) {
    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          settings: const RouteSettings(name: '/home'),
          pageBuilder: (_, _, _) => const BerandaScreen(),
          transitionDuration: Duration.zero,
        ),
        (_) => false,
      );
    } else if (index == 1) {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          settings: const RouteSettings(name: '/aktivitas'),
          pageBuilder: (_, _, _) => const AktivitasScreen(),
          transitionDuration: Duration.zero,
        ),
        (_) => false,
      );
    } else if (index == 2) {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          settings: const RouteSettings(name: '/dompet'),
          pageBuilder: (_, _, _) => const DompetScreen(),
          transitionDuration: Duration.zero,
        ),
        (_) => false,
      );
    } else if (index == 3) {
      Navigator.pop(context);
    }
  }

  void _showHelpCenterDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Pusat Bantuan PARVE',
          style: TextStyle(color: AppColors.darkPrimary),
        ),
        content: Text(
          'Hubungi tim layanan pelanggan PARVE 24/7 melalui petugas lobi mal atau email support@parve.id.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark;

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
                  padding: const EdgeInsets.fromLTRB(21, 12, 21, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const BookingTopBar(title: 'Pengaturan'),
                      const SizedBox(height: 20),
                      Text(
                        'Tampilan',
                        style: TextStyle(
                          color: AppColors.darkPrimary,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pilih satu mode tampilan untuk aplikasi PARVE.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.6,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _ThemeModeCard(
                              label: 'Mode terang',
                              isDarkPreview: false,
                              isSelected: !isDark,
                              onTap: () =>
                                  setState(() => AppColors.setDarkMode(false)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ThemeModeCard(
                              label: 'Mode gelap',
                              isDarkPreview: true,
                              isSelected: isDark,
                              onTap: () =>
                                  setState(() => AppColors.setDarkMode(true)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isDark
                            ? 'Mode gelap sedang digunakan.'
                            : 'Mode terang sedang digunakan.',
                        style: TextStyle(
                          color: AppColors.navActive,
                          fontSize: 11.8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Notifikasi',
                        style: TextStyle(
                          color: AppColors.darkPrimary,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildNotificationCard(),
                      const SizedBox(height: 14),
                      _buildHelpCenterCard(),
                    ],
                  ),
                ),
              ),
              ParveBottomNav(
                currentIndex: 3,
                onTap: _onBottomNavTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.darkPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifikasi layanan',
                      style: TextStyle(
                        color: AppColors.darkPrimary,
                        fontSize: 13.8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Status valet dan transaksi',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11.6,
                      ),
                    ),
                  ],
                ),
              ),
              ParveGoldSwitch(
                value: AuthStore.serviceNotificationsEnabled,
                onChanged: (val) => setState(
                  () => AuthStore.serviceNotificationsEnabled = val,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, thickness: 1, color: AppColors.divider),
          ),
          Text(
            'Terima pembaruan pemesanan, status kendaraan, dan transaksi Anda.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.8,
              height: 1.38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCenterCard() {
    return GestureDetector(
      onTap: _showHelpCenterDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder, width: 1.2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pusat bantuan',
                    style: TextStyle(
                      color: AppColors.darkPrimary,
                      fontSize: 13.8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Bantuan seputar aplikasi dan layanan valet',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11.6,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeModeCard extends StatelessWidget {
  final String label;
  final bool isDarkPreview;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeModeCard({
    required this.label,
    required this.isDarkPreview,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final previewBg =
        isDarkPreview ? const Color(0xFF1D201D) : const Color(0xFFF6F6F2);
    final previewCard =
        isDarkPreview ? const Color(0xFF2B2F2A) : Colors.white;
    final previewText =
        isDarkPreview ? Colors.white : const Color(0xFF20231F);
    final barPrimary =
        isDarkPreview ? const Color(0xFFB5B8B2) : const Color(0xFF8C8F8A);
    final barSecondary =
        isDarkPreview ? const Color(0xFF5E625C) : const Color(0xFFE0E2DA);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.softGoldCard : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? const Color(0xFFD4B46C) : AppColors.cardBorder,
            width: isSelected ? 1.5 : 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: previewBg,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PARVE',
                        style: TextStyle(
                          color: previewText,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                      Icon(
                        isDarkPreview
                            ? Icons.dark_mode_outlined
                            : Icons.wb_sunny_outlined,
                        size: 14,
                        color: AppColors.goldText,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: previewCard,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 64,
                          height: 4.5,
                          decoration: BoxDecoration(
                            color: barPrimary,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: 86,
                          height: 4,
                          decoration: BoxDecoration(
                            color: barSecondary,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(height: 9),
                        Container(
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.goldButton,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 20,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: previewCard,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(4, (idx) {
                        return Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: idx == 0 ? AppColors.goldButton : barSecondary,
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 11),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: AppColors.darkPrimary,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_off_rounded,
                    size: 19,
                    color: isSelected
                        ? AppColors.navActive
                        : AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable toggle switch emas lembut (dipakai di Profil & Pengaturan)
class ParveGoldSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const ParveGoldSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 44,
        height: 25,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
          color: value ? AppColors.goldButton : AppColors.cardBorder,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: 19,
          height: 19,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

