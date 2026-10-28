import 'package:flutter/material.dart';
import '../constants/colors.dart';

// =============================================================================
// SCREEN 7: ADMIN VERIFIKASI PEMBAYARAN
// =============================================================================
class AdminPaymentScreen extends StatelessWidget {
  const AdminPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ParveColors.darkBg,
      body: SafeArea(
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

              // Title
              const Text(
                'Verifikasi Pembayaran',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Tinjau keluar masuk, verifikasi pembayaran, dan pantau slot parkir dari satu layar operasional.',
                style: TextStyle(color: ParveColors.textMuted, fontSize: 12, height: 1.35),
              ),
              const SizedBox(height: 16),

              // Stats Row
              Row(
                children: [
                  Expanded(child: _buildStatMini('Masuk hari ini', '18')),
                  const SizedBox(width: 10),
                  Expanded(child: _buildStatMini('Keluar hari ini', '12')),
                  const SizedBox(width: 10),
                  Expanded(child: _buildStatMini('Slot tersedia', '78')),
                ],
              ),
              const SizedBox(height: 16),

              // Daftar Transaksi Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daftar transaksi',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    '2 transaksi',
                    style: TextStyle(
                      color: ParveColors.gold.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Transaction Item 1 — Lunas
              _buildTransactionItem(
                id: 'PAY-0248',
                date: '8 Okt 2026, 14.38',
                name: 'Aditya Wijaya',
                source: 'Dompet PARVE',
                amount: 'Rp95.000',
                status: 'Lunas',
                statusColor: ParveColors.green,
                isVerified: true,
              ),
              const SizedBox(height: 10),

              // Transaction Item 2 — Menunggu
              _buildTransactionItem(
                id: 'PAY-0244',
                date: '8 Okt 2026, 14.12',
                name: 'Bima Santoso',
                source: 'OtIs',
                amount: 'Rp110.000',
                status: 'Menunggu',
                statusColor: ParveColors.gold,
                isVerified: false,
              ),
              const SizedBox(height: 16),

              // Detail Transaksi
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
                          'Detail transaksi',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF142921),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            '● Lunas',
                            style: TextStyle(
                              color: ParveColors.green,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Rp95.000',
                      style: TextStyle(
                        color: ParveColors.gold,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'PAY-0248 · 8 Okt 2026, 14.38',
                      style: TextStyle(color: ParveColors.textMuted, fontSize: 11),
                    ),
                    const Divider(color: ParveColors.darkBorder, height: 20),
                    _buildDataRow('Pelanggan', 'Aditya Wijaya'),
                    _buildDataRow('Nomor tiket', 'PV-081026-0248'),
                    _buildDataRow('Kendaraan', 'B 1234 PAR'),
                    _buildDataRow('Layanan valet', 'Rp50.000'),
                    _buildDataRow('Parkir · 3 jam', 'Rp45.000'),
                    const Divider(color: ParveColors.darkBorder, height: 20),
                    _buildDataRow('Metode', 'Dompet PARVE'),
                    _buildDataRow(
                      'Status keluar',
                      'Menunggu verifikasi keluar',
                      valueColor: ParveColors.gold,
                    ),
                    _buildDataRow('Saldo akhir', 'Rp280.000'),
                    const SizedBox(height: 16),

                    // Action Buttons
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ParveColors.darkSurfaceLight,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Unduh bukti pembayaran',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Bukti pembayaran dikirim ke pelanggan.'),
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
                          'Kirim ke pelanggan',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        'Pembayaran terverifikasi. Kendaraan masih menunggu persetujuan keluar Admin.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ParveColors.textMuted,
                          fontSize: 11,
                          height: 1.4,
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
      ),
    );
  }

  static Widget _buildStatMini(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ParveColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ParveColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: ParveColors.textMuted, fontSize: 10),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildTransactionItem({
    required String id,
    required String date,
    required String name,
    required String source,
    required String amount,
    required String status,
    required Color statusColor,
    required bool isVerified,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ParveColors.darkSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ParveColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                id,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor == ParveColors.green
                      ? const Color(0xFF142921)
                      : ParveColors.goldBadgeDark,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '● $status',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(date, style: const TextStyle(color: ParveColors.textMuted, fontSize: 11)),
          const SizedBox(height: 6),
          Text(name, style: const TextStyle(color: ParveColors.textGrey, fontSize: 13)),
          Text(
            'Dompet $source',
            style: const TextStyle(color: ParveColors.textMuted, fontSize: 11),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                isVerified ? 'Verifikasi selesai →' : 'Tinjau & verifikasi →',
                style: TextStyle(
                  color: isVerified ? ParveColors.textMuted : ParveColors.gold,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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
          Text(
            label,
            style: const TextStyle(color: ParveColors.textMuted, fontSize: 12),
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

