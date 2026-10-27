import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../models/auth_store.dart';
import '../widgets/booking_step_header.dart';
import '../widgets/parve_text_field.dart';
import '../widgets/vehicle_illustration.dart';

class KendaraanSayaScreen extends StatefulWidget {
  const KendaraanSayaScreen({super.key});

  @override
  State<KendaraanSayaScreen> createState() => _KendaraanSayaScreenState();
}

class _KendaraanSayaScreenState extends State<KendaraanSayaScreen> {
  Future<Uint8List?> _pickVehiclePhoto(BuildContext sheetContext) async {
    final choice = await showModalBottomSheet<String>(
      context: sheetContext,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Unggah Foto Kendaraan',
                    style: TextStyle(
                      color: AppColors.darkPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.navActive,
                ),
                title: Text(
                  'Pilih Foto Mobil dari Galeri',
                  style: TextStyle(color: AppColors.darkPrimary),
                ),
                subtitle: Text(
                  'Unggah foto kendaraan dari perangkat Anda',
                  style: TextStyle(color: AppColors.textMuted),
                ),
                onTap: () => Navigator.pop(ctx, 'gallery'),
              ),
              ListTile(
                leading: Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.navActive,
                ),
                title: Text(
                  'Ambil Foto dari Kamera',
                  style: TextStyle(color: AppColors.darkPrimary),
                ),
                subtitle: Text(
                  'Potret langsung ciri unik mobil Anda',
                  style: TextStyle(color: AppColors.textMuted),
                ),
                onTap: () => Navigator.pop(ctx, 'camera'),
              ),
              ListTile(
                leading: Icon(
                  Icons.folder_open_rounded,
                  color: AppColors.navActive,
                ),
                title: Text(
                  'Masukkan Path File Foto Lokal',
                  style: TextStyle(color: AppColors.darkPrimary),
                ),
                subtitle: Text(
                  'Opsional: muat file .png/.jpg dari penyimpanan',
                  style: TextStyle(color: AppColors.textMuted),
                ),
                onTap: () => Navigator.pop(ctx, 'path'),
              ),
            ],
          ),
        ),
      ),
    );

    if (choice == null || !mounted) return null;

    if (choice == 'path') {
      final pathCtrl = TextEditingController();
      final customPath = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'Path File Foto',
            style: TextStyle(color: AppColors.darkPrimary),
          ),
          content: TextField(
            controller: pathCtrl,
            style: TextStyle(color: AppColors.darkPrimary),
            decoration: const InputDecoration(
              hintText: 'Contoh: assets/images/toyota_veloz.png',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, pathCtrl.text.trim()),
              child: const Text('Muat Foto'),
            ),
          ],
        ),
      );
      if (customPath != null && customPath.isNotEmpty) {
        try {
          final file = File(customPath);
          if (await file.exists()) {
            return await file.readAsBytes();
          }
        } catch (_) {}
      }
    }

    final data = await rootBundle.load('assets/images/toyota_veloz.png');
    return data.buffer.asUint8List();
  }

  void _openVehicleForm({SavedVehicle? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final plateCtrl = TextEditingController(text: existing?.plateNumber ?? '');
    final colorCtrl = TextEditingController(text: existing?.color ?? '');
    final yearCtrl = TextEditingController(text: existing?.year ?? '2024');
    Uint8List? selectedPhoto = existing?.photoBytes;
    bool isPrimary = existing?.isPrimary ?? true;
    String? errorMsg;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return Padding(
              padding: EdgeInsets.fromLTRB(21, 20, 21, bottomInset + 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      existing == null ? 'Tambah Kendaraan' : 'Ubah Kendaraan',
                      style: TextStyle(
                        color: AppColors.darkPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () async {
                        final bytes = await _pickVehiclePhoto(context);
                        if (bytes != null) {
                          setModalState(() {
                            selectedPhoto = bytes;
                            errorMsg = null;
                          });
                        }
                      },
                      child: AnimatedVehicleIllustration(
                        photoBytes: selectedPhoto,
                        width: double.infinity,
                        height: 120,
                        isLargeCard: true,
                      ),
                    ),
                    if (selectedPhoto != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Ketuk foto di atas jika ingin mengganti foto kendaraan.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11.2,
                        ),
                      ),
                    ],
                    if (errorMsg != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        errorMsg!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFB8564B),
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    ParveTextField(
                      label: 'Merk & tipe mobil',
                      controller: nameCtrl,
                      hintText: 'Contoh: Toyota Veloz / Honda Civic Custom',
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ParveTextField(
                            label: 'Nomor polisi',
                            controller: plateCtrl,
                            hintText: 'Contoh: B 2148 SJD',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: ParveTextField(
                            label: 'Tahun',
                            controller: yearCtrl,
                            keyboardType: TextInputType.number,
                            hintText: '2024',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ParveTextField(
                      label: 'Warna & ciri unik kendaraan',
                      controller: colorCtrl,
                      hintText: 'Contoh: Putih-Hitam Two Tone • Velg Gold',
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () => setModalState(() => isPrimary = !isPrimary),
                      child: Row(
                        children: [
                          Icon(
                            isPrimary
                                ? Icons.check_box_rounded
                                : Icons.check_box_outline_blank_rounded,
                            color: AppColors.navActive,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Jadikan sebagai kendaraan utama',
                            style: TextStyle(
                              color: AppColors.darkPrimary,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.goldButton,
                        foregroundColor: AppColors.onGold,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      onPressed: () {
                        final name = nameCtrl.text.trim();
                        final plate = plateCtrl.text.trim().toUpperCase();
                        final color = colorCtrl.text.trim();
                        final year = yearCtrl.text.trim();

                        if (selectedPhoto == null) {
                          setModalState(() {
                            errorMsg =
                                'Wajib mengunggah foto kendaraan agar petugas mengenali mobil Anda.';
                          });
                          return;
                        }
                        if (name.isEmpty || plate.isEmpty || color.isEmpty) {
                          setModalState(() {
                            errorMsg =
                                'Mohon lengkapi merk mobil, nomor polisi, dan warna/ciri unik.';
                          });
                          return;
                        }

                        final saved = SavedVehicle(
                          id: existing?.id ??
                              'veh-${DateTime.now().millisecondsSinceEpoch}',
                          name: name,
                          plateNumber: plate,
                          color: color,
                          year: year.isEmpty ? '2024' : year,
                          photoBytes: selectedPhoto,
                          isPrimary: isPrimary,
                        );
                        setState(() => AuthStore.addOrUpdateVehicle(saved));
                        Navigator.pop(sheetContext);
                      },
                      child: Text(
                        existing == null
                            ? 'Simpan kendaraan'
                            : 'Simpan perubahan',
                        style: const TextStyle(fontWeight: FontWeight.w700),
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

  void _handleDelete(SavedVehicle vehicle) {
    if (AuthStore.savedVehicles.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Minimal harus ada 1 kendaraan tersimpan.'),
        ),
      );
      return;
    }
    setState(() => AuthStore.removeVehicle(vehicle.id));
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = AuthStore.savedVehicles;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppColors.pageOverlayStyle,
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(21, 12, 21, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const BookingTopBar(title: 'Kendaraan saya'),
                      const SizedBox(height: 16),
                      Text(
                        'Simpan kendaraan Anda agar pemesanan valet\nberikutnya lebih cepat.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13.0,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Kendaraan tersimpan',
                            style: TextStyle(
                              color: AppColors.darkPrimary,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${vehicles.length} kendaraan',
                            style: TextStyle(
                              color: AppColors.navActive,
                              fontSize: 12.2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      for (final v in vehicles) ...[
                        _buildVehicleCard(v),
                        const SizedBox(height: 14),
                      ],
                      _buildNoticeBanner(),
                      const SizedBox(height: 14),
                      _buildPrimaryInfoCard(),
                    ],
                  ),
                ),
              ),
              BookingStickyBottomBar(
                icon: Icons.add_rounded,
                label: 'Tambah kendaraan',
                onTap: () => _openVehicleForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleCard(SavedVehicle v) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => setState(() => AuthStore.setPrimaryVehicle(v.id)),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color:
                        v.isPrimary ? AppColors.navPillBg : AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5.5,
                        height: 5.5,
                        decoration: BoxDecoration(
                          color: v.isPrimary
                              ? AppColors.navActive
                              : AppColors.textMuted,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        v.isPrimary ? 'Kendaraan utama' : 'Jadikan utama',
                        style: TextStyle(
                          color: v.isPrimary
                              ? AppColors.navActive
                              : AppColors.textSecondary,
                          fontSize: 11.4,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _openVehicleForm(existing: v),
                child: Icon(
                  Icons.more_horiz_rounded,
                  color: AppColors.darkPrimary,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _openVehicleForm(existing: v),
            child: AnimatedVehicleIllustration(
              photoBytes: v.photoBytes,
              width: double.infinity,
              height: 116,
              isLargeCard: true,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            v.name,
            style: TextStyle(
              color: AppColors.darkPrimary,
              fontSize: 17.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            v.plateNumber,
            style: TextStyle(
              color: AppColors.darkPrimary,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            v.specs,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12.2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, thickness: 1, color: AppColors.divider),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _openVehicleForm(existing: v),
                child: Text(
                  'Ubah kendaraan',
                  style: TextStyle(
                    color: AppColors.navActive,
                    fontSize: 12.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _handleDelete(v),
                child: const Text(
                  'Hapus',
                  style: TextStyle(
                    color: Color(0xFFB8564B),
                    fontSize: 12.8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.softGoldBanner,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(
              Icons.verified_user_outlined,
              color: AppColors.navActive,
              size: 17,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Nomor polisi membantu petugas mengenali mobil '
              'Anda. Pastikan data sesuai sebelum memesan.',
              style: TextStyle(
                color: AppColors.navActive,
                fontSize: 11.6,
                height: 1.38,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  Icons.star_border_rounded,
                  color: AppColors.darkPrimary,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kendaraan utama',
                      style: TextStyle(
                        color: AppColors.darkPrimary,
                        fontSize: 13.8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Dipilih otomatis saat Anda memesan valet.',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11.4,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Anda dapat mengganti kendaraan pada setiap\npemesanan.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.0,
              height: 1.38,
            ),
          ),
        ],
      ),
    );
  }
}
