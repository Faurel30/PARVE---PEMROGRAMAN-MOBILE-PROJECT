import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../models/auth_store.dart';
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
  ParkingTicket get _ticket => AuthStore.activeTicket;

  void _openPesanValet() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PesanValetScreen()),
    );
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
          'Jika pemesanan valet Anda hangus atau membutuhkan bantuan pengambilan mobil, '
          'hubungi petugas lobi Senayan City (Pintu Selatan).',
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
    final expiredTicket = t.copyWith(
      plateNumber: 'B 54311 TGO',
      vehicleSpecs: '${t.vehicleSpecs.split('•').first.trim()} • 2025',
    );
    final unreadCount = t.isPickupRequested ? 4 : 3;

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
                            'Hari ini, ${t.fullDate}',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12.0,
                            ),
                          ),
                          Text(
                            '$unreadCount baru',
                            style: TextStyle(
                              color: AppColors.navActive,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (t.isPickupRequested) ...[
                        _NotificationCard(
                          iconBg: AppColors.badgeBg,
                          iconColor: AppColors.badgeGreen,
                          icon: Icons.payments_outlined,
                          title: 'Pembayaran parkir berhasil',
                          description:
                              'Pembayaran parkir ${t.formattedParkingFee} (${t.parkingHours} jam) '
                              'untuk ${t.vehicleName} ${t.plateNumber} telah lunas. '
                              'Petugas (${t.valetOfficerName}) sedang mengantar mobil ke ${t.pickupLobby}.',
                          ticket: t,
                          metaLabel: 'Total dibayar (Valet + Parkir)',
                          metaValue: t.formattedGrandTotal,
                          buttonLabel: 'Lihat status pengantaran',
                          onButtonTap: _openPantau,
                        ),
                        const SizedBox(height: 16),
                      ],
                      _NotificationCard(
                        iconBg: AppColors.isDark
                            ? const Color(0xFF3A2320)
                            : const Color(0xFFF9ECEA),
                        iconColor: const Color(0xFFD06A5E),
                        icon: Icons.history_toggle_off_rounded,
                        title: 'Pemesanan valet hangus',
                        description:
                            'Batas waktu kedatangan telah terlewati. Pemesanan '
                            'valet Anda hangus dan tidak dapat digunakan lagi.',
                        showLocationBanner: true,
                        ticket: expiredTicket,
                        metaLabel: 'Jadwal kedatangan',
                        metaValue: '${t.entryTime} WIB',
                        buttonLabel: 'Pesan valet lagi',
                        onButtonTap: _openPesanValet,
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
                        icon: Icons.history_toggle_off_rounded,
                        title: 'Kendaraan diserahkan',
                        description:
                            '${t.vehicleName} ${t.plateNumber} berhasil diserahkan ke '
                            'valet. Silakan pantau proses parkir kendaraan Anda.',
                        ticket: t,
                        metaLabel: 'Waktu status',
                        metaValue: '${t.startHour} WIB • Durasi 0 menit',
                        buttonLabel: 'Pantau kendaraan',
                        onButtonTap: _openPantau,
                      ),
                      const SizedBox(height: 16),
                      _NotificationCard(
                        iconBg: AppColors.navPillBg,
                        iconColor: AppColors.navActive,
                        icon: Icons.history_toggle_off_rounded,
                        title: 'Terparkir aman',
                        description:
                            '${t.vehicleName} ${t.plateNumber} telah terparkir '
                            'aman di area ${t.parkingArea}. Anda dapat melanjutkan '
                            'aktivitas sambil memantau atau mengambil kendaraan.',
                        ticket: t,
                        metaLabel: 'Area & tarif berjalan',
                        metaValue: '${t.shortSlot} • ${t.formattedParkingFee}',
                        buttonLabel: 'Ambil & bayar parkir',
                        onButtonTap: _openAmbil,
                      ),
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
                'assets/images/senayan_city.png',
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
