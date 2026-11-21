class Officer {
  final String initials;
  final String name;
  final String shift;
  final bool isDuty;
  final String location;
  final String email;
  final String officerId;
  final String phone;
  final String uniqueCode;

  const Officer({
    required this.initials,
    required this.name,
    required this.shift,
    this.isDuty = true,
    this.location = 'Pacific Place',
    this.email = '',
    this.officerId = '',
    this.phone = '',
    this.uniqueCode = 'PV-7788',
  });

  static const Officer rizky = Officer(
    initials: 'RS',
    name: 'Rizky Saputra',
    shift: 'Shift 08.00–16.00',
    isDuty: true,
    location: 'Pacific Place',
    email: 'rizky.saputra@parve.id',
    officerId: 'PET-0810-01',
    phone: '081234567890',
    uniqueCode: 'PV-7788',
  );

  static const Officer fajar = Officer(
    initials: 'FH',
    name: 'Fajar Hidayat',
    shift: 'Shift 14.00–22.00',
    isDuty: true,
    location: 'Pacific Place',
    email: 'fajar.hidayat@parve.id',
    officerId: 'PET-0810-02',
    phone: '081298765432',
    uniqueCode: 'PV-9900',
  );
}

enum ValetVehicleStatus {
  akanDatang,
  terparkir,
  mauDiambil,
  sudahDiambil;

  String get label {
    switch (this) {
      case ValetVehicleStatus.akanDatang:
        return 'Akan Datang (Mau Diparkir)';
      case ValetVehicleStatus.terparkir:
        return 'Terparkir';
      case ValetVehicleStatus.mauDiambil:
        return 'Mau Diambil';
      case ValetVehicleStatus.sudahDiambil:
        return 'Sudah Diambil / Keluar';
    }
  }

  String get shortLabel {
    switch (this) {
      case ValetVehicleStatus.akanDatang:
        return 'Mau Diparkir';
      case ValetVehicleStatus.terparkir:
        return 'Terparkir';
      case ValetVehicleStatus.mauDiambil:
        return 'Mau Diambil';
      case ValetVehicleStatus.sudahDiambil:
        return 'Sudah Keluar';
    }
  }
}

class ValetVehicle {
  final String id;
  final String plateNumber;
  final String driverName;
  final String vehicleModel;
  final String slot;
  final ValetVehicleStatus status;
  final String entryTime;
  final String? exitTime;
  final String paymentStatus;
  final String ticketNumber;
  final String note;
  final String phoneNumber;
  final String officerName;

  const ValetVehicle({
    required this.id,
    required this.plateNumber,
    required this.driverName,
    required this.vehicleModel,
    required this.slot,
    required this.status,
    required this.entryTime,
    this.exitTime,
    required this.paymentStatus,
    required this.ticketNumber,
    this.note = '',
    this.phoneNumber = '0812-3456-7890',
    this.officerName = 'Rizky Saputra',
  });

  ValetVehicle copyWith({
    String? id,
    String? plateNumber,
    String? driverName,
    String? vehicleModel,
    String? slot,
    ValetVehicleStatus? status,
    String? entryTime,
    String? exitTime,
    String? paymentStatus,
    String? ticketNumber,
    String? note,
    String? phoneNumber,
    String? officerName,
  }) {
    return ValetVehicle(
      id: id ?? this.id,
      plateNumber: plateNumber ?? this.plateNumber,
      driverName: driverName ?? this.driverName,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      slot: slot ?? this.slot,
      status: status ?? this.status,
      entryTime: entryTime ?? this.entryTime,
      exitTime: exitTime ?? this.exitTime,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      note: note ?? this.note,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      officerName: officerName ?? this.officerName,
    );
  }

  static List<ValetVehicle> generateSampleVehicles() {
    return [
      const ValetVehicle(
        id: 'val-001',
        plateNumber: 'B 1234 PAR',
        driverName: 'Aditya Wijaya',
        vehicleModel: 'Toyota Alphard · Hitam',
        slot: 'A-018',
        status: ValetVehicleStatus.terparkir,
        entryTime: '14.15 WIB',
        paymentStatus: 'Sudah Terverifikasi',
        ticketNumber: 'PV-081026-0248',
        note: 'Kunci disimpan di loker VIP 02. Mobil siap jalan.',
        phoneNumber: '0812-8877-6655',
        officerName: 'Rizky Saputra',
      ),
      const ValetVehicle(
        id: 'val-002',
        plateNumber: 'B 2024 FAK',
        driverName: 'Farhan Akbar',
        vehicleModel: 'Honda Civic · Putih',
        slot: 'B-004',
        status: ValetVehicleStatus.mauDiambil,
        entryTime: '13.30 WIB',
        exitTime: '14.30 WIB',
        paymentStatus: 'Sudah Terverifikasi',
        ticketNumber: 'PV-081026-0246',
        note: 'Customer meminta mobil disiapkan di Lobi Barat GF.',
        phoneNumber: '0813-2211-9988',
        officerName: 'Fajar Hidayat',
      ),
      const ValetVehicle(
        id: 'val-003',
        plateNumber: 'B 8899 LUX',
        driverName: 'Jessica Tan',
        vehicleModel: 'Mercedes-Benz C200 · Abu-abu',
        slot: 'Menunggu Slot',
        status: ValetVehicleStatus.akanDatang,
        entryTime: '14.38 WIB',
        paymentStatus: 'Menunggu Konfirmasi',
        ticketNumber: 'PV-081026-0250',
        note: 'Baru tiba di Lobi Drop-off. Pengemudi menyerahkan kunci.',
        phoneNumber: '0818-4455-6677',
        officerName: 'Rizky Saputra',
      ),
      const ValetVehicle(
        id: 'val-004',
        plateNumber: 'D 1455 KEL',
        driverName: 'Dimas Setiawan',
        vehicleModel: 'Hyundai Ioniq 5 · Emas',
        slot: 'C-002 (EV)',
        status: ValetVehicleStatus.akanDatang,
        entryTime: '14.40 WIB',
        paymentStatus: 'Sudah Terverifikasi',
        ticketNumber: 'PV-081026-0251',
        note: 'Permintaan parkir di slot charger EV Lantai B1.',
        phoneNumber: '0811-9988-7766',
        officerName: 'Rizky Saputra',
      ),
      const ValetVehicle(
        id: 'val-005',
        plateNumber: 'B 9012 BOS',
        driverName: 'Hendra Gunawan',
        vehicleModel: 'BMW X5 · Hitam',
        slot: 'A-001',
        status: ValetVehicleStatus.sudahDiambil,
        entryTime: '11.00 WIB',
        exitTime: '14.10 WIB',
        paymentStatus: 'Sudah Terverifikasi',
        ticketNumber: 'PV-081026-0240',
        note: 'Selesai serah terima di Lobi Utama oleh Petugas Fajar.',
        phoneNumber: '0812-3344-5566',
        officerName: 'Fajar Hidayat',
      ),
    ];
  }
}

class VehicleTicket {
  final String plateNumber;
  final String driverName;
  final String vehicleModel;
  final String ticketNumber;
  final String slot;
  final String scanTime;
  final String officerName;
  final String paymentStatus;
  final String exitApprovalStatus;
  final bool isApproved;
  final String? approvedBy;
  final String? approvalTime;
  final String transactionStatus;

  const VehicleTicket({
    required this.plateNumber,
    required this.driverName,
    required this.vehicleModel,
    required this.ticketNumber,
    required this.slot,
    required this.scanTime,
    required this.officerName,
    required this.paymentStatus,
    required this.exitApprovalStatus,
    this.isApproved = false,
    this.approvedBy,
    this.approvalTime,
    this.transactionStatus = 'Proses Verifikasi',
  });

  // Data default screen 2 Figma
  static const VehicleTicket sampleExitScan = VehicleTicket(
    plateNumber: 'B 1234 PAR',
    driverName: 'Aditya Wijaya',
    vehicleModel: 'Toyota Alphard · Hitam',
    ticketNumber: 'PV-081026-0248',
    slot: 'A-018',
    scanTime: '8 Okt 2026 · 14.38 WIB',
    officerName: 'Rizky Saputra',
    paymentStatus: 'Sudah terverifikasi',
    exitApprovalStatus: 'Belum disetujui',
    isApproved: false,
    transactionStatus: 'Menunggu Persetujuan',
  );

  // Data default screen 3 Figma
  static const VehicleTicket sampleApprovedExit = VehicleTicket(
    plateNumber: 'B 2024 FAK',
    driverName: 'Farhan Akbar',
    vehicleModel: 'Honda Civic · Putih',
    ticketNumber: 'PV-081026-0246',
    slot: 'B-004',
    scanTime: '8 Okt 2026 · 14.28 WIB',
    officerName: 'Fajar Hidayat',
    paymentStatus: 'Sudah terverifikasi',
    exitApprovalStatus: 'Keluar Disetujui',
    isApproved: true,
    approvedBy: 'Admin Dimas Pratama',
    approvalTime: '8 Okt 2026 · 14.30 WIB',
    transactionStatus: 'Selesai',
  );
}

class OfficerNotification {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final String authorInfo;
  final VehicleTicket ticket;
  final bool isRead;
  final bool isDetailOpen;

  const OfficerNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.authorInfo,
    required this.ticket,
    this.isRead = false,
    this.isDetailOpen = true,
  });

  static final OfficerNotification sampleFigmaNotification = OfficerNotification(
    id: 'notif-1',
    title: 'Keluar Disetujui',
    subtitle: 'B 2024 FAK · Farhan Akbar',
    time: '14.30',
    authorInfo: 'Dimas Pratama · Detail notifikasi terbuka',
    ticket: VehicleTicket.sampleApprovedExit,
    isRead: false,
    isDetailOpen: true,
  );
}
