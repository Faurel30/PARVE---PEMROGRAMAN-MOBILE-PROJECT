import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/ticket_data.dart';
import '../../core/services/auth_service.dart';
import 'auth/welcome_screen.dart';
import 'scan_screen.dart';
import 'scan_result_screen.dart';
import 'notifications_screen.dart';
import 'parking_slot_screen.dart';
import '../widgets/evaluation_bottom_sheet.dart';

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
  int _currentTab = 0; // 0: Scan, 1: Slot Parkir, 2: Notifikasi
  bool _hasScanResult = false; // true if showing Screen 2 (Hasil Scan Keluar)
  late Officer _currentOfficer;

  @override
  void initState() {
    super.initState();
    _currentOfficer = widget.initialOfficer ??
        AuthService.instance.currentOfficer ??
        Officer.rizky;
  }

  // Active ticket being viewed
  VehicleTicket _currentTicket = VehicleTicket.sampleExitScan;

  // List of notifications
  final List<OfficerNotification> _notifications = [
    OfficerNotification.sampleFigmaNotification,
  ];

  void _onScanPressed([String? barcode]) {
    setState(() {
      _hasScanResult = true;
      _currentTicket = VehicleTicket.sampleExitScan;
    });
  }

  void _onScanNext() {
    setState(() {
      _hasScanResult = false;
    });
  }

  void _switchToNotifications() {
    setState(() {
      _currentTab = 2;
      // Per Figma Screen 3, Petugas for notifications is Fajar Hidayat
      _currentOfficer = Officer.fajar;
    });
  }

  void _switchToScan() {
    setState(() {
      _currentTab = 0;
      _hasScanResult = false;
      // Return to active officer
      if (_currentOfficer.initials == 'FH' && widget.initialOfficer != null) {
        _currentOfficer = widget.initialOfficer!;
      }
    });
  }

  void _switchToSlots() {
    setState(() {
      _currentTab = 1;
    });
  }

  void _showOfficerMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
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

  void _simulateAdminApproval() {
    // Generate approval notification
    final newNotif = OfficerNotification(
      id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Keluar Disetujui',
      subtitle: '${_currentTicket.plateNumber} · ${_currentTicket.driverName}',
      time: '14.38',
      authorInfo: 'Admin Dimas Pratama · Detail notifikasi terbuka',
      ticket: VehicleTicket(
        plateNumber: _currentTicket.plateNumber,
        driverName: _currentTicket.driverName,
        vehicleModel: _currentTicket.vehicleModel,
        ticketNumber: _currentTicket.ticketNumber,
        slot: _currentTicket.slot,
        scanTime: _currentTicket.scanTime,
        officerName: _currentOfficer.name,
        paymentStatus: 'Sudah terverifikasi',
        exitApprovalStatus: 'Keluar Disetujui',
        isApproved: true,
        approvedBy: 'Admin Dimas Pratama',
        approvalTime: '8 Okt 2026 · 14.38 WIB',
        transactionStatus: 'Selesai',
      ),
      isDetailOpen: true,
    );

    setState(() {
      _notifications.insert(0, newNotif);
      _currentTab = 2; // Jump to notifications tab
      _currentOfficer = Officer.fajar;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '🔔 Notifikasi Baru: Keluar telah disetujui oleh Admin!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Color(0xFF1B4D2E),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showEvaluationSheet() {
    EvaluationBottomSheet.show(
      context,
      onSimulateManualPlate: (plate) {
        setState(() {
          _currentTicket = VehicleTicket(
            plateNumber: plate.isNotEmpty ? plate : 'B 1234 PAR',
            driverName: 'Aditya Wijaya (Input Manual)',
            vehicleModel: 'Toyota Alphard · Hitam',
            ticketNumber: 'PV-081026-0248',
            slot: 'A-018',
            scanTime: '8 Okt 2026 · 14.40 WIB',
            officerName: _currentOfficer.name,
            paymentStatus: 'Sudah terverifikasi',
            exitApprovalStatus: 'Belum disetujui',
          );
          _hasScanResult = true;
          _currentTab = 0;
        });
      },
      onSimulateEmergencyGate: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '⚠️ Palang Darurat Dibuka Manual oleh Petugas. Log tersimpan ke server!',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            backgroundColor: Color(0xFF701A1A),
            duration: Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    switch (_currentTab) {
      case 0:
        return _hasScanResult
            ? ScanResultScreen(
                officer: _currentOfficer,
                ticket: _currentTicket,
                onScanNext: _onScanNext,
                onOpenNotifications: _switchToNotifications,
                onSimulateAdminApproval: _simulateAdminApproval,
                onSwitchOfficer: _showOfficerMenu,
              )
            : ScanScreen(
                officer: _currentOfficer,
                onScanPressed: _onScanPressed,
                onOpenNotifications: _switchToNotifications,
                onSwitchOfficer: _showOfficerMenu,
                onShowEvaluation: _showEvaluationSheet,
                onViewSlots: _switchToSlots,
                animateLaser: widget.animateLaser,
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
          onBackToScan: _switchToScan,
          onSwitchOfficer: _showOfficerMenu,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _buildBody(),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: AppColors.navBackground,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Tab 0: Scan
          _buildNavItem(
            index: 0,
            icon: Icons.crop_free_rounded,
            label: 'Scan',
            isActive: _currentTab == 0,
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
          horizontal: isActive ? 20 : 14,
          vertical: 8,
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
                  size: 20,
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
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? AppColors.goldPrimary
                    : AppColors.navInactiveText,
                fontSize: 12.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
