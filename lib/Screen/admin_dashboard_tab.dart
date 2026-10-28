import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'admin_verification_masuk_tab.dart';
import 'admin_verification_keluar_screen.dart';
import 'admin_payment_screen.dart';
import 'admin_slot_screen.dart';
import 'admin_barcode_screen.dart';
import 'admin_status_petugas_screen.dart';

// =============================================================================
// SCREEN 4: ADMIN DASHBOARD TAB (Beranda)
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

                  _buildQueueItem(
                    plate: 'B 1234 PAR',
                    badge: 'Keluar',
                    passenger: 'Aditya Wijaya - 14.38',
                    officer: 'Petugas Rizky Saputra',
                  ),
                  const SizedBox(height: 10),

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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminVerificationKeluarScreen(),
                      ),
                    );
                  },
                ),
                _buildActionTile(
                  icon: Icons.credit_card_outlined,
                  label: 'Pembayaran',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminPaymentScreen(),
                      ),
                    );
                  },
                ),
                _buildActionTile(
                  icon: Icons.bar_chart_outlined,
                  label: 'Slot parkir',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminSlotScreen(),
                      ),
                    );
                  },
                ),
                _buildActionTile(
                  icon: Icons.qr_code_2_outlined,
                  label: 'Monitoring barcode',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminBarcodeScreen(),
                      ),
                    );
                  },
                ),
                _buildActionTile(
                  icon: Icons.people_outline,
                  label: 'Status petugas',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminStatusPetugasScreen(),
                      ),
                    );
                  },
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

