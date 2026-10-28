import 'package:flutter/material.dart';

enum AuthButtonVariant {
  goldFilled,
  whiteOutline,
  whiteFilled,
}

class AuthPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final AuthButtonVariant variant;
  final double height;

  const AuthPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.variant = AuthButtonVariant.goldFilled,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    Border? border;

    switch (variant) {
      case AuthButtonVariant.goldFilled:
        bgColor = const Color(0xFFD4A751); // Figma amber-gold tone
        textColor = const Color(0xFF1B1B1B);
        border = null;
        break;
      case AuthButtonVariant.whiteOutline:
        bgColor = Colors.white;
        textColor = const Color(0xFF1B1B1B);
        border = Border.all(color: const Color(0xFFE5E7EB), width: 1.2);
        break;
      case AuthButtonVariant.whiteFilled:
        bgColor = Colors.white;
        textColor = const Color(0xFF1B1B1B);
        border = null;
        break;
    }

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Material(
        color: onPressed == null ? bgColor.withValues(alpha: 0.5) : bgColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.black.withValues(alpha: 0.1),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: border,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (leadingIcon != null) ...[
                        Icon(leadingIcon, color: textColor, size: 19),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                      if (trailingIcon != null) ...[
                        const SizedBox(width: 8),
                        Icon(trailingIcon, color: textColor, size: 19),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
