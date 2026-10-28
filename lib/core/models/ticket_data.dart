class Officer {
  final String initials;
  final String name;
  final String shift;
  final bool isDuty;
  final String location;
  final String email;
  final String officerId;
  final String phone;

  const Officer({
    required this.initials,
    required this.name,
    required this.shift,
    this.isDuty = true,
    this.location = 'Pacific Place',
    this.email = '',
    this.officerId = '',
    this.phone = '',
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
  );
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

