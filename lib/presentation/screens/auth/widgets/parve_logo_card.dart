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
                  color: AppColors.goldPrimary.withValues(alpha: 0.12),
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
                  color: AppColors.goldPrimary.withValues(alpha: 0.06),
                ),
              ),
            ),

            // Official Circular PARVE Golden Badge Logo from Figma
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Image.asset(
                  'assets/images/parve_logo.png',
                  height: height * 0.76,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
