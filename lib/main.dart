import 'package:flutter/material.dart';

void main() {
  runApp(const ParveApp());
}

class ParveApp extends StatelessWidget {
  const ParveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PARVE Valet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'sans-serif',
        scaffoldBackgroundColor: const Color(0xFF181B19),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD1A75B),
          primary: const Color(0xFFD1A75B),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}

// =============================================================================
// COLOR PALETTE CONSTANTS
// =============================================================================
class ParveColors {
  // Gold / Brand Accents
  static const Color gold = Color(0xFFD1A75B);
  static const Color goldDark = Color(0xFFA6823F);
  static const Color goldLight = Color(0xFFE8D19F);
  static const Color goldBgWarm = Color(0xFFF6EFE2);
  static const Color goldBadgeDark = Color(0xFF2C2417);

  // Dark Theme Colors
  static const Color darkBg = Color(0xFF181B19);
  static const Color darkSurface = Color(0xFF1B1E22);
  static const Color darkSurfaceLight = Color(0xFF23272E);
  static const Color darkBorder = Color(0xFF2A2E35);
  static const Color textGrey = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF6B7280);

  // Light Theme Colors
  static const Color lightBg = Color(0xFFF9F9F7);
  static const Color lightCard = Colors.white;
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightText = Color(0xFF111827);
  static const Color lightTextSub = Color(0xFF6B7280);

  // Status Colors
  static const Color green = Color(0xFF10B981);
  static const Color greenLight = Color(0xFFD1FAE5);
}

// =============================================================================
// SCREEN 1: ONBOARDING / LANDING PAGE (PARVE · Selamat datang)
// =============================================================================
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ParveColors.darkBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Scrollable Area to support multiple screen heights without overflow
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Logo Hero Card
                    Container(
                      width: double.infinity,
                      height: 270,
                      decoration: BoxDecoration(
                        gradient: const RadialGradient(
                          center: Alignment(0, -0.2),
                          radius: 1.0,
                          colors: [
                            Color(0xFF282D2A),
                            Color(0xFF1B1E1C),
                            Color(0xFF121413),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.45),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: CustomPaint(
                          size: const Size(260, 190),
                          painter: ParveBrandLogoPainter(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Small Uppercase Header Tag
                    const Text(
                      'LAYANAN VALET PRIBADI ANDA',
                      style: TextStyle(
                        color: ParveColors.gold,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.6,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Main Headline
                    const Text(
                      'Parkir harap tenang.\nPergi tanpa repot',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        height: 1.22,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle Body
                    const Text(
                      'Serahkan kunci, nikmati waktu Anda. PARVE mengurus parkir hingga mobil siap kembali.',
                      style: TextStyle(
                        color: Color(0xFF9EABA2),
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Key Features List
                    Row(
                      children: [
                        _buildFeatureItem('Petugas tepercaya'),
                        const SizedBox(width: 20),
                        _buildFeatureItem('Tarif transparan'),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Bottom White Card with Buttons (Exact design matching Figma)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Gold Button: Masuk ke PARVE
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ParveColors.gold,
                          foregroundColor: const Color(0xFF1E1E1E),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_forward, size: 20, color: Color(0xFF1A1A1A)),
                            SizedBox(width: 8),
                            Text(
                              'Masuk ke PARVE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // White Button: Daftar akun baru
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF111827),
                          side: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Daftar akun baru',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Footer text
                    const Text(
                      'Valet lebih mudah, mulai dari Jakarta.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // iOS Home Indicator Bar
                    Container(
                      width: 134,
                      height: 4.5,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildFeatureItem(String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: const [
            Icon(Icons.shield_outlined, color: ParveColors.gold, size: 20),
            Icon(Icons.check, color: ParveColors.gold, size: 11),
          ],
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// SCREEN 2: LOGIN / MASUK
// =============================================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController =
      TextEditingController(text: '+62 812 3456 7890');
  final TextEditingController _passwordController =
      TextEditingController(text: 'secretpass123');
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ParveColors.lightBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Masuk',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Key Icon Box
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: ParveColors.goldBgWarm,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.vpn_key_outlined,
                  color: ParveColors.goldDark,
                  size: 26,
                ),
              ),
              const SizedBox(height: 20),

              // Title Headline
              const Text(
                'Selamat datang\nkembali.',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              const Text(
                'Masuk untuk memesan valet dan mengelola perjalanan Anda.',
                style: TextStyle(
                  color: ParveColors.lightTextSub,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),

              // Phone Field
              const Text(
                'Nomor ponsel',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: const Icon(Icons.phone_outlined, color: Colors.black54),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ParveColors.lightBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ParveColors.lightBorder),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Password Field
              const Text(
                'Kata sandi',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ParveColors.lightBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ParveColors.lightBorder),
                  ),
                ),
              ),

              // Forgot password link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Lupa kata sandi?',
                    style: TextStyle(
                      color: ParveColors.goldDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Button: Masuk
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate directly to Admin Dashboard
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminMainScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ParveColors.gold,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Register CTA
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun? ',
                      style: TextStyle(color: ParveColors.lightTextSub, fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Daftar sekarang',
                        style: TextStyle(
                          color: ParveColors.goldDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Data Protection Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: ParveColors.goldBgWarm,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: ParveColors.goldDark,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Data dan transaksi Anda dilindungi. Jangan bagikan kata sandi kepada siapa pun.',
                        style: TextStyle(
                          color: Color(0xFF7B5C28),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Support Footer
              const Center(
                child: Text(
                  'Butuh bantuan? Hubungi layanan PARVE',
                  style: TextStyle(
                    color: ParveColors.lightTextSub,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// SCREEN 3: REGISTER / DAFTAR AKUN
// =============================================================================
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Dimas Pratama');
  final TextEditingController _phoneController =
      TextEditingController(text: '+62 812 3456 7890');
  final TextEditingController _emailController =
      TextEditingController(text: 'dimas.pratama@example.com');
  final TextEditingController _passwordController =
      TextEditingController(text: 'password123');

  bool _obscurePassword = true;
  bool _agreeTerms = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ParveColors.lightBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Daftar akun',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Title
              const Text(
                'Parkir nyaman dimulai di\nsini.',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              const Text(
                'Buat akun pribadi Anda. Satu akun untuk kendaraan, tiket, dan dompet.',
                style: TextStyle(
                  color: ParveColors.lightTextSub,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // 1. Nama Lengkap
              const Text(
                'Nama lengkap',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ParveColors.lightBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ParveColors.lightBorder),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Nomor Ponsel
              const Text(
                'Nomor ponsel',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: const Icon(Icons.phone_outlined, color: Colors.black54),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ParveColors.lightBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ParveColors.lightBorder),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Alamat Email
              const Text(
                'Alamat email',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: const Icon(Icons.mail_outline, color: Colors.black54),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ParveColors.lightBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ParveColors.lightBorder),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 4. Kata Sandi
              const Text(
                'Kata sandi',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ParveColors.lightBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ParveColors.lightBorder),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Minimal 8 karakter, kombinasi huruf dan angka.',
                style: TextStyle(color: ParveColors.lightTextSub, fontSize: 12),
              ),
              const SizedBox(height: 18),

              // Checkbox: Syarat & Ketentuan
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _agreeTerms,
                      activeColor: ParveColors.gold,
                      checkColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _agreeTerms = val ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Saya menyetujui Syarat & Ketentuan serta Kebijakan Privasi PARVE.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4B5563),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Button: Buat Akun
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminMainScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ParveColors.gold,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Buat akun',
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Login Footer CTA
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sudah punya akun? ',
                      style: TextStyle(color: ParveColors.lightTextSub, fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          color: ParveColors.goldDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// MAIN ADMIN NAVIGATION WRAPPER (Dashboard & Verifikasi tabs)
// =============================================================================
class AdminMainScreen extends StatefulWidget {
  final int initialIndex;
  const AdminMainScreen({super.key, this.initialIndex = 0});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ParveColors.darkBg,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          AdminDashboardTab(onNavigateToVerification: () => _onTabTapped(1)),
          const AdminVerificationTab(),
          const PlaceholderTab(title: 'Slot Parkir'),
          const PlaceholderTab(title: 'Monitoring Barcode'),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF131517),
          border: Border(top: BorderSide(color: Color(0xFF1E2227), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          backgroundColor: const Color(0xFF131517),
          selectedItemColor: ParveColors.gold,
          unselectedItemColor: ParveColors.textMuted,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_filled),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car_outlined),
              activeIcon: Icon(Icons.directions_car),
              label: 'Verifikasi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              activeIcon: Icon(Icons.grid_view_rounded),
              label: 'Slot',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              activeIcon: Icon(Icons.qr_code_scanner),
              label: 'Barcode',
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// SCREEN 4: ADMIN DASHBOARD TAB
// =============================================================================
class AdminDashboardTab extends StatelessWidget {
  final VoidCallback onNavigateToVerification;

  const AdminDashboardTab({
    super.key,
    required this.onNavigateToVerification,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Bar
            Row(
              children: [
                // Small Logo Icon
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ParveColors.gold.withOpacity(0.4)),
                  ),
                  child: const Center(
                    child: Icon(Icons.bolt, color: ParveColors.gold, size: 22),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pacific Place',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Operasional parkir',
                        style: TextStyle(
                          color: ParveColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Notification Button
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: ParveColors.darkSurfaceLight,
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Profile Tile
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF2E2619),
                  ),
                  child: const Center(
                    child: Text(
                      'DP',
                      style: TextStyle(
                        color: ParveColors.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dimas Pratama',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Administrator · Shift 08.00–16.00',
                      style: TextStyle(
                        color: ParveColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Title section
            const Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Selamat siang, Dimas. Pantau masuk, keluar, pembayaran, slot, dan barcode dari satu layar.',
              style: TextStyle(
                color: ParveColors.textMuted,
                fontSize: 13,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),

            // 1. Card Kapasitas Parkir
            _buildStatCard(
              title: 'Kapasitas parkir',
              badge: '120 slot',
              badgeColor: ParveColors.gold,
              bigValue: '42',
              bottomLeft: 'Tersedia',
              rightColumn: const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('35% terisi', style: TextStyle(color: ParveColors.textMuted, fontSize: 13)),
                  SizedBox(height: 4),
                  Text('78 slot', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 2. Card Antrean Keluar
            _buildStatCard(
              title: 'Antrean keluar',
              badge: '● 6 antrean',
              badgeColor: ParveColors.gold,
              bigValue: '6',
              bottomLeft: '2 menunggu verifikasi admin',
            ),
            const SizedBox(height: 12),

            // 3. Card Barcode Aktif
            _buildStatCard(
              title: 'Barcode aktif',
              badge: '4 barcode',
              badgeColor: ParveColors.gold,
              bigValue: '4',
              bottomLeft: '2 contoh menunggu verifikasi Admin',
            ),
            const SizedBox(height: 16),

            // 4. Card Antrean Verifikasi
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ParveColors.darkSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ParveColors.darkBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Antrean verifikasi',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        '2 menunggu',
                        style: TextStyle(
                          color: ParveColors.gold.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Item 1
                  _buildQueueItem(
                    plate: 'B 1234 PAR',
                    badge: 'Keluar',
                    passenger: 'Aditya Wijaya - 14.38',
                    officer: 'Petugas Rizky Saputra',
                  ),
                  const SizedBox(height: 10),

                  // Item 2
                  _buildQueueItem(
                    plate: 'B 8821 KLA',
                    badge: 'Keluar',
                    passenger: 'Bima Santoso - 14.36',
                    officer: 'Petugas Fajar Hidayat',
                  ),
                  const SizedBox(height: 12),

                  // Link View All
                  GestureDetector(
                    onTap: onNavigateToVerification,
                    child: const Row(
                      children: [
                        Text(
                          'Lihat seluruh antrean',
                          style: TextStyle(
                            color: ParveColors.gold,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, size: 14, color: ParveColors.gold),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5. Akses Operasional Grid (6 Buttons)
            const Text(
              'Akses operasional',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.3,
              children: [
                _buildActionTile(
                  icon: Icons.check_circle_outline,
                  label: 'Verifikasi masuk',
                  onTap: onNavigateToVerification,
                ),
                _buildActionTile(
                  icon: Icons.check_circle_outline,
                  label: 'Verifikasi keluar',
                ),
                _buildActionTile(
                  icon: Icons.credit_card_outlined,
                  label: 'Pembayaran',
                ),
                _buildActionTile(
                  icon: Icons.bar_chart_outlined,
                  label: 'Slot parkir',
                ),
                _buildActionTile(
                  icon: Icons.qr_code_2_outlined,
                  label: 'Monitoring barcode',
                ),
                _buildActionTile(
                  icon: Icons.people_outline,
                  label: 'Status petugas',
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static Widget _buildStatCard({
    required String title,
    required String badge,
    required Color badgeColor,
    required String bigValue,
    required String bottomLeft,
    Widget? rightColumn,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ParveColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ParveColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: ParveColors.textGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ParveColors.goldBadgeDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bigValue,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bottomLeft,
                    style: const TextStyle(
                      color: ParveColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              if (rightColumn != null) rightColumn,
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildQueueItem({
    required String plate,
    required String badge,
    required String passenger,
    required String officer,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ParveColors.darkSurfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                plate,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: ParveColors.textGrey,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            passenger,
            style: const TextStyle(color: ParveColors.textGrey, fontSize: 13),
          ),
          const SizedBox(height: 2),
          Text(
            officer,
            style: const TextStyle(color: ParveColors.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }

  static Widget _buildActionTile({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: ParveColors.darkSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ParveColors.darkBorder),
          ),
          child: Row(
            children: [
              Icon(icon, color: ParveColors.gold, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// SCREEN 5: ADMIN VERIFIKASI PARKIR MASUK TAB
// =============================================================================
class AdminVerificationTab extends StatelessWidget {
  const AdminVerificationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar with Logo and Online status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Small Logo
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: ParveColors.gold.withOpacity(0.5)),
                      ),
                      child: const Center(
                        child: Icon(Icons.bolt, color: ParveColors.gold, size: 18),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'PARVE',
                      style: TextStyle(
                        color: ParveColors.gold,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                // Sistem Online Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF142921),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.circle, color: ParveColors.green, size: 8),
                      SizedBox(width: 6),
                      Text(
                        'Sistem online',
                        style: TextStyle(
                          color: ParveColors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Main Title
            const Text(
              'Verifikasi Parkir Masuk',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Pacific Place · Pintu masuk utama',
              style: TextStyle(
                color: ParveColors.textGrey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Validasi barcode, tiket, kendaraan dan alokasi slot.',
              style: TextStyle(
                color: ParveColors.textMuted,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),

            // Two Summary Metric Cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: ParveColors.darkSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ParveColors.darkBorder),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Menunggu verifikasi',
                          style: TextStyle(color: ParveColors.textMuted, fontSize: 11),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '1',
                          style: TextStyle(
                            color: ParveColors.gold,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: ParveColors.darkSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ParveColors.darkBorder),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Slot tersedia',
                          style: TextStyle(color: ParveColors.textMuted, fontSize: 11),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '78',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Main Verification Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ParveColors.darkSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.4), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Header
                  const Text(
                    'Permintaan masuk baru',
                    style: TextStyle(color: ParveColors.textMuted, fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'PV-081026-0247',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: ParveColors.goldBadgeDark,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '● Menunggu verifikasi',
                          style: TextStyle(
                            color: ParveColors.gold,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Vehicle Badge Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ParveColors.darkSurfaceLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // License Plate Box
                        Container(
                          width: 80,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF16191D),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white24, width: 1),
                          ),
                          child: const Column(
                            children: [
                              Text(
                                'B 9081',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'NDP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Owner Details
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nadya Putri',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Scan 11.22 · Slot A-019',
                                style: TextStyle(
                                  color: ParveColors.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Petugas Andi Firmansyah',
                                style: TextStyle(
                                  color: ParveColors.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Key-value Details
                  _buildDataRow('Hasil scan barcode user', 'PV-081026-0247'),
                  _buildDataRow('Nomor polisi terbaca', 'B 9081 NDP'),
                  _buildDataRow('Waktu scan', '11.22 WIB'),
                  const SizedBox(height: 14),

                  // Sub-header Validasi Identitas
                  const Text(
                    'Validasi identitas',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDataRow('Tiket', 'Cocok', valueColor: Colors.white),
                  _buildDataRow('Nomor polisi', 'Cocok', valueColor: Colors.white),
                  _buildDataRow('Slot A-019', 'Dialokasikan', valueColor: ParveColors.gold),
                  const SizedBox(height: 18),

                  // Action Buttons: Tolak Masuk & Setujui Masuk
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Permintaan masuk ditolak.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF23272E),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Tolak masuk',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Permintaan parkir masuk disetujui!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ParveColors.gold,
                              foregroundColor: const Color(0xFF1E1E1E),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Setujui masuk',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Card Slot Parkir
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ParveColors.darkSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ParveColors.darkBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Slot parkir',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDataRow('Slot terpilih', 'A-019', valueColor: Colors.white),
                  _buildDataRow('Status slot', 'Dialokasikan', valueColor: ParveColors.green),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF23272E),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Lihat slot parkir',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Card Monitoring Barcode
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ParveColors.darkSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ParveColors.darkBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Monitoring barcode',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Petugas melakukan scan barcode user. Keputusan verifikasi masuk dilakukan oleh Admin.',
                    style: TextStyle(color: ParveColors.textMuted, fontSize: 12, height: 1.35),
                  ),
                  const SizedBox(height: 12),
                  _buildDataRow('Barcode terakhir', 'PV-081026-0247', valueColor: Colors.white),
                  _buildDataRow('Sumber scan', 'Petugas Andi Firmansyah', valueColor: Colors.white),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF23272E),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Lihat log scan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static Widget _buildDataRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: ParveColors.textMuted,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PLACEHOLDER TAB FOR SLOT & BARCODE
// =============================================================================
class PlaceholderTab extends StatelessWidget {
  final String title;
  const PlaceholderTab({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.dashboard_customize_outlined, size: 54, color: ParveColors.gold.withOpacity(0.8)),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Halaman ini siap untuk diintegrasikan.',
            style: TextStyle(color: ParveColors.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

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
