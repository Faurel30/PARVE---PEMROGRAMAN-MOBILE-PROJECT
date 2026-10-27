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
import 'aktivitas_screen.dart';
import 'isi_saldo_screen.dart';

class KonfirmasiBayarScreen extends StatefulWidget {
  final ValetLocation location;
  final SavedVehicle vehicle;
  final String arrivalDateLabel;
  final String arrivalHour;

  const KonfirmasiBayarScreen({
    super.key,
    required this.location,
    required this.vehicle,
    required this.arrivalDateLabel,
    required this.arrivalHour,
  });

  @override
  State<KonfirmasiBayarScreen> createState() => _KonfirmasiBayarScreenState();
}

class _KonfirmasiBayarScreenState extends State<KonfirmasiBayarScreen> {
  static const int _valetFee = 35000;

  late PaymentMethodOption _selectedMethod =
      PaymentMethodOption.parveWalletOption(AuthStore.formattedWalletBalance);

  void _finalizeBooking() {
    final startH = int.tryParse(widget.arrivalHour.split('.').first) ?? 13;
    final parkedMin = '${widget.arrivalHour.split('.').first}.08';

    AuthStore.activeTicket = AuthStore.activeTicket.copyWith(
      locationName: widget.location.name,
      pickupLobby: widget.location.lobbySubtitle,
      vehicleName: widget.vehicle.name,
      plateNumber: widget.vehicle.plateNumber,
      vehicleSpecs: widget.vehicle.specs,
      vehiclePhotoBytes: widget.vehicle.photoBytes,
      entryTime: '${widget.arrivalDateLabel} • ${widget.arrivalHour}',
      shortEntryTime: '8 Okt • ${widget.arrivalHour}',
      startHour: widget.arrivalHour,
      pickupTime: '${startH + 1}.55 WIB',
      parkingHours: 2,
      walletBalance: AuthStore.walletBalance,
      statusText: 'Terparkir aman',
      valetPaymentMethod: _selectedMethod.title,
      isActive: true,
      isPickupRequested: false,
      journeySteps: [
        VehicleJourneyStep(
          title: 'Diserahkan ke petugas',
          subtitle: widget.location.lobbySubtitle,
          time: widget.arrivalHour,
        ),
        VehicleJourneyStep(
          title: 'Terparkir aman',
          subtitle: widget.location.parkingArea,
          time: parkedMin,
        ),
      ],
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: '/aktivitas'),
        builder: (_) => const AktivitasScreen(),
      ),
      (_) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pembayaran valet Rp35.000 via ${_selectedMethod.title} berhasil!',
        ),
      ),
    );
  }

  Future<void> _handlePayValet() async {
    if (_selectedMethod.category == PaymentCategory.parveWallet) {
      final ok = AuthStore.deductWallet(
        amount: _valetFee,
        title: 'Layanan valet',
        subtitle: '${widget.location.name} • ${widget.arrivalHour}',
      );
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Saldo Dompet PARVE tidak mencukupi. Silakan isi saldo atau pilih metode lain.',
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
                }
              },
            ),
          ),
        );
        return;
      }
      _finalizeBooking();
      return;
    }

    await showMidtransSandboxSheet(
      context: context,
      method: _selectedMethod,
      amount: _valetFee,
      description: 'Total tagihan layanan valet sekarang',
      onConfirmed: _finalizeBooking,
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
                  padding: const EdgeInsets.fromLTRB(21, 12, 21, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const BookingTopBar(title: 'Konfirmasi & bayar'),
                      const SizedBox(height: 18),
                      const BookingStepIndicator(currentStep: 2),
                      const SizedBox(height: 14),
                      _buildBookingSummaryCard(),
                      const SizedBox(height: 20),
                      Text(
                        'Rincian biaya',
                        style: TextStyle(
                          color: AppColors.darkPrimary,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildCostBreakdownCard(),
                      const SizedBox(height: 20),
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
                      _buildDeductionInfoBanner(),
                    ],
                  ),
                ),
              ),
              BookingStickyBottomBar(
                icon: Icons.lock_outline_rounded,
                label: 'Bayar valet · Rp35.000',
                onTap: _handlePayValet,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingSummaryCard() {
    final v = widget.vehicle;
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
                      widget.location.name,
                      style: TextStyle(
                        color: AppColors.darkPrimary,
                        fontSize: 15.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.location.lobbySubtitle,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, thickness: 1, color: AppColors.divider),
          ),
          Row(
            children: [
              SizedBox(
                width: 88,
                height: 48,
                child: Center(
                  child: AnimatedVehicleIllustration(
                    photoBytes: v.photoBytes,
                    width: 84,
                    height: 48,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v.name,
                      style: TextStyle(
                        color: AppColors.darkPrimary,
                        fontSize: 15.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      v.plateNumber,
                      style: TextStyle(
                        color: AppColors.darkPrimary,
                        fontSize: 13.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      v.specs,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TicketDetailRow(
            label: 'Kedatangan',
            value: '${widget.arrivalDateLabel} • ${widget.arrivalHour}',
          ),
        ],
      ),
    );
  }

  Widget _buildCostBreakdownCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TicketDetailRow(
            label: 'Valet (dibayar sekarang)',
            value: 'Rp35.000',
          ),
          const SizedBox(height: 11),
          const TicketDetailRow(label: 'Estimasi parkir 2 jam', value: 'Rp10.000'),
          const SizedBox(height: 11),
          const TicketDetailRow(label: 'Biaya layanan', value: 'Rp0'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Divider(height: 1, thickness: 1, color: AppColors.divider),
          ),
          const TicketDetailRow(
            label: 'Estimasi total',
            value: 'Rp45.000',
            isHighlight: true,
          ),
          const SizedBox(height: 8),
          Text(
            'Parkir Rp5.000/jam, dibulatkan ke atas.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 11.4),
          ),
        ],
      ),
    );
  }

  Widget _buildDeductionInfoBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
              size: 17,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Rp35.000 dipotong sekarang. Biaya parkir dibayar '
              'saat pengambilan sesuai durasi aktual.',
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
}
