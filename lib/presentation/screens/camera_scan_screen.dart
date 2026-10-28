import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../core/theme/app_colors.dart';

class CameraScanScreen extends StatefulWidget {
  final Function(String rawValue) onBarcodeDetected;
  final bool animateLaser;

  const CameraScanScreen({
    super.key,
    required this.onBarcodeDetected,
    this.animateLaser = true,
  });

  @override
  State<CameraScanScreen> createState() => _CameraScanScreenState();
}

class _CameraScanScreenState extends State<CameraScanScreen>
    with SingleTickerProviderStateMixin {
  late MobileScannerController _scannerController;
  late AnimationController _laserController;
  late Animation<double> _laserAnimation;

  bool _isDetected = false;
  bool _isTorchOn = false;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    if (widget.animateLaser) {
      _laserController.repeat(reverse: true);
    }

    _laserAnimation = Tween<double>(begin: -100.0, end: 100.0).animate(
      CurvedAnimation(parent: _laserController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _laserController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isDetected) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final value = barcode.rawValue;
      if (value != null && value.isNotEmpty) {
        _triggerSuccess(value);
        break;
      }
    }
  }

  void _triggerSuccess(String value) {
    if (_isDetected) return;
    setState(() {
      _isDetected = true;
    });

    // Berikan jeda feedback visual sebelum pindah layar
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        widget.onBarcodeDetected(value);
        Navigator.pop(context, value);
      }
    });
  }

  void _toggleTorch() {
    _scannerController.toggleTorch();
    setState(() {
      _isTorchOn = !_isTorchOn;
    });
  }

  void _switchCamera() {
    _scannerController.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Live Camera Feed via MobileScanner
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
            errorBuilder: (context, error) {
              return _buildFallbackCameraView();
            },
          ),

          // 2. Translucent Cutout Overlay
          Positioned.fill(
            child: CustomPaint(
              painter: _ScannerCutoutPainter(
                cutoutSize: const Size(260, 260),
                borderColor: _isDetected
                    ? AppColors.successGreen
                    : AppColors.goldPrimary,
              ),
            ),
          ),

          // 3. Animated Laser Line
          Center(
            child: AnimatedBuilder(
              animation: _laserAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _laserAnimation.value),
                  child: Container(
                    width: 240,
                    height: 2.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (_isDetected
                                  ? AppColors.successGreen
                                  : AppColors.goldPrimary)
                              .withValues(alpha: 0.0),
                          _isDetected
                              ? AppColors.successGreen
                              : AppColors.goldPrimary,
                          (_isDetected
                                  ? AppColors.successGreen
                                  : AppColors.goldPrimary)
                              .withValues(alpha: 0.0),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (_isDetected
                                  ? AppColors.successGreen
                                  : AppColors.goldPrimary)
                              .withValues(alpha: 0.8),
                          blurRadius: 8,
                          spreadRadius: 1.5,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 4. Success Indicator Overlay when Scanned
          if (_isDetected)
            Center(
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.successGreen.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.successGreen, width: 2.5),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.successGreen,
                  size: 42,
                ),
              ),
            ),

          // 5. Top Navigation & Control Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  _buildCircleButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.pop(context),
                  ),

                  // Title Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.qr_code_scanner_rounded,
                          color: AppColors.goldPrimary,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Kamera Aktif Petugas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action Controls: Flash & Flip
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildCircleButton(
                        icon: _isTorchOn
                            ? Icons.flash_on_rounded
                            : Icons.flash_off_rounded,
                        color: _isTorchOn
                            ? AppColors.goldPrimary
                            : Colors.white,
                        onTap: _toggleTorch,
                      ),
                      const SizedBox(width: 10),
                      _buildCircleButton(
                        icon: Icons.flip_camera_ios_rounded,
                        onTap: _switchCamera,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 6. Bottom Instruction & Quick Simulation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.85),
                      Colors.black,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Arahkan kamera ke barcode di HP pengemudi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Posisikan barcode di dalam bingkai kuning untuk memindai otomatis.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),

                    // Quick Simulation Button for Testing/Demo
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _triggerSuccess('PV-081026-0248');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.goldPrimary,
                          foregroundColor: const Color(0xFF111215),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.qr_code_2_rounded, size: 20),
                        label: const Text(
                          'Deteksi Barcode Tiket (PV-081026-0248)',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
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

  Widget _buildFallbackCameraView() {
    return Container(
      color: const Color(0xFF16181E),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border, width: 1.5),
                ),
                child: const Icon(
                  Icons.videocam_rounded,
                  color: AppColors.goldPrimary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Mode Simulasi Kamera',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Perangkat fisik kamera tidak tersedia atau belum diizinkan.\nGunakan tombol di bawah untuk simulasi pemindaian barcode tiket.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Center(
            child: Icon(icon, color: color, size: 20),
          ),
        ),
      ),
    );
  }
}

class _ScannerCutoutPainter extends CustomPainter {
  final Size cutoutSize;
  final Color borderColor;
  final double cornerLength = 24.0;
  final double cornerWidth = 3.5;

  _ScannerCutoutPainter({
    required this.cutoutSize,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCenter(
      center: center,
      width: cutoutSize.width,
      height: cutoutSize.height,
    );

    // Draw dark overlay with cutout hole
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(backgroundPath, backgroundPaint);

    // Draw Corner Brackets
    final cornerPaint = Paint()
      ..color = borderColor
      ..strokeWidth = cornerWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final l = rect.left;
    final t = rect.top;
    final r = rect.right;
    final b = rect.bottom;

    // Top-Left
    canvas.drawPath(
      Path()
        ..moveTo(l, t + cornerLength)
        ..lineTo(l, t + 12)
        ..quadraticBezierTo(l, t, l + 12, t)
        ..lineTo(l + cornerLength, t),
      cornerPaint,
    );

    // Top-Right
    canvas.drawPath(
      Path()
        ..moveTo(r - cornerLength, t)
        ..lineTo(r - 12, t)
        ..quadraticBezierTo(r, t, r, t + 12)
        ..lineTo(r, t + cornerLength),
      cornerPaint,
    );

    // Bottom-Left
    canvas.drawPath(
      Path()
        ..moveTo(l, b - cornerLength)
        ..lineTo(l, b - 12)
        ..quadraticBezierTo(l, b, l + 12, b)
        ..lineTo(l + cornerLength, b),
      cornerPaint,
    );

    // Bottom-Right
    canvas.drawPath(
      Path()
        ..moveTo(r - cornerLength, b)
        ..lineTo(r - 12, b)
        ..quadraticBezierTo(r, b, r, b - 12)
        ..lineTo(r, b - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScannerCutoutPainter oldDelegate) {
    return oldDelegate.borderColor != borderColor;
  }
}
