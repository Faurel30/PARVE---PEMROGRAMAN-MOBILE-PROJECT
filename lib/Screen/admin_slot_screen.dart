import 'package:flutter/material.dart';
import '../constants/colors.dart';

// =============================================================================
// SCREEN 8: ADMIN SLOT PARKIR
// =============================================================================
class AdminSlotScreen extends StatelessWidget {
  const AdminSlotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: ParveColors.gold.withOpacity(0.4)),
                  ),
                  child: const Center(
                    child: Icon(Icons.bolt, color: ParveColors.gold, size: 18),
                  ),
                ),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PARVE Pacific Place',
                      style: TextStyle(
                        color: ParveColors.gold,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Operasional parkir',
                      style: TextStyle(color: ParveColors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: ParveColors.darkSurfaceLight,
                  ),
                  child: const Icon(Icons.notifications_outlined, color: Colors.white70, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Title & Stats
            const Text(
              'Slot Parkir',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildSlotStatChip('120 slot', 'B1 & B2'),
                const SizedBox(width: 10),
                _buildSlotStatChip('Terisi  42', '35% terisi'),
                const SizedBox(width: 10),
                _buildSlotStatChip('Tersedia  78', 'Siap diallokasi'),
              ],
            ),
            const SizedBox(height: 16),

            // Ringkasan Verifikasi Card
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
                        'Ringkasan verifikasi',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '3 menunggu',
                        style: TextStyle(
                          color: ParveColors.gold.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildVerifSummaryCard(
                          title: 'Masuk',
                          value: '1',
                          subtitle: 'Permintaan masuk',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildVerifSummaryCard(
                          title: 'Keluar',
                          value: '2',
                          subtitle: 'Antrean Zona A',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Denah B2 Zona A
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
                        'Denah B2 Zona A',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '8 slot',
                        style: TextStyle(
                          color: ParveColors.textMuted.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Legend
                  Row(
                    children: [
                      _buildLegendDot(const Color(0xFF2563EB), 'Terpakai'),
                      const SizedBox(width: 12),
                      _buildLegendDot(ParveColors.green, 'Tersedia'),
                      const SizedBox(width: 12),
                      _buildLegendDot(ParveColors.gold, 'Menunggu Keluar'),
                      const SizedBox(width: 12),
                      _buildLegendDot(const Color(0xFF6B7280), 'Kosong'),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Slot Grid 2 rows × 4
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1.05,
                    children: [
                      _buildSlotCard('A-016', 'B 7602 RKS', SlotState.terpakai),
                      _buildSlotCard('A-017', 'Tersedia', SlotState.tersedia),
                      _buildSlotCard('A-018', 'B 1234 PAR', SlotState.menungguKeluar),
                      _buildSlotCard('A-019', 'Kosong', SlotState.kosong),
                      _buildSlotCard('A-020', 'B 9081 NDP', SlotState.terpakai),
                      _buildSlotCard('A-021', 'Tersedia', SlotState.tersedia),
                      _buildSlotCard('A-022', 'B 8821 KLA', SlotState.terpakai),
                      _buildSlotCard('A-023', 'Tersedia', SlotState.tersedia),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Vehicle Detail Card
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
                    children: [
                      const Icon(Icons.directions_car, color: ParveColors.gold, size: 20),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Toyota Alphard',
                              style: TextStyle(color: ParveColors.textMuted, fontSize: 12),
                            ),
                            Text(
                              'B 1234 PAR',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: ParveColors.goldBadgeDark,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '● Menunggu verifikasi keluar',
                          style: TextStyle(
                            color: ParveColors.gold,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: ParveColors.darkBorder, height: 20),
                  _buildDataRow('Pemilik', 'Aditya Wijaya'),
                  _buildDataRow('Slot / warna', 'A-018 / Hitam'),
                  _buildDataRow('Petugas', 'Rizky Saputra'),
                  _buildDataRow('Kondisi awal', 'Baik · 4 foto'),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF23272E),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.photo_library_outlined, color: ParveColors.gold, size: 18),
                      label: const Text(
                        'Lihat dokumentasi',
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

  static Widget _buildSlotStatChip(String main, String sub) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: ParveColors.darkSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ParveColors.darkBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              main,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Text(
              sub,
              style: const TextStyle(color: ParveColors.textMuted, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildVerifSummaryCard({
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ParveColors.darkSurfaceLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: ParveColors.textMuted, fontSize: 11)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          Text(subtitle, style: const TextStyle(color: ParveColors.textMuted, fontSize: 10)),
        ],
      ),
    );
  }

  static Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: ParveColors.textMuted, fontSize: 9),
        ),
      ],
    );
  }

  static Widget _buildSlotCard(String slot, String detail, SlotState state) {
    Color borderColor;
    Color bgColor;
    Color textColor;

    switch (state) {
      case SlotState.terpakai:
        borderColor = const Color(0xFF2563EB);
        bgColor = const Color(0xFF1A2035);
        textColor = const Color(0xFF93C5FD);
        break;
      case SlotState.tersedia:
        borderColor = ParveColors.green;
        bgColor = const Color(0xFF142921);
        textColor = ParveColors.green;
        break;
      case SlotState.menungguKeluar:
        borderColor = ParveColors.gold;
        bgColor = ParveColors.goldBadgeDark;
        textColor = ParveColors.gold;
        break;
      case SlotState.kosong:
        borderColor = ParveColors.darkBorder;
        bgColor = ParveColors.darkSurfaceLight;
        textColor = ParveColors.textMuted;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            slot,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            detail,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor.withOpacity(0.75),
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildDataRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: ParveColors.textMuted, fontSize: 12)),
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

enum SlotState { terpakai, tersedia, menungguKeluar, kosong }

