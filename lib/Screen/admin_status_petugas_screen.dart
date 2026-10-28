import 'package:flutter/material.dart';
import '../constants/colors.dart';

// =============================================================================
// SCREEN 10: ADMIN STATUS PETUGAS & NOTIFIKASI
// =============================================================================
class AdminStatusPetugasScreen extends StatelessWidget {
  const AdminStatusPetugasScreen({super.key});

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
                  const Spacer(),
                  const Text(
                    'DP',
                    style: TextStyle(
                      color: ParveColors.gold,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Online badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF142921),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, color: ParveColors.green, size: 8),
                    SizedBox(width: 6),
                    Text(
                      'Sistem online · 3 petugas bertugas',
                      style: TextStyle(
                        color: ParveColors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Title
              const Text(
                'Status Petugas & Notifikasi',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pantau aktivitas petugas parkir, riwayat scan, dan pengiriman notifikasi keluar.',
                style: TextStyle(color: ParveColors.textMuted, fontSize: 12, height: 1.35),
              ),
              const SizedBox(height: 14),

              // Live Badge
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C0D0D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, color: Colors.red, size: 8),
                        SizedBox(width: 5),
                        Text(
                          'Live',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Stats Row
              Row(
                children: [
                  Expanded(child: _buildStatMini('Petugas aktif', '4')),
                  const SizedBox(width: 10),
                  Expanded(child: _buildStatMini('Scan hari ini', '12')),
                  const SizedBox(width: 10),
                  Expanded(child: _buildStatMini('Notifikasi terkirim', '8')),
                ],
              ),
              const SizedBox(height: 16),

              // Status Petugas Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Status Petugas',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    '3 aktif',
                    style: TextStyle(
                      color: ParveColors.green.withOpacity(0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              _buildPetugasCard(
                initials: 'RS',
                name: 'Rizky Saputra',
                detail: 'Petugas parkir · 4 scan hari ini',
                status: 'Aktif',
              ),
              const SizedBox(height: 8),
              _buildPetugasCard(
                initials: 'AF',
                name: 'Andi Firmansyah',
                detail: 'Petugas parkir · 3 scan hari ini',
                status: 'Aktif',
              ),
              const SizedBox(height: 8),
              _buildPetugasCard(
                initials: 'FH',
                name: 'Fajar Hidayat',
                detail: 'Petugas parkir · 5 scan hari ini',
                status: 'Aktif',
              ),
              const SizedBox(height: 16),

              // Riwayat Scan & Notifikasi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Riwayat Scan & Notifikasi',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    '2 terbaru',
                    style: TextStyle(
                      color: ParveColors.gold.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              _buildRiwayatCard(
                status: 'Menunggu verifikasi',
                statusColor: ParveColors.gold,
                time: '14:38 WIB',
                ticket: 'PV-081026-0248',
                name: 'Aditya Wijaya · B 1234 PAR',
                desc: 'Petugas Rizky Saputra · Scan keluar belum diverifikasi admin.',
                notifStatus: 'Pending',
                notifColor: ParveColors.gold,
              ),
              const SizedBox(height: 8),
              _buildRiwayatCard(
                status: 'Selesai',
                statusColor: ParveColors.green,
                time: '14:30 WIB',
                ticket: 'PV-081026-0246',
                name: 'Farhan Akbar · B 2024 FAK',
                desc: 'Petugas Fajar Hidayat · Scan keluar sudah diverifikasi admin.',
                notifStatus: 'Sent',
                notifColor: ParveColors.green,
              ),
              const SizedBox(height: 16),

              // Info Note
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: ParveColors.darkSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ParveColors.darkBorder),
                ),
                child: const Text(
                  'Petugas hanya dapat scan barcode user. Notifikasi keluar dikirimkan setelah admin menyetujui verifikasi keluar.',
                  style: TextStyle(
                    color: ParveColors.textGrey,
                    fontSize: 12,
                    height: 1.4,
                  ),
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
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: ParveColors.textMuted, fontSize: 10)),
        ],
      ),
    );
  }

  static Widget _buildPetugasCard({
    required String initials,
    required String name,
    required String detail,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ParveColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ParveColors.darkBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF2E2619),
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  color: ParveColors.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(detail, style: const TextStyle(color: ParveColors.textMuted, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF142921),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: ParveColors.green,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildRiwayatCard({
    required String status,
    required Color statusColor,
    required String time,
    required String ticket,
    required String name,
    required String desc,
    required String notifStatus,
    required Color notifColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ParveColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ParveColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor == ParveColors.green
                      ? const Color(0xFF142921)
                      : ParveColors.goldBadgeDark,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                time,
                style: const TextStyle(color: ParveColors.textMuted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            ticket,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 2),
          Text(name, style: const TextStyle(color: ParveColors.textGrey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(color: ParveColors.textMuted, fontSize: 11, height: 1.3)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Notifikasi keluar dikirim ke Petugas Parkir',
                style: TextStyle(color: ParveColors.textMuted, fontSize: 10),
              ),
              Text(
                notifStatus,
                style: TextStyle(
                  color: notifColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

