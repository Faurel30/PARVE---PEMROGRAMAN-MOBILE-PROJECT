import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/ticket_data.dart';

class VehicleInfoCard extends StatelessWidget {
  final VehicleTicket ticket;

  const VehicleInfoCard({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vehicle Header: Icon, Plate, Driver, Model
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Car Icon Container
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF262933),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.8), width: 1),
                ),
                child: const Center(
                  child: Icon(
                    Icons.directions_car_rounded,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Plate, Driver, Model
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.plateNumber,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ticket.driverName,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ticket.vehicleModel,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Divider
          const Divider(
            color: AppColors.divider,
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 14),

          // Detail rows
          _buildDetailRow('Tiket', ticket.ticketNumber, isMonospace: true),
          const SizedBox(height: 10),
          _buildDetailRow('Slot tercatat', ticket.slot),
          const SizedBox(height: 10),
          _buildDetailRow('Scan keluar', ticket.scanTime),
          const SizedBox(height: 10),
          _buildDetailRow('Petugas scan', ticket.officerName),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isMonospace = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.5,
            fontWeight: FontWeight.w400,
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
              fontFamily: isMonospace ? 'monospace' : null,
            ),
          ),
        ),
      ],
    );
  }
}
