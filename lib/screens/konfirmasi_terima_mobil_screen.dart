import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../models/auth_store.dart';
import '../models/ticket_model.dart';
import '../widgets/booking_step_header.dart';
import '../widgets/ticket_card.dart';
import '../widgets/vehicle_illustration.dart';
import 'pengambilan_selesai_screen.dart';

class KonfirmasiTerimaMobilScreen extends StatefulWidget {
  final ParkingTicket ticket;
  final int remainingBalanceAfterPay;
  final ValueChanged<ParkingTicket>? onTicketUpdated;

  const KonfirmasiTerimaMobilScreen({
    super.key,
    required this.ticket,
    required this.remainingBalanceAfterPay,
    this.onTicketUpdated,
  });

  @override
  State<KonfirmasiTerimaMobilScreen> createState() =>
      _KonfirmasiTerimaMobilScreenState();
}

class _KonfirmasiTerimaMobilScreenState
    extends State<KonfirmasiTerimaMobilScreen> {
  late ParkingTicket _ticket = widget.ticket;
  bool _isCheckingExterior = true;
  bool _isKeyReceived = true;
  bool _isBelongingsChecked = true;
  bool _isSubmitting = false;

  void _showContactOfficerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.goldButton.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.support_agent_rounded,
                    color: AppColors.goldText,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _ticket.valetOfficerName,
                        style: TextStyle(
                          color: AppColors.darkPrimary,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Petugas Valet di ${_ticket.pickupLobby}',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Petugas telah membawa mobil Anda ke lobi penjemputan. Anda dapat langsung menemuinya di lobi.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13.0,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Menghubungi ${_ticket.valetOfficerName}... Silakan temui petugas di ${_ticket.pickupLobby}',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.phone_in_talk_rounded, size: 18),
              label: const Text('Hubungi Petugas'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldButton,
                foregroundColor: AppColors.onGold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleConfirmReceived() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    final now = DateTime.now();
    final finishHour =
        '${now.hour.toString().padLeft(2, '0')}.${now.minute.toString().padLeft(2, '0')}';

    final completed = AuthStore.completeActiveTicket(
      _ticket.copyWith(
        statusText: 'Selesai',
        isActive: false,
        journeySteps: [
          ..._ticket.journeySteps,
          VehicleJourneyStep(
            title: 'Mobil diterima oleh pemilik',
            subtitle: '${_ticket.pickupLobby} • Kunci & kondisi terkonfirmasi',
            time: finishHour,
          ),
        ],
      ),
    );

    widget.onTicketUpdated?.call(completed);

    if (!mounted) return;

    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PengambilanSelesaiScreen(
          ticket: completed,
          remainingBalanceAfterPay: widget.remainingBalanceAfterPay,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canConfirm =
        _isCheckingExterior && _isKeyReceived && _isBelongingsChecked;

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
                        title: 'Konfirmasi Pengambilan',
                        onBack: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 18),
                      _buildArrivalBanner(),
                      const SizedBox(height: 16),
                      _buildHandoverDetailCard(),
                      const SizedBox(height: 16),
                      _buildOfficerCard(),
                      const SizedBox(height: 16),
                      _buildVerificationChecklist(),
                    ],
                  ),
                ),
              ),
              _buildBottomConfirmBar(canConfirm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArrivalBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E211D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.goldButton.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.goldButton.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.car_rental_rounded,
                    color: AppColors.goldButton,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'MOBIL SIAP DI LOBI',
                          style: TextStyle(
                            color: AppColors.goldText,
                            fontSize: 11.2,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Mobil Anda Telah Diantar!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: AppColors.goldText,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Petugas sudah menunggu di ${_ticket.pickupLobby}. Cocokkan plat nomor dan nomor tiket Anda.',
                    style: const TextStyle(
                      color: Color(0xFFD6D8D2),
                      fontSize: 12.0,
                      height: 1.35,
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

  Widget _buildHandoverDetailCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Detail Serah Terima',
                style: TextStyle(
                  color: AppColors.darkPrimary,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              StatusBadge(
                text: 'Di Lobi Penjemputan',
                isActive: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          VehicleSummaryRow(
            ticket: _ticket,
          ),
          const SizedBox(height: 16),
          Divider(height: 1, thickness: 1, color: AppColors.divider),
          const SizedBox(height: 14),
          TicketDetailRow(
            label: 'Nomor Tiket',
            value: _ticket.ticketCode,
          ),
          const SizedBox(height: 11),
          TicketDetailRow(
            label: 'Lokasi',
            value: _ticket.locationName,
          ),
          const SizedBox(height: 11),
          TicketDetailRow(
            label: 'Titik Temu Lobi',
            value: _ticket.pickupLobby,
            isHighlight: true,
          ),
          const SizedBox(height: 11),
          TicketDetailRow(
            label: 'Waktu Pengantaran',
            value: _ticket.pickupTime.isNotEmpty
                ? _ticket.pickupTime
                : '${DateTime.now().hour.toString().padLeft(2, '0')}.${DateTime.now().minute.toString().padLeft(2, '0')} WIB',
          ),
        ],
      ),
    );
  }

  Widget _buildOfficerCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.how_to_reg_outlined,
              color: AppColors.darkPrimary,
              size: 22,
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
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Petugas Valet Lapangan • Serah Terima Kunci',
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.goldButton.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Hubungi',
                style: TextStyle(
                  color: AppColors.navActive,
                  fontSize: 12.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationChecklist() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.fact_check_outlined,
                size: 19,
                color: AppColors.navActive,
              ),
              const SizedBox(width: 8),
              Text(
                'Verifikasi Penerimaan Kendaraan',
                style: TextStyle(
                  color: AppColors.darkPrimary,
                  fontSize: 14.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Centang poin berikut sebelum menyelesaikan pengambilan mobil:',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.0,
            ),
          ),
          const SizedBox(height: 14),
          _buildCheckItem(
            value: _isCheckingExterior,
            title: 'Kondisi fisik & eksterior sesuai',
            subtitle: 'Pastikan bodi mobil dalam kondisi aman tanpa kendala baru.',
            onChanged: (val) =>
                setState(() => _isCheckingExterior = val ?? false),
          ),
          const SizedBox(height: 10),
          _buildCheckItem(
            value: _isKeyReceived,
            title: 'Kunci kendaraan sudah diterima',
            subtitle: 'Kunci fisik / smart key telah diserahkan oleh petugas.',
            onChanged: (val) => setState(() => _isKeyReceived = val ?? false),
          ),
          const SizedBox(height: 10),
          _buildCheckItem(
            value: _isBelongingsChecked,
            title: 'Barang bawaan lengkap',
            subtitle: 'Barang berharga di kabin kendaraan telah diperiksa.',
            onChanged: (val) =>
                setState(() => _isBelongingsChecked = val ?? false),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem({
    required bool value,
    required String title,
    required String subtitle,
    required ValueChanged<bool?> onChanged,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: value
                ? AppColors.goldButton.withValues(alpha: 0.08)
                : AppColors.surfaceSubtle.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: value
                  ? AppColors.goldButton.withValues(alpha: 0.4)
                  : AppColors.cardBorder,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.goldButton,
                checkColor: AppColors.onGold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.darkPrimary,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11.2,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomConfirmBar(bool canConfirm) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        21,
        12,
        21,
        bottomPadding > 0 ? bottomPadding + 8 : 14,
      ),
      child: Material(
        color: canConfirm ? AppColors.goldButton : AppColors.divider,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: canConfirm && !_isSubmitting ? _handleConfirmReceived : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 48,
            alignment: Alignment.center,
            child: _isSubmitting
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.onGold),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: 20,
                        color: canConfirm
                            ? AppColors.onGold
                            : AppColors.textMuted,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Konfirmasi Mobil Sudah Diterima',
                        style: TextStyle(
                          color: canConfirm
                              ? AppColors.onGold
                              : AppColors.textMuted,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
