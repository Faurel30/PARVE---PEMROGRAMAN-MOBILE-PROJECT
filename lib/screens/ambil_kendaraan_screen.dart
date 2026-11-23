import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../models/auth_store.dart';
import '../models/booking_models.dart';
import '../models/ticket_model.dart';
import '../widgets/booking_step_header.dart';
import '../widgets/midtrans_sandbox_sheet.dart';
import '../widgets/payment_method_dropdown.dart';
import '../widgets/ticket_card.dart';
import '../widgets/vehicle_illustration.dart';
import 'isi_saldo_screen.dart';
import 'konfirmasi_terima_mobil_screen.dart';

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
  late PaymentMethodOption _selectedMethod =
      PaymentMethodOption.parveWalletOption(AuthStore.formattedWalletBalance);
  Timer? _liveTimer;

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

  void _updateTicket(ParkingTicket updated) {
    setState(() => _ticket = updated);
    AuthStore.activeTicket = updated;
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

  Future<void> _finalizePickup({
    required int finalHours,
    required String paidFee,
    required String pickupHour,
  }) async {
    final remainingBalance = AuthStore.walletBalance;
    final frozenSecs = _ticket.liveElapsedSeconds;

    final updated = _ticket.copyWith(
      walletBalance: remainingBalance,
      parkingHours: finalHours,
      currentDuration: _ticket.liveDurationText,
      pickupTime: '$pickupHour WIB',
      frozenElapsedSeconds: frozenSecs,
      valetPaymentMethod: _selectedMethod.title,
      statusText: 'Siap di lobi',
      isActive: true,
      isPickupRequested: true,
      journeySteps: [
        ..._ticket.journeySteps,
        VehicleJourneyStep(
          title:
              'Permintaan ambil & bayar ($paidFee via ${_selectedMethod.shortName})',
          subtitle: _ticket.pickupLobby,
          time: pickupHour,
        ),
        VehicleJourneyStep(
          title: 'Mobil diantar ke ${_ticket.pickupLobby}',
          subtitle: 'Petugas ${_ticket.valetOfficerName}',
          time: pickupHour,
        ),
      ],
    );
    AuthStore.syncPickupRequestToSupabase(updated);
    setState(() => _ticket = updated);
    widget.onTicketUpdated?.call(updated);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KonfirmasiTerimaMobilScreen(
          ticket: updated,
          remainingBalanceAfterPay: remainingBalance,
          onTicketUpdated: widget.onTicketUpdated,
        ),
      ),
    );
  }

  Future<void> _processPaymentAndRequestCar() async {
    final finalHours = _ticket.accumulatedHours;
    final fee = _ticket.totalParkingFee;
    final paidFee = _ticket.formattedParkingFee;
    final now = DateTime.now();
    final pickupHour =
        '${now.hour.toString().padLeft(2, '0')}.${now.minute.toString().padLeft(2, '0')}';

    if (_selectedMethod.category == PaymentCategory.parveWallet) {
      final success = AuthStore.deductWallet(
        amount: fee,
        title: 'Parkir gedung ($finalHours jam)',
        subtitle: '${_ticket.locationName} • $pickupHour',
      );
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Saldo Dompet PARVE tidak cukup. Silakan isi saldo atau pilih metode pembayaran lain (QRIS / E-Wallet / Bank).',
            ),
            action: SnackBarAction(
              label: 'Isi saldo',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IsiSaldoScreen()),
                );
                if (mounted) {
                  setState(() {
                    _selectedMethod = PaymentMethodOption.parveWalletOption(
                      AuthStore.formattedWalletBalance,
                    );
                  });
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

      await _finalizePickup(
        finalHours: finalHours,
        paidFee: paidFee,
        pickupHour: pickupHour,
      );
      return;
    }

    await showMidtransSandboxSheet(
      context: context,
      method: _selectedMethod,
      amount: fee,
      description: 'Total pembayaran parkir gedung ($finalHours jam)',
      onConfirmed: () {
        _finalizePickup(
          finalHours: finalHours,
          paidFee: paidFee,
          pickupHour: pickupHour,
        );
      },
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
                        'Selesaikan pembayaran akumulasi parkir',
                        style: TextStyle(
                          color: AppColors.darkPrimary,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildPaymentSummaryCard(),
                      const SizedBox(height: 18),
                      Text(
                        'Metode pembayaran',
                        style: TextStyle(
                          color: AppColors.darkPrimary,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      PaymentMethodDropdown(
                        selected: _selectedMethod,
                        includeParveWallet: true,
                        onChanged: (val) =>
                            setState(() => _selectedMethod = val),
                      ),
                      const SizedBox(height: 14),
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
      child: Row(
        children: [
          const Icon(
            Icons.timer_outlined,
            color: AppColors.goldText,
            size: 26,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Siap dalam ±5 menit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Timer parkir: ${_ticket.liveStopwatchText} • Akumulasi ${_ticket.accumulatedHours} jam.',
                  style: const TextStyle(
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
    final accHours = _ticket.accumulatedHours;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        children: [
          TicketDetailRow(label: 'Waktu masuk', value: _ticket.shortEntryTime),
          const SizedBox(height: 11),
          TicketDetailRow(
            label: 'Timer durasi berjalan',
            value: '${_ticket.liveStopwatchText} (${_ticket.liveDurationText})',
          ),
          const SizedBox(height: 11),
          TicketDetailRow(
            label: 'Akumulasi parkir ($accHours jam × ${_ticket.formattedHourlyRate})',
            value: _ticket.formattedParkingFee,
          ),
          const SizedBox(height: 11),
          TicketDetailRow(
            label: 'Valet • sudah dibayar di awal',
            value: _ticket.valetFee,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Divider(height: 1, thickness: 1, color: AppColors.divider),
          ),
          TicketDetailRow(
            label: 'Total akumulasi parkir (Bayar sekarang)',
            value: _ticket.formattedParkingFee,
            isHighlight: true,
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
              'Biaya parkir dihitung berdasarkan akumulasi waktu berjalan (Rp5.000/jam, dibulatkan ke atas). '
              'Timer akan berhenti otomatis saat pembayaran dikonfirmasi.',
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
