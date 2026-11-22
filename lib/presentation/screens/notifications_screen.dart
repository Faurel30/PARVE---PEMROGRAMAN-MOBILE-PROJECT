import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/ticket_data.dart';
import '../../core/services/supabase_service.dart';
import '../widgets/parve_header.dart';

class NotificationsScreen extends StatefulWidget {
  final Officer officer;
  final List<OfficerNotification> notifications;
  final VoidCallback? onBackToVehicles;
  final VoidCallback? onBackToScan;
  final VoidCallback onSwitchOfficer;
  final VoidCallback? onClearNotifications;

  const NotificationsScreen({
    super.key,
    required this.officer,
    required this.notifications,
    this.onBackToVehicles,
    this.onBackToScan,
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
            'Notifikasi perubahan status kendaraan, khusus untuk Petugas ${widget.officer.name}.',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Supabase Real-time Sync Status Card
          _buildSupabaseBanner(context),

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

          // Action Button: Kembali ke Daftar Kendaraan
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: widget.onBackToVehicles ?? widget.onBackToScan,
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.card,
                side: const BorderSide(color: AppColors.goldBorder, width: 1.1),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_car_rounded,
                    size: 19,
                    color: AppColors.goldPrimary,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Kembali ke Daftar Kendaraan',
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

          // Operational Footnote
          const Center(
            child: Text(
              'Tampilan operasional · Notifikasi persetujuan Admin disinkronisasi',
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

    // Warna & ikon berdasarkan status kendaraan
    final Color iconBg;
    final Color iconColor;
    final IconData iconData;
    final String detailTitle;
    final Color alertBg;
    final Color alertBorder;
    final Color alertIconColor;
    final String alertLabel;
    final String alertDesc;

    switch (notif.vehicleStatus) {
      case ValetVehicleStatus.akanDatang:
        iconBg = const Color(0xFF3D2E14);
        iconColor = const Color(0xFFE5A93C);
        iconData = Icons.directions_car_rounded;
        detailTitle = 'Detail Kedatangan Kendaraan';
        alertBg = const Color(0xFF3D2E14);
        alertBorder = const Color(0xFFE5A93C);
        alertIconColor = const Color(0xFFE5A93C);
        alertLabel = 'Kendaraan Tiba di Drop-off';
        alertDesc = 'Belum diparkir. Siapkan slot parkir yang tersedia.';
        break;
      case ValetVehicleStatus.terparkir:
        iconBg = AppColors.successGreenDark;
        iconColor = AppColors.successGreen;
        iconData = Icons.local_parking_rounded;
        detailTitle = 'Detail Parkir Kendaraan';
        alertBg = AppColors.successGreenDark;
        alertBorder = AppColors.successGreenBorder;
        alertIconColor = AppColors.successGreen;
        alertLabel = 'Kendaraan Berhasil Diparkir';
        alertDesc = 'Mobil sudah berada di slot. Kunci tersimpan aman.';
        break;
      case ValetVehicleStatus.mauDiambil:
        iconBg = const Color(0xFF0C2938);
        iconColor = const Color(0xFF38BDF8);
        iconData = Icons.key_rounded;
        detailTitle = 'Detail Permintaan Ambil';
        alertBg = const Color(0xFF0C2938);
        alertBorder = const Color(0xFF164E63);
        alertIconColor = const Color(0xFF38BDF8);
        alertLabel = 'Customer Meminta Kendaraan';
        alertDesc = 'Ambil kunci dan siapkan mobil di lobi pick-up.';
        break;
      case ValetVehicleStatus.sudahDiambil:
      case null:
        iconBg = AppColors.successGreenDark;
        iconColor = AppColors.successGreen;
        iconData = Icons.check_circle_rounded;
        detailTitle = 'Detail Selesai Keluar';
        alertBg = AppColors.successGreenDark;
        alertBorder = AppColors.successGreenBorder;
        alertIconColor = AppColors.successGreen;
        alertLabel = 'Kendaraan Selesai Keluar';
        alertDesc = 'Serah terima kunci selesai. Transaksi berhasil.';
        break;
    }

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
                  // Status Icon in Circle
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: iconBg,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        iconData,
                        color: iconColor,
                        size: 18,
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
                            Flexible(
                              child: Text(
                                notif.title,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
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
                              : 'Ketuk untuk melihat detail',
                          style: TextStyle(
                            color: iconColor.withValues(alpha: 0.8),
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

          // Detail Card (If Expanded)
          if (isExpanded) ...[
            const Divider(color: AppColors.divider, height: 1, thickness: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detailTitle,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Status Alert Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: alertBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: alertBorder, width: 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(iconData, color: alertIconColor, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alertLabel,
                                style: TextStyle(
                                  color: alertIconColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                alertDesc,
                                style: TextStyle(
                                  color: alertIconColor.withValues(alpha: 0.75),
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
                    'Petugas bertanggung jawab',
                    notif.ticket.officerName,
                  ),
                  const SizedBox(height: 9),
                  _buildDetailRow(
                    'Waktu',
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
                          style: TextStyle(
                            color: iconColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Footnote
                  const Text(
                    'Notifikasi ini otomatis dibuat dari perubahan status kendaraan.',
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

  Widget _buildSupabaseBanner(BuildContext context) {
    final isConnected = SupabaseService.instance.isConfigured;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: isConnected ? const Color(0xFF14241B) : const Color(0xFF1B1E26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isConnected
              ? AppColors.successGreen.withValues(alpha: 0.6)
              : AppColors.goldBorder.withValues(alpha: 0.5),
          width: 1.1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isConnected
                  ? AppColors.successGreenDark
                  : AppColors.goldDarkBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isConnected ? Icons.cloud_done_rounded : Icons.cloud_sync_rounded,
              size: 18,
              color: isConnected ? AppColors.successGreen : AppColors.goldPrimary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        isConnected
                            ? 'Supabase Realtime Terhubung'
                            : 'Database Realtime Supabase',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isConnected ? AppColors.successGreen : AppColors.goldPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isConnected ? AppColors.successGreen : AppColors.goldPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                Text(
                  isConnected
                      ? 'Notifikasi keluar dari Admin otomatis sinkron'
                      : 'Mode Lokal Aktif · Ketuk untuk atur kredensial',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _showSupabaseConfigDialog(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.tune_rounded, size: 14, color: AppColors.goldPrimary),
                  SizedBox(width: 4),
                  Text(
                    'Kelola',
                    style: TextStyle(
                      color: AppColors.goldPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSupabaseConfigDialog(BuildContext context) {
    final urlController = TextEditingController(text: SupabaseService.instance.url);
    final keyController = TextEditingController(text: SupabaseService.instance.anonKey);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      constraints: const BoxConstraints(maxWidth: 640),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final isConn = SupabaseService.instance.isConfigured;

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 22,
                  right: 22,
                  top: 16,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.goldBorder),
                            ),
                            child: const Icon(Icons.cloud_sync_rounded, color: AppColors.goldPrimary, size: 22),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Koneksi Database Supabase',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Sinkronisasi notifikasi Admin secara real-time',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: 14),

                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isConn ? AppColors.successGreenDark : const Color(0xFF262117),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isConn ? AppColors.successGreen : AppColors.goldBorder,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isConn ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                              size: 16,
                              color: isConn ? AppColors.successGreen : AppColors.goldPrimary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                isConn
                                    ? 'Status: Terhubung ke Supabase Cloud'
                                    : 'Status: Mode Realtime Lokal (Siap disambungkan)',
                                style: TextStyle(
                                  color: isConn ? AppColors.successGreen : AppColors.goldPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Input Supabase URL
                      const Text(
                        'Project URL Supabase:',
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: urlController,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'https://xxxx.supabase.co',
                          hintStyle: const TextStyle(color: AppColors.textSubtle, fontSize: 12.5),
                          filled: true,
                          fillColor: AppColors.card,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Input Anon Key
                      const Text(
                        'Anon Public Key:',
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: keyController,
                        obscureText: true,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
                          hintStyle: const TextStyle(color: AppColors.textSubtle, fontSize: 12.5),
                          filled: true,
                          fillColor: AppColors.card,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Button: Hubungkan
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.goldPrimary,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.link_rounded, size: 18),
                          label: const Text('Simpan & Hubungkan Supabase', style: TextStyle(fontWeight: FontWeight.w700)),
                          onPressed: () async {
                            final success = await SupabaseService.instance.initialize(
                              url: urlController.text,
                              anonKey: keyController.text,
                            );

                            setSheetState(() {});
                            setState(() {});

                            if (ctx.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? '✅ Berhasil terhubung ke Supabase Realtime!'
                                        : '⚠️ Masukkan Project URL & Anon Key yang valid.',
                                  ),
                                  backgroundColor: success ? const Color(0xFF14241B) : AppColors.card,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Button: Kirim Notifikasi Uji Coba Real-time
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.goldPrimary,
                            side: const BorderSide(color: AppColors.goldBorder),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.send_rounded, size: 16),
                          label: const Text('Kirim Uji Coba Notifikasi Real-time', style: TextStyle(fontWeight: FontWeight.w600)),
                          onPressed: () async {
                            final now = DateTime.now();
                            final timeStr = '${now.hour}.${now.minute.toString().padLeft(2, '0')} WIB';

                            final testNotif = OfficerNotification(
                              id: 'notif-${now.millisecondsSinceEpoch}',
                              title: 'Keluar Disetujui (Real-time)',
                              subtitle: 'B 1234 PAR · Aditya Wijaya',
                              time: timeStr,
                              authorInfo: 'Admin Dimas Pratama · Real-time Supabase',
                              ticket: VehicleTicket(
                                plateNumber: 'B 1234 PAR',
                                driverName: 'Aditya Wijaya',
                                ticketNumber: 'PV-081026-0248',
                                approvedBy: 'Admin Dimas Pratama',
                                approvalTime: timeStr,
                                isApproved: true,
                              ),
                            );

                            await SupabaseService.instance.sendNotification(testNotif);

                            if (ctx.mounted) {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('🔔 Notifikasi Real-time berhasil dikirim & disinkronisasi!'),
                                  backgroundColor: Color(0xFF14241B),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Button: Salin SQL Schema
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: TextButton.icon(
                          icon: const Icon(Icons.code_rounded, size: 16, color: AppColors.textSecondary),
                          label: const Text('Salin SQL Schema DDL ke Clipboard', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(text: SupabaseService.sqlSchema));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('📋 Skrip SQL DDL disalin ke clipboard! Jalankan di SQL Editor Supabase Anda.'),
                                backgroundColor: AppColors.card,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
