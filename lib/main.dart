import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_colors.dart';
import 'presentation/screens/auth/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.navBackground,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ParvePetugasApp());
}

class ParvePetugasApp extends StatelessWidget {
  final bool animateLaser;
  final Widget? home;

  const ParvePetugasApp({
    super.key,
    this.animateLaser = true,
    this.home,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parvee - Petugas Parkir',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.goldPrimary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.goldPrimary,
          surface: AppColors.surface,
        ),
        fontFamily: 'sans-serif',
        useMaterial3: true,
      ),
      home: home ?? const WelcomeScreen(),
    );
  }
}
