import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CameraScannerBox extends StatefulWidget {
  final bool isScanning;
  final bool animateLaser;

  const CameraScannerBox({
    super.key,
    this.isScanning = true,
    this.animateLaser = true,
  });

  @override
  State<CameraScannerBox> createState() => _CameraScannerBoxState();
}

class _CameraScannerBoxState extends State<CameraScannerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _laserController;
  late Animation<double> _laserAnimation;

  @override
  void initState() {
    super.initState();
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    if (widget.animateLaser) {
      _laserController.repeat(reverse: true);
    }

    _laserAnimation = Tween<double>(begin: -35.0, end: 35.0).animate(
      CurvedAnimation(parent: _laserController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _laserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 230,
      decoration: BoxDecoration(
        color: const Color(0xFF16181E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF282B36), width: 1.2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background subtle camera grid / dark fill
          Positioned(
            top: 12,
            left: 14,
            child: Text(
              'ILUSTRASI KAMERA',
              style: TextStyle(
                color: AppColors.textMuted.withValues(alpha: 0.7),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),

          // Center: Phone Mockup with Barcode
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Phone Silhouette
              Container(
                width: 145,
                height: 125,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2129),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF383C4A), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  // White ticket / phone display inside
                  child: Container(
                    width: 125,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // PARVE logo text
                        const Text(
                          'PARVE',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Barcode stripes simulation
                        SizedBox(
                          height: 44,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildBar(2.5),
                              _buildSpace(1.5),
                              _buildBar(1.0),
                              _buildSpace(2.0),
                              _buildBar(3.0),
                              _buildSpace(1.0),
                              _buildBar(1.5),
                              _buildSpace(2.5),
                              _buildBar(2.0),
                              _buildSpace(1.0),
                              _buildBar(4.0),
                              _buildSpace(2.0),
                              _buildBar(1.0),
                              _buildSpace(1.5),
                              _buildBar(2.5),
                              _buildSpace(1.0),
                              _buildBar(3.0),
                              _buildSpace(2.0),
                              _buildBar(1.5),
                              _buildSpace(1.0),
                              _buildBar(2.0),
                              _buildSpace(2.0),
                              _buildBar(1.0),
                              _buildSpace(1.5),
                              _buildBar(3.0),
                              _buildSpace(1.0),
                              _buildBar(2.0),
                              _buildSpace(2.0),
                              _buildBar(1.5),
                              _buildSpace(1.0),
                              _buildBar(2.5),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),

                        // Subtitle: CONTOH - NONOPERASIONAL
                        const Text(
                          'CONTOH - NONOPERASIONAL',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 5.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Subtitle inside: Posisikan barcode di dalam bingkai
              const Text(
                'Posisikan barcode di dalam bingkai',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          // Golden Viewfinder Corners Overlay
          Positioned(
            width: 175,
            height: 145,
            child: IgnorePointer(
              child: CustomPaint(
                painter: _ViewfinderReticlePainter(
                  cornerColor: AppColors.goldPrimary,
                ),
              ),
            ),
          ),

          // Animated Golden Laser Scan Line
          if (widget.isScanning)
            AnimatedBuilder(
              animation: _laserAnimation,
              builder: (context, child) {
                return Positioned(
                  top: (230 / 2 - 20) + _laserAnimation.value,
                  left: 60,
                  right: 60,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.goldPrimary.withValues(alpha: 0.0),
                          AppColors.goldPrimary.withValues(alpha: 0.95),
                          AppColors.goldPrimary.withValues(alpha: 0.0),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.goldPrimary.withValues(alpha: 0.6),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBar(double width) {
    return Container(
      width: width,
      height: 42,
      color: Colors.black87,
    );
  }

  Widget _buildSpace(double width) {
    return SizedBox(width: width);
  }
}

class _ViewfinderReticlePainter extends CustomPainter {
  final Color cornerColor;
  static const double cornerLength = 18.0;
  static const double strokeWidth = 2.5;

  _ViewfinderReticlePainter({
    required this.cornerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = cornerColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // Top-Left Corner
    final tlPath = Path()
      ..moveTo(0, cornerLength)
      ..lineTo(0, 0)
      ..lineTo(cornerLength, 0);
    canvas.drawPath(tlPath, paint);

    // Top-Right Corner
    final trPath = Path()
      ..moveTo(w - cornerLength, 0)
      ..lineTo(w, 0)
      ..lineTo(w, cornerLength);
    canvas.drawPath(trPath, paint);

    // Bottom-Left Corner
    final blPath = Path()
      ..moveTo(0, h - cornerLength)
      ..lineTo(0, h)
      ..lineTo(cornerLength, h);
    canvas.drawPath(blPath, paint);

    // Bottom-Right Corner
    final brPath = Path()
      ..moveTo(w - cornerLength, h)
      ..lineTo(w, h)
      ..lineTo(w, h - cornerLength);
    canvas.drawPath(brPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
