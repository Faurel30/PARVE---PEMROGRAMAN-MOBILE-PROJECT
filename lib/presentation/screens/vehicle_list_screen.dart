import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/ticket_data.dart';
import '../widgets/parve_header.dart';

class VehicleListScreen extends StatefulWidget {
  final Officer officer;
  final List<ValetVehicle> vehicles;
  final Function(ValetVehicle newVehicle, OfficerNotification newNotif)? onAddNewVehicle;
  final Function(ValetVehicle updatedVehicle, OfficerNotification? newNotif)? onUpdateVehicle;
  final VoidCallback onOpenNotifications;
  final VoidCallback onSwitchOfficer;

  const VehicleListScreen({
    super.key,
    required this.officer,
    required this.vehicles,
    this.onAddNewVehicle,
    this.onUpdateVehicle,
    required this.onOpenNotifications,
    required this.onSwitchOfficer,
  });

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  String _selectedFilter = 'Semua';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = [
    'Semua',
    'Mau Diparkir',
    'Terparkir',
    'Mau Diambil',
    'Sudah Keluar',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ValetVehicle> get _filteredVehicles {
    return widget.vehicles.where((v) {
      final matchesFilter = switch (_selectedFilter) {
        'Mau Diparkir' => v.status == ValetVehicleStatus.akanDatang,
        'Terparkir' => v.status == ValetVehicleStatus.terparkir,
        'Mau Diambil' => v.status == ValetVehicleStatus.mauDiambil,
        'Sudah Keluar' => v.status == ValetVehicleStatus.sudahDiambil,
        _ => true,
      };

      final q = _searchQuery.toLowerCase();
      final matchesSearch = q.isEmpty ||
          v.plateNumber.toLowerCase().contains(q) ||
          v.driverName.toLowerCase().contains(q) ||
          v.vehicleModel.toLowerCase().contains(q) ||
          v.slot.toLowerCase().contains(q) ||
          v.ticketNumber.toLowerCase().contains(q);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  int get _countAkanDatang =>
      widget.vehicles.where((v) => v.status == ValetVehicleStatus.akanDatang).length;
  int get _countTerparkir =>
      widget.vehicles.where((v) => v.status == ValetVehicleStatus.terparkir).length;
  int get _countMauDiambil =>
      widget.vehicles.where((v) => v.status == ValetVehicleStatus.mauDiambil).length;
  int get _countSudahDiambil =>
      widget.vehicles.where((v) => v.status == ValetVehicleStatus.sudahDiambil).length;

  void _showAssignSlotDialog(ValetVehicle vehicle) {
    String selectedSlot = 'A-012';
    final slots = ['A-012', 'A-015', 'B-008', 'B-014', 'C-005 (EV)'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: AppColors.goldBorder),
            ),
            title: Row(
              children: [
                const Icon(Icons.local_parking_rounded, color: AppColors.goldPrimary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Parkirkan ${vehicle.plateNumber}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pengemudi: ${vehicle.driverName}\nModel: ${vehicle.vehicleModel}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pilih Slot Parkir Tersedia:',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedSlot,
                      isExpanded: true,
                      dropdownColor: AppColors.card,
                      items: slots.map((s) {
                        return DropdownMenuItem(
                          value: s,
                          child: Text(
                            'Slot $s',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedSlot = val);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.goldPrimary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  final updated = vehicle.copyWith(
                    slot: selectedSlot,
                    status: ValetVehicleStatus.terparkir,
                    note: 'Mobil berhasil diparkirkan di Slot $selectedSlot oleh ${widget.officer.name}.',
                  );
                  final notif = OfficerNotification.fromVehicleStatus(
                    vehicle: updated,
                    status: ValetVehicleStatus.terparkir,
                  );
                  widget.onUpdateVehicle?.call(updated, notif);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '🅿️ ${vehicle.plateNumber} berhasil diparkirkan di Slot $selectedSlot',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: const Color(0xFF14241B),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text('Simpan & Terparkir', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showVehicleDetailSheet(ValetVehicle vehicle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      constraints: const BoxConstraints(maxWidth: 640),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header Detail
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.goldBorder),
                        ),
                        child: Text(
                          vehicle.plateNumber,
                          style: const TextStyle(
                            color: AppColors.goldPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vehicle.vehicleModel,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Tiket: ${vehicle.ticketNumber}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildStatusChip(vehicle.status),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Foto Kendaraan & Tag Cek Fisik Valet
                  Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: const Color(0xFF13151B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            vehicle.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) {
                              return Container(
                                color: const Color(0xFF1A1D24),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.directions_car_rounded,
                                        size: 48,
                                        color: AppColors.goldPrimary,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        vehicle.vehicleModel,
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            loadingBuilder: (ctx, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: const Color(0xFF1A1D24),
                                child: const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.goldPrimary,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          // Dark gradient overlay for bottom tags readability
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.75),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Top Tag: Foto Mobil Fisik Valet
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.75),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.goldBorder.withValues(alpha: 0.6)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.camera_alt_rounded, size: 12, color: AppColors.goldPrimary),
                                  SizedBox(width: 4),
                                  Text(
                                    'Foto Fisik Valet',
                                    style: TextStyle(
                                      color: AppColors.goldPrimary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Bottom Tag: Keterangan Transmisi & Cek Bodi
                          Positioned(
                            bottom: 10,
                            left: 10,
                            right: 10,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.85),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${vehicle.transmission} · ${vehicle.fuelType}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF14241B),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: AppColors.successGreen.withValues(alpha: 0.5)),
                                  ),
                                  child: Text(
                                    vehicle.bodyCondition,
                                    style: const TextStyle(
                                      color: AppColors.successGreen,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 10),

                  // Detail Fields & Keterangan Lengkap
                  _buildDetailRow(Icons.person_rounded, 'Pengemudi / Pemilik', vehicle.driverName),
                  _buildDetailRow(Icons.phone_rounded, 'Nomor Kontak', vehicle.phoneNumber),
                  _buildDetailRow(Icons.palette_rounded, 'Warna Kendaraan', vehicle.color),
                  _buildDetailRow(Icons.local_parking_rounded, 'Lokasi Slot', vehicle.slot),
                  _buildDetailRow(Icons.vpn_key_rounded, 'Posisi Kunci Valet', vehicle.keyLocker),
                  _buildDetailRow(Icons.speed_rounded, 'Transmisi / Mesin', '${vehicle.transmission} · ${vehicle.fuelType}'),
                  _buildDetailRow(Icons.verified_rounded, 'Kondisi Cek Fisik', vehicle.bodyCondition),
                  _buildDetailRow(Icons.access_time_rounded, 'Waktu Masuk', vehicle.entryTime),
                  if (vehicle.exitTime != null)
                    _buildDetailRow(Icons.logout_rounded, 'Waktu Pengambilan', vehicle.exitTime!),
                  _buildDetailRow(Icons.payments_rounded, 'Status Pembayaran', vehicle.paymentStatus),
                  _buildDetailRow(Icons.badge_rounded, 'Petugas Bertanggung Jawab', vehicle.officerName),
                  if (vehicle.note.isNotEmpty)
                    _buildDetailRow(Icons.notes_rounded, 'Catatan Valet', vehicle.note),

                  const SizedBox(height: 20),

                  // Action Buttons
                Row(
                  children: [
                    if (vehicle.status == ValetVehicleStatus.akanDatang) ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.goldPrimary,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.local_parking_rounded, size: 18),
                          label: const Text('Parkirkan ke Slot', style: TextStyle(fontWeight: FontWeight.w700)),
                          onPressed: () {
                            Navigator.pop(ctx);
                            _showAssignSlotDialog(vehicle);
                          },
                        ),
                      ),
                    ] else if (vehicle.status == ValetVehicleStatus.terparkir) ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF38BDF8),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.key_rounded, size: 18),
                          label: const Text('Siapkan untuk Diambil', style: TextStyle(fontWeight: FontWeight.w700)),
                          onPressed: () {
                            Navigator.pop(ctx);
                            final updated = vehicle.copyWith(
                              status: ValetVehicleStatus.mauDiambil,
                              note: 'Customer meminta mobil disiapkan di Lobi Pick-up.',
                            );
                                                        final notif = OfficerNotification.fromVehicleStatus(vehicle: updated, status: ValetVehicleStatus.mauDiambil);
                            widget.onUpdateVehicle?.call(updated, notif);
                          },
                        ),
                      ),
                    ] else if (vehicle.status == ValetVehicleStatus.mauDiambil) ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.successGreen,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.check_circle_rounded, size: 18),
                          label: const Text('Konfirmasi Selesai Diambil', style: TextStyle(fontWeight: FontWeight.w700)),
                          onPressed: () {
                            Navigator.pop(ctx);
                            final updated = vehicle.copyWith(
                              status: ValetVehicleStatus.sudahDiambil,
                              exitTime: '${DateTime.now().hour}.${DateTime.now().minute} WIB',
                              note: 'Selesai serah terima kunci dan mobil keluar area valet.',
                            );
                                                        final notif2 = OfficerNotification.fromVehicleStatus(vehicle: updated, status: ValetVehicleStatus.sudahDiambil);
                            widget.onUpdateVehicle?.call(updated, notif2);
                          },
                        ),
                      ),
                    ],
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.card,
                        foregroundColor: AppColors.textPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Tutup'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          )),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.goldPrimary, size: 17),
          const SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.5,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ValetVehicleStatus status) {
    Color bg;
    Color fg;
    IconData icon;

    switch (status) {
      case ValetVehicleStatus.akanDatang:
        bg = const Color(0xFF3D2E14);
        fg = AppColors.goldPrimary;
        icon = Icons.directions_car_rounded;
        break;
      case ValetVehicleStatus.terparkir:
        bg = AppColors.successGreenDark;
        fg = AppColors.successGreen;
        icon = Icons.local_parking_rounded;
        break;
      case ValetVehicleStatus.mauDiambil:
        bg = const Color(0xFF0C2938);
        fg = const Color(0xFF38BDF8);
        icon = Icons.key_rounded;
        break;
      case ValetVehicleStatus.sudahDiambil:
        bg = const Color(0xFF232630);
        fg = AppColors.textSecondary;
        icon = Icons.check_circle_outline_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: fg, size: 13),
          const SizedBox(width: 5),
          Text(
            status.shortLabel,
            style: TextStyle(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredVehicles;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Petugas
          ParveHeader(
            officer: widget.officer,
            unreadNotifications: 1,
            onNotificationTap: widget.onOpenNotifications,
            onSwitchOfficer: widget.onSwitchOfficer,
          ),
          const SizedBox(height: 16),

          // Title Section
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Antrean & Daftar Kendaraan',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Kelola mobil masuk, parkir di slot, dan permintaan ambil',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  '${widget.vehicles.length} Total',
                  style: const TextStyle(
                    color: AppColors.goldPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Metrics Summary Cards
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSummaryBadge(
                  label: 'Mau Diparkir',
                  count: _countAkanDatang,
                  color: AppColors.goldPrimary,
                  icon: Icons.directions_car_rounded,
                  isActive: _selectedFilter == 'Mau Diparkir',
                  onTap: () => setState(() => _selectedFilter = 'Mau Diparkir'),
                ),
                const SizedBox(width: 8),
                _buildSummaryBadge(
                  label: 'Terparkir',
                  count: _countTerparkir,
                  color: AppColors.successGreen,
                  icon: Icons.local_parking_rounded,
                  isActive: _selectedFilter == 'Terparkir',
                  onTap: () => setState(() => _selectedFilter = 'Terparkir'),
                ),
                const SizedBox(width: 8),
                _buildSummaryBadge(
                  label: 'Mau Diambil',
                  count: _countMauDiambil,
                  color: const Color(0xFF38BDF8),
                  icon: Icons.key_rounded,
                  isActive: _selectedFilter == 'Mau Diambil',
                  onTap: () => setState(() => _selectedFilter = 'Mau Diambil'),
                ),
                const SizedBox(width: 8),
                _buildSummaryBadge(
                  label: 'Sudah Keluar',
                  count: _countSudahDiambil,
                  color: AppColors.textSecondary,
                  icon: Icons.check_circle_outline_rounded,
                  isActive: _selectedFilter == 'Sudah Keluar',
                  onTap: () => setState(() => _selectedFilter = 'Sudah Keluar'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Search Bar
          TextField(
            controller: _searchController,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 13.5),
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Cari plat, pengemudi, mobil, atau slot...',
              hintStyle: const TextStyle(color: AppColors.textSubtle, fontSize: 13),
              filled: true,
              fillColor: AppColors.card,
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.goldPrimary, size: 19),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.goldPrimary),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Filter Segmented Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.black : AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.goldPrimary,
                    backgroundColor: AppColors.card,
                    side: BorderSide(
                      color: isSelected ? AppColors.goldPrimary : AppColors.border,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedFilter = filter);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // Vehicle List
          if (filtered.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.cardSubtle,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Icon(Icons.car_crash_rounded, color: AppColors.textMuted, size: 40),
                  const SizedBox(height: 12),
                  const Text(
                    'Tidak Ada Kendaraan Sesuai Filter',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Coba ubah kata kunci pencarian atau pilih filter status lain.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldPrimary,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _selectedFilter = 'Semua';
                        _searchQuery = '';
                      });
                    },
                    child: const Text('Reset Filter'),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final v = filtered[index];
                return _buildVehicleCard(v);
              },
            ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSummaryBadge({
    required String label,
    required int count,
    required Color color,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isActive ? color.withValues(alpha: 0.15) : AppColors.card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? color : AppColors.border,
              width: isActive ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? color : AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleCard(ValetVehicle vehicle) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => _showVehicleDetailSheet(vehicle),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border, width: 0.9),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Plate & Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.goldBorder),
                    ),
                    child: Text(
                      vehicle.plateNumber,
                      style: const TextStyle(
                        color: AppColors.goldPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  _buildStatusChip(vehicle.status),
                ],
              ),
              const SizedBox(height: 10),

              // Row 2: Driver & Vehicle Model
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.driverName,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          vehicle.vehicleModel,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Slot Info Box
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Lokasi Slot',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                        ),
                        Text(
                          vehicle.slot,
                          style: const TextStyle(
                            color: AppColors.goldPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: AppColors.divider, height: 1),
              const SizedBox(height: 10),

              // Row 3: Waktu Masuk & Quick Action Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, color: AppColors.textMuted, size: 14),
                      const SizedBox(width: 5),
                      Text(
                        'Masuk: ${vehicle.entryTime}',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 11.5),
                      ),
                    ],
                  ),

                  // Action Buttons based on status
                  if (vehicle.status == ValetVehicleStatus.akanDatang)
                    InkWell(
                      onTap: () => _showAssignSlotDialog(vehicle),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.goldDarkBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.goldBorder),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.local_parking_rounded, color: AppColors.goldPrimary, size: 14),
                            SizedBox(width: 5),
                            Text(
                              'Parkirkan',
                              style: TextStyle(
                                color: AppColors.goldPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (vehicle.status == ValetVehicleStatus.mauDiambil)
                    InkWell(
                      onTap: () {
                        final updated = vehicle.copyWith(
                          status: ValetVehicleStatus.sudahDiambil,
                          exitTime: '${DateTime.now().hour}.${DateTime.now().minute} WIB',
                          note: 'Selesai serah terima di lobi.',
                        );
                                                final notifCard = OfficerNotification.fromVehicleStatus(vehicle: updated, status: ValetVehicleStatus.sudahDiambil);
                        widget.onUpdateVehicle?.call(updated, notifCard);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0C2938),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF164E63)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_rounded, color: Color(0xFF38BDF8), size: 14),
                            SizedBox(width: 5),
                            Text(
                              'Serahkan',
                              style: TextStyle(
                                color: Color(0xFF38BDF8),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lihat Detail',
                          style: TextStyle(
                            color: AppColors.goldMutedText,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: AppColors.goldMutedText, size: 16),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
