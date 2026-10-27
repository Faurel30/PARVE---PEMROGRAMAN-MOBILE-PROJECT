import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../models/auth_store.dart';
import '../models/booking_models.dart';
import '../widgets/booking_step_header.dart';
import '../widgets/ticket_card.dart';
import '../widgets/vehicle_illustration.dart';
import 'kendaraan_saya_screen.dart';
import 'konfirmasi_bayar_screen.dart';

class PesanValetScreen extends StatefulWidget {
  const PesanValetScreen({super.key});

  @override
  State<PesanValetScreen> createState() => _PesanValetScreenState();
}

class _PesanValetScreenState extends State<PesanValetScreen> {
  ValetLocation _selectedLocation = ValetLocation.presets.first;
  late String _selectedVehicleId = AuthStore.primaryVehicle.id;
  String _arrivalHour = '13.00';

  SavedVehicle get _selectedVehicle {
    return AuthStore.savedVehicles.firstWhere(
      (v) => v.id == _selectedVehicleId,
      orElse: () => AuthStore.primaryVehicle,
    );
  }

  void _pickLocation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Text(
                  'Pilih Lokasi Valet',
                  style: TextStyle(
                    color: AppColors.darkPrimary,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              for (final loc in ValetLocation.presets)
                ListTile(
                  leading: Icon(
                    Icons.location_on_outlined,
                    color: AppColors.navActive,
                  ),
                  title: Text(
                    loc.name,
                    style: TextStyle(
                      color: AppColors.darkPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    loc.lobbySubtitle,
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                  trailing: loc.id == _selectedLocation.id
                      ? Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.navActive,
                        )
                      : null,
                  onTap: () {
                    setState(() => _selectedLocation = loc);
                    Navigator.pop(ctx);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickOrManageVehicle() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Pilih Kendaraan',
                style: TextStyle(
                  color: AppColors.darkPrimary,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              for (final veh in AuthStore.savedVehicles)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.directions_car_outlined,
                    color: AppColors.navActive,
                  ),
                  title: Text(
                    '${veh.name} (${veh.plateNumber})',
                    style: TextStyle(
                      color: AppColors.darkPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    veh.specs,
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                  trailing: veh.id == _selectedVehicle.id
                      ? Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.navActive,
                        )
                      : null,
                  onTap: () {
                    setState(() => _selectedVehicleId = veh.id);
                    Navigator.pop(ctx);
                  },
                ),
              Divider(height: 18, color: AppColors.divider),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.darkPrimary,
                  side: BorderSide(color: AppColors.cardBorder),
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(ctx);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const KendaraanSayaScreen(),
                    ),
                  );
                  if (mounted) {
                    setState(() {
                      _selectedVehicleId = AuthStore.primaryVehicle.id;
                    });
                  }
                },
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Kelola / Upload Foto Kendaraan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickArrivalTime() {
    const slots = ['11.00', '13.00', '14.30', '16.00', '19.00'];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Text(
                  'Pilih Jadwal Kedatangan (Hari ini, 8 Okt)',
                  style: TextStyle(
                    color: AppColors.darkPrimary,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              for (final slot in slots)
                ListTile(
                  leading: Icon(
                    Icons.access_time_rounded,
                    color: AppColors.navActive,
                  ),
                  title: Text(
                    'Hari ini, 8 Okt • $slot WIB',
                    style: TextStyle(color: AppColors.darkPrimary),
                  ),
                  trailing: slot == _arrivalHour
                      ? Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.navActive,
                        )
                      : null,
                  onTap: () {
                    setState(() => _arrivalHour = slot);
                    Navigator.pop(ctx);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KonfirmasiBayarScreen(
          location: _selectedLocation,
          vehicle: _selectedVehicle,
          arrivalDateLabel: '8 Okt 2026',
          arrivalHour: _arrivalHour,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = _selectedVehicle;

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
                      const BookingTopBar(title: 'Pesan valet'),
                      const SizedBox(height: 18),
                      const BookingStepIndicator(currentStep: 1),
                      const SizedBox(height: 14),
                      _buildLocationCard(),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Kendaraan Anda',
                            style: TextStyle(
                              color: AppColors.darkPrimary,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          GestureDetector(
                            onTap: _pickOrManageVehicle,
                            child: Text(
                              'Ganti',
                              style: TextStyle(
                                color: AppColors.navActive,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildVehicleCard(vehicle),
                      const SizedBox(height: 18),
                      Text(
                        'Waktu kedatangan',
                        style: TextStyle(
                          color: AppColors.darkPrimary,
                          fontSize: 12.8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildArrivalTimeField(),
                      const SizedBox(height: 16),
                      _buildTariffSummaryCard(),
                    ],
                  ),
                ),
              ),
              BookingStickyBottomBar(
                icon: Icons.arrow_forward_rounded,
                label: 'Lanjut ke pembayaran',
                onTap: _goToPayment,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              'assets/images/senayan_city.png',
              height: 136,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 13),
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
                      _selectedLocation.name,
                      style: TextStyle(
                        color: AppColors.darkPrimary,
                        fontSize: 15.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _selectedLocation.lobbySubtitle,
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
          const SizedBox(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const StatusBadge(text: 'Valet tersedia', isActive: true),
              GestureDetector(
                onTap: _pickLocation,
                child: Text(
                  'Ganti lokasi',
                  style: TextStyle(
                    color: AppColors.navActive,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(SavedVehicle vehicle) {
    return GestureDetector(
      onTap: _pickOrManageVehicle,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder, width: 1.2),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 88,
              height: 48,
              child: Center(
                child: AnimatedVehicleIllustration(
                  photoBytes: vehicle.photoBytes,
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
                    vehicle.name,
                    style: TextStyle(
                      color: AppColors.darkPrimary,
                      fontSize: 15.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    vehicle.plateNumber,
                    style: TextStyle(
                      color: AppColors.darkPrimary,
                      fontSize: 13.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    vehicle.specs,
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
      ),
    );
  }

  Widget _buildArrivalTimeField() {
    return GestureDetector(
      onTap: _pickArrivalTime,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder, width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Hari ini, 8 Okt • $_arrivalHour WIB',
              style: TextStyle(
                color: AppColors.darkPrimary,
                fontSize: 13.8,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.calendar_today_outlined,
              color: AppColors.textMuted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTariffSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TicketDetailRow(
            label: 'Layanan valet',
            value: 'Rp35.000',
            isHighlight: true,
          ),
          const SizedBox(height: 11),
          const TicketDetailRow(label: 'Parkir gedung', value: 'Rp5.000 / jam'),
          const SizedBox(height: 10),
          Text(
            'Parkir dihitung per jam, dibulatkan ke atas.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 11.4),
          ),
        ],
      ),
    );
  }
}
