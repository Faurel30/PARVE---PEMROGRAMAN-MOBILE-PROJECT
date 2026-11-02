import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../models/auth_store.dart';
import '../models/booking_models.dart';
import '../models/ticket_model.dart';
import '../widgets/booking_step_header.dart';
import '../widgets/ticket_card.dart';
import 'ambil_kendaraan_screen.dart';
import 'pantau_kendaraan_screen.dart';
import 'pesan_valet_screen.dart';

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  Timer? _liveTimer;

  ParkingTicket get _ticket => AuthStore.activeTicket;

  @override
  void initState() {
    super.initState();
    _liveTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _ticket.frozenElapsedSeconds == null) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _liveTimer?.cancel();
    super.dispose();
  }

  Future<void> _openPantau() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PantauKendaraanScreen(
          ticket: _ticket,
          onTicketUpdated: (updated) {
            if (mounted) {
              setState(() => AuthStore.activeTicket = updated);
            }
          },
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _openAmbil() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AmbilKendaraanScreen(
          ticket: _ticket,
          onTicketUpdated: (updated) {
            if (mounted) {
              setState(() => AuthStore.activeTicket = updated);
            }
          },
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  void _showHelpCenterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Pusat Bantuan PARVE',
          style: TextStyle(color: AppColors.darkPrimary),
        ),
        content: Text(
          'Jika membutuhkan bantuan pemantauan atau pengambilan mobil, '
          'hubungi petugas valet lobi ${_ticket.locationName} (${_ticket.pickupLobby}).',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = _ticket;
    final hasSessionNotifications = AuthStore.hasBookedOnce || t.isActive;
    final unreadCount = !hasSessionNotifications
        ? 0
        : (t.isPickupRequested ? 4 : 3);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppColors.pageOverlayStyle,
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(21, 12, 21, 10),
                child: BookingTopBar(title: 'Notifikasi'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(21, 6, 21, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hari ini, ${AuthStore.formatRealTimeFullDate()}',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12.0,
                            ),
                          ),
                          Text(
                            unreadCount > 0 ? '$unreadCount baru' : '0 baru',
                            style: TextStyle(
                              color: AppColors.navActive,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (!hasSessionNotifications) ...[
                        _buildEmptyNotificationsCard(),
                      ] else ...[
                        if (t.isPickupRequested) ...[
                          _NotificationCard(
                            iconBg: AppColors.badgeBg,
                            iconColor: AppColors.badgeGreen,
                            icon: Icons.verified_rounded,
                            title: 'Pembayaran parkir berhasil',
                            description:
                                'Tagihan parkir sebesar ${t.formattedParkingFee} (${t.accumulatedHours} jam) '
                                'untuk ${t.vehicleName} ${t.plateNumber} telah lunas. '
                                'Petugas valet (${t.valetOfficerName}) sedang mengantar kendaraan Anda ke ${t.pickupLobby}.',
                            ticket: t,
                            metaLabel: 'Total transaksi selesai',
                            metaValue: t.formattedGrandTotal,
                            buttonLabel: 'Lihat status kendaraan',
                            onButtonTap: _openPantau,
                          ),
                          const SizedBox(height: 16),
                        ],
                        _NotificationCard(
                          iconBg: AppColors.navPillBg,
                          iconColor: AppColors.navActive,
                          icon: Icons.timer_outlined,
                          title: t.isActive
                              ? 'Sesi parkir sedang berlangsung'
                              : 'Sesi parkir telah selesai',
                          description: t.isActive
                              ? 'Durasi parkir untuk ${t.vehicleName} ${t.plateNumber} tercatat '
                                  'secara otomatis (${t.liveStopwatchText}). Tarif parkir gedung berlaku '
                                  '${t.formattedHourlyRate}/jam dan dibayarkan saat pengambilan kendaraan.'
                              : 'Sesi parkir untuk ${t.vehicleName} ${t.plateNumber} di ${t.locationName} '
                                  'telah selesai dengan durasi akhir ${t.liveStopwatchText} (${t.accumulatedHours} jam).',
                          showLocationBanner: true,
                          ticket: t,
                          metaLabel:
                              'Durasi & biaya parkir (${t.accumulatedHours} jam)',
                          metaValue:
                              '${t.liveStopwatchText} • ${t.formattedParkingFee}',
                          buttonLabel: t.isActive
                              ? 'Ambil kendaraan'
                              : 'Lihat detail perjalanan',
                          onButtonTap: t.isActive ? _openAmbil : _openPantau,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Butuh bantuan?',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12.0,
                              ),
                            ),
                            GestureDetector(
                              onTap: _showHelpCenterDialog,
                              child: Text(
                                'Pusat bantuan',
                                style: TextStyle(
                                  color: AppColors.navActive,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _NotificationCard(
                          iconBg: AppColors.navPillBg,
                          iconColor: AppColors.navActive,
                          icon: Icons.verified_user_outlined,
                          title: 'Kendaraan terparkir aman',
                          description:
                              '${t.vehicleName} ${t.plateNumber} telah terparkir '
                              'dengan aman di area ${t.parkingArea}. Anda dapat beraktivitas '
                              'dengan tenang dan memantau status kendaraan kapan saja.',
                          ticket: t,
                          metaLabel: 'Lokasi slot & tarif gedung',
                          metaValue:
                              '${t.shortSlot} • ${t.formattedHourlyRate}/jam',
                          buttonLabel: 'Pantau kendaraan',
                          onButtonTap: _openPantau,
                        ),
                        const SizedBox(height: 16),
                        _NotificationCard(
                          iconBg: AppColors.navPillBg,
                          iconColor: AppColors.navActive,
                          icon: Icons.directions_car_outlined,
                          title: 'Kendaraan diterima petugas valet',
                          description:
                              '${t.vehicleName} ${t.plateNumber} telah diserahkan kepada '
                              'petugas valet resmi (${t.valetOfficerName}). Pembayaran layanan valet sebesar ${t.valetFee} telah dikonfirmasi.',
                          ticket: t,
                          metaLabel: 'Waktu serah terima',
                          metaValue: '${t.startHour} WIB • Valet ${t.valetFee}',
                          buttonLabel: 'Pantau kendaraan',
                          onButtonTap: _openPantau,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyNotificationsCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 34, 22, 28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.navPillBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              color: AppColors.navActive,
              size: 27,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada notifikasi layanan',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.darkPrimary,
              fontSize: 17.2,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Notifikasi penerimaan kendaraan, sesi parkir berjalan, dan bukti pembayaran akan muncul secara otomatis setelah Anda memesan layanan valet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 22),
          Material(
            color: AppColors.goldButton,
            borderRadius: BorderRadius.circular(11),
            child: InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PesanValetScreen()),
                );
                if (mounted) setState(() {});
              },
              borderRadius: BorderRadius.circular(11),
              child: const SizedBox(
                height: 47,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_car_outlined,
                      size: 18,
                      color: AppColors.onGold,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Pesan valet sekarang',
                      style: TextStyle(
                        color: AppColors.onGold,
                        fontSize: 13.8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String title;
  final String description;
  final bool showLocationBanner;
  final ParkingTicket ticket;
  final String metaLabel;
  final String metaValue;
  final String buttonLabel;
  final VoidCallback onButtonTap;

  const _NotificationCard({
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.description,
    this.showLocationBanner = false,
    required this.ticket,
    required this.metaLabel,
    required this.metaValue,
    required this.buttonLabel,
    required this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Text(
                '• Baru',
                style: TextStyle(
                  color: AppColors.navActive,
                  fontSize: 11.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: TextStyle(
              color: AppColors.darkPrimary,
              fontSize: 17.5,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.6,
              height: 1.4,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, thickness: 1, color: AppColors.divider),
          ),
          if (showLocationBanner) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Image.asset(
                ValetLocation.imageAssetForMallName(ticket.locationName),
                height: 118,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.navPillBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: AppColors.navActive,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.locationName,
                        style: TextStyle(
                          color: AppColors.darkPrimary,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ticket.pickupLobby,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
          ],
          VehicleSummaryRow(ticket: ticket),
          const SizedBox(height: 14),
          TicketDetailRow(label: metaLabel, value: metaValue),
          const SizedBox(height: 14),
          Material(
            color: AppColors.goldButton,
            borderRadius: BorderRadius.circular(11),
            child: InkWell(
              onTap: onButtonTap,
              borderRadius: BorderRadius.circular(11),
              child: SizedBox(
                height: 46,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: AppColors.onGold,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      buttonLabel,
                      style: const TextStyle(
                        color: AppColors.onGold,
                        fontSize: 13.8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
