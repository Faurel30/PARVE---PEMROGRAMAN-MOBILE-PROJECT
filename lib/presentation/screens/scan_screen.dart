import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/ticket_data.dart';
import '../widgets/parve_header.dart';
import '../widgets/camera_scanner_box.dart';
import 'camera_scan_screen.dart';

class ScanScreen extends StatefulWidget {
  final Officer officer;
  final Function(String? barcode) onScanPressed;
  final VoidCallback onOpenNotifications;
  final VoidCallback onSwitchOfficer;
  final VoidCallback? onShowEvaluation;
  final VoidCallback onViewSlots;
  final bool animateLaser;

  const ScanScreen({
    super.key,
    required this.officer,
    required this.onScanPressed,
    required this.onOpenNotifications,
    required this.onSwitchOfficer,
    this.onShowEvaluation,
    required this.onViewSlots,
    this.animateLaser = true,
  });

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  void _openCamera() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScanScreen(
          animateLaser: widget.animateLaser,
          onBarcodeDetected: (barcode) {
            widget.onScanPressed(barcode);
          },
        ),
      ),
    );

    if (result != null && mounted) {
      widget.onScanPressed(result);
    }
  }

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
            officer: widget.officer,
            unreadNotifications: 1,
            onNotificationTap: widget.onOpenNotifications,
            onSwitchOfficer: widget.onSwitchOfficer,
          ),
          const SizedBox(height: 20),

          // Title & Description
          const Text(
            'Scan Barcode',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Pindai barcode dari user. Verifikasi masuk dan keluar dilakukan oleh Admin.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Camera Viewfinder Box (Mockup matching Figma - tap to open camera)
          InkWell(
            onTap: _openCamera,
            borderRadius: BorderRadius.circular(16),
            child: CameraScannerBox(animateLaser: widget.animateLaser),
          ),
          const SizedBox(height: 14),

          // Quick Slot Availability Card (Tapping switches to Slot tab)
          InkWell(
            onTap: widget.onViewSlots,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 0.9),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppColors.successGreenDark,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.successGreenBorder,
                        width: 0.8,
                      ),
                    ),
                    child: const Icon(
                      Icons.local_parking_rounded,
                      color: AppColors.successGreen,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ketersediaan Slot Parkir',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          '38 Slot Kosong di B1 & B2 • Ketuk untuk lihat',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.goldPrimary,
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Instruction rows
          _buildInstructionRow(
            Icons.crop_free_rounded,
            'Arahkan ke barcode di layar user.',
          ),
          const SizedBox(height: 10),
          _buildInstructionRow(
            Icons.wb_sunny_outlined,
            'Pastikan barcode jelas dan tidak silau.',
          ),
          const SizedBox(height: 18),

          // Main Action Button: Scan barcode user (Opens Camera)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _openCamera,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldPrimary,
                foregroundColor: const Color(0xFF111215),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    'Scan barcode user',
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
          const SizedBox(height: 14),

          // Notice Alert Banner: Barcode valid bukan izin keluar...
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.goldDarkBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.goldBorder, width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.shield_outlined,
                  color: AppColors.goldPrimary,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Barcode valid bukan izin keluar. Tunggu notifikasi persetujuan dari Admin.',
                    style: TextStyle(
                      color: AppColors.goldPrimary.withValues(alpha: 0.95),
                      fontSize: 12,
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Static Footnote
          const Center(
            child: Text(
              'Tampilan statis · Kamera dan scan tidak aktif',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInstructionRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.textSecondary,
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
