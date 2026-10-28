import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class EvaluationBottomSheet extends StatefulWidget {
  final Function(String plate) onSimulateManualPlate;
  final VoidCallback onSimulateEmergencyGate;

  const EvaluationBottomSheet({
    super.key,
    required this.onSimulateManualPlate,
    required this.onSimulateEmergencyGate,
  });

  static void show(
    BuildContext context, {
    required Function(String plate) onSimulateManualPlate,
    required VoidCallback onSimulateEmergencyGate,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => EvaluationBottomSheet(
        onSimulateManualPlate: onSimulateManualPlate,
        onSimulateEmergencyGate: onSimulateEmergencyGate,
      ),
    );
  }

  @override
  State<EvaluationBottomSheet> createState() => _EvaluationBottomSheetState();
}

class _EvaluationBottomSheetState extends State<EvaluationBottomSheet> {
  final TextEditingController _plateController = TextEditingController(text: 'B 1234 PAR');

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF14161C),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: ListView(
            controller: scrollController,
            children: [
              // Handle pill
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.goldDarkBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.goldBorder, width: 1),
                    ),
                    child: const Icon(
                      Icons.analytics_outlined,
                      color: AppColors.goldPrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Evaluasi Alur & Fitur Petugas',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Catatan Teknis & Operasional untuk Tim Parvee',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.divider, height: 1),
              const SizedBox(height: 16),

              // Section 1: Critical Issues in Current Design
              _buildSectionTitle('1. Temuan Masalah Kritis pada Alur Saat Ini'),
              const SizedBox(height: 10),
              _buildIssueCard(
                icon: Icons.traffic_rounded,
                title: 'Bottleneck Antrean Gerbang Keluar',
                desc:
                    'Pada desain saat ini, setelah barcode di-scan petugas, kendaraan HARUS menunggu verifikasi manual dari Admin. Di jam sibuk mall, menunggu admin mengklik persetujuan per mobil akan memicu kemacetan luar biasa di pintu keluar.',
                badge: 'Kritis',
                badgeColor: Colors.redAccent,
              ),
              const SizedBox(height: 10),
              _buildIssueCard(
                icon: Icons.lock_clock_rounded,
                title: 'Redundansi Approval (Otomatisasi Hilang)',
                desc:
                    'Jika status pembayaran sudah "Sudah terverifikasi" secara digital (QRIS/E-Wallet/Saldo), sistem backend seharusnya otomatis mengizinkan keluar (<1 detik) tanpa intervensi manusia.',
                badge: 'Arsitektur',
                badgeColor: AppColors.goldPrimary,
              ),
              const SizedBox(height: 10),
              _buildIssueCard(
                icon: Icons.pan_tool_outlined,
                title: 'Petugas Terlalu Pasif (Hanya-Baca)',
                desc:
                    'Petugas lapangan di gardu tidak memiliki aksi darurat (buka palang manual jika sensor macet, pencarian nopol jika HP user lowbat, atau lapor kendala).',
                badge: 'Operasional',
                badgeColor: Colors.orangeAccent,
              ),
              const SizedBox(height: 20),

              // Section 2: Essential Recommended Features
              _buildSectionTitle('2. Rekomendasi Fitur Wajib Role Petugas'),
              const SizedBox(height: 12),
              _buildRecommendationItem(
                'Instant Auto-Clearance',
                'Begitu barcode valid & bayar lunas, layar langsung HIJAU "Silakan Keluar" & palang terbuka otomatis.',
              ),
              _buildRecommendationItem(
                'Input No. Polisi Manual',
                'Solusi jika kamera bermasalah, layar HP user retak, atau kertas barcode basah.',
              ),
              _buildRecommendationItem(
                'Buka Palang Darurat (Emergency Override)',
                'Akses bagi petugas untuk membuka gate saat macet dengan log audit sistem.',
              ),
              _buildRecommendationItem(
                'Pembayaran di Tempat (Loket Cadangan)',
                'Jika saldo user kurang atau jaringan bank offline, petugas bisa memproses tunai / EDC EDC.',
              ),
              _buildRecommendationItem(
                'Rekap Shift & Handover',
                'Laporan ringkas berapa kendaraan keluar yang diproses dan total uang di gardu.',
              ),
              const SizedBox(height: 20),

              // Section 3: Interactive Demo of Extra Features
              _buildSectionTitle('3. Coba Fitur Tambahan Rekomendasi (Demo Langsung)'),
              const SizedBox(height: 10),

              // Interactive Demo: Input Plat Manual
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pencarian No. Polisi Manual (Fallback Scan):',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _plateController,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.card,
                              hintText: 'Contoh: B 1234 PAR',
                              hintStyle: const TextStyle(color: AppColors.textMuted),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: AppColors.border),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: AppColors.border),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onSimulateManualPlate(_plateController.text);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.goldPrimary,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Cari'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Interactive Demo: Buka Palang Darurat
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Buka Palang Manual (Emergency):',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Buka barrier gate fisik jika ada masalah darurat.',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onSimulateEmergencyGate();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E1919),
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.lock_open_rounded, size: 16),
                      label: const Text('Buka Gate'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.goldPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildIssueCard({
    required IconData icon,
    required String title,
    required String desc,
    required String badge,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: badgeColor, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.5), width: 0.8),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.successGreen,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  height: 1.35,
                ),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: desc),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
