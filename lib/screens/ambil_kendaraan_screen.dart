import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../models/auth_store.dart';
import '../models/ticket_model.dart';
import '../widgets/booking_step_header.dart';
import '../widgets/ticket_card.dart';
import '../widgets/vehicle_illustration.dart';
import 'isi_saldo_screen.dart';
import 'pengambilan_selesai_screen.dart';

class AmbilKendaraanScreen extends StatefulWidget {
  final ParkingTicket ticket;
  final ValueChanged<ParkingTicket>? onTicketUpdated;

  const AmbilKendaraanScreen({
    super.key,
    required this.ticket,
    this.onTicketUpdated,
  });

  @override
  State<AmbilKendaraanScreen> createState() => _AmbilKendaraanScreenState();
}

class _AmbilKendaraanScreenState extends State<AmbilKendaraanScreen> {
  late ParkingTicket _ticket = widget.ticket;

  void _updateTicket(ParkingTicket updated) {
    setState(() => _ticket = updated);
    widget.onTicketUpdated?.call(updated);
  }

  void _cycleVehicleCategory() {
    final nextSize = switch (_ticket.vehicleSize) {
      VehicleSize.large => VehicleSize.small,
      VehicleSize.small => VehicleSize.medium,
      VehicleSize.medium => VehicleSize.large,
    };
    final preset = ParkingTicket.vehiclePresets[nextSize]!;
    _updateTicket(
      _ticket.copyWith(
        vehicleSize: nextSize,
        vehicleName: preset.name,
        vehicleSpecs: preset.specs,
      ),
    );
  }

  void _cycleParkingHours() {
    final nextHours = (_ticket.parkingHours % 5) + 1;
    final endHour = 13 + nextHours - 1;
    _updateTicket(
      _ticket.copyWith(
        parkingHours: nextHours,
        pickupTime: '$endHour.55 WIB',
        currentDuration: '$nextHours jam',
      ),
    );
  }

  Future<void> _processPaymentAndRequestCar() async {
    final fee = _ticket.totalParkingFee;
    final paidFee = _ticket.formattedParkingFee;
    final pickupHour = _ticket.pickupTime.replaceAll(' WIB', '');

    final success = AuthStore.deductWallet(
      amount: fee,
      title: 'Parkir gedung',
      subtitle: '${_ticket.locationName} • $pickupHour',
    );
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Saldo Dompet PARVE tidak cukup untuk membayar parkir.',
          ),
          action: SnackBarAction(
            label: 'Isi saldo',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const IsiSaldoScreen()),
              );
              if (mounted) {
                _updateTicket(
                  _ticket.copyWith(walletBalance: AuthStore.walletBalance),
                );
              }
            },
          ),
        ),
      );
      return;
    }

    final remainingBalance = AuthStore.walletBalance;
    final updated = _ticket.copyWith(
      walletBalance: remainingBalance,
      statusText: 'Diantar ke lobi',
      isPickupRequested: true,
      journeySteps: [
        ..._ticket.journeySteps,
        VehicleJourneyStep(
          title: 'Permintaan ambil & bayar ($paidFee)',
          subtitle: _ticket.pickupLobby,
          time: pickupHour,
        ),
      ],
    );
    _updateTicket(updated);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PengambilanSelesaiScreen(
          ticket: updated,
          remainingBalanceAfterPay: remainingBalance,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppColors.pageOverlayStyle,
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(21, 12, 21, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BookingTopBar(
                        title: 'Ambil kendaraan',
                        onBack: () => Navigator.pop(context, _ticket),
                      ),
                      const SizedBox(height: 16),
                      _buildEtaBannerCard(),
                      const SizedBox(height: 14),
                      _buildVehicleAndLobbyCard(),
                      const SizedBox(height: 18),
                      Text(
                        'Selesaikan pembayaran parkir',
                        style: TextStyle(
                          color: AppColors.darkPrimary,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildPaymentSummaryCard(),
                      const SizedBox(height: 12),
                      _buildWalletMethodCard(),
                      const SizedBox(height: 12),
                      _buildInfoNoticeCard(),
                    ],
                  ),
                ),
              ),
              _buildBottomPayBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEtaBannerCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.heroDark,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.timer_outlined,
            color: AppColors.goldText,
            size: 26,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Siap dalam ±5 menit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Petugas mengantar mobil ke lobi utama.',
                  style: TextStyle(
                    color: Color(0xFFA0A39E),
                    fontSize: 12.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleAndLobbyCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        children: [
          VehicleSummaryRow(
            ticket: _ticket,
            onVehicleTap: _cycleVehicleCategory,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, thickness: 1, color: AppColors.divider),
          ),
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.navPillBg,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.navActive,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _ticket.locationName,
                      style: TextStyle(
                        color: AppColors.darkPrimary,
                        fontSize: 14.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _ticket.pickupLobby,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummaryCard() {
    return GestureDetector(
      onTap: _cycleParkingHours,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder, width: 1.2),
        ),
        child: Column(
          children: [
            TicketDetailRow(label: 'Masuk', value: _ticket.shortEntryTime),
            const SizedBox(height: 11),
            TicketDetailRow(
              label: 'Permintaan pengambilan',
              value: _ticket.pickupTime,
            ),
            const SizedBox(height: 11),
            TicketDetailRow(
              label:
                  'Parkir ${_ticket.parkingHours} jam × ${_ticket.formattedHourlyRate}',
              value: _ticket.formattedParkingFee,
            ),
            const SizedBox(height: 11),
            TicketDetailRow(
              label: 'Valet • sudah dibayar',
              value: _ticket.valetFee,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Divider(height: 1, thickness: 1, color: AppColors.divider),
            ),
            TicketDetailRow(
              label: 'Bayar sekarang',
              value: _ticket.formattedParkingFee,
              isHighlight: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletMethodCard() {
    final currentWallet = AuthStore.walletBalance;
    final afterPay = currentWallet - _ticket.totalParkingFee;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Row(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            color: AppColors.navActive,
            size: 21,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dompet PARVE • ${ParkingTicket.formatRupiah(currentWallet)}',
                  style: TextStyle(
                    color: AppColors.darkPrimary,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Saldo setelah bayar ${ParkingTicket.formatRupiah(afterPay < 0 ? 0 : afterPay)}',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11.4,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.badgeGreen,
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoNoticeCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.softGoldBanner,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(
              Icons.info_outline_rounded,
              color: AppColors.navActive,
              size: 18,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              'Pastikan Anda sudah menuju lobi. Siapkan tiket digital; '
              'petugas akan memverifikasi sebelum menyerahkan mobil.',
              style: TextStyle(
                color: AppColors.navActive,
                fontSize: 11.6,
                height: 1.38,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPayBar() {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      padding: EdgeInsets.fromLTRB(
        21,
        12,
        21,
        bottomPadding > 0 ? bottomPadding + 8 : 14,
      ),
      child: Material(
        color: AppColors.goldButton,
        borderRadius: BorderRadius.circular(11),
        child: InkWell(
          onTap: _processPaymentAndRequestCar,
          borderRadius: BorderRadius.circular(11),
          child: SizedBox(
            height: 49,
            child: Center(
              child: Text(
                'Bayar ${_ticket.formattedParkingFee} & minta mobil',
                style: const TextStyle(
                  color: AppColors.onGold,
                  fontSize: 14.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
