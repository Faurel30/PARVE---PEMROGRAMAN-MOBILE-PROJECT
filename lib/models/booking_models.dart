import 'package:flutter/material.dart';

class ValetLocation {
  final String id;
  final String name;
  final String lobbySubtitle;
  final String parkingArea;
  final String shortSlot;

  const ValetLocation({
    required this.id,
    required this.name,
    required this.lobbySubtitle,
    required this.parkingArea,
    required this.shortSlot,
  });

  static const List<ValetLocation> presets = [
    ValetLocation(
      id: 'loc-sency',
      name: 'Senayan City',
      lobbySubtitle: 'Lobi utama • Pintu selatan',
      parkingArea: 'B1 • Blok A-12',
      shortSlot: 'B1 A-12',
    ),
    ValetLocation(
      id: 'loc-gi',
      name: 'Grand Indonesia',
      lobbySubtitle: 'East Mall • Pintu Arjuna',
      parkingArea: 'P2 • Valet Zone B',
      shortSlot: 'P2 B-04',
    ),
    ValetLocation(
      id: 'loc-ps',
      name: 'Plaza Senayan',
      lobbySubtitle: 'Lobi utama • Pintu utara',
      parkingArea: 'B1 • Valet Zone A',
      shortSlot: 'B1 A-04',
    ),
  ];
}

enum PaymentCategory { parveWallet, qris, ewallet, bank }

class PaymentMethodOption {
  final String id;
  final String title;
  final String shortName;
  final String subtitle;
  final PaymentCategory category;
  final IconData icon;
  /// Kode payment_type standar untuk integrasi Midtrans Sandbox nantinya
  final String midtransPaymentType;
  final String? vaPrefix;

  const PaymentMethodOption({
    required this.id,
    required this.title,
    required this.shortName,
    required this.subtitle,
    required this.category,
    required this.icon,
    required this.midtransPaymentType,
    this.vaPrefix,
  });

  static String categoryTitle(PaymentCategory category) {
    return switch (category) {
      PaymentCategory.parveWallet => 'Saldo Aplikasi',
      PaymentCategory.qris => 'QR (QRIS • Midtrans Sandbox)',
      PaymentCategory.ewallet => 'E-Wallet',
      PaymentCategory.bank => 'Transfer Bank (Virtual Account)',
    };
  }

  static PaymentMethodOption parveWalletOption(String formattedBalance) {
    return PaymentMethodOption(
      id: 'parve_wallet',
      title: 'Dompet PARVE',
      shortName: 'Dompet PARVE',
      subtitle: 'Saldo Anda $formattedBalance',
      category: PaymentCategory.parveWallet,
      icon: Icons.account_balance_wallet_outlined,
      midtransPaymentType: 'parve_wallet',
    );
  }

  static const List<PaymentMethodOption> externalOptions = [
    // 1. QR (QRIS Midtrans Sandbox)
    PaymentMethodOption(
      id: 'qris',
      title: 'QRIS (Midtrans Sandbox)',
      shortName: 'QRIS',
      subtitle: 'Scan kode QR dari aplikasi bank atau dompet digital',
      category: PaymentCategory.qris,
      icon: Icons.qr_code_scanner_rounded,
      midtransPaymentType: 'qris',
    ),

    // 2. E-Wallet (GoPay, ShopeePay, OVO)
    PaymentMethodOption(
      id: 'gopay',
      title: 'GoPay',
      shortName: 'GoPay',
      subtitle: 'E-Wallet • Pembayaran instan via GoPay',
      category: PaymentCategory.ewallet,
      icon: Icons.account_balance_wallet_outlined,
      midtransPaymentType: 'gopay',
    ),
    PaymentMethodOption(
      id: 'shopeepay',
      title: 'ShopeePay',
      shortName: 'ShopeePay',
      subtitle: 'E-Wallet • Pembayaran instan via ShopeePay',
      category: PaymentCategory.ewallet,
      icon: Icons.account_balance_wallet_outlined,
      midtransPaymentType: 'shopeepay',
    ),
    PaymentMethodOption(
      id: 'ovo',
      title: 'OVO',
      shortName: 'OVO',
      subtitle: 'E-Wallet • Pembayaran instan via OVO',
      category: PaymentCategory.ewallet,
      icon: Icons.account_balance_wallet_outlined,
      midtransPaymentType: 'ovo',
    ),

    // 3. Bank (BCA, BRI, Mandiri)
    PaymentMethodOption(
      id: 'bca',
      title: 'Bank BCA',
      shortName: 'BCA',
      subtitle: 'BCA Virtual Account • Dicek otomatis',
      category: PaymentCategory.bank,
      icon: Icons.account_balance_outlined,
      midtransPaymentType: 'bca_va',
      vaPrefix: '8277',
    ),
    PaymentMethodOption(
      id: 'bri',
      title: 'Bank BRI',
      shortName: 'BRI',
      subtitle: 'BRI Virtual Account • Dicek otomatis',
      category: PaymentCategory.bank,
      icon: Icons.account_balance_outlined,
      midtransPaymentType: 'bri_va',
      vaPrefix: '8881',
    ),
    PaymentMethodOption(
      id: 'mandiri',
      title: 'Bank Mandiri',
      shortName: 'Mandiri',
      subtitle: 'Mandiri Virtual Account • Dicek otomatis',
      category: PaymentCategory.bank,
      icon: Icons.account_balance_outlined,
      midtransPaymentType: 'echannel',
      vaPrefix: '7001',
    ),
  ];
}
