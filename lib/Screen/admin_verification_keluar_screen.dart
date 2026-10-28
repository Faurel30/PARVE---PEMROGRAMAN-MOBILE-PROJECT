import 'package:flutter/material.dart';
import '../constants/colors.dart';

// =============================================================================
// SCREEN 6: ADMIN VERIFIKASI PARKIR KELUAR
// =============================================================================
class AdminVerificationKeluarScreen extends StatelessWidget {
  const AdminVerificationKeluarScreen({super.key});

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: ParveColors.darkSurfaceLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PARVE Admin',
                            style: TextStyle(
                              color: ParveColors.gold,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'Pacific Place',
                            style: TextStyle(color: ParveColors.textMuted, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
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
                          'Online',
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

              // Title
              const Text(
                'Verifikasi Parkir Keluar',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Proses verifikasi keluar, pembayaran, dan notifikasi ke Petugas Parkir.',
                style: TextStyle(color: ParveColors.textMuted, fontSize: 12, height: 1.35),
              ),
              const SizedBox(height: 16),

              // Permintaan Keluar Card
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
                          'Permintaan keluar',
                          style: TextStyle(color: ParveColors.textMuted, fontSize: 11),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: ParveColors.goldBadgeDark,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            '● Menunggu',
                            style: TextStyle(
                              color: ParveColors.gold,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Vehicle info
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ParveColors.darkSurfaceLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF23272E),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.directions_car, color: ParveColors.gold, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Toyota Alphard',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'B 1234 PAR',
                                  style: TextStyle(color: ParveColors.textGrey, fontSize: 12),
                                ),
                                Text(
                                  'Tiket PV-081026-0248',
                                  style: TextStyle(color: ParveColors.textMuted, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDataRow('Masuk', '11:30 WIB'),
                    _buildDataRow('Slot', 'A-018'),
                    _buildDataRow('Petugas', 'Rizky Saputra'),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Pembayaran Card
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
                          'Pembayaran',
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
                            '● Terverifikasi',
                            style: TextStyle(
                              color: ParveColors.green,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildDataRow('Metode', 'Dompet PARVE'),
                    _buildDataRow('ID Pembayaran', 'PAY-0248'),
                    const Divider(color: ParveColors.darkBorder, height: 20),
                    _buildDataRow('Parkir · 3 jam', 'Rp50.000'),
                    _buildDataRow('Layanan valet', 'Rp45.000'),
                    const Divider(color: ParveColors.darkBorder, height: 20),
                    _buildDataRow(
                      'Total',
                      'Rp95.000',
                      valueBold: true,
                      valueColor: ParveColors.gold,
                    ),
                    _buildDataRow('Waktu bayar', '14:38 WIB'),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Hasil Scan Petugas Card
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
                      'Hasil scan Petugas',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDataRow('Barcode scan', 'PV-081026-0248'),
                    _buildDataRow(
                      'Status',
                      'Siterima',
                      valueColor: ParveColors.green,
                    ),
                    _buildDataRow('Sumber scan', 'Petugas Rizky Saputra'),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Aksi Verifikasi Keluar Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ParveColors.darkSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF3B82F6).withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Aksi verifikasi keluar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Admin menyetujui keluar setelah pembayaran. Petugas Parkir akan menerima notifikasi setelah Admin menyetujui.',
                      style: TextStyle(color: ParveColors.textMuted, fontSize: 12, height: 1.35),
                    ),
                    const SizedBox(height: 12),

                    // Catatan Admin Input
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ParveColors.darkSurfaceLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Petugas Rizky Saputra sudah melakukan scan barcode. Admin perlu menyetujui tiket agar notifikasi dikirim ke Petugas Parkir.',
                        style: TextStyle(
                          color: ParveColors.textGrey,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Permintaan keluar ditolak.'),
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
                                'Tolak',
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
                                    content: Text('Keluar disetujui! Notifikasi dikirim ke petugas.'),
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
                                'Setujui keluar',
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildDataRow(
    String label,
    String value, {
    Color? valueColor,
    bool valueBold = false,
  }) {
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
              fontWeight: valueBold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

