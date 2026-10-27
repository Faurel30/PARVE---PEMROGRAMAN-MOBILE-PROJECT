import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/ticket_model.dart';
import 'vehicle_illustration.dart';

class TicketCard extends StatelessWidget {
  final ParkingTicket ticket;
  final VoidCallback? onVehicleTap;

  const TicketCard({
    super.key,
    required this.ticket,
    this.onVehicleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: AppColors.heroDark,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PARVE / TIKET DIGITAL',
                      style: TextStyle(
                        color: AppColors.goldText,
                        fontSize: 10.8,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.55,
                      ),
                    ),
                    Icon(
                      Icons.confirmation_number_outlined,
                      color: AppColors.goldText,
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  ticket.locationName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  ticket.ticketCode,
                  style: const TextStyle(
                    color: Color(0xFFA0A39E),
                    fontSize: 12.8,
                  ),
                ),
              ],
            ),
          ),
          if (ticket.isActive) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 18, 22),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/images/qr_code.png',
                      width: 82,
                      height: 82,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StatusBadge(text: ticket.statusText, isActive: true),
                        const SizedBox(height: 10),
                        Text(
                          'Tunjukkan tiket ini saat\nmengambil mobil.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12.6,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Kode contoh • jangan dibagikan',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Divider(
                height: 1,
                thickness: 1,
                color: AppColors.divider,
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 17, 18, 19),
            child: Column(
              children: [
                VehicleSummaryRow(
                  ticket: ticket,
                  onVehicleTap: onVehicleTap,
                  trailing: !ticket.isActive
                      ? StatusBadge(text: ticket.statusText, isActive: false)
                      : null,
                ),
                const SizedBox(height: 18),
                TicketDetailRow(label: 'Waktu masuk', value: ticket.entryTime),
                const SizedBox(height: 12),
                TicketDetailRow(
                  label: 'Area parkir',
                  value: ticket.parkingArea,
                ),
                const SizedBox(height: 12),
                TicketDetailRow(
                  label: 'Valet dibayar',
                  value: ticket.valetFee,
                  isHighlight: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VehicleSummaryRow extends StatelessWidget {
  final ParkingTicket ticket;
  final VoidCallback? onVehicleTap;
  final Widget? trailing;

  const VehicleSummaryRow({
    super.key,
    required this.ticket,
    this.onVehicleTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onVehicleTap,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: 88,
            height: 46,
            child: Center(
              child: AnimatedVehicleIllustration(
                sizeCategory: ticket.vehicleSize,
                colorName: ticket.vehicleSpecs,
                photoBytes: ticket.vehiclePhotoBytes,
                width: 84,
                height: 48,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ticket.vehicleName,
                style: TextStyle(
                  color: AppColors.darkPrimary,
                  fontSize: 15.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                ticket.plateNumber,
                style: TextStyle(
                  color: AppColors.darkPrimary,
                  fontSize: 13.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                ticket.vehicleSpecs,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12.2,
                ),
              ),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String text;
  final bool isActive;

  const StatusBadge({super.key, required this.text, this.isActive = true});

  @override
  Widget build(BuildContext context) {
    final fg = isActive ? AppColors.badgeGreen : AppColors.textSecondary;
    final bg = isActive ? AppColors.badgeBg : AppColors.surfaceSubtle;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5.5,
            height: 5.5,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: fg,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class TicketDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;

  const TicketDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13.2,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.darkPrimary,
            fontSize: isHighlight ? 14.8 : 13.2,
            fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
