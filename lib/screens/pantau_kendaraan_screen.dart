import 'package:flutter/material.dart';
import 'aktivitas_screen.dart';

class PantauKendaraanScreen extends StatelessWidget {
  const PantauKendaraanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F0),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Header: Back Button + "Pantau kendaraan"
              _buildHeader(context),
              const SizedBox(height: 20),

              // 2. Status Bar Row: "• Terparkir aman" + "Diperbarui 14.30 WIB"
              _buildStatusRow(),
              const SizedBox(height: 16),

              // 3. Denah Area Parkir Map Card
              _buildParkingMapCard(),
              const SizedBox(height: 16),

              // 4. Vehicle Info & Duration Card
              _buildVehicleDetailCard(),
              const SizedBox(height: 22),

              // 5. Section Title: "Perjalanan kendaraan"
              const Text(
                'Perjalanan kendaraan',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D1E1C),
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 12),

              // 6. Journey Timeline Card
              _buildJourneyCard(),
              const SizedBox(height: 14),

              // 7. Valet Attendant Card (Andi Saputra)
              _buildAttendantCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          child: Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.arrow_back_rounded,
              size: 20,
              color: Color(0xFF1D1E1C),
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            'Pantau kendaraan',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D1E1C),
              letterSpacing: -0.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
        const Text(
          'Diperbarui 14.30 WIB',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w400,
            color: Color(0xFF7D7B74),
          ),
        ),
      ],
    );
  }

  Widget _buildParkingMapCard() {
    return Container(
      height: 196,
      decoration: BoxDecoration(
        color: const Color(0xFFEBECE6),
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Map Roads (White horizontal & vertical lanes)
          const Positioned.fill(
            child: CustomPaint(
              painter: _ParkingMapPainter(),
            ),
          ),

          // Top-left label pill: "Denah area parkir"
          Positioned(
            top: 14,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFDFCFA),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'Denah area parkir',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF72706A),
                ),
              ),
            ),
          ),

          // Building Zone Block: "SENAYAN CITY"
          Positioned(
            left: 28,
            top: 72,
            width: 175,
            height: 66,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFDCDFD6),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: const Text(
                'SENAYAN CITY',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF696B65),
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),

          // Dark Car Pin Marker Circle
          Positioned(
            left: 218,
            top: 68,
            child: Container(
              width: 54,
              height: 54,
              decoration: const BoxDecoration(
                color: Color(0xFF21211F),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const FrontCarOutlineIcon(
                color: Color(0xFFD5B363),
                size: 24,
              ),
            ),
          ),

          // White Pill Badge under/next to marker: "B1 • A-12"
          Positioned(
            left: 187,
            top: 126,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'B1 • A-12',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D1E1C),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleDetailCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEAE8E1), width: 1),
      ),
      child: Column(
        children: [
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
          const SizedBox(height: 18),
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFEFEDE7),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Lokasi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7D7B74),
                ),
              ),
              Text(
                'Senayan City • B1 A-12',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D1E1C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Durasi saat ini',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7D7B74),
                ),
              ),
              Text(
                '1 jam 30 menit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D1E1C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEAE8E1), width: 1),
      ),
      child: Column(
        children: [
          _buildJourneyStep(
            title: 'Diserahkan ke petugas',
            subtitle: 'Lobi utama • Pintu selatan',
            time: '13.00',
          ),
          const SizedBox(height: 18),
          _buildJourneyStep(
            title: 'Terparkir aman',
            subtitle: 'B1 • Blok A-12',
            time: '13.08',
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyStep({
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: Color(0xFFE7F3EC),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.check_rounded,
            size: 16,
            color: Color(0xFF286E50),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D1E1C),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7D7B74),
                ),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Color(0xFF7D7B74),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendantCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEAE8E1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F5F0),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: const VerifiedUserOutlineIcon(
              color: Color(0xFF1D1E1C),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Andi Saputra',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1E1C),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Petugas valet Anda • Identitas terverifikasi',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7D7B74),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'Hubungi',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7A5C1D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
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
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: () {},
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
                  FrontCarOutlineIcon(
                    color: Color(0xFF1D1E1C),
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Ambil kendaraan',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D1E1C),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom Painter for the Parking Map grid lanes matching the reference design
class _ParkingMapPainter extends CustomPainter {
  const _ParkingMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFFFDFCFA)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Top horizontal lane
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.23, w, 14),
      roadPaint,
    );

    // Bottom horizontal lane
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.78, w, 14),
      roadPaint,
    );

    // Right vertical intersecting lane
    canvas.drawRect(
      Rect.fromLTWH(w * 0.72, 0, 18, h),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom Front-Facing Car Outline Icon used in Map Pin & "Ambil kendaraan" button
class FrontCarOutlineIcon extends StatelessWidget {
  final Color color;
  final double size;

  const FrontCarOutlineIcon({
    super.key,
    required this.color,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _FrontCarOutlinePainter(color: color),
      ),
    );
  }
}

class _FrontCarOutlinePainter extends CustomPainter {
  final Color color;

  _FrontCarOutlinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Roof / cabin trapezoid
    final cabinPath = Path()
      ..moveTo(w * 0.16, h * 0.45)
      ..lineTo(w * 0.25, h * 0.18)
      ..quadraticBezierTo(w * 0.28, h * 0.14, w * 0.34, h * 0.14)
      ..lineTo(w * 0.66, h * 0.14)
      ..quadraticBezierTo(w * 0.72, h * 0.14, w * 0.75, h * 0.18)
      ..lineTo(w * 0.84, h * 0.45);
    canvas.drawPath(cabinPath, strokePaint);

    // Lower body rounded rectangle
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.10, h * 0.45, w * 0.80, h * 0.30),
      const Radius.circular(3.5),
    );
    canvas.drawRRect(bodyRect, strokePaint);

    // Left & right tires/legs
    canvas.drawLine(
      Offset(w * 0.20, h * 0.75),
      Offset(w * 0.20, h * 0.86),
      strokePaint,
    );
    canvas.drawLine(
      Offset(w * 0.80, h * 0.75),
      Offset(w * 0.80, h * 0.86),
      strokePaint,
    );

    // Headlight dots
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.27, h * 0.60), 1.4, dotPaint);
    canvas.drawCircle(Offset(w * 0.73, h * 0.60), 1.4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _FrontCarOutlinePainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Custom Person with Checkmark Icon for Valet Attendant ("Andi Saputra")
class VerifiedUserOutlineIcon extends StatelessWidget {
  final Color color;
  final double size;

  const VerifiedUserOutlineIcon({
    super.key,
    required this.color,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _VerifiedUserOutlinePainter(color: color),
      ),
    );
  }
}

class _VerifiedUserOutlinePainter extends CustomPainter {
  final Color color;

  _VerifiedUserOutlinePainter({required this.color});

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

    // Head circle (slightly shifted left)
    canvas.drawCircle(Offset(w * 0.42, h * 0.32), w * 0.18, paint);

    // Shoulders arc
    final bodyPath = Path()
      ..moveTo(w * 0.14, h * 0.82)
      ..quadraticBezierTo(w * 0.16, h * 0.56, w * 0.42, h * 0.56)
      ..quadraticBezierTo(w * 0.56, h * 0.56, w * 0.64, h * 0.65);
    canvas.drawPath(bodyPath, paint);

    // Small verification checkmark on bottom right
    final checkPath = Path()
      ..moveTo(w * 0.64, h * 0.74)
      ..lineTo(w * 0.73, h * 0.83)
      ..lineTo(w * 0.90, h * 0.64);
    canvas.drawPath(checkPath, paint);
  }

  @override
  bool shouldRepaint(covariant _VerifiedUserOutlinePainter oldDelegate) =>
      oldDelegate.color != color;
}
