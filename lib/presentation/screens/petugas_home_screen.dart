import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/ticket_data.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/supabase_service.dart';
import 'auth/welcome_screen.dart';
import 'vehicle_list_screen.dart';
import 'notifications_screen.dart';
import 'parking_slot_screen.dart';

class PetugasHomeScreen extends StatefulWidget {
  final bool animateLaser;
  final Officer? initialOfficer;

  const PetugasHomeScreen({
    super.key,
    this.animateLaser = true,
    this.initialOfficer,
  });

  @override
  State<PetugasHomeScreen> createState() => _PetugasHomeScreenState();
}

class _PetugasHomeScreenState extends State<PetugasHomeScreen> {
  int _currentTab = 0; // 0: Kendaraan, 1: Slot Parkir, 2: Notifikasi
  late Officer _currentOfficer;

  // List of vehicles (Mau diparkir, terparkir, mau diambil, sudah keluar)
  final List<ValetVehicle> _vehicles = ValetVehicle.generateSampleVehicles();

  // List of notifications – diinisialisasi dari status semua kendaraan
  late List<OfficerNotification> _notifications;
  StreamSubscription<List<OfficerNotification>>? _notifSubscription;

  @override
  void initState() {
    super.initState();
    _currentOfficer = widget.initialOfficer ??
        AuthService.instance.currentOfficer ??
        Officer.rizky;

    // Inisialisasi notifikasi dari status semua kendaraan saat ini
    _notifications = OfficerNotification.generateInitialNotifications(_vehicles);

    // Berlangganan stream realtime Supabase / lokal
    _notifSubscription = SupabaseService.instance.streamNotifications().listen((notifs) {
      if (mounted && notifs.isNotEmpty) {
        setState(() {
          _notifications = List.from(notifs);
        });
      }
    });
  }

  @override
  void dispose() {
    _notifSubscription?.cancel();
    super.dispose();
  }

  void _onAddNewVehicle(ValetVehicle newVehicle, OfficerNotification newNotif) {
    setState(() {
      _vehicles.insert(0, newVehicle);
    });
    SupabaseService.instance.sendNotification(newNotif);
  }

  void _onUpdateVehicle(ValetVehicle updatedVehicle, OfficerNotification? newNotif) {
    setState(() {
      final index = _vehicles.indexWhere((v) => v.id == updatedVehicle.id);
      if (index != -1) {
        _vehicles[index] = updatedVehicle;
      }
    });
    if (newNotif != null) {
      SupabaseService.instance.sendNotification(newNotif);
      // Tampilkan snackbar notifikasi status baru
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.notifications_active_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  newNotif.title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1E2129),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          action: SnackBarAction(
            label: 'Lihat',
            textColor: const Color(0xFFE5A93C),
            onPressed: () => setState(() => _currentTab = 2),
          ),
        ),
      );
    }
  }

  void _switchToNotifications() {
    setState(() {
      _currentTab = 2;
      // Per Figma Screen 3, Petugas for notifications is Fajar Hidayat
      _currentOfficer = Officer.fajar;
    });
  }

  void _switchToVehicles() {
    setState(() {
      _currentTab = 0;
      // Return to active officer
      if (_currentOfficer.initials == 'FH' && widget.initialOfficer != null) {
        _currentOfficer = widget.initialOfficer!;
      }
    });
  }

  void _showOfficerMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      constraints: const BoxConstraints(maxWidth: 640),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.goldDarkBg,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.goldBorder),
                      ),
                      child: Center(
                        child: Text(
                          _currentOfficer.initials,
                          style: const TextStyle(
                            color: AppColors.goldPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentOfficer.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_currentOfficer.officerId.isNotEmpty ? "${_currentOfficer.officerId} · " : ""}${_currentOfficer.location}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.successGreenDark,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Aktif Bertugas',
                        style: TextStyle(
                          color: AppColors.successGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: AppColors.divider, height: 1),
                const SizedBox(height: 12),

                // Shift Handover / Switch Officer
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.swap_horiz_rounded, color: AppColors.goldPrimary),
                  ),
                  title: const Text(
                    'Serah Terima Shift (Ganti Petugas)',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Ganti ke ${_currentOfficer.initials == "RS" ? "Fajar Hidayat" : "Rizky Saputra"}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _toggleOfficer();
                  },
                ),

                // Logout
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B1212),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
                  ),
                  title: const Text(
                    'Keluar Akun (Logout)',
                    style: TextStyle(color: Color(0xFFEF4444), fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Akhiri sesi dan kembali ke halaman selamat datang',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    AuthService.instance.logout();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleOfficer() {
    setState(() {
      if (_currentOfficer.initials == 'RS') {
        _currentOfficer = Officer.fajar;
      } else {
        _currentOfficer = Officer.rizky;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Berganti Petugas: ${_currentOfficer.name} (${_currentOfficer.shift})',
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
        ),
        backgroundColor: AppColors.card,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentTab) {
      case 0:
        return VehicleListScreen(
          officer: _currentOfficer,
          vehicles: _vehicles,
          onAddNewVehicle: _onAddNewVehicle,
          onUpdateVehicle: _onUpdateVehicle,
          onOpenNotifications: _switchToNotifications,
          onSwitchOfficer: _showOfficerMenu,
        );
      case 1:
        return ParkingSlotScreen(
          officer: _currentOfficer,
          onOpenNotifications: _switchToNotifications,
          onSwitchOfficer: _showOfficerMenu,
        );
      case 2:
      default:
        return NotificationsScreen(
          officer: _currentOfficer,
          notifications: _notifications,
          onBackToVehicles: _switchToVehicles,
          onBackToScan: _switchToVehicles,
          onSwitchOfficer: _showOfficerMenu,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: _buildBody(),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 72,
        decoration: const BoxDecoration(
          color: AppColors.navBackground,
          border: Border(
            top: BorderSide(color: AppColors.divider, width: 1),
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: _buildBottomNav(),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final pendingCount = _vehicles
        .where((v) =>
            v.status == ValetVehicleStatus.akanDatang ||
            v.status == ValetVehicleStatus.mauDiambil)
        .length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Tab 0: Kendaraan (Utama Petugas)
          _buildNavItem(
            index: 0,
            icon: Icons.directions_car_rounded,
            label: 'Kendaraan',
            isActive: _currentTab == 0,
            badgeCount: pendingCount,
            onTap: () {
              setState(() {
                _currentTab = 0;
              });
            },
          ),

          // Tab 1: Slot Parkir
          _buildNavItem(
            index: 1,
            icon: Icons.local_parking_rounded,
            label: 'Slot',
            isActive: _currentTab == 1,
            onTap: () {
              setState(() {
                _currentTab = 1;
              });
            },
          ),

          // Tab 2: Notifikasi
          _buildNavItem(
            index: 2,
            icon: Icons.notifications_none_rounded,
            label: 'Notifikasi',
            isActive: _currentTab == 2,
            badgeCount: _notifications.length,
            onTap: () {
              setState(() {
                _currentTab = 2;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 12 : 8,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.navActiveBg : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: isActive
              ? Border.all(
                  color: AppColors.goldBorder.withValues(alpha: 0.7),
                  width: 1,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 19,
                  color: isActive
                      ? AppColors.goldPrimary
                      : AppColors.navInactiveText,
                ),
                if (badgeCount > 0 && !isActive)
                  Positioned(
                    top: -2,
                    right: -4,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.goldPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? AppColors.goldPrimary
                    : AppColors.navInactiveText,
                fontSize: 11.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
