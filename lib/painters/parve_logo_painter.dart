import 'package:flutter/material.dart';

// =============================================================================
// CUSTOM PAINTER: PARVE LOGO (GOLD METALLIC SILHOUETTE & P LIGHTNING)
// =============================================================================
class ParveBrandLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Metallic gold shader with rich specular reflection
    final Rect rect = Rect.fromLTWH(0, 0, w, h);
    final goldShader = const LinearGradient(
      colors: [
        Color(0xFFFFEE93),
        Color(0xFFE1B85D),
        Color(0xFFBA8B2F),
        Color(0xFF865D12),
        Color(0xFFE2B75B),
        Color(0xFFFFF0A5),
      ],
      stops: [0.0, 0.22, 0.48, 0.70, 0.88, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(rect);

    final goldFill = Paint()
      ..shader = goldShader
      ..style = PaintingStyle.fill;

    final goldStrokeThick = Paint()
      ..shader = goldShader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.8 * (w / 260)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final goldStrokeMedium = Paint()
      ..shader = goldShader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6 * (w / 260)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 1. Stylized bold 'P' with lightning bolt tail (Left side)
    final pPath = Path();
    pPath.moveTo(w * 0.17, h * 0.10);
    pPath.lineTo(w * 0.44, h * 0.10);
    pPath.cubicTo(
      w * 0.52, h * 0.10,
      w * 0.53, h * 0.32,
      w * 0.38, h * 0.34,
    );
    pPath.lineTo(w * 0.27, h * 0.34);
    pPath.lineTo(w * 0.29, h * 0.24);
    pPath.lineTo(w * 0.38, h * 0.24);
    pPath.cubicTo(
      w * 0.42, h * 0.24,
      w * 0.42, h * 0.18,
      w * 0.35, h * 0.18,
    );
    pPath.lineTo(w * 0.24, h * 0.18);
    // Lightning bolt downward stem
    pPath.lineTo(w * 0.20, h * 0.38);
    pPath.lineTo(w * 0.27, h * 0.38);
    pPath.lineTo(w * 0.12, h * 0.68); // sharp lightning bottom strike
    pPath.lineTo(w * 0.19, h * 0.46);
    pPath.lineTo(w * 0.14, h * 0.46);
    pPath.close();
    canvas.drawPath(pPath, goldFill);

    // 2. Car Roofline (Curved aerodynamic swoop)
    final roofPath = Path();
    roofPath.moveTo(w * 0.47, h * 0.14);
    roofPath.cubicTo(
      w * 0.55, h * 0.13,
      w * 0.67, h * 0.16,
      w * 0.74, h * 0.21,
    );
    canvas.drawPath(roofPath, goldStrokeThick);

    // 3. Right Wing Mirror
    final mirrorPath = Path();
    mirrorPath.moveTo(w * 0.74, h * 0.21);
    mirrorPath.lineTo(w * 0.78, h * 0.23);
    mirrorPath.lineTo(w * 0.73, h * 0.26);
    canvas.drawPath(mirrorPath, goldStrokeMedium);

    // 4. Windshield & Front Hood Contour
    final hoodPath = Path();
    hoodPath.moveTo(w * 0.50, h * 0.23);
    hoodPath.cubicTo(
      w * 0.60, h * 0.25,
      w * 0.72, h * 0.33,
      w * 0.81, h * 0.37,
    );
    // Front right fender & bumper curve
    hoodPath.lineTo(w * 0.83, h * 0.45);
    hoodPath.cubicTo(
      w * 0.82, h * 0.58,
      w * 0.80, h * 0.64,
      w * 0.75, h * 0.68,
    );
    hoodPath.lineTo(w * 0.38, h * 0.68);
    canvas.drawPath(hoodPath, goldStrokeThick);

    // 5. Angular Dynamic Headlight
    final headlightPath = Path();
    headlightPath.moveTo(w * 0.62, h * 0.33);
    headlightPath.lineTo(w * 0.76, h * 0.39);
    headlightPath.lineTo(w * 0.70, h * 0.44);
    headlightPath.close();
    canvas.drawPath(headlightPath, goldFill);

    // 6. Grill Curves (aerodynamic front wings)
    final grillPath = Path();
    grillPath.moveTo(w * 0.42, h * 0.62);
    grillPath.quadraticBezierTo(w * 0.51, h * 0.65, w * 0.61, h * 0.62);
    canvas.drawPath(grillPath, goldStrokeThick);

    // 7. Map Pin (Location Marker) in Center Grille
    final pinPath = Path();
    final double pinX = w * 0.51;
    final double pinY = h * 0.56;
    pinPath.moveTo(pinX, pinY + 7);
    pinPath.cubicTo(pinX - 5.5, pinY + 2, pinX - 5.5, pinY - 5, pinX, pinY - 5);
    pinPath.cubicTo(pinX + 5.5, pinY - 5, pinX + 5.5, pinY + 2, pinX, pinY + 7);
    pinPath.close();
    canvas.drawPath(pinPath, goldFill);

    // Hole inside Map Pin
    final holePaint = Paint()
      ..color = const Color(0xFF1B1E1C)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(pinX, pinY - 1), 2.2, holePaint);

    // 8. Bottom Base Accent Line
    final basePath = Path();
    basePath.moveTo(w * 0.16, h * 0.70);
    basePath.lineTo(w * 0.82, h * 0.70);
    canvas.drawPath(basePath, goldStrokeThick);

    // 9. Wordmark "PARVE" (Metallic Gold, Italic, Bold)
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'PARVE',
        style: TextStyle(
          foreground: Paint()..shader = goldShader,
          fontSize: 34 * (w / 260),
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          letterSpacing: 4.8,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((w - textPainter.width) / 2, h * 0.74),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

