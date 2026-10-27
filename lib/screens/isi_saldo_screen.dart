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

class IsiSaldoScreen extends StatefulWidget {
  const IsiSaldoScreen({super.key});

  @override
  State<IsiSaldoScreen> createState() => _IsiSaldoScreenState();
}

class _IsiSaldoScreenState extends State<IsiSaldoScreen> {
  static const List<int> _presetAmounts = [50000, 100000, 200000];

  final TextEditingController _amountCtrl =
      TextEditingController(text: 'Rp100.000');
  int _selectedAmount = 100000;

  PaymentMethodOption _selectedMethod = PaymentMethodOption.externalOptions
      .firstWhere((m) => m.id == 'bca');

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  void _onNominalTextChanged(String raw) {
    final digitsOnly = raw.replaceAll(RegExp(r'[^0-9]'), '');
    final parsed = int.tryParse(digitsOnly) ?? 0;
    final formatted = parsed > 0 ? ParkingTicket.formatRupiah(parsed) : 'Rp0';
    setState(() => _selectedAmount = parsed);
    if (_amountCtrl.text != formatted) {
      _amountCtrl.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void _selectPreset(int amount) {
    final formatted = ParkingTicket.formatRupiah(amount);
    setState(() {
      _selectedAmount = amount;
      _amountCtrl.text = formatted;
    });
  }

  void _handleTopUp() {
    if (_selectedAmount < 50000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Minimal nominal isi saldo adalah Rp50.000.'),
        ),
      );
      return;
    }

    showMidtransSandboxSheet(
      context: context,
      method: _selectedMethod,
      amount: _selectedAmount,
      description: 'Nominal isi saldo Dompet PARVE',
      onConfirmed: () {
        final formatted = ParkingTicket.formatRupiah(_selectedAmount);
        AuthStore.topUpWallet(
          amount: _selectedAmount,
          methodShortName: _selectedMethod.shortName,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Isi saldo $formatted via ${_selectedMethod.title} berhasil ditambahkan!',
            ),
          ),
        );
        Navigator.pop(context, true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentBalance = AuthStore.walletBalance;
    final afterBalance = currentBalance + _selectedAmount;
    final formattedAmount = ParkingTicket.formatRupiah(_selectedAmount);
    final isBelowMinimum = _selectedAmount < 50000;

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
                      const BookingTopBar(title: 'Isi saldo'),
                      const SizedBox(height: 18),
                      _buildCurrentBalancePill(),
                      const SizedBox(height: 18),
                      Text(
                        'Nominal isi saldo',
                        style: TextStyle(
                          color: AppColors.darkPrimary,
                          fontSize: 12.8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isBelowMinimum
                                ? const Color(0xFFB8564B)
                                : AppColors.cardBorder,
                            width: 1.2,
                          ),
                        ),
                        child: TextField(
                          controller: _amountCtrl,
                          keyboardType: TextInputType.number,
                          onChanged: _onNominalTextChanged,
                          style: TextStyle(
                            color: AppColors.darkPrimary,
                            fontSize: 15.2,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Minimal isi saldo Rp50.000.',
                        style: TextStyle(
                          color: isBelowMinimum
                              ? const Color(0xFFB8564B)
                              : AppColors.textMuted,
                          fontSize: 11.4,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildPresetNominalRow(),
                      const SizedBox(height: 22),
                      Text(
                        'Metode isi saldo',
                        style: TextStyle(
                          color: AppColors.darkPrimary,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      PaymentMethodDropdown(
                        selected: _selectedMethod,
                        includeParveWallet: false,
                        onChanged: (val) =>
                            setState(() => _selectedMethod = val),
                      ),
                      const SizedBox(height: 18),
                      _buildCalculationCard(
                        formattedAmount: formattedAmount,
                        formattedAfter: ParkingTicket.formatRupiah(afterBalance),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Saldo bertambah setelah pembayaran terkonfirmasi. Nomor pembayaran muncul di langkah berikutnya.',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11.4,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildStickyButton(formattedAmount),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentBalancePill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.heroDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Saldo Anda',
            style: TextStyle(color: Color(0xFFA0A39E), fontSize: 13.0),
          ),
          Text(
            AuthStore.formattedWalletBalance,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetNominalRow() {
    return Row(
      children: [
        for (int i = 0; i < _presetAmounts.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () => _selectPreset(_presetAmounts[i]),
              child: Container(
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _selectedAmount == _presetAmounts[i]
                      ? AppColors.softGoldCard
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _selectedAmount == _presetAmounts[i]
                        ? const Color(0xFFD6BE8A)
                        : AppColors.cardBorder,
                    width: 1.2,
                  ),
                ),
                child: Text(
                  ParkingTicket.formatRupiah(_presetAmounts[i]),
                  style: TextStyle(
                    color: _selectedAmount == _presetAmounts[i]
                        ? AppColors.navActive
                        : AppColors.darkPrimary,
                    fontSize: 12.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCalculationCard({
    required String formattedAmount,
    required String formattedAfter,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        children: [
          TicketDetailRow(label: 'Isi saldo', value: formattedAmount),
          const SizedBox(height: 11),
          const TicketDetailRow(label: 'Biaya admin', value: 'Rp0'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Divider(height: 1, thickness: 1, color: AppColors.divider),
          ),
          TicketDetailRow(
            label: 'Saldo setelah berhasil',
            value: formattedAfter,
            isHighlight: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStickyButton(String formattedAmount) {
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
          onTap: _handleTopUp,
          borderRadius: BorderRadius.circular(11),
          child: SizedBox(
            height: 49,
            child: Center(
              child: Text(
                'Lanjut isi saldo · $formattedAmount',
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
