import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  AppColors._();

  /// Notifier global untuk Mode Terang / Mode Gelap seluruh aplikasi PARVE
  static final ValueNotifier<bool> isDarkMode = ValueNotifier<bool>(false);

  static bool get isDark => isDarkMode.value;

  static void setDarkMode(bool value) {
    if (isDarkMode.value != value) {
      isDarkMode.value = value;
    }
  }

  // Warna permukaan & latar belakang
  static Color get bgPage =>
      isDark ? const Color(0xFF151715) : const Color(0xFFF7F7F4);
  static Color get surface =>
      isDark ? const Color(0xFF20231F) : Colors.white;
  static Color get surfaceSubtle =>
      isDark ? const Color(0xFF292D28) : const Color(0xFFF4F5F1);
  static Color get heroDark =>
      isDark ? const Color(0xFF262A25) : const Color(0xFF20231F);

  // Warna teks & aksen utama
  static Color get darkPrimary =>
      isDark ? const Color(0xFFF3F3EE) : const Color(0xFF20231F);
  static const Color onGold = Color(0xFF20231F);
  static const Color goldText = Color(0xFFC9AB68);
  static const Color goldButton = Color(0xFFD4B46C);

  // Border & garis pemisah
  static Color get cardBorder =>
      isDark ? const Color(0xFF323630) : const Color(0xFFE7E9E1);
  static Color get divider =>
      isDark ? const Color(0xFF2D312B) : const Color(0xFFE8EAE3);

  // Teks sekunder & muted
  static Color get textSecondary =>
      isDark ? const Color(0xFFA5A8A2) : const Color(0xFF7E807C);
  static Color get textMuted =>
      isDark ? const Color(0xFF8C9089) : const Color(0xFF8E918C);

  // Status & navigasi
  static Color get badgeBg =>
      isDark ? const Color(0xFF1F352B) : const Color(0xFFEAF3ED);
  static Color get badgeGreen =>
      isDark ? const Color(0xFF69C89E) : const Color(0xFF38705C);
  static Color get navPillBg =>
      isDark ? const Color(0xFF352F22) : const Color(0xFFF4EDDD);
  static Color get navActive =>
      isDark ? const Color(0xFFE0C27B) : const Color(0xFF6B5832);

  // Banner aksen emas lembut
  static Color get softGoldBanner =>
      isDark ? const Color(0xFF2D271C) : const Color(0xFFF3ECE0);
  static Color get softGoldCard =>
      isDark ? const Color(0xFF2B251B) : const Color(0xFFF7F1E4);

  static SystemUiOverlayStyle get pageOverlayStyle => SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    systemNavigationBarColor: surface,
    systemNavigationBarIconBrightness:
        isDark ? Brightness.light : Brightness.dark,
  );
}
