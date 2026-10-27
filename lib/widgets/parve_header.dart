import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class ParveHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onHelpTap;
  final IconData trailingIcon;

  const ParveHeader({
    super.key,
    required this.title,
    this.onHelpTap,
    this.trailingIcon = Icons.help_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            'assets/images/logo_parve.png',
            width: 46,
            height: 46,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.darkPrimary,
              fontSize: 21,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
        ),
        if (onHelpTap != null)
          IconButton(
            onPressed: onHelpTap,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            icon: Icon(
              trailingIcon,
              color: AppColors.darkPrimary,
              size: 23,
            ),
          ),
      ],
    );
  }
}
