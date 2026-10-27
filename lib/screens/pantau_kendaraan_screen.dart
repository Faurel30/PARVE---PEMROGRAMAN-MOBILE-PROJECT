import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../models/ticket_model.dart';
import '../widgets/booking_step_header.dart';
import '../widgets/ticket_card.dart';
import '../widgets/vehicle_illustration.dart';
import 'ambil_kendaraan_screen.dart';

class PantauKendaraanScreen extends StatefulWidget {
  final ParkingTicket ticket;
  final ValueChanged<ParkingTicket>? onTicketUpdated;

  const PantauKendaraanScreen({
    super.key,
    required this.ticket,
    this.onTicketUpdated,
  });

  @override
  State<PantauKendaraanScreen> createState() => _PantauKendaraanScreenState();
}

class _PantauKendaraanScreenState extends State<PantauKendaraanScreen> {
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

  void _showContactOfficerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hubungi ${_ticket.valetOfficerName}',
              style: TextStyle(
                color: AppColors.darkPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Petugas valet terverifikasi untuk tiket ${_ticket.ticketCode} '
              '(${_ticket.vehicleName} • ${_ticket.plateNumber}).',
              style: TextStyle(color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.goldButton,
                  foregroundColor: AppColors.onGold,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.call_outlined, size: 18),
                label: const Text('Panggilan Suara Dalam Aplikasi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAmbilKendaraan() async {
    final updated = await Navigator.push<ParkingTicket>(
      context,
      MaterialPageRoute(
        builder: (context) => AmbilKendaraanScreen(
          ticket: _ticket,
          onTicketUpdated: _updateTicket,
        ),
      ),
    );
    if (updated != null && mounted) {
      _updateTicket(updated);
    }
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
                        title: 'Pantau kendaraan',
                        onBack: () => Navigator.pop(context, _ticket),
                      ),
                      const SizedBox(height: 16),
                      _buildStatusHeaderRow(),
                      const SizedBox(height: 12),
                      _buildParkingMapCard(),
                      const SizedBox(height: 14),
                      _buildVehicleLocationCard(),
                      const SizedBox(height: 18),
                      Text(
                        'Perjalanan kendaraan',
                        style: TextStyle(
                          color: AppColors.darkPrimary,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildJourneyCard(),
                      const SizedBox(height: 12),
                      _buildOfficerCard(),
                    ],
                  ),
                ),
              ),
              BookingStickyBottomBar(
                icon: Icons.directions_car_outlined,
                label: 'Ambil kendaraan',
                onTap: _openAmbilKendaraan,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatusBadge(text: _ticket.statusText, isActive: true),
        Text(
          _ticket.lastUpdated,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 11.5,
          ),
        ),
      ],
    );
  }

  Widget _buildParkingMapCard() {
    final mapBg = AppColors.isDark
        ? const Color(0xFF232722)
        : const Color(0xFFEAECE6);
    final roadColor = AppColors.isDark
        ? const Color(0xFF333831)
        : Colors.white.withValues(alpha: 0.85);
    final buildingBg = AppColors.isDark
        ? const Color(0xFF2E332D)
        : const Color(0xFFDCDFD7);

    return Container(
      height: 168,
      decoration: BoxDecoration(
        color: mapBg,
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: 38,
            left: 0,
            right: 0,
            height: 16,
            child: Container(color: roadColor),
          ),
          Positioned(
            bottom: 22,
            left: 0,
            right: 0,
            height: 14,
            child: Container(color: roadColor),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 84,
            width: 18,
            child: Container(color: roadColor),
          ),
          Positioned(
            top: 66,
            left: 22,
            width: 148,
            height: 54,
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: buildingBg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Text(
                _ticket.locationName.toUpperCase(),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.8,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Denah area parkir',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: 98,
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFF20231F),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.directions_car_outlined,
                    color: AppColors.goldText,
                    size: 21,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _ticket.shortSlot.replaceAll(' ', ' • '),
                    style: TextStyle(
                      color: AppColors.darkPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleLocationCard() {
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
          TicketDetailRow(
            label: 'Lokasi',
            value: '${_ticket.locationName} • ${_ticket.shortSlot}',
          ),
          const SizedBox(height: 11),
          TicketDetailRow(
            label: 'Durasi saat ini',
            value: _ticket.currentDuration,
            isHighlight: true,
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        children: List.generate(_ticket.journeySteps.length, (index) {
          final step = _ticket.journeySteps[index];
          return Padding(
            padding: EdgeInsets.only(top: index == 0 ? 0 : 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: AppColors.badgeBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 14,
                    color: AppColors.badgeGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style: TextStyle(
                          color: AppColors.darkPrimary,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step.subtitle,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11.8,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  step.time,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.2,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOfficerCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              Icons.how_to_reg_outlined,
              color: AppColors.darkPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _ticket.valetOfficerName,
                  style: TextStyle(
                    color: AppColors.darkPrimary,
                    fontSize: 13.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Petugas valet Anda • Identitas terverifikasi',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11.2,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _showContactOfficerSheet,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Text(
                'Hubungi',
                style: TextStyle(
                  color: AppColors.navActive,
                  fontSize: 12.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
