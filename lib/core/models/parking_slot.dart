enum SlotStatus {
  available, // Tersedia (Hijau)
  occupied,  // Terisi (Merah/Gelap)
  reserved,  // Dibooking (Kuning/Emas)
}

enum VehicleType {
  car,
  motorcycle,
  vip,
}

class ParkingSlot {
  final String id;
  final String floor;
  final String zone;
  final SlotStatus status;
  final VehicleType vehicleType;
  final String? currentPlate;
  final String? currentVehicleModel;
  final String? entryTime;
  final String? driverName;
  final String? duration;

  const ParkingSlot({
    required this.id,
    required this.floor,
    required this.zone,
    required this.status,
    this.vehicleType = VehicleType.car,
    this.currentPlate,
    this.currentVehicleModel,
    this.entryTime,
    this.driverName,
    this.duration,
  });

  static List<ParkingSlot> generateSampleSlots() {
    return [
      // Zona A - Basement 1
      const ParkingSlot(
        id: 'A-001',
        floor: 'Basement 1 (B1)',
        zone: 'Zona A',
        status: SlotStatus.occupied,
        vehicleType: VehicleType.car,
        currentPlate: 'B 8899 KLS',
        currentVehicleModel: 'Honda HR-V · Abu-Abu',
        entryTime: '09.15 WIB',
        driverName: 'Budi Santoso',
        duration: '5 Jam 20 Menit',
      ),
      const ParkingSlot(
        id: 'A-002',
        floor: 'Basement 1 (B1)',
        zone: 'Zona A',
        status: SlotStatus.available,
        vehicleType: VehicleType.car,
      ),
      const ParkingSlot(
        id: 'A-003',
        floor: 'Basement 1 (B1)',
        zone: 'Zona A',
        status: SlotStatus.reserved,
        vehicleType: VehicleType.car,
        currentPlate: 'B 3012 QW',
        driverName: 'Siti Rahma (Booking)',
        duration: 'Estimasi Tiba: 14.50 WIB',
      ),
      const ParkingSlot(
        id: 'A-004',
        floor: 'Basement 1 (B1)',
        zone: 'Zona A',
        status: SlotStatus.available,
        vehicleType: VehicleType.car,
      ),
      const ParkingSlot(
        id: 'A-005',
        floor: 'Basement 1 (B1)',
        zone: 'Zona A',
        status: SlotStatus.occupied,
        vehicleType: VehicleType.vip,
        currentPlate: 'B 1 VIP',
        currentVehicleModel: 'Mercedes-Benz S450 · Hitam',
        entryTime: '10.30 WIB',
        driverName: 'Hendrawan Pratama',
        duration: '4 Jam 05 Menit',
      ),
      const ParkingSlot(
        id: 'A-018', // Sesuai tiket Figma di Layar 2!
        floor: 'Basement 1 (B1)',
        zone: 'Zona A',
        status: SlotStatus.occupied,
        vehicleType: VehicleType.car,
        currentPlate: 'B 1234 PAR',
        currentVehicleModel: 'Toyota Alphard · Hitam',
        entryTime: '11.20 WIB',
        driverName: 'Aditya Wijaya',
        duration: '3 Jam 18 Menit',
      ),
      const ParkingSlot(
        id: 'A-019',
        floor: 'Basement 1 (B1)',
        zone: 'Zona A',
        status: SlotStatus.available,
        vehicleType: VehicleType.car,
      ),
      const ParkingSlot(
        id: 'A-020',
        floor: 'Basement 1 (B1)',
        zone: 'Zona A',
        status: SlotStatus.available,
        vehicleType: VehicleType.car,
      ),

      // Zona B - Basement 1
      const ParkingSlot(
        id: 'B-001',
        floor: 'Basement 1 (B1)',
        zone: 'Zona B',
        status: SlotStatus.available,
        vehicleType: VehicleType.car,
      ),
      const ParkingSlot(
        id: 'B-002',
        floor: 'Basement 1 (B1)',
        zone: 'Zona B',
        status: SlotStatus.occupied,
        vehicleType: VehicleType.car,
        currentPlate: 'B 9021 JKL',
        currentVehicleModel: 'Hyundai Ioniq 5 · Putih',
        entryTime: '12.45 WIB',
        driverName: 'Clarissa Natalia',
        duration: '1 Jam 50 Menit',
      ),
      const ParkingSlot(
        id: 'B-003',
        floor: 'Basement 1 (B1)',
        zone: 'Zona B',
        status: SlotStatus.available,
        vehicleType: VehicleType.car,
      ),
      const ParkingSlot(
        id: 'B-004', // Sesuai data Screen 3 Figma!
        floor: 'Basement 1 (B1)',
        zone: 'Zona B',
        status: SlotStatus.occupied,
        vehicleType: VehicleType.car,
        currentPlate: 'B 2024 FAK',
        currentVehicleModel: 'Honda Civic · Putih',
        entryTime: '13.10 WIB',
        driverName: 'Farhan Akbar',
        duration: '1 Jam 25 Menit',
      ),
      const ParkingSlot(
        id: 'B-005',
        floor: 'Basement 1 (B1)',
        zone: 'Zona B',
        status: SlotStatus.reserved,
        vehicleType: VehicleType.car,
        currentPlate: 'B 4444 XYZ',
        driverName: 'Reza Mahendra (Booking)',
        duration: 'Estimasi Tiba: 15.00 WIB',
      ),
      const ParkingSlot(
        id: 'B-006',
        floor: 'Basement 1 (B1)',
        zone: 'Zona B',
        status: SlotStatus.available,
        vehicleType: VehicleType.car,
      ),

      // Basement 2 (B2)
      const ParkingSlot(
        id: 'C-001',
        floor: 'Basement 2 (B2)',
        zone: 'Zona C',
        status: SlotStatus.available,
        vehicleType: VehicleType.car,
      ),
      const ParkingSlot(
        id: 'C-002',
        floor: 'Basement 2 (B2)',
        zone: 'Zona C',
        status: SlotStatus.occupied,
        vehicleType: VehicleType.car,
        currentPlate: 'B 5511 MNO',
        currentVehicleModel: 'Toyota Innova Zenix · Silver',
        entryTime: '13.40 WIB',
        driverName: 'Denny Kurnia',
        duration: '55 Menit',
      ),
      const ParkingSlot(
        id: 'C-003',
        floor: 'Basement 2 (B2)',
        zone: 'Zona C',
        status: SlotStatus.available,
        vehicleType: VehicleType.car,
      ),
      const ParkingSlot(
        id: 'C-004',
        floor: 'Basement 2 (B2)',
        zone: 'Zona C',
        status: SlotStatus.available,
        vehicleType: VehicleType.car,
      ),
      const ParkingSlot(
        id: 'M-001',
        floor: 'Basement 2 (B2)',
        zone: 'Area Motor',
        status: SlotStatus.occupied,
        vehicleType: VehicleType.motorcycle,
        currentPlate: 'B 4123 ABC',
        currentVehicleModel: 'Yamaha NMAX · Hitam',
        entryTime: '08.30 WIB',
        driverName: 'Rian Pratama',
        duration: '6 Jam 05 Menit',
      ),
      const ParkingSlot(
        id: 'M-002',
        floor: 'Basement 2 (B2)',
        zone: 'Area Motor',
        status: SlotStatus.available,
        vehicleType: VehicleType.motorcycle,
      ),
      const ParkingSlot(
        id: 'M-003',
        floor: 'Basement 2 (B2)',
        zone: 'Area Motor',
        status: SlotStatus.available,
        vehicleType: VehicleType.motorcycle,
      ),
    ];
  }
}

