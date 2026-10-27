import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class ParveTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final TextInputType keyboardType;

  const ParveTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.darkPrimary,
            fontSize: 12.2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.cardBorder, width: 1.2),
          ),
          alignment: Alignment.center,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            obscuringCharacter: '•',
            keyboardType: keyboardType,
            style: TextStyle(
              color: AppColors.darkPrimary,
              fontSize: 13.8,
              fontWeight: FontWeight.w500,
              letterSpacing: obscureText ? 1.8 : 0,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText,
              hintStyle: TextStyle(
                color: AppColors.textMuted,
                fontSize: 13.5,
                letterSpacing: 0,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 13,
              ),
              border: InputBorder.none,
              suffixIcon: suffixIcon != null
                  ? GestureDetector(
                      onTap: onSuffixTap,
                      behavior: HitTestBehavior.opaque,
                      child: Icon(
                        suffixIcon,
                        color: AppColors.textSecondary,
                        size: 19,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
