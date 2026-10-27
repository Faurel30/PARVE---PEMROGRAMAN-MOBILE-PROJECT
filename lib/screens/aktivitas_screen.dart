import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../models/auth_store.dart';
import '../models/ticket_model.dart';
import '../widgets/parve_bottom_nav.dart';
import '../widgets/parve_header.dart';
import '../widgets/ticket_card.dart';
import 'beranda_screen.dart';
import 'dompet_screen.dart';
import 'kendaraan_saya_screen.dart';
import 'pantau_kendaraan_screen.dart';
import 'profil_screen.dart';

class AktivitasScreen extends StatefulWidget {
  final int initialTabIndex;

  const AktivitasScreen({super.key, this.initialTabIndex = 0});

  @override
  State<AktivitasScreen> createState() => _AktivitasScreenState();
}

class _AktivitasScreenState extends State<AktivitasScreen> {
  late int _selectedTabIndex = widget.initialTabIndex;

  ParkingTicket get _activeTicket => AuthStore.activeTicket;

  void _updateActiveTicket(ParkingTicket updated) {
    setState(() => AuthStore.activeTicket = updated);
  }

  Future<void> _openKendaraanSaya() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const KendaraanSayaScreen()),
    );
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openPantauKendaraan() async {
    final updated = await Navigator.push<ParkingTicket>(
      context,
      MaterialPageRoute(
        builder: (context) => PantauKendaraanScreen(
          ticket: _activeTicket,
          onTicketUpdated: (newTicket) {
            if (mounted) {
              _updateActiveTicket(newTicket);
            }
          },
        ),
      ),
    );
    if (updated != null && mounted) {
      _updateActiveTicket(updated);
    }
  }

  void _onBottomNavTap(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          settings: const RouteSettings(name: '/home'),
          pageBuilder: (_, _, _) => const BerandaScreen(),
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

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Bantuan Tiket Digital',
          style: TextStyle(color: AppColors.darkPrimary),
        ),
        content: Text(
          'Tunjukkan QR Code pada tiket aktif kepada petugas valet saat ingin mengambil kendaraan Anda.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        title: 'Aktivitas',
                        onHelpTap: _showHelpDialog,
                      ),
                      const SizedBox(height: 15),
                      _buildSegmentedTabs(),
                      const SizedBox(height: 17),
                      if (_selectedTabIndex == 0) ...[
                        TicketCard(
                          ticket: _activeTicket,
                          onVehicleTap: _openKendaraanSaya,
                        ),
                        const SizedBox(height: 18),
                        _buildPantauButton(),
                        const SizedBox(height: 14),
                        Text(
                          'Biaya parkir dibayar saat pengambilan kendaraan.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11.8,
                          ),
                        ),
                      ] else ...[
                        for (final item in ParkingTicket.sampleHistory) ...[
                          TicketCard(ticket: item),
                          const SizedBox(height: 14),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
              ParveBottomNav(
                currentIndex: 1,
                onTap: _onBottomNavTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedTabs() {
    const tabs = ['Tiket aktif', 'Riwayat parkir'];
    return Row(
      children: List.generate(tabs.length, (i) {
        final isSelected = _selectedTabIndex == i;
        return Expanded(
          child: Padding(
            padding:
                EdgeInsets.only(left: i == 0 ? 0 : 4, right: i == 0 ? 4 : 0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedTabIndex = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.heroDark : AppColors.surface,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : AppColors.cardBorder,
                  ),
                ),
                child: Text(
                  tabs[i],
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontSize: 12.8,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPantauButton() {
    return Material(
      color: AppColors.goldButton,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: _openPantauKendaraan,
        borderRadius: BorderRadius.circular(11),
        child: const SizedBox(
          height: 49,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.gps_fixed_rounded, size: 18, color: AppColors.onGold),
              SizedBox(width: 9),
              Text(
                'Pantau kendaraan',
                style: TextStyle(
                  color: AppColors.onGold,
                  fontSize: 14.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
