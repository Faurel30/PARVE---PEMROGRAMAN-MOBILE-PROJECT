import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/aktivitas_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const ParveApp());
}

class ParveApp extends StatelessWidget {
  const ParveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PARVE · Tiket parkir digital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F5F0),
        fontFamily: 'Roboto',
      ),
      home: const AktivitasScreen(),
    );
  }
}

