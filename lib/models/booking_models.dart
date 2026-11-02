import 'package:flutter/material.dart';
import 'auth_store.dart';

class ValetLocation {
  static const int defaultTotalSlots = AuthStore.uniformMallSlots; // 15 slot

  final String id;
  final String name;
  final String imageAsset;
  final String lobbySubtitle;
  final String parkingArea;
  final String shortSlot;
  final String address;
  final String distanceKm;
  final String operatingHours;
  final int openHour;
  final int closeHour;
  final int totalSlots;
  final List<String> facilities;

  const ValetLocation({
    required this.id,
    required this.name,
    this.imageAsset =
        'assets/images/Asset Project Mobile/Summarecon_Mall_Bekasi.png',
    required this.lobbySubtitle,
    required this.parkingArea,
    required this.shortSlot,
    this.address = 'Jakarta',
    this.distanceKm = '1,2 km',
    this.operatingHours = '10.00 – 22.00 WIB',
    this.openHour = 10,
    this.closeHour = 22,
    this.totalSlots = defaultTotalSlots,
    this.facilities = const [
      'Lobi VIP Berkanopi',
      'CCTV 24 Jam',
      'Petugas Terverifikasi',
    ],
  });

  /// Mengambil path foto mall berdasarkan nama mall
  static String imageAssetForMallName(String mallName) {
    final target = mallName.trim().toLowerCase();
    for (final loc in presets) {
      if (loc.name.toLowerCase() == target) {
        return loc.imageAsset;
      }
    }
    return presets.first.imageAsset;
  }

  /// Mengecek apakah mall sedang buka berdasarkan waktu dunia real-time (DateTime.now())
  /// Jam operasional resmi Google untuk ke-5 mall: 10.00 – 22.00 WIB
  bool get isMallOpen {
    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final openMinutes = openHour * 60;
    final closeMinutes = closeHour * 60;
    return nowMinutes >= openMinutes && nowMinutes < closeMinutes;
  }

  /// Jumlah slot parkir valet yang sedang terisi oleh tiket aktif secara real-time
  int get occupiedSlots =>
      AuthStore.occupiedSlotsForMall(name, maxSlots: totalSlots);

  /// Sisa slot parkir valet dari total 15 slot secara real-time
  int get availableSlots =>
      AuthStore.availableSlotsForMall(name, maxSlots: totalSlots);

  /// Apakah slot parkir masih tersedia (> 0 dari 15 slot)
  bool get isParkingAvailable => availableSlots > 0;

  /// Apakah mall ini bisa dipesan saat ini (mall buka & slot parkir > 0)
  bool get canBookValet => isMallOpen && isParkingAvailable;

  /// Label status operasional mall secara real-time mengikuti jam dunia
  String get mallStatusLabel {
    final now = DateTime.now();
    final closeStr = '${closeHour.toString().padLeft(2, '0')}.00';
    final openStr = '${openHour.toString().padLeft(2, '0')}.00';

    if (isMallOpen) {
      final totalCloseMinutes = closeHour * 60;
      final currentMinutes = now.hour * 60 + now.minute;
      final remaining = totalCloseMinutes - currentMinutes;
      final remH = remaining ~/ 60;
      final remM = remaining % 60;
      if (remH > 0) {
        return 'Buka • Tutup ${remH}j ${remM}m lagi ($closeStr)';
      }
      return 'Buka • Tutup $remM mnt lagi ($closeStr)';
    }
    return 'Tutup • Buka pukul $openStr WIB';
  }

  /// Label ringkas status parkir untuk badge UI
  String get parkingStatusLabel {
    if (!isMallOpen) return 'Mall Tutup';
    if (!isParkingAvailable) return 'Parkir Penuh';
    return 'Tersedia';
  }

  /// Teks detail ketersediaan slot parkir dari 15 slot
  String get slotAvailabilityText {
    if (!isMallOpen) {
      return 'Layanan valet tutup • Buka kembali pukul ${openHour.toString().padLeft(2, '0')}.00 WIB';
    }
    if (!isParkingAvailable) {
      return '0 dari $totalSlots slot tersedia (Penuh • $occupiedSlots terisi)';
    }
    return '$availableSlots dari $totalSlots slot valet tersedia ($occupiedSlots terisi)';
  }

  /// 5 Lokasi Mall resmi PARVE dengan jam operasional dunia nyata (Google: 10.00 – 22.00 WIB)
  /// dan kapasitas seragam 15 slot parkir valet per mall.
  static const List<ValetLocation> presets = [
    // 1. Summarecon Mall Bekasi
    ValetLocation(
      id: 'loc-smb',
      name: 'Summarecon Mall Bekasi',
      imageAsset:
          'assets/images/Asset Project Mobile/Summarecon_Mall_Bekasi.png',
      lobbySubtitle: 'The Downtown Walk • Lobi Utama',
      parkingArea: 'B1 • Zona Valet A-01',
      shortSlot: 'B1 A-01',
      address: 'Jl. Boulevard Ahmad Yani Blok M, Marga Mulya, Bekasi Utara',
      distanceKm: '18,4 km',
      operatingHours: '10.00 – 22.00 WIB',
      openHour: 10,
      closeHour: 22,
      totalSlots: defaultTotalSlots,
      facilities: [
        'Drop-off The Downtown Walk',
        'CCTV 24 Jam',
        'Petugas Terverifikasi',
      ],
    ),

    // 2. Grand Indonesia
    ValetLocation(
      id: 'loc-gi',
      name: 'Grand Indonesia',
      imageAsset: 'assets/images/Asset Project Mobile/Grand_Indonesia.png',
      lobbySubtitle: 'East Mall • Pintu Arjuna',
      parkingArea: 'P2 • Valet Zone B-04',
      shortSlot: 'P2 B-04',
      address: 'Jl. M.H. Thamrin No. 1, Menteng, Jakarta Pusat',
      distanceKm: '3,4 km',
      operatingHours: '10.00 – 22.00 WIB',
      openHour: 10,
      closeHour: 22,
      totalSlots: defaultTotalSlots,
      facilities: [
        'Drop-off East & West Mall',
        'CCTV 24 Jam',
        'Ruang Tunggu Lounge',
      ],
    ),

    // 3. PIM 2 (Pondok Indah Mall 2)
    ValetLocation(
      id: 'loc-pim2',
      name: 'PIM 2',
      imageAsset: 'assets/images/Asset Project Mobile/PIM_2.png',
      lobbySubtitle: 'North Skywalk • Lobi Utama PIM 2',
      parkingArea: 'P1 • Valet Premier V-11',
      shortSlot: 'P1 V-11',
      address: 'Jl. Metro Pondok Indah Kav. IV, Kebayoran Lama, Jakarta Selatan',
      distanceKm: '6,8 km',
      operatingHours: '10.00 – 22.00 WIB',
      openHour: 10,
      closeHour: 22,
      totalSlots: defaultTotalSlots,
      facilities: [
        'Akses Langsung Skywalk',
        'CCTV 24 Jam',
        'Petugas Terverifikasi',
      ],
    ),

    // 4. Senayan City
    ValetLocation(
      id: 'loc-sency',
      name: 'Senayan City',
      imageAsset: 'assets/images/Asset Project Mobile/senayan_city.png',
      lobbySubtitle: 'Lobi utama • Pintu selatan',
      parkingArea: 'B1 • Blok A-12',
      shortSlot: 'B1 A-12',
      address: 'Jl. Asia Afrika No. 19, Gelora, Tanah Abang, Jakarta Pusat',
      distanceKm: '1,2 km',
      operatingHours: '10.00 – 22.00 WIB',
      openHour: 10,
      closeHour: 22,
      totalSlots: defaultTotalSlots,
      facilities: [
        'Lobi VIP Berkanopi',
        'CCTV 24 Jam',
        'EV Charging Ready',
      ],
    ),

    // 5. Pacific Place Jakarta
    ValetLocation(
      id: 'loc-pp',
      name: 'Pacific Place Jakarta',
      imageAsset: 'assets/images/Asset Project Mobile/Pacific_Place.png',
      lobbySubtitle: 'Lobi Selatan • SCBD Lot 3–5',
      parkingArea: 'B1 • VIP Zone C-08',
      shortSlot: 'B1 C-08',
      address: 'Jl. Jend. Sudirman Kav. 52–53, SCBD, Jakarta Selatan',
      distanceKm: '2,1 km',
      operatingHours: '10.00 – 22.00 WIB',
      openHour: 10,
      closeHour: 22,
      totalSlots: defaultTotalSlots,
      facilities: [
        'Lobi Eksklusif SCBD',
        'EV Supercharger',
        'Asuransi Valet Penuh',
      ],
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
