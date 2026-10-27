import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/auth_store.dart';
import '../models/booking_models.dart';

class PaymentMethodDropdown extends StatefulWidget {
  final PaymentMethodOption selected;
  final ValueChanged<PaymentMethodOption> onChanged;
  final bool includeParveWallet;

  const PaymentMethodDropdown({
    super.key,
    required this.selected,
    required this.onChanged,
    this.includeParveWallet = false,
  });

  @override
  State<PaymentMethodDropdown> createState() => _PaymentMethodDropdownState();
}

class _PaymentMethodDropdownState extends State<PaymentMethodDropdown> {
  bool _isExpanded = false;

  List<PaymentMethodOption> get _availableOptions {
    return [
      if (widget.includeParveWallet)
        PaymentMethodOption.parveWalletOption(AuthStore.formattedWalletBalance),
      ...PaymentMethodOption.externalOptions,
    ];
  }

  List<PaymentCategory> get _visibleCategories {
    return [
      if (widget.includeParveWallet) PaymentCategory.parveWallet,
      PaymentCategory.qris,
      PaymentCategory.ewallet,
      PaymentCategory.bank,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final options = _availableOptions;
    final categories = _visibleCategories;
    final currentSubtitle = widget.selected.id == 'parve_wallet'
        ? 'Saldo Anda ${AuthStore.formattedWalletBalance}'
        : widget.selected.subtitle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              color: AppColors.softGoldCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFD6BE8A),
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  widget.selected.icon,
                  color: AppColors.navActive,
                  size: 22,
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.selected.title,
                        style: TextStyle(
                          color: AppColors.darkPrimary,
                          fontSize: 14.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentSubtitle,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11.8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.navActive, width: 1.4),
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 13,
                    color: AppColors.navActive,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.navActive,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder, width: 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final category in categories) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Text(
                      PaymentMethodOption.categoryTitle(category),
                      style: TextStyle(
                        color: AppColors.navActive,
                        fontSize: 11.2,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  for (final option
                      in options.where((o) => o.category == category))
                    _buildOptionTile(option),
                  if (category != categories.last)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.divider,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOptionTile(PaymentMethodOption option) {
    final isSelected = option.id == widget.selected.id;
    return InkWell(
      onTap: () {
        widget.onChanged(option);
        setState(() => _isExpanded = false);
      },
      child: Container(
        color: isSelected ? AppColors.softGoldCard : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(
              option.icon,
              size: 19,
              color: isSelected ? AppColors.navActive : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: TextStyle(
                      color: AppColors.darkPrimary,
                      fontSize: 13.4,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                  Text(
                    option.subtitle,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11.2,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              size: 18,
              color: isSelected ? AppColors.navActive : AppColors.cardBorder,
            ),
          ],
        ),
      ),
    );
  }
}
