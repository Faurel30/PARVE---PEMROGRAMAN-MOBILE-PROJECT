import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class BookingTopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;

  const BookingTopBar({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack ?? () => Navigator.pop(context),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              color: AppColors.darkPrimary,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Text(
          title,
          style: TextStyle(
            color: AppColors.darkPrimary,
            fontSize: 20.5,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

class BookingStepIndicator extends StatelessWidget {
  final int currentStep;

  const BookingStepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final isStep1 = currentStep == 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (isStep1)
          Text.rich(
            const TextSpan(
              children: [
                TextSpan(text: '01  '),
                TextSpan(text: 'Lokasi & kendaraan'),
              ],
            ),
            style: TextStyle(
              color: AppColors.navActive,
              fontSize: 12.2,
              fontWeight: FontWeight.w700,
            ),
          )
        else
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_rounded,
                size: 14,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                'Lokasi & kendaraan',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        Text.rich(
          const TextSpan(
            children: [
              TextSpan(text: '02  '),
              TextSpan(text: 'Pembayaran'),
            ],
          ),
          style: TextStyle(
            color: isStep1 ? AppColors.textMuted : AppColors.navActive,
            fontSize: 12.2,
            fontWeight: isStep1 ? FontWeight.w500 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class BookingStickyBottomBar extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const BookingStickyBottomBar({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      padding: EdgeInsets.fromLTRB(
        21,
        12,
        21,
        bottomPadding > 0 ? bottomPadding + 8 : 14,
      ),
      child: Material(
        color: AppColors.goldButton,
        borderRadius: BorderRadius.circular(11),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11),
          child: SizedBox(
            height: 49,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: AppColors.onGold),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.onGold,
                    fontSize: 14.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
