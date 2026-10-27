import 'dart:typed_data';
import '../widgets/vehicle_illustration.dart';

class VehicleJourneyStep {
  final String title;
  final String subtitle;
  final String time;

  const VehicleJourneyStep({
    required this.title,
    required this.subtitle,
    required this.time,
  });
}

class ParkingTicket {
  static const int defaultHourlyRate = 5000;
  static const int defaultValetFee = 35000;

  final String ticketCode;
  final String userName;
  final String fullDate;
  final String locationName;
  final String pickupLobby;
  final String statusText;
  final String vehicleName;
  final String plateNumber;
  final String vehicleSpecs;
  final VehicleSize vehicleSize;
  final Uint8List? vehiclePhotoBytes;
  final String entryTime;
  final String shortEntryTime;
  final String startHour;
  final String pickupTime;
  final int parkingHours;
  final int hourlyRate;
  final int valetFeeAmount;
  final int walletBalance;
  final String parkingArea;
  final String shortSlot;
  final String currentDuration;
  final String lastUpdated;
  final String valetOfficerName;
  final String valetPaymentMethod;
  final List<VehicleJourneyStep> journeySteps;
  final bool isActive;
  final bool isPickupRequested;

  const ParkingTicket({
    required this.ticketCode,
    this.userName = 'Dimas',
    this.fullDate = '8 Oktober 2026',
    required this.locationName,
    this.pickupLobby = 'Lobi utama • Pintu selatan',
    required this.statusText,
    required this.vehicleName,
    required this.plateNumber,
    required this.vehicleSpecs,
    this.vehicleSize = VehicleSize.large,
    this.vehiclePhotoBytes,
    required this.entryTime,
    this.shortEntryTime = '8 Okt • 13.00',
    this.startHour = '13.00',
    this.pickupTime = '14.55 WIB',
    this.parkingHours = 2,
    this.hourlyRate = defaultHourlyRate,
    this.valetFeeAmount = defaultValetFee,
    this.walletBalance = 205000,
    required this.parkingArea,
    required this.shortSlot,
    required this.currentDuration,
    required this.lastUpdated,
    required this.valetOfficerName,
    this.valetPaymentMethod = 'QRIS (Midtrans Sandbox)',
    required this.journeySteps,
    this.isActive = true,
    this.isPickupRequested = false,
  });

  int get totalParkingFee => parkingHours * hourlyRate;
  int get grandTotalFee => valetFeeAmount + totalParkingFee;
  int get remainingWalletBalance => walletBalance - totalParkingFee;

  String get valetFee => formatRupiah(valetFeeAmount);
  String get formattedHourlyRate => formatRupiah(hourlyRate);
  String get formattedParkingFee => formatRupiah(totalParkingFee);
  String get formattedGrandTotal => formatRupiah(grandTotalFee);
  String get formattedWalletBalance => formatRupiah(walletBalance);
  String get formattedRemainingBalance => formatRupiah(remainingWalletBalance);

  String get shortVehicleModel {
    final parts = vehicleName.split(' ');
    return parts.length > 1 ? parts.sublist(1).join(' ') : vehicleName;
  }

  String get valetFirstName => valetOfficerName.split(' ').first;

  String get endHour {
    final startH = int.tryParse(startHour.split('.').first) ?? 13;
    return '${startH + parkingHours}.00';
  }

  static String formatRupiah(int amount) {
    final digits = amount.toString();
    final buffer = StringBuffer('Rp');
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  ParkingTicket copyWith({
    String? ticketCode,
    String? userName,
    String? locationName,
    String? pickupLobby,
    String? statusText,
    String? vehicleName,
    String? plateNumber,
    String? vehicleSpecs,
    VehicleSize? vehicleSize,
    Uint8List? vehiclePhotoBytes,
    String? entryTime,
    String? shortEntryTime,
    String? startHour,
    String? pickupTime,
    int? parkingHours,
    int? walletBalance,
    String? currentDuration,
    String? valetPaymentMethod,
    List<VehicleJourneyStep>? journeySteps,
    bool? isActive,
    bool? isPickupRequested,
  }) {
    return ParkingTicket(
      ticketCode: ticketCode ?? this.ticketCode,
      userName: userName ?? this.userName,
      fullDate: fullDate,
      locationName: locationName ?? this.locationName,
      pickupLobby: pickupLobby ?? this.pickupLobby,
      statusText: statusText ?? this.statusText,
      vehicleName: vehicleName ?? this.vehicleName,
      plateNumber: plateNumber ?? this.plateNumber,
      vehicleSpecs: vehicleSpecs ?? this.vehicleSpecs,
      vehicleSize: vehicleSize ?? this.vehicleSize,
      vehiclePhotoBytes: vehiclePhotoBytes ?? this.vehiclePhotoBytes,
      entryTime: entryTime ?? this.entryTime,
      shortEntryTime: shortEntryTime ?? this.shortEntryTime,
      startHour: startHour ?? this.startHour,
      pickupTime: pickupTime ?? this.pickupTime,
      parkingHours: parkingHours ?? this.parkingHours,
      hourlyRate: hourlyRate,
      valetFeeAmount: valetFeeAmount,
      walletBalance: walletBalance ?? this.walletBalance,
      parkingArea: parkingArea,
      shortSlot: shortSlot,
      currentDuration: currentDuration ?? this.currentDuration,
      lastUpdated: lastUpdated,
      valetOfficerName: valetOfficerName,
      valetPaymentMethod: valetPaymentMethod ?? this.valetPaymentMethod,
      journeySteps: journeySteps ?? this.journeySteps,
      isActive: isActive ?? this.isActive,
      isPickupRequested: isPickupRequested ?? this.isPickupRequested,
    );
  }

  static const Map<VehicleSize, ({String name, String specs})> vehiclePresets = {
    VehicleSize.small: (
      name: 'Honda Civic RS',
      specs: 'Putih • 2024',
    ),
    VehicleSize.medium: (
      name: 'Honda HR-V',
      specs: 'Hitam • 2024',
    ),
    VehicleSize.large: (
      name: 'Toyota Veloz',
      specs: 'Putih • 2024',
    ),
  };

  static const ParkingTicket sampleActive = ParkingTicket(
    ticketCode: 'PV-081026-0248',
    userName: 'Dimas',
    fullDate: '8 Oktober 2026',
    locationName: 'Senayan City',
    pickupLobby: 'Lobi utama • Pintu selatan',
    statusText: 'Terparkir aman',
    vehicleName: 'Toyota Veloz',
    plateNumber: 'B 2148 SJD',
    vehicleSpecs: 'Putih • 2024',
    vehicleSize: VehicleSize.large,
    entryTime: '8 Okt 2026 • 13.00',
    shortEntryTime: '8 Okt • 13.00',
    startHour: '13.00',
    pickupTime: '14.55 WIB',
    parkingHours: 2,
    hourlyRate: 5000,
    valetFeeAmount: 35000,
    walletBalance: 205000,
    parkingArea: 'B1 • Blok A-12',
    shortSlot: 'B1 A-12',
    currentDuration: '1 jam 30 menit',
    lastUpdated: 'Diperbarui 14.30 WIB',
    valetOfficerName: 'Andi Saputra',
    journeySteps: [
      VehicleJourneyStep(
        title: 'Diserahkan ke petugas',
        subtitle: 'Lobi utama • Pintu selatan',
        time: '13.00',
      ),
      VehicleJourneyStep(
        title: 'Terparkir aman',
        subtitle: 'B1 • Blok A-12',
        time: '13.08',
      ),
    ],
    isActive: true,
  );

  static const List<ParkingTicket> sampleHistory = [
    ParkingTicket(
      ticketCode: 'PV-021026-0119',
      locationName: 'Grand Indonesia',
      statusText: 'Selesai',
      vehicleName: 'Honda HR-V',
      plateNumber: 'B 1829 KLP',
      vehicleSpecs: 'Hitam • 2024',
      vehicleSize: VehicleSize.medium,
      entryTime: '2 Okt 2026 • 18.30',
      parkingHours: 3,
      parkingArea: 'P2 • Valet Zone B',
      shortSlot: 'P2 B-04',
      currentDuration: '2 jam 15 menit',
      lastUpdated: 'Selesai 20.45 WIB',
      valetOfficerName: 'Budi Santoso',
      journeySteps: [],
      isActive: false,
    ),
    ParkingTicket(
      ticketCode: 'PV-250926-0084',
      locationName: 'Plaza Senayan',
      statusText: 'Selesai',
      vehicleName: 'Honda Civic RS',
      plateNumber: 'B 1042 TZX',
      vehicleSpecs: 'Silver • 2023',
      vehicleSize: VehicleSize.small,
      entryTime: '25 Sep 2026 • 11.15',
      parkingHours: 2,
      parkingArea: 'Lobby Utama • A-04',
      shortSlot: 'L1 A-04',
      currentDuration: '1 jam 45 menit',
      lastUpdated: 'Selesai 13.00 WIB',
      valetOfficerName: 'Rizky Pratama',
      journeySteps: [],
      isActive: false,
    ),
  ];
}
