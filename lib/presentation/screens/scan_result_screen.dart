import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/ticket_data.dart';
import '../widgets/parve_header.dart';
import '../widgets/vehicle_info_card.dart';
import '../widgets/admin_status_card.dart';

class ScanResultScreen extends StatelessWidget {
  final Officer officer;
  final VehicleTicket ticket;
  final VoidCallback onScanNext;
  final VoidCallback onOpenNotifications;
  final VoidCallback onSimulateAdminApproval;
  final VoidCallback onSwitchOfficer;

  const ScanResultScreen({
    super.key,
    required this.officer,
    required this.ticket,
    required this.onScanNext,
    required this.onOpenNotifications,
    required this.onSimulateAdminApproval,
    required this.onSwitchOfficer,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (PARVE Logo, Pacific Place, Officer Card)
          ParveHeader(
            officer: officer,
            unreadNotifications: 1,
            onNotificationTap: onOpenNotifications,
            onSwitchOfficer: onSwitchOfficer,
          ),
          const SizedBox(height: 18),

          // Title: Hasil Scan Keluar
          const Text(
            'Hasil Scan Keluar',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),

          // Status Badge: Barcode valid · Scan diterima Admin
          Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.successGreen,
                size: 16,
              ),
              const SizedBox(width: 6),
              const Text(
                'Barcode valid · Scan diterima Admin',
                style: TextStyle(
                  color: AppColors.successGreen,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Alert Box: Menunggu verifikasi Admin
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.goldDarkBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.goldBorder, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row with clock icon and Title
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: AppColors.goldPrimary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Menunggu verifikasi Admin',
                      style: TextStyle(
                        color: AppColors.goldPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Bold subheadline
                const Text(
                  'Kendaraan belum diizinkan keluar.',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),

                // Explanation text
                const Text(
                  'Barcode valid tidak berarti keluar disetujui. Tunggu notifikasi keputusan Admin.',
                  style: TextStyle(
                    color: AppColors.goldMutedText,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Vehicle Info Card
          VehicleInfoCard(ticket: ticket),
          const SizedBox(height: 14),

          // Status dari Admin Card
          AdminStatusCard(ticket: ticket),
          const SizedBox(height: 20),

          // Main Button: Scan barcode berikutnya
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onScanNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldPrimary,
                foregroundColor: const Color(0xFF111215),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 20,
                    color: Color(0xFF111215),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Scan barcode berikutnya',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Interactive Demo Simulation Button
          OutlinedButton(
            onPressed: onSimulateAdminApproval,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.goldBorder, width: 1),
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bolt_rounded,
                  color: AppColors.goldPrimary,
                  size: 18,
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Simulasikan Keputusan Admin (Terima Notifikasi)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.goldPrimary,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
