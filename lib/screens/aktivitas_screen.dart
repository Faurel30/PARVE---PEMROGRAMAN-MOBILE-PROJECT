import 'package:flutter/material.dart';
import 'pantau_kendaraan_screen.dart';

class AktivitasScreen extends StatefulWidget {
  const AktivitasScreen({super.key});

  @override
  State<AktivitasScreen> createState() => _AktivitasScreenState();
}

class _AktivitasScreenState extends State<AktivitasScreen> {
  int _selectedTabIndex = 0; // 0 = Tiket aktif, 1 = Riwayat parkir
  int _bottomNavIndex = 1; // 1 = Aktivitas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F0),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header: Logo + Aktivitas + Help Icon
                    _buildHeader(),
                    const SizedBox(height: 18),

                    // Segmented Tabs: Tiket aktif & Riwayat parkir
                    _buildSegmentedTabs(),
                    const SizedBox(height: 18),

                    // Main Content (Tiket Aktif Card + Button + Note)
                    if (_selectedTabIndex == 0) ...[
                      _buildTicketCard(),
                      const SizedBox(height: 18),
                      _buildPantauButton(),
                      const SizedBox(height: 16),
                      const Text(
                        'Biaya parkir dibayar saat pengambilan kendaraan.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF7D7B74),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ] else ...[
                      _buildRiwayatPlaceholder(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const ParveLogoBadge(),
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            'Aktivitas',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D1E1C),
              letterSpacing: -0.3,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF1D1E1C),
                width: 1.8,
              ),
            ),
            alignment: Alignment.center,
            child: const Text(
              '?',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D1E1C),
                height: 1.1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentedTabs() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 44,
              decoration: BoxDecoration(
                color: _selectedTabIndex == 0
                    ? const Color(0xFF21211F)
                    : Colors.white,
                borderRadius: BorderRadius.circular(11),
                border: _selectedTabIndex == 0
                    ? null
                    : Border.all(color: const Color(0xFFEBEAE4), width: 1),
              ),
              alignment: Alignment.center,
              child: Text(
                'Tiket aktif',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      _selectedTabIndex == 0 ? FontWeight.w600 : FontWeight.w500,
                  color: _selectedTabIndex == 0
                      ? Colors.white
                      : const Color(0xFF7D7B74),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = 1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 44,
              decoration: BoxDecoration(
                color: _selectedTabIndex == 1
                    ? const Color(0xFF21211F)
                    : Colors.white,
                borderRadius: BorderRadius.circular(11),
                border: _selectedTabIndex == 1
                    ? null
                    : Border.all(color: const Color(0xFFEBEAE4), width: 1),
              ),
              alignment: Alignment.center,
              child: Text(
                'Riwayat parkir',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      _selectedTabIndex == 1 ? FontWeight.w600 : FontWeight.w500,
                  color: _selectedTabIndex == 1
                      ? Colors.white
                      : const Color(0xFF7D7B74),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTicketCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEAE8E1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Dark Header
          Container(
            color: const Color(0xFF21211F),
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'PARVE / TIKET DIGITAL',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD5B363),
                        letterSpacing: 0.6,
                      ),
                    ),
                    const TicketStubIcon(
                      color: Color(0xFFD5B363),
                      size: 22,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Senayan City',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'PV-081026-0248',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFA09E97),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),

          // White Card Body
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
            child: Column(
              children: [
                // QR Code & Status Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 118,
                      height: 118,
                      child: CustomPaint(
                        painter: ParveQrPainter(),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status Pill: Terparkir aman
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE7F3EC),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6.5,
                                  height: 6.5,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF286E50),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Terparkir aman',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF286E50),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Tunjukkan tiket ini saat mengambil mobil.',
                            style: TextStyle(
                              fontSize: 13.5,
                              height: 1.35,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF72706A),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Kode contoh • jangan dibagikan',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF908E86),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFEFEDE7),
                ),
                const SizedBox(height: 20),

                // Car Info Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 105,
                      height: 60,
                      child: CustomPaint(
                        painter: WhiteMpvCarPainter(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Toyota Veloz',
                            style: TextStyle(
                              fontSize: 17.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1D1E1C),
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'B 2148 SJD',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C2C2A),
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Putih • MPV • 2024',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF86847D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // Metadata Rows
                _buildInfoRow(
                  label: 'Waktu masuk',
                  value: '8 Okt 2026 • 13.00',
                  isBoldValue: false,
                ),
                const SizedBox(height: 14),
                _buildInfoRow(
                  label: 'Area parkir',
                  value: 'B1 • Blok A-12',
                  isBoldValue: false,
                ),
                const SizedBox(height: 14),
                _buildInfoRow(
                  label: 'Valet dibayar',
                  value: 'Rp35.000',
                  isBoldValue: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required bool isBoldValue,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w400,
            color: Color(0xFF7D7B74),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBoldValue ? 16.5 : 15,
            fontWeight: isBoldValue ? FontWeight.w700 : FontWeight.w600,
            color: const Color(0xFF1D1E1C),
          ),
        ),
      ],
    );
  }

  Widget _buildPantauButton() {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const PantauKendaraanScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD6B56A),
          foregroundColor: const Color(0xFF1D1E1C),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            TargetCrosshairIcon(
              color: Color(0xFF1D1E1C),
              size: 20,
            ),
            SizedBox(width: 10),
            Text(
              'Pantau kendaraan',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D1E1C),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiwayatPlaceholder() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEAE8E1), width: 1),
      ),
      child: Column(
        children: const [
          Icon(
            Icons.history_rounded,
            size: 40,
            color: Color(0xFF908E86),
          ),
          SizedBox(height: 12),
          Text(
            'Riwayat Parkir',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1E1C),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Daftar riwayat tiket parkir Anda akan tampil di sini.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              color: Color(0xFF7D7B74),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFDFCFA),
        border: Border(
          top: BorderSide(color: Color(0xFFEBE9E2), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                label: 'Beranda',
                iconWidget: const NavHomeIcon(color: Color(0xFF7D7B74)),
                activeIconWidget: const NavHomeIcon(color: Color(0xFF7A5C1D)),
              ),
              _buildNavItem(
                index: 1,
                label: 'Aktivitas',
                iconWidget: const TicketStubIcon(
                  color: Color(0xFF7D7B74),
                  size: 21,
                ),
                activeIconWidget: const TicketStubIcon(
                  color: Color(0xFF7A5C1D),
                  size: 21,
                ),
              ),
              _buildNavItem(
                index: 2,
                label: 'Dompet',
                iconWidget: const NavWalletIcon(color: Color(0xFF7D7B74)),
                activeIconWidget: const NavWalletIcon(color: Color(0xFF7A5C1D)),
              ),
              _buildNavItem(
                index: 3,
                label: 'Profil',
                iconWidget: const NavProfileIcon(color: Color(0xFF7D7B74)),
                activeIconWidget: const NavProfileIcon(color: Color(0xFF7A5C1D)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required Widget iconWidget,
    required Widget activeIconWidget,
  }) {
    final bool isSelected = _bottomNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _bottomNavIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 76,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFF3EFE4)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: isSelected ? activeIconWidget : iconWidget,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected
                    ? const Color(0xFF7A5C1D)
                    : const Color(0xFF7D7B74),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom PARVE Circular Gold & Black Emblem Logo matching the reference image
class ParveLogoBadge extends StatelessWidget {
  const ParveLogoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1A1B1E),
        border: Border.all(
          color: const Color(0xFFD5B363),
          width: 2.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2.5),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFD5B363).withValues(alpha: 0.6),
            width: 0.8,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 6,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'P',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFFD5B363),
                      height: 1.0,
                    ),
                  ),
                  SizedBox(width: 1),
                  Icon(
                    Icons.directions_car_filled_outlined,
                    size: 14,
                    color: Color(0xFFD5B363),
                  ),
                ],
              ),
            ),
            const Positioned(
              bottom: 7,
              child: Text(
                'PARVE',
                style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFD5B363),
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom Ticket Stub Icon with notches on left/right and vertical perforations
class TicketStubIcon extends StatelessWidget {
  final Color color;
  final double size;

  const TicketStubIcon({
    super.key,
    required this.color,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.75,
      child: CustomPaint(
        painter: _TicketStubPainter(color: color),
      ),
    );
  }
}

class _TicketStubPainter extends CustomPainter {
  final Color color;

  _TicketStubPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;
    final notchR = h * 0.22;
    final cornerR = 2.5;

    final path = Path()
      ..moveTo(cornerR, 0)
      ..lineTo(w - cornerR, 0)
      ..quadraticBezierTo(w, 0, w, cornerR)
      ..lineTo(w, h / 2 - notchR)
      ..arcToPoint(
        Offset(w, h / 2 + notchR),
        radius: Radius.circular(notchR),
        clockwise: false,
      )
      ..lineTo(w, h - cornerR)
      ..quadraticBezierTo(w, h, w - cornerR, h)
      ..lineTo(cornerR, h)
      ..quadraticBezierTo(0, h, 0, h - cornerR)
      ..lineTo(0, h / 2 + notchR)
      ..arcToPoint(
        Offset(0, h / 2 - notchR),
        radius: Radius.circular(notchR),
        clockwise: false,
      )
      ..lineTo(0, cornerR)
      ..quadraticBezierTo(0, 0, cornerR, 0);

    canvas.drawPath(path, paint);

    // Inner perforation dots/lines
    final midX = w * 0.5;
    canvas.drawLine(Offset(midX, h * 0.22), Offset(midX, h * 0.36), paint);
    canvas.drawLine(Offset(midX, h * 0.64), Offset(midX, h * 0.78), paint);
  }

  @override
  bool shouldRepaint(covariant _TicketStubPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Custom Crosshair Target Icon for "Pantau kendaraan" button
class TargetCrosshairIcon extends StatelessWidget {
  final Color color;
  final double size;

  const TargetCrosshairIcon({
    super.key,
    required this.color,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _TargetCrosshairPainter(color: color),
      ),
    );
  }
}

class _TargetCrosshairPainter extends CustomPainter {
  final Color color;

  _TargetCrosshairPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width * 0.34;
    final innerRadius = size.width * 0.12;
    final tickExtent = size.width * 0.48;

    // Outer circle
    canvas.drawCircle(center, outerRadius, paint);

    // Inner circle
    canvas.drawCircle(center, innerRadius, paint);

    // 4 Crosshair ticks (top, bottom, left, right)
    canvas.drawLine(
      Offset(center.dx, center.dy - tickExtent),
      Offset(center.dx, center.dy - outerRadius),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + outerRadius),
      Offset(center.dx, center.dy + tickExtent),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - tickExtent, center.dy),
      Offset(center.dx - outerRadius, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + outerRadius, center.dy),
      Offset(center.dx + tickExtent, center.dy),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _TargetCrosshairPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Custom QR Code Painter matching the exact stylized QR matrix in the screenshot
class ParveQrPainter extends CustomPainter {
  const ParveQrPainter();

  // 15x15 matrix matching the stylized QR code in the reference image
  static const List<List<int>> _matrix = [
    [1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1],
    [1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1],
    [1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1],
    [1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1],
    [1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0],
    [1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1],
    [1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0],
    [0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1],
    [0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 1, 0],
    [1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0],
    [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1],
    [1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 0],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF21211F)
      ..style = PaintingStyle.fill;

    final int gridSize = _matrix.length;
    final double cellSize = size.width / gridSize;

    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (_matrix[r][c] == 1) {
          final rect = Rect.fromLTWH(
            c * cellSize,
            r * cellSize,
            cellSize + 0.4,
            cellSize + 0.4,
          );
          canvas.drawRect(rect, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom Vector Illustration of a White Toyota Veloz MPV matching the card preview
class WhiteMpvCarPainter extends CustomPainter {
  const WhiteMpvCarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Ground shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.14)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawOval(
      Rect.fromLTWH(w * 0.06, h * 0.78, w * 0.88, h * 0.15),
      shadowPaint,
    );

    // Rear-left & front-right background wheels
    final darkWheelPaint = Paint()..color = const Color(0xFF141414);
    canvas.drawCircle(Offset(w * 0.85, h * 0.70), h * 0.13, darkWheelPaint);

    // Main car body (white pearl MPV silhouette angled 3/4 to the right)
    final bodyPath = Path()
      ..moveTo(w * 0.08, h * 0.65)
      ..lineTo(w * 0.06, h * 0.44)
      ..quadraticBezierTo(w * 0.08, h * 0.25, w * 0.22, h * 0.18)
      ..lineTo(w * 0.56, h * 0.16)
      ..lineTo(w * 0.74, h * 0.36)
      ..quadraticBezierTo(w * 0.92, h * 0.40, w * 0.95, h * 0.49)
      ..lineTo(w * 0.95, h * 0.68)
      ..lineTo(w * 0.62, h * 0.72)
      ..lineTo(w * 0.08, h * 0.65)
      ..close();

    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [
          Color(0xFFFFFFFF),
          Color(0xFFF1F2F4),
          Color(0xFFDCE0E5),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(bodyPath, bodyPaint);

    // Subtle body outline
    final bodyStroke = Paint()
      ..color = const Color(0xFFD0D4DA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(bodyPath, bodyStroke);

    // Greenhouse / Windows (Dark tinted glass)
    final windowPath = Path()
      ..moveTo(w * 0.13, h * 0.40)
      ..lineTo(w * 0.23, h * 0.22)
      ..lineTo(w * 0.55, h * 0.20)
      ..lineTo(w * 0.71, h * 0.37)
      ..lineTo(w * 0.50, h * 0.41)
      ..close();

    final windowPaint = Paint()..color = const Color(0xFF23272E);
    canvas.drawPath(windowPath, windowPaint);

    // Front windshield section
    final windshieldPath = Path()
      ..moveTo(w * 0.56, h * 0.20)
      ..lineTo(w * 0.72, h * 0.36)
      ..lineTo(w * 0.54, h * 0.39)
      ..lineTo(w * 0.45, h * 0.22)
      ..close();
    canvas.drawPath(
      windshieldPath,
      Paint()..color = const Color(0xFF1A1D22),
    );

    // Window pillar dividers (white/silver)
    final pillarPaint = Paint()
      ..color = const Color(0xFFE6E8EC)
      ..strokeWidth = 1.6;
    canvas.drawLine(
      Offset(w * 0.30, h * 0.21),
      Offset(w * 0.29, h * 0.40),
      pillarPaint,
    );
    canvas.drawLine(
      Offset(w * 0.46, h * 0.20),
      Offset(w * 0.51, h * 0.40),
      pillarPaint,
    );

    // Front Grille (Large trapezoidal black grille characteristic of Veloz)
    final grillePath = Path()
      ..moveTo(w * 0.77, h * 0.47)
      ..lineTo(w * 0.93, h * 0.48)
      ..lineTo(w * 0.91, h * 0.62)
      ..lineTo(w * 0.75, h * 0.61)
      ..close();
    canvas.drawPath(grillePath, Paint()..color = const Color(0xFF18191C));

    // Headlight (Sleek LED strip extending from grille)
    final headlightPath = Path()
      ..moveTo(w * 0.65, h * 0.44)
      ..lineTo(w * 0.78, h * 0.45)
      ..lineTo(w * 0.76, h * 0.49)
      ..lineTo(w * 0.63, h * 0.47)
      ..close();
    canvas.drawPath(headlightPath, Paint()..color = const Color(0xFF4A5568));

    // Lower front bumper & side skirt trim
    final skirtPaint = Paint()
      ..color = const Color(0xFF212328)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(w * 0.22, h * 0.65, w * 0.34, h * 0.04),
      skirtPaint,
    );

    // Rear Wheel & Tire
    _drawWheel(canvas, Offset(w * 0.20, h * 0.67), h * 0.15);

    // Front Wheel & Tire
    _drawWheel(canvas, Offset(w * 0.61, h * 0.71), h * 0.165);
  }

  void _drawWheel(Canvas canvas, Offset center, double radius) {
    // Tire arch cutout
    canvas.drawCircle(
      center,
      radius * 1.1,
      Paint()..color = const Color(0xFF1A1B1E),
    );
    // Tire
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = const Color(0xFF111214),
    );
    // Alloy rim
    canvas.drawCircle(
      center,
      radius * 0.58,
      Paint()..color = const Color(0xFF9CA3AF),
    );
    // Inner hub
    canvas.drawCircle(
      center,
      radius * 0.25,
      Paint()..color = const Color(0xFF1F2937),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom Bottom Navigation Icons matching the thin outline style in the screenshot
class NavHomeIcon extends StatelessWidget {
  final Color color;
  const NavHomeIcon({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _NavHomePainter(color: color)),
    );
  }
}

class _NavHomePainter extends CustomPainter {
  final Color color;
  _NavHomePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final path = Path()
      ..moveTo(w * 0.5, h * 0.1)
      ..lineTo(w * 0.12, h * 0.44)
      ..lineTo(w * 0.12, h * 0.88)
      ..lineTo(w * 0.88, h * 0.88)
      ..lineTo(w * 0.88, h * 0.44)
      ..close();

    canvas.drawPath(path, paint);

    // Door
    final doorPath = Path()
      ..moveTo(w * 0.38, h * 0.88)
      ..lineTo(w * 0.38, h * 0.58)
      ..lineTo(w * 0.62, h * 0.58)
      ..lineTo(w * 0.62, h * 0.88);
    canvas.drawPath(doorPath, paint);
  }

  @override
  bool shouldRepaint(covariant _NavHomePainter oldDelegate) =>
      oldDelegate.color != color;
}

class NavWalletIcon extends StatelessWidget {
  final Color color;
  const NavWalletIcon({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _NavWalletPainter(color: color)),
    );
  }
}

class _NavWalletPainter extends CustomPainter {
  final Color color;
  _NavWalletPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Main wallet body
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.1, h * 0.24, w * 0.8, h * 0.64),
      const Radius.circular(3.5),
    );
    canvas.drawRRect(rrect, paint);

    // Top fold line
    final topFold = Path()
      ..moveTo(w * 0.16, h * 0.24)
      ..lineTo(w * 0.16, h * 0.14)
      ..lineTo(w * 0.76, h * 0.14);
    canvas.drawPath(topFold, paint);

    // Clasp on the right
    final clasp = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.64, h * 0.46, w * 0.26, h * 0.20),
      const Radius.circular(2),
    );
    canvas.drawRRect(clasp, paint);
  }

  @override
  bool shouldRepaint(covariant _NavWalletPainter oldDelegate) =>
      oldDelegate.color != color;
}

class NavProfileIcon extends StatelessWidget {
  final Color color;
  const NavProfileIcon({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _NavProfilePainter(color: color)),
    );
  }
}

class _NavProfilePainter extends CustomPainter {
  final Color color;
  _NavProfilePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // Head circle
    canvas.drawCircle(Offset(w * 0.5, h * 0.32), w * 0.20, paint);

    // Shoulders arc
    final bodyPath = Path()
      ..moveTo(w * 0.16, h * 0.88)
      ..quadraticBezierTo(w * 0.18, h * 0.58, w * 0.5, h * 0.58)
      ..quadraticBezierTo(w * 0.82, h * 0.58, w * 0.84, h * 0.88);
    canvas.drawPath(bodyPath, paint);
  }

  @override
  bool shouldRepaint(covariant _NavProfilePainter oldDelegate) =>
      oldDelegate.color != color;
}