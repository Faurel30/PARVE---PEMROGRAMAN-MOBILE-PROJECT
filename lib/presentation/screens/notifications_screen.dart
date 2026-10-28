import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/ticket_data.dart';
import '../widgets/parve_header.dart';

class NotificationsScreen extends StatefulWidget {
  final Officer officer;
  final List<OfficerNotification> notifications;
  final VoidCallback onBackToScan;
  final VoidCallback onSwitchOfficer;
  final VoidCallback? onClearNotifications;

  const NotificationsScreen({
    super.key,
    required this.officer,
    required this.notifications,
    required this.onBackToScan,
    required this.onSwitchOfficer,
    this.onClearNotifications,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Map of opened notification IDs
  final Set<String> _expandedIds = {'notif-1'};

  void _toggleExpanded(String id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (PARVE Logo, Pacific Place, Officer Card)
          ParveHeader(
            officer: widget.officer,
            unreadNotifications: widget.notifications.length,
            onSwitchOfficer: widget.onSwitchOfficer,
          ),
          const SizedBox(height: 18),

          // Title & Subtitle
          const Text(
            'Notifikasi',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Persetujuan keluar dari Admin, khusus untuk Petugas ${widget.officer.name}.',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Date & Counter Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '8 Oktober 2026',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${widget.notifications.length} notifikasi baru',
                style: const TextStyle(
                  color: AppColors.goldPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Notification Cards List
          if (widget.notifications.isEmpty)
            _buildEmptyState()
          else
            ...widget.notifications.map((notif) => _buildNotificationCard(notif)),

          const SizedBox(height: 16),

          // Secondary Action Button: Kembali ke scan
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: widget.onBackToScan,
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.card,
                side: const BorderSide(color: AppColors.border, width: 1.2),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.crop_free_rounded,
                    size: 19,
                    color: AppColors.goldPrimary,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Kembali ke scan',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Static Footnote
          const Center(
            child: Text(
              'Tampilan statis · Notifikasi tidak dikirim secara nyata',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.notifications_off_outlined,
            color: AppColors.textMuted,
            size: 40,
          ),
          SizedBox(height: 12),
          Text(
            'Belum ada notifikasi keluar',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(OfficerNotification notif) {
    final isExpanded = _expandedIds.contains(notif.id);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Notification Header (Tap to toggle)
          InkWell(
            onTap: () => _toggleExpanded(notif.id),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Green Checkmark in Circle
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppColors.successGreenDark,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.successGreen,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Notification Title, Plate & Driver
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              notif.title,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              notif.time,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          notif.subtitle,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isExpanded
                              ? notif.authorInfo
                              : 'Ketuk untuk melihat rincian persetujuan',
                          style: const TextStyle(
                            color: AppColors.goldMutedText,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Detail Persetujuan Keluar Card (If Expanded)
          if (isExpanded) ...[
            const Divider(color: AppColors.divider, height: 1, thickness: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detail persetujuan keluar',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Success Alert Box: Keluar disetujui Admin
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.successGreenDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.successGreenBorder,
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.gpp_good_rounded,
                          color: AppColors.successGreen,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Keluar disetujui Admin',
                                style: TextStyle(
                                  color: AppColors.successGreen,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Kendaraan telah diizinkan keluar.',
                                style: TextStyle(
                                  color: AppColors.successGreenMuted,
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Plate and Driver Name
                  Text(
                    notif.ticket.plateNumber,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notif.ticket.driverName,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Detail Key-Values
                  _buildDetailRow('Tiket', notif.ticket.ticketNumber, isMono: true),
                  const SizedBox(height: 9),
                  _buildDetailRow(
                    'Disetujui oleh',
                    notif.ticket.approvedBy ?? 'Admin Dimas Pratama',
                  ),
                  const SizedBox(height: 9),
                  _buildDetailRow(
                    'Waktu persetujuan',
                    notif.ticket.approvalTime ?? notif.time,
                  ),
                  const SizedBox(height: 9),
                  _buildDetailRow(
                    'Penerima notifikasi',
                    'Petugas ${widget.officer.name}',
                  ),
                  const SizedBox(height: 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status transaksi',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          notif.ticket.transactionStatus,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            color: AppColors.successGreen,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Explanatory note
                  const Text(
                    'Notifikasi dikirim setelah Admin memverifikasi keluar. Petugas hanya menerima informasi, tanpa tindakan persetujuan.',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isMono = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.5,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: isMono ? 'monospace' : null,
            ),
          ),
        ),
      ],
    );
  }
}
