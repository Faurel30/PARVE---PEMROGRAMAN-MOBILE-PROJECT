import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../models/auth_store.dart';
import '../models/booking_models.dart';
import '../widgets/booking_step_header.dart';
import 'pesan_valet_screen.dart';

enum _MallFilter { all, availableOnly, withActiveTicket }

class DaftarMallScreen extends StatefulWidget {
  const DaftarMallScreen({super.key});

  @override
  State<DaftarMallScreen> createState() => _DaftarMallScreenState();
}

class _DaftarMallScreenState extends State<DaftarMallScreen> {
  final TextEditingController _searchController = TextEditingController();
  _MallFilter _selectedFilter = _MallFilter.all;
  String _query = '';
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  String _formatLiveWorldClock() {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    final s = now.second.toString().padLeft(2, '0');
    return '$h:$m:$s WIB';
  }

  List<ValetLocation> get _filteredMalls {
    return ValetLocation.presets.where((mall) {
      final matchesQuery = _query.isEmpty ||
          mall.name.toLowerCase().contains(_query.toLowerCase()) ||
          mall.lobbySubtitle.toLowerCase().contains(_query.toLowerCase()) ||
          mall.address.toLowerCase().contains(_query.toLowerCase());
      if (!matchesQuery) return false;

      return switch (_selectedFilter) {
        _MallFilter.all => true,
        _MallFilter.availableOnly => mall.canBookValet,
        _MallFilter.withActiveTicket => mall.occupiedSlots > 0,
      };
    }).toList();
  }

  Future<void> _openBookingForMall(ValetLocation mall) async {
    if (!mall.canBookValet) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            !mall.isMallOpen
                ? '${mall.name} sedang tutup. Jam operasional: ${mall.operatingHours}.'
                : '15 slot parkir valet di ${mall.name} sedang penuh (0/15 tersedia).',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PesanValetScreen(initialLocation: mall),
      ),
    );
    if (mounted) setState(() {});
  }

  void _showMallDetailBottomSheet(ValetLocation mall) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final bool isOpen = mall.isMallOpen;
            final bool hasParking = mall.canBookValet;
            final int avail = mall.availableSlots;
            final int occupied = mall.occupiedSlots;
            final int total = mall.totalSlots;

            void mutateSlots(VoidCallback fn) {
              fn();
              setModalState(() {});
              if (mounted) setState(() {});
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(21, 14, 21, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.cardBorder,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.navPillBg,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(
                            Icons.storefront_outlined,
                            color: AppColors.navActive,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mall.name,
                                style: TextStyle(
                                  color: AppColors.darkPrimary,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                mall.address,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12.2,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _DetailStatusBox(
                            label: 'STATUS MALL (REAL-TIME)',
                            value: isOpen ? 'Sedang Buka' : 'Sedang Tutup',
                            subvalue: '${mall.operatingHours} (Setiap Hari)',
                            icon: isOpen
                                ? Icons.access_time_filled_rounded
                                : Icons.lock_clock_outlined,
                            accentColor: isOpen
                                ? AppColors.badgeGreen
                                : const Color(0xFFB84A39),
                            bgColor: isOpen
                                ? AppColors.badgeBg
                                : const Color(0xFFFDEDEA),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _DetailStatusBox(
                            label: 'KAPASITAS 15 SLOT VALET',
                            value: hasParking
                                ? 'Tersedia $avail / $total Slot'
                                : (!isOpen ? 'Tutup' : 'Penuh (0 / $total Slot)'),
                            subvalue: occupied > 0
                                ? '$occupied slot terisi tiket aktif'
                                : 'Semua 15 slot masih kosong',
                            icon: hasParking
                                ? Icons.local_parking_rounded
                                : Icons.block_rounded,
                            accentColor: hasParking
                                ? AppColors.badgeGreen
                                : const Color(0xFFB85D19),
                            bgColor: hasParking
                                ? AppColors.badgeBg
                                : const Color(0xFFFFF3E6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Panel Simulasi Slot Parkir Real-Time (untuk demo pengujian)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.heroDark,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'SIMULASI TIKET AKTIF & SLOT PARKIR',
                                style: TextStyle(
                                  color: AppColors.goldText,
                                  fontSize: 10.2,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                'Terisi: $occupied / $total slot',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.4,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _SimSlotButton(
                                  label: '+1 Tiket Aktif (-1 Slot)',
                                  onTap: () => mutateSlots(
                                    () => AuthStore.adjustMallOccupiedSlots(
                                      mall.name,
                                      1,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: _SimSlotButton(
                                  label: '-1 Selesai (+1 Slot)',
                                  onTap: () => mutateSlots(
                                    () => AuthStore.adjustMallOccupiedSlots(
                                      mall.name,
                                      -1,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              _SimSlotButton(
                                label: 'Reset',
                                onTap: () => mutateSlots(
                                  () => AuthStore.resetMallSlots(mall.name),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSubtle,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        children: [
                          _InfoRow(
                            label: 'Titik serah terima (Lobi)',
                            value: mall.lobbySubtitle,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            child: Divider(height: 1, color: AppColors.divider),
                          ),
                          _InfoRow(
                            label: 'Area parkir khusus valet',
                            value: mall.parkingArea,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            child: Divider(height: 1, color: AppColors.divider),
                          ),
                          _InfoRow(
                            label: 'Status waktu dunia saat ini',
                            value: mall.mallStatusLabel,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            child: Divider(height: 1, color: AppColors.divider),
                          ),
                          const _InfoRow(
                            label: 'Tarif layanan valet',
                            value: 'Rp35.000 (awal) + Rp5.000/jam',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final item in mall.facilities)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.navPillBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified_outlined,
                                  size: 13.5,
                                  color: AppColors.navActive,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  item,
                                  style: TextStyle(
                                    color: AppColors.navActive,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hasParking
                              ? AppColors.goldButton
                              : AppColors.surfaceSubtle,
                          foregroundColor: hasParking
                              ? AppColors.onGold
                              : AppColors.textMuted,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        onPressed: hasParking
                            ? () {
                                Navigator.pop(ctx);
                                _openBookingForMall(mall);
                              }
                            : null,
                        icon: Icon(
                          hasParking
                              ? Icons.directions_car_filled_outlined
                              : Icons.lock_outline_rounded,
                          size: 19,
                        ),
                        label: Text(
                          hasParking
                              ? 'Pesan valet di ${mall.name} ($avail/$total slot)'
                              : (!isOpen
                                  ? 'Mall sedang tutup (${mall.operatingHours})'
                                  : 'Slot parkir valet penuh (0/$total slot)'),
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final allMalls = ValetLocation.presets;
    final openCount = allMalls.where((m) => m.isMallOpen).length;
    final totalAvailableSlots =
        allMalls.fold<int>(0, (sum, m) => sum + m.availableSlots);
    final totalCapacitySlots =
        allMalls.fold<int>(0, (sum, m) => sum + m.totalSlots);
    final activeMallCount =
        allMalls.where((m) => m.occupiedSlots > 0).length;
    final filtered = _filteredMalls;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppColors.pageOverlayStyle,
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(21, 12, 21, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BookingTopBar(title: 'Valet di dekat Anda'),
                    const SizedBox(height: 12),
                    _buildLiveClockHeader(),
                    const SizedBox(height: 10),
                    _buildSummaryBanner(
                      totalCount: allMalls.length,
                      openCount: openCount,
                      totalAvailableSlots: totalAvailableSlots,
                      totalCapacitySlots: totalCapacitySlots,
                    ),
                    const SizedBox(height: 12),
                    _buildSearchBar(),
                    const SizedBox(height: 10),
                    _buildFilterChips(
                      totalCount: allMalls.length,
                      availableCount:
                          allMalls.where((m) => m.canBookValet).length,
                      activeMallCount: activeMallCount,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(21, 4, 21, 28),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final mall = filtered[index];
                          return _MallInfoCard(
                            mall: mall,
                            onDetailTap: () => _showMallDetailBottomSheet(mall),
                            onBookTap: () => _openBookingForMall(mall),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveClockHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.softGoldBanner,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.public_rounded,
                size: 15,
                color: AppColors.navActive,
              ),
              const SizedBox(width: 6),
              Text(
                AuthStore.formatRealTimeFullDate(),
                style: TextStyle(
                  color: AppColors.navActive,
                  fontSize: 11.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            _formatLiveWorldClock(),
            style: TextStyle(
              color: AppColors.darkPrimary,
              fontSize: 11.8,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBanner({
    required int totalCount,
    required int openCount,
    required int totalAvailableSlots,
    required int totalCapacitySlots,
  }) {
    final totalOccupied = totalCapacitySlots - totalAvailableSlots;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.heroDark,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryMetric(
              label: 'Total Lokasi',
              value: '$totalCount Mall',
              sublabel: '15 slot / mall',
            ),
          ),
          Container(
            width: 1,
            height: 34,
            color: const Color(0xFF363A34),
          ),
          Expanded(
            child: _SummaryMetric(
              label: 'Status Real-Time',
              value: '$openCount Buka',
              sublabel: openCount == totalCount
                  ? '10.00–22.00 WIB'
                  : '${totalCount - openCount} tutup',
            ),
          ),
          Container(
            width: 1,
            height: 34,
            color: const Color(0xFF363A34),
          ),
          Expanded(
            child: _SummaryMetric(
              label: 'Sisa Slot Valet',
              value: '$totalAvailableSlots / $totalCapacitySlots Slot',
              sublabel: '$totalOccupied terisi tiket aktif',
              isGold: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: AppColors.textMuted,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _query = val.trim()),
              style: TextStyle(
                color: AppColors.darkPrimary,
                fontSize: 13.5,
              ),
              decoration: InputDecoration(
                hintText: 'Cari dari 5 mall (Summarecon, GI, PIM 2, Sency, PP)...',
                hintStyle: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12.4,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (_query.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() => _query = '');
              },
              child: Icon(
                Icons.close_rounded,
                color: AppColors.textMuted,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChips({
    required int totalCount,
    required int availableCount,
    required int activeMallCount,
  }) {
    final items = [
      (
        filter: _MallFilter.all,
        label: 'Semua Mall ($totalCount)',
      ),
      (
        filter: _MallFilter.availableOnly,
        label: 'Parkir Tersedia ($availableCount)',
      ),
      (
        filter: _MallFilter.withActiveTicket,
        label: 'Ada Tiket Aktif ($activeMallCount)',
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            GestureDetector(
              onTap: () => setState(() => _selectedFilter = items[i].filter),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: _selectedFilter == items[i].filter
                      ? AppColors.darkPrimary
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _selectedFilter == items[i].filter
                        ? AppColors.darkPrimary
                        : AppColors.cardBorder,
                  ),
                ),
                child: Text(
                  items[i].label,
                  style: TextStyle(
                    color: _selectedFilter == items[i].filter
                        ? AppColors.surface
                        : AppColors.textSecondary,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 44,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 12),
            Text(
              'Mall tidak ditemukan',
              style: TextStyle(
                color: AppColors.darkPrimary,
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Coba ubah kata kunci pencarian atau pilih filter Semua Mall.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final String label;
  final String value;
  final String sublabel;
  final bool isGold;

  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.sublabel,
    this.isGold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFA0A39E),
              fontSize: 10.6,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              color: isGold ? AppColors.goldText : Colors.white,
              fontSize: 13.4,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sublabel,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF8B8E88),
              fontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _MallInfoCard extends StatelessWidget {
  final ValetLocation mall;
  final VoidCallback onDetailTap;
  final VoidCallback onBookTap;

  const _MallInfoCard({
    required this.mall,
    required this.onDetailTap,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOpen = mall.isMallOpen;
    final bool hasParking = mall.canBookValet;
    final int avail = mall.availableSlots;
    final int occupied = mall.occupiedSlots;
    final int total = mall.totalSlots;
    final double ratio = total > 0 ? (avail / total).clamp(0.0, 1.0) : 0.0;

    return GestureDetector(
      onTap: onDetailTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: occupied > 0 ? AppColors.goldButton : AppColors.cardBorder,
            width: occupied > 0 ? 1.5 : 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner Foto Mall + Badge Status Real-Time Buka/Tutup & Slot
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: ColorFiltered(
                    colorFilter: isOpen
                        ? const ColorFilter.mode(
                            Colors.transparent,
                            BlendMode.multiply,
                          )
                        : const ColorFilter.mode(
                            Color(0x88000000),
                            BlendMode.darken,
                          ),
                    child: Image.asset(
                      mall.imageAsset,
                      height: 132,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: _OverlayPill(
                    icon: isOpen
                        ? Icons.storefront_rounded
                        : Icons.lock_clock_outlined,
                    text: isOpen
                        ? 'Mall Buka (${mall.operatingHours})'
                        : 'Mall Tutup (${mall.operatingHours})',
                    bgColor: isOpen
                        ? const Color(0xE61E3A2F)
                        : const Color(0xE64A1F1B),
                    textColor: isOpen
                        ? const Color(0xFF8FF0C4)
                        : const Color(0xFFFFB4A9),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: _OverlayPill(
                    icon: Icons.near_me_outlined,
                    text: mall.distanceKm,
                    bgColor: const Color(0xD920231F),
                    textColor: Colors.white,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: _OverlayPill(
                    icon: hasParking
                        ? Icons.local_parking_rounded
                        : Icons.error_outline_rounded,
                    text: hasParking
                        ? 'Parkir Tersedia ($avail/$total slot)'
                        : (!isOpen ? 'Valet Tutup' : 'Parkir Penuh (0/$total)'),
                    bgColor: hasParking
                        ? const Color(0xE61E3A2F)
                        : const Color(0xE6523212),
                    textColor: hasParking
                        ? const Color(0xFF8FF0C4)
                        : const Color(0xFFFFD199),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            // Nama Mall & Lobi
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.navPillBg,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: AppColors.navActive,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mall.name,
                        style: TextStyle(
                          color: AppColors.darkPrimary,
                          fontSize: 15.8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${mall.lobbySubtitle} • Area ${mall.shortSlot}',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        mall.address,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (occupied > 0) ...[
              const SizedBox(height: 11),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.softGoldBanner,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.directions_car_filled_outlined,
                      size: 15,
                      color: AppColors.navActive,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        '$occupied slot sedang dipakai tiket aktif • Sisa $avail dari $total slot valet',
                        style: TextStyle(
                          color: AppColors.navActive,
                          fontSize: 11.4,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            // Kotak Informasi Operasional Mall & Ketersediaan 15 Slot Parkir
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 15,
                            color: isOpen
                                ? AppColors.badgeGreen
                                : const Color(0xFFB84A39),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Status Mall (Real-Time)',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11.6,
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        child: Text(
                          mall.mallStatusLabel,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: isOpen
                                ? AppColors.badgeGreen
                                : const Color(0xFFB84A39),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.local_parking_rounded,
                            size: 15,
                            color: hasParking
                                ? AppColors.badgeGreen
                                : const Color(0xFFB85D19),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Slot Parkir Valet',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11.6,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        hasParking
                            ? 'Tersedia • $avail / $total slot'
                            : (!isOpen
                                ? 'Tutup • 0 / $total slot'
                                : 'Penuh • 0 / $total slot'),
                        style: TextStyle(
                          color: hasParking
                              ? AppColors.badgeGreen
                              : const Color(0xFFB85D19),
                          fontSize: 11.6,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 6,
                      backgroundColor: AppColors.cardBorder,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        hasParking
                            ? AppColors.badgeGreen
                            : const Color(0xFFD67D3E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Baris Aksi: Info Mall & Pesan Valet
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkPrimary,
                      side: BorderSide(color: AppColors.cardBorder, width: 1.2),
                      minimumSize: const Size.fromHeight(42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    onPressed: onDetailTap,
                    icon: const Icon(Icons.info_outline_rounded, size: 16),
                    label: const Text(
                      'Info & Simulasi',
                      style: TextStyle(
                        fontSize: 12.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasParking
                          ? AppColors.goldButton
                          : AppColors.surfaceSubtle,
                      foregroundColor: hasParking
                          ? AppColors.onGold
                          : AppColors.textMuted,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    onPressed: onBookTap,
                    icon: Icon(
                      hasParking
                          ? Icons.arrow_forward_rounded
                          : Icons.block_rounded,
                      size: 16,
                    ),
                    label: Text(
                      hasParking
                          ? 'Pesan valet'
                          : (!isOpen ? 'Mall tutup' : 'Parkir penuh'),
                      style: const TextStyle(
                        fontSize: 12.4,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SimSlotButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SimSlotButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF30352E),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10.6,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _OverlayPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color bgColor;
  final Color textColor;

  const _OverlayPill({
    required this.icon,
    required this.text,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 11.2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailStatusBox extends StatelessWidget {
  final String label;
  final String value;
  final String subvalue;
  final IconData icon;
  final Color accentColor;
  final Color bgColor;

  const _DetailStatusBox({
    required this.label,
    required this.value,
    required this.subvalue,
    required this.icon,
    required this.accentColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: accentColor),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 9.8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: accentColor,
              fontSize: 13.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subvalue,
            style: TextStyle(
              color: accentColor.withValues(alpha: 0.85),
              fontSize: 10.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.2,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.darkPrimary,
              fontSize: 12.4,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
