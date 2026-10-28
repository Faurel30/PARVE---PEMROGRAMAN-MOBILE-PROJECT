import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/ticket_data.dart';
import '../../core/models/parking_slot.dart';
import '../widgets/parve_header.dart';

class ParkingSlotScreen extends StatefulWidget {
  final Officer officer;
  final VoidCallback onOpenNotifications;
  final VoidCallback onSwitchOfficer;

  const ParkingSlotScreen({
    super.key,
    required this.officer,
    required this.onOpenNotifications,
    required this.onSwitchOfficer,
  });

  @override
  State<ParkingSlotScreen> createState() => _ParkingSlotScreenState();
}

class _ParkingSlotScreenState extends State<ParkingSlotScreen> {
  final List<ParkingSlot> _allSlots = ParkingSlot.generateSampleSlots();
  String _selectedFloor = 'Semua Lantai';
  String _selectedVehicleType = 'Semua';
  String _searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ParkingSlot> get _filteredSlots {
    return _allSlots.where((slot) {
      final matchesFloor = _selectedFloor == 'Semua Lantai' ||
          slot.floor.contains(_selectedFloor.replaceAll('Lantai ', ''));

      final matchesType = _selectedVehicleType == 'Semua' ||
          (_selectedVehicleType == 'Mobil' &&
              (slot.vehicleType == VehicleType.car ||
                  slot.vehicleType == VehicleType.vip)) ||
          (_selectedVehicleType == 'Motor' &&
              slot.vehicleType == VehicleType.motorcycle) ||
          (_selectedVehicleType == 'VIP' &&
              slot.vehicleType == VehicleType.vip);

      final matchesSearch = _searchQuery.isEmpty ||
          slot.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (slot.currentPlate != null &&
              slot.currentPlate!
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase())) ||
          (slot.driverName != null &&
              slot.driverName!
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()));

      return matchesFloor && matchesType && matchesSearch;
    }).toList();
  }

  int get _totalAvailable =>
      _allSlots.where((s) => s.status == SlotStatus.available).length;
  int get _totalOccupied =>
      _allSlots.where((s) => s.status == SlotStatus.occupied).length;
  int get _totalReserved =>
      _allSlots.where((s) => s.status == SlotStatus.reserved).length;

  void _showSlotDetail(ParkingSlot slot) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            color: Color(0xFF16181F),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle pill
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Slot Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF231D12),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: AppColors.goldBorder, width: 1),
                        ),
                        child: Text(
                          slot.id,
                          style: const TextStyle(
                            color: AppColors.goldPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            slot.floor,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            slot.zone,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  _buildStatusBadge(slot.status),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.divider, height: 1),
              const SizedBox(height: 16),

              // Detail Section
              if (slot.status == SlotStatus.available) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.successGreenDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.successGreenBorder, width: 1),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.successGreen,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Slot Kosong & Siap Digunakan',
                              style: TextStyle(
                                color: AppColors.successGreen,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Petugas dapat mengarahkan kendaraan yang baru masuk ke slot ini.',
                              style: TextStyle(
                                color: AppColors.successGreenMuted,
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('Plat Nomor', slot.currentPlate ?? '-'),
                      const SizedBox(height: 10),
                      _buildInfoRow(
                          'Model Kendaraan', slot.currentVehicleModel ?? '-'),
                      const SizedBox(height: 10),
                      _buildInfoRow(
                          'Nama Pengemudi', slot.driverName ?? '-'),
                      const SizedBox(height: 10),
                      _buildInfoRow('Waktu Masuk', slot.entryTime ?? '-'),
                      const SizedBox(height: 10),
                      _buildInfoRow('Durasi Terparkir', slot.duration ?? '-'),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Tutup',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Slot ${slot.id} berhasil ditandai oleh ${widget.officer.name}.',
                            ),
                            backgroundColor: AppColors.surface,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.goldPrimary,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Pilih Slot',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredSlots;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (PARVE Logo, Pacific Place, Officer Card)
          ParveHeader(
            officer: widget.officer,
            unreadNotifications: 1,
            onNotificationTap: widget.onOpenNotifications,
            onSwitchOfficer: widget.onSwitchOfficer,
          ),
          const SizedBox(height: 18),

          // Title & Description
          const Text(
            'Slot Parkir',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Pemantauan ketersediaan slot kendaraan di Pacific Place secara real-time.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // 1. KPI Summary Cards (Tersedia, Terisi, Terbooking)
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: 'Tersedia',
                  count: '$_totalAvailable',
                  color: AppColors.successGreen,
                  bgColor: AppColors.successGreenDark,
                  borderColor: AppColors.successGreenBorder,
                  icon: Icons.check_circle_outline_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSummaryCard(
                  title: 'Terisi',
                  count: '$_totalOccupied',
                  color: const Color(0xFFFF5252),
                  bgColor: const Color(0xFF281416),
                  borderColor: const Color(0xFF4D2225),
                  icon: Icons.directions_car_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSummaryCard(
                  title: 'Booking',
                  count: '$_totalReserved',
                  color: AppColors.goldPrimary,
                  bgColor: AppColors.goldDarkBg,
                  borderColor: AppColors.goldBorder,
                  icon: Icons.bookmark_border_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2. Search Field
          TextField(
            controller: _searchController,
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            style: const TextStyle(color: Colors.white, fontSize: 13.5),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface,
              hintText: 'Cari no. slot (A-018), plat, atau nama...',
              hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.textMuted, size: 18),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 3. Filter Chips: Lantai
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'Semua Lantai',
                  isSelected: _selectedFloor == 'Semua Lantai',
                  onTap: () => setState(() => _selectedFloor = 'Semua Lantai'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Basement 1 (B1)',
                  isSelected: _selectedFloor == 'Basement 1 (B1)',
                  onTap: () => setState(() => _selectedFloor = 'Basement 1 (B1)'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Basement 2 (B2)',
                  isSelected: _selectedFloor == 'Basement 2 (B2)',
                  onTap: () => setState(() => _selectedFloor = 'Basement 2 (B2)'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 4. Filter Chips: Jenis Kendaraan
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'Semua Jenis',
                  isSelected: _selectedVehicleType == 'Semua',
                  onTap: () => setState(() => _selectedVehicleType = 'Semua'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Mobil',
                  isSelected: _selectedVehicleType == 'Mobil',
                  onTap: () => setState(() => _selectedVehicleType = 'Mobil'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Motor',
                  isSelected: _selectedVehicleType == 'Motor',
                  onTap: () => setState(() => _selectedVehicleType = 'Motor'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'VIP',
                  isSelected: _selectedVehicleType == 'VIP',
                  onTap: () => setState(() => _selectedVehicleType = 'VIP'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 5. Slot Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daftar Slot (${filtered.length})',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.refresh_rounded, color: AppColors.textMuted, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Real-time',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (filtered.isEmpty)
            _buildEmptyFilteredState()
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.35,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final slot = filtered[index];
                return _buildSlotCard(slot);
              },
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String count,
    required Color color,
    required Color bgColor,
    required Color borderColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(icon, color: color, size: 16),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.goldDarkBg : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.goldBorder : AppColors.border,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.goldPrimary : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSlotCard(ParkingSlot slot) {
    Color statusColor;
    Color statusBg;
    String statusText;

    switch (slot.status) {
      case SlotStatus.available:
        statusColor = AppColors.successGreen;
        statusBg = AppColors.successGreenDark;
        statusText = 'KOSONG';
        break;
      case SlotStatus.occupied:
        statusColor = const Color(0xFFFF5252);
        statusBg = const Color(0xFF281416);
        statusText = 'TERISI';
        break;
      case SlotStatus.reserved:
        statusColor = AppColors.goldPrimary;
        statusBg = AppColors.goldDarkBg;
        statusText = 'BOOKING';
        break;
    }

    return InkWell(
      onTap: () => _showSlotDetail(slot),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: slot.id == 'A-018'
                ? AppColors.goldBorder
                : AppColors.border,
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top: Slot ID & Status Pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  slot.id,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.5),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            // Middle: Plate Number or Available Indicator
            if (slot.status == SlotStatus.available)
              Row(
                children: [
                  Icon(
                    slot.vehicleType == VehicleType.motorcycle
                        ? Icons.two_wheeler_rounded
                        : Icons.directions_car_rounded,
                    color: AppColors.successGreen,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Siap Pakai',
                    style: TextStyle(
                      color: AppColors.successGreenMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slot.currentPlate ?? '-',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    slot.driverName ?? '-',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),

            // Bottom: Floor tag
            Text(
              '${slot.floor} · ${slot.zone}',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(SlotStatus status) {
    Color color;
    Color bg;
    String label;

    switch (status) {
      case SlotStatus.available:
        color = AppColors.successGreen;
        bg = AppColors.successGreenDark;
        label = 'Tersedia';
        break;
      case SlotStatus.occupied:
        color = const Color(0xFFFF5252);
        bg = const Color(0xFF281416);
        label = 'Terisi';
        break;
      case SlotStatus.reserved:
        color = AppColors.goldPrimary;
        bg = AppColors.goldDarkBg;
        label = 'Dibooking';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.6), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.5,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyFilteredState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            color: AppColors.textMuted,
            size: 38,
          ),
          SizedBox(height: 10),
          Text(
            'Tidak ada slot parkir yang cocok',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

