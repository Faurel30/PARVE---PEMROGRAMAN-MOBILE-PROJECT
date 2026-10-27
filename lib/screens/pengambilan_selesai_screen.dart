import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../models/ticket_model.dart';
import '../widgets/booking_step_header.dart';
import '../widgets/ticket_card.dart';
import 'beranda_screen.dart';

class PengambilanSelesaiScreen extends StatefulWidget {
  final ParkingTicket ticket;
  final int remainingBalanceAfterPay;

  const PengambilanSelesaiScreen({
    super.key,
    required this.ticket,
    required this.remainingBalanceAfterPay,
  });

  @override
  State<PengambilanSelesaiScreen> createState() =>
      _PengambilanSelesaiScreenState();
}

class _PengambilanSelesaiScreenState extends State<PengambilanSelesaiScreen> {
  final GlobalKey _receiptBoundaryKey = GlobalKey();
  int _selectedRating = 0;
  bool _isSavingPng = false;

  Future<void> _downloadReceiptAsPng() async {
    if (_isSavingPng) return;
    setState(() => _isSavingPng = true);

    try {
      final boundary = _receiptBoundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) return;

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final fileName = 'Bukti_Pembayaran_${widget.ticket.ticketCode}.png';
      String savedPath = fileName;

      try {
        final file = File('${Directory.systemTemp.path}/$fileName');
        await file.writeAsBytes(pngBytes);
        savedPath = file.path;
      } catch (_) {}

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'Bukti Pembayaran (.PNG)',
            style: TextStyle(
              color: AppColors.darkPrimary,
              fontSize: 16.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Berhasil disimpan dalam format PNG:',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
              ),
              const SizedBox(height: 6),
              Text(
                savedPath,
                style: TextStyle(
                  color: AppColors.darkPrimary,
                  fontSize: 11.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  pngBytes,
                  height: 190,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.goldButton,
                foregroundColor: AppColors.onGold,
              ),
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Selesai'),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSavingPng = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.ticket;
    final formattedRemaining = ParkingTicket.formatRupiah(
      widget.remainingBalanceAfterPay,
    );

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
                      const BookingTopBar(title: 'Pengambilan selesai'),
                      const SizedBox(height: 20),
                      _buildSuccessHeader(t),
                      const SizedBox(height: 20),
                      RepaintBoundary(
                        key: _receiptBoundaryKey,
                        child: _buildReceiptCard(t, formattedRemaining),
                      ),
                      const SizedBox(height: 20),
                      _buildRatingSection(t),
                      const SizedBox(height: 18),
                      _buildDownloadPngButton(),
                    ],
                  ),
                ),
              ),
              _buildBottomHomeBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessHeader(ParkingTicket t) {
    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: AppColors.badgeBg,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            color: AppColors.badgeGreen,
            size: 28,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Mobil sudah Anda terima.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.darkPrimary,
            fontSize: 21.5,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Terima kasih, ${t.userName}. Selamat melanjutkan perjalanan!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.2,
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptCard(ParkingTicket t, String formattedRemaining) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 17, 18, 17),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bukti pembayaran',
                style: TextStyle(
                  color: AppColors.darkPrimary,
                  fontSize: 15.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const StatusBadge(text: 'Lunas', isActive: true),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${t.ticketCode} • ${t.fullDate}',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11.6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, thickness: 1, color: AppColors.divider),
          ),
          TicketDetailRow(label: 'Lokasi', value: t.locationName),
          const SizedBox(height: 11),
          TicketDetailRow(
            label: 'Kendaraan',
            value: '${t.shortVehicleModel} • ${t.plateNumber}',
          ),
          const SizedBox(height: 11),
          TicketDetailRow(
            label: 'Waktu parkir',
            value: '${t.startHour}–${t.endHour} • ${t.parkingHours} jam',
          ),
          const SizedBox(height: 11),
          TicketDetailRow(
            label: 'Siap di lobi / diterima',
            value: '${t.endHour} / ${t.endHour}',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, thickness: 1, color: AppColors.divider),
          ),
          TicketDetailRow(label: 'Layanan valet', value: t.valetFee),
          const SizedBox(height: 11),
          TicketDetailRow(
            label: 'Parkir ${t.parkingHours} jam × ${t.formattedHourlyRate}',
            value: t.formattedParkingFee,
          ),
          const SizedBox(height: 11),
          TicketDetailRow(
            label: 'Total pembayaran',
            value: t.formattedGrandTotal,
            isHighlight: true,
          ),
          const SizedBox(height: 12),
          Text(
            'Dibayar dengan Dompet PARVE • saldo $formattedRemaining',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection(ParkingTicket t) {
    return Column(
      children: [
        Text(
          'Bagaimana layanan ${t.valetFirstName} hari ini?',
          style: TextStyle(
            color: AppColors.darkPrimary,
            fontSize: 13.2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starNumber = index + 1;
            final isFilled = starNumber <= _selectedRating;
            return GestureDetector(
              onTap: () => setState(() => _selectedRating = starNumber),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: Icon(
                  isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                  color: isFilled ? AppColors.goldButton : AppColors.navActive,
                  size: 30,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDownloadPngButton() {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: _downloadReceiptAsPng,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.cardBorder, width: 1.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.file_download_outlined,
                color: AppColors.darkPrimary,
                size: 19,
              ),
              const SizedBox(width: 8),
              Text(
                _isSavingPng ? 'Menyimpan PNG...' : 'Unduh bukti pembayaran',
                style: TextStyle(
                  color: AppColors.darkPrimary,
                  fontSize: 13.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomHomeBar() {
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
          onTap: () => Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              settings: const RouteSettings(name: '/home'),
              pageBuilder: (_, _, _) => const BerandaScreen(),
              transitionDuration: Duration.zero,
            ),
            (_) => false,
          ),
          borderRadius: BorderRadius.circular(11),
          child: const SizedBox(
            height: 49,
            child: Center(
              child: Text(
                'Kembali ke beranda',
                style: TextStyle(
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
