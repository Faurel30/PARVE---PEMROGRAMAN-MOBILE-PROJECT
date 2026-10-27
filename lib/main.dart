import 'package:flutter/material.dart';
import 'core/app_colors.dart';
import 'screens/landing_screen.dart';

void main() {
  runApp(const ParveApp());
}

class ParveApp extends StatelessWidget {
  const ParveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppColors.isDarkMode,
      builder: (context, isDark, _) {
        return MaterialApp(
          title: 'PARVE - Tiket Parkir Digital',
          debugShowCheckedModeBanner: false,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF7F7F4),
            fontFamily: 'Roboto',
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF151715),
            fontFamily: 'Roboto',
          ),
          home: const LandingScreen(),
        );
      },
    );
  }
}
