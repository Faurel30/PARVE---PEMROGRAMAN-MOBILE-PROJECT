import 'package:flutter/material.dart';
import '../constants/colors.dart';

// =============================================================================
// SCREEN 9: ADMIN MONITORING BARCODE
// =============================================================================
class AdminBarcodeScreen extends StatefulWidget {
  const AdminBarcodeScreen({super.key});

  @override
  State<AdminBarcodeScreen> createState() => _AdminBarcodeScreenState();
}

class _AdminBarcodeScreenState extends State<AdminBarcodeScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['Semua', 'Aktif', 'Terpakai', 'Kadaluarsa'];

  final List<Map<String, dynamic>> _barcodes = [
    {
      'id': 'PV-081026-0248',
      'pengguna': 'Aditya Wijaya',
      'jenis': 'Keluar',
      'status': 'Aktif',
      'statusColor': ParveColors.green,
      'tanggal': '08 Oktober 2026, 13:52',
      'petugas': 'Rizky Saputra',
      'note': 'Menunggu verifikasi oleh Admin',
      'noteColor': ParveColors.gold,
    },
    {
      'id': 'PV-081026-0247',
      'pengguna': 'Nadya Putri',
      'jenis': 'Masuk',
      'status': 'Aktif',
      'statusColor': ParveColors.green,
      'tanggal': '08 Oktober 2026, 11:20',
      'petugas': 'Andi Firmansyah',
      'note': 'Menunggu verifikasi masuk oleh Admin',
      'noteColor': ParveColors.gold,
    },
    {
      'id': 'PV-071026-0241',
      'pengguna': 'Budi Santoso · B 4567 BDI',
      'jenis': 'Keluar',
      'status': 'Terpakai',
      'statusColor': ParveColors.textMuted,
      'tanggal': '07 Okt 2026',
      'petugas': 'Rizky Saputra',
      'note': 'Keluar · Pembayaran ✓',
      'noteColor': ParveColors.green,
    },
  ];

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
                const Text(
                  '9:41',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Spacer(),
                const Icon(Icons.wifi, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                const Icon(Icons.battery_full, color: Colors.white, size: 16),
              ],
            ),
            const SizedBox(height: 12),

            // Title
            const Text(
              'Monitoring Barcode',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 12),

            // Stats Row
            Row(
              children: [
                Expanded(child: _buildStatCard('Total Barcode', '12')),
                const SizedBox(width: 8),
                Expanded(child: _buildStatCard('Aktif', '4')),
                const SizedBox(width: 8),
                Expanded(child: _buildStatCard('Terpakai', '6')),
                const SizedBox(width: 8),
                Expanded(child: _buildStatCard('Kadaluarsa', '2')),
              ],
            ),
            const SizedBox(height: 14),

            // Filter Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_filters.length, (i) {
                  final selected = _selectedFilter == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = i),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? ParveColors.gold : ParveColors.darkSurface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? ParveColors.gold : ParveColors.darkBorder,
                        ),
                      ),
                      child: Text(
                        _filters[i],
                        style: TextStyle(
                          color: selected ? const Color(0xFF1E1E1E) : ParveColors.textGrey,
                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '8 October 2026 · Diperbarui 14:38',
              style: TextStyle(color: ParveColors.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 12),

            // Barcode List
            ...List.generate(_barcodes.length, (i) {
              final bc = _barcodes[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildBarcodeCard(bc),
              );
            }),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: ParveColors.darkSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ParveColors.darkBorder),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: ParveColors.textMuted, fontSize: 9),
          ),
        ],
      ),
    );
  }

  Widget _buildBarcodeCard(Map<String, dynamic> bc) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ParveColors.darkSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: (bc['statusColor'] as Color).withOpacity(0.3),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bc['id'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (bc['statusColor'] as Color) == ParveColors.green
                      ? const Color(0xFF142921)
                      : ParveColors.darkSurfaceLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '● ${bc['status']}',
                  style: TextStyle(
                    color: bc['statusColor'] as Color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // QR placeholder
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.qr_code_2, color: Colors.black, size: 40),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bc['pengguna'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      bc['jenis'] as String,
                      style: const TextStyle(color: ParveColors.textGrey, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bc['note'] as String,
                      style: TextStyle(
                        color: bc['noteColor'] as Color,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Digenerate: ${bc['tanggal']}',
                style: const TextStyle(color: ParveColors.textMuted, fontSize: 10),
              ),
              Text(
                'Petugas: ${bc['petugas']}',
                style: const TextStyle(color: ParveColors.textMuted, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

