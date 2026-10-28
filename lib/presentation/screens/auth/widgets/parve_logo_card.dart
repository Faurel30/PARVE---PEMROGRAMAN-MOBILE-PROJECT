import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ParveLogoCard extends StatelessWidget {
  final double height;
  final double? width;
  final bool showGlow;

  const ParveLogoCard({
    super.key,
    this.height = 190,
    this.width,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.goldBorder.withValues(alpha: 0.7),
          width: 1.2,
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF22242D),
            Color(0xFF14151B),
            Color(0xFF0C0D10),
          ],
        ),
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: AppColors.goldPrimary.withValues(alpha: 0.08),
                  blurRadius: 32,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background subtle gold ambient glow
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.goldPrimary.withValues(alpha: 0.05),
                ),
              ),
            ),

            // Inner Vector Emblem & Typography
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Metallic Gold Emblem (Custom Painted for ultra sharpness)
                  SizedBox(
                    width: 130,
                    height: 76,
                    child: CustomPaint(
                      painter: _ParveEmblemPainter(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Metallic Gold "PARVE" Brand Wordmark
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFFFFF2BD),
                        Color(0xFFF7C759),
                        Color(0xFFE5A93C),
                        Color(0xFFB87818),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds),
                    child: const Text(
                      'PARVE',
                      style: TextStyle(
                        fontFamily: 'sans-serif',
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 6.0,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
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

class _ParveEmblemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Gold Gradient Shader
    final Rect shaderRect = Rect.fromLTWH(0, 0, w, h);
    final Gradient goldGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFFEC9E),
        Color(0xFFF5BE44),
        Color(0xFFE5A93C),
        Color(0xFFC0831F),
      ],
      stops: [0.0, 0.35, 0.7, 1.0],
    );

    final Paint fillPaint = Paint()
      ..shader = goldGradient.createShader(shaderRect)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final Paint strokePaint = Paint()
      ..shader = goldGradient.createShader(shaderRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final Paint thinStrokePaint = Paint()
      ..shader = goldGradient.createShader(shaderRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    // 1. Stylized lightning 'P' monogram on the left
    final Path pPath = Path();
    pPath.moveTo(w * 0.12, h * 0.12);
    pPath.lineTo(w * 0.32, h * 0.12);
    pPath.cubicTo(w * 0.40, h * 0.12, w * 0.43, h * 0.28, w * 0.33, h * 0.44);
    pPath.lineTo(w * 0.24, h * 0.44);
    pPath.lineTo(w * 0.22, h * 0.54);
    pPath.lineTo(w * 0.27, h * 0.54);
    pPath.lineTo(w * 0.19, h * 0.78);
    pPath.lineTo(w * 0.21, h * 0.50);
    pPath.lineTo(w * 0.15, h * 0.50);
    pPath.close();

    // Inner cutout for the 'P' loop
    final Path pCutout = Path();
    pCutout.moveTo(w * 0.20, h * 0.22);
    pCutout.lineTo(w * 0.28, h * 0.22);
    pCutout.cubicTo(w * 0.33, h * 0.22, w * 0.33, h * 0.34, w * 0.28, h * 0.34);
    pCutout.lineTo(w * 0.20, h * 0.34);
    pCutout.close();

    final Path finalPPath = Path.combine(
      PathOperation.difference,
      pPath,
      pCutout,
    );
    canvas.drawPath(finalPPath, fillPaint);

    // 2. Aerodynamic Supercar Front Silhouette
    // Windshield & Roof arc
    final Path roofPath = Path();
    roofPath.moveTo(w * 0.42, h * 0.32);
    roofPath.cubicTo(w * 0.52, h * 0.14, w * 0.72, h * 0.14, w * 0.82, h * 0.34);
    canvas.drawPath(roofPath, strokePaint);

    // Hood & Front nose curves
    final Path hoodPath = Path();
    hoodPath.moveTo(w * 0.38, h * 0.42);
    hoodPath.cubicTo(w * 0.46, h * 0.38, w * 0.60, h * 0.36, w * 0.76, h * 0.42);
    hoodPath.cubicTo(w * 0.88, h * 0.46, w * 0.94, h * 0.58, w * 0.88, h * 0.68);
    hoodPath.lineTo(w * 0.34, h * 0.68);
    hoodPath.cubicTo(w * 0.30, h * 0.68, w * 0.32, h * 0.52, w * 0.38, h * 0.42);
    canvas.drawPath(hoodPath, strokePaint);

    // Sleek LED Headlights (Left & Right swooshes)
    final Path leftLight = Path();
    leftLight.moveTo(w * 0.46, h * 0.48);
    leftLight.lineTo(w * 0.55, h * 0.48);
    leftLight.lineTo(w * 0.52, h * 0.53);
    canvas.drawPath(leftLight, thinStrokePaint);

    final Path rightLight = Path();
    rightLight.moveTo(w * 0.74, h * 0.48);
    rightLight.lineTo(w * 0.65, h * 0.48);
    rightLight.lineTo(w * 0.68, h * 0.53);
    canvas.drawPath(rightLight, thinStrokePaint);

    // Front Splitter / Lower Aero Wing
    final Path splitterPath = Path();
    splitterPath.moveTo(w * 0.30, h * 0.76);
    splitterPath.lineTo(w * 0.90, h * 0.76);
    canvas.drawPath(splitterPath, strokePaint);

    // Center badge accent
    final Path centerBadge = Path();
    centerBadge.moveTo(w * 0.60, h * 0.58);
    centerBadge.lineTo(w * 0.57, h * 0.64);
    centerBadge.lineTo(w * 0.63, h * 0.64);
    centerBadge.close();
    canvas.drawPath(centerBadge, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

