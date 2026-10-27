import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/booking_models.dart';
import '../models/ticket_model.dart';

Future<void> showMidtransSandboxSheet({
  required BuildContext context,
  required PaymentMethodOption method,
  required int amount,
  required String description,
  required VoidCallback onConfirmed,
}) {
  final formattedAmount = ParkingTicket.formatRupiah(amount);

  return showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(21, 18, 21, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.navPillBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'MIDTRANS SANDBOX • ${method.midtransPaymentType.toUpperCase()}',
                    style: TextStyle(
                      color: AppColors.navActive,
                      fontSize: 10.8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: AppColors.darkPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Pembayaran ${method.title}',
              style: TextStyle(
                color: AppColors.darkPrimary,
                fontSize: 17.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$description: $formattedAmount',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.6,
              ),
            ),
            const SizedBox(height: 16),
            if (method.category == PaymentCategory.qris)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Image.asset(
                    'assets/images/qr_code.png',
                    width: 132,
                    height: 132,
                  ),
                ),
              )
            else if (method.category == PaymentCategory.bank)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.bgPage,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nomor Virtual Account (Sandbox)',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${method.vaPrefix ?? '8277'} 0812 3456 7890',
                      style: TextStyle(
                        color: AppColors.darkPrimary,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.bgPage,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Text(
                  'Konfirmasi pembayaran instan melalui aplikasi ${method.title} Anda.',
                  style: TextStyle(
                    color: AppColors.darkPrimary,
                    fontSize: 12.8,
                  ),
                ),
              ),
            const SizedBox(height: 18),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.goldButton,
                foregroundColor: AppColors.onGold,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                onConfirmed();
              },
              child: Text(
                'Selesaikan pembayaran · $formattedAmount',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
