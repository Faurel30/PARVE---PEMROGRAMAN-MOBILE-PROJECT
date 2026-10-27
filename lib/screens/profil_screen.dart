import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../models/auth_store.dart';
import '../widgets/parve_bottom_nav.dart';
import '../widgets/parve_header.dart';
import '../widgets/parve_text_field.dart';
import 'aktivitas_screen.dart';
import 'beranda_screen.dart';
import 'dompet_screen.dart';
import 'kendaraan_saya_screen.dart';
import 'landing_screen.dart';
import 'pengaturan_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    final user = AuthStore.currentUser;
    _nameCtrl = TextEditingController(text: user?.fullName ?? 'Dimas Pratama');
    _phoneCtrl = TextEditingController(
      text: user?.phone ?? '+62 812 3456 7890',
    );
    _emailCtrl = TextEditingController(
      text: user?.email ?? 'dimas.pratama@example.com',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          settings: const RouteSettings(name: '/home'),
          pageBuilder: (_, _, _) => const BerandaScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          settings: const RouteSettings(name: '/aktivitas'),
          pageBuilder: (_, _, _) => const AktivitasScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          settings: const RouteSettings(name: '/dompet'),
          pageBuilder: (_, _, _) => const DompetScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    }
  }

  Future<void> _changeProfilePhoto() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.navActive,
                ),
                title: Text(
                  'Unggah Foto dari Galeri',
                  style: TextStyle(color: AppColors.darkPrimary),
                ),
                onTap: () => Navigator.pop(ctx, 'upload'),
              ),
              if (AuthStore.profilePhotoBytes != null)
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFB8564B),
                  ),
                  title: const Text(
                    'Gunakan Inisial Nama (Hapus Foto)',
                    style: TextStyle(color: Color(0xFFB8564B)),
                  ),
                  onTap: () => Navigator.pop(ctx, 'remove'),
                ),
            ],
          ),
        ),
      ),
    );

    if (choice == 'upload') {
      final data = await rootBundle.load('assets/images/logo_parve.png');
      if (mounted) {
        setState(() => AuthStore.profilePhotoBytes = data.buffer.asUint8List());
      }
    } else if (choice == 'remove' && mounted) {
      setState(() => AuthStore.profilePhotoBytes = null);
    }
  }

  void _saveProfileChanges() {
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    if (name.isEmpty || phone.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi seluruh data pribadi.')),
      );
      return;
    }
    setState(() {
      AuthStore.updateProfile(fullName: name, phone: phone, email: email);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perubahan data pribadi berhasil disimpan!')),
    );
  }

  Future<void> _openKendaraanSaya() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const KendaraanSayaScreen()),
    );
    if (mounted) setState(() {});
  }

  void _openRiwayatParkir() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        settings: const RouteSettings(name: '/aktivitas'),
        pageBuilder: (_, _, _) => const AktivitasScreen(initialTabIndex: 1),
        transitionDuration: Duration.zero,
      ),
    );
  }

  Future<void> _openPengaturan() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PengaturanScreen()),
    );
    if (mounted) setState(() {});
  }

  void _showHelpCenterDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Pusat Bantuan PARVE',
          style: TextStyle(color: AppColors.darkPrimary),
        ),
        content: Text(
          'Hubungi petugas valet PARVE di lobi utama mal atau layanan bantuan 24 jam melalui support@parve.id.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    AuthStore.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LandingScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final displayName = _nameCtrl.text.trim().isEmpty
        ? 'Dimas Pratama'
        : _nameCtrl.text.trim();
    final initials = UserAccount(
      fullName: displayName,
      phone: '',
      email: '',
      password: '',
    ).initials;

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
                  padding: const EdgeInsets.fromLTRB(21, 12, 21, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const ParveHeader(title: 'Profil saya'),
                      const SizedBox(height: 20),
                      _buildAvatarHeader(displayName, initials),
                      const SizedBox(height: 22),
                      Text(
                        'Data pribadi',
                        style: TextStyle(
                          color: AppColors.darkPrimary,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ParveTextField(
                        label: 'Nama lengkap',
                        controller: _nameCtrl,
                      ),
                      const SizedBox(height: 12),
                      ParveTextField(
                        label: 'Nomor ponsel',
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        suffixIcon: Icons.verified_outlined,
                      ),
                      const SizedBox(height: 12),
                      ParveTextField(
                        label: 'Alamat email',
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 14),
                      _buildSaveChangesButton(),
                      const SizedBox(height: 18),
                      _buildMenuCard(),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: _showHelpCenterDialog,
                            child: Text(
                              'Pusat bantuan',
                              style: TextStyle(
                                color: AppColors.navActive,
                                fontSize: 12.8,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _handleLogout,
                            child: const Text(
                              'Keluar akun',
                              style: TextStyle(
                                color: Color(0xFFB8564B),
                                fontSize: 12.8,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ParveBottomNav(
                currentIndex: 3,
                onTap: _onBottomNavTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarHeader(String displayName, String initials) {
    return Row(
      children: [
        GestureDetector(
          onTap: _changeProfilePhoto,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.heroDark,
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            child: AuthStore.profilePhotoBytes != null
                ? Image.memory(
                    AuthStore.profilePhotoBytes!,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  )
                : Text(
                    initials,
                    style: const TextStyle(
                      color: AppColors.goldText,
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: TextStyle(
                  color: AppColors.darkPrimary,
                  fontSize: 20.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Pengguna PARVE sejak Oktober 2026',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12.0,
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: _changeProfilePhoto,
                child: Text(
                  'Ubah foto profil',
                  style: TextStyle(
                    color: AppColors.navActive,
                    fontSize: 12.4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaveChangesButton() {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: _saveProfileChanges,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.cardBorder, width: 1.2),
          ),
          child: Text(
            'Simpan perubahan',
            style: TextStyle(
              color: AppColors.darkPrimary,
              fontSize: 13.8,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        children: [
          _buildMenuTile(
            icon: Icons.directions_car_outlined,
            title: 'Kendaraan saya',
            trailing: Text(
              '${AuthStore.savedVehicles.length} mobil',
              style: TextStyle(
                color: AppColors.navActive,
                fontSize: 12.4,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: _openKendaraanSaya,
          ),
          Divider(height: 1, thickness: 1, color: AppColors.divider),
          _buildMenuTile(
            icon: Icons.history_rounded,
            title: 'Riwayat parkir',
            subtitle: 'Tiket dan bukti pembayaran sebelumnya',
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
            onTap: _openRiwayatParkir,
          ),
          Divider(height: 1, thickness: 1, color: AppColors.divider),
          _buildMenuTile(
            icon: Icons.notifications_none_rounded,
            title: 'Notifikasi layanan',
            subtitle: 'Status valet dan transaksi',
            trailing: ParveGoldSwitch(
              value: AuthStore.serviceNotificationsEnabled,
              onChanged: (val) => setState(
                () => AuthStore.serviceNotificationsEnabled = val,
              ),
            ),
          ),
          Divider(height: 1, thickness: 1, color: AppColors.divider),
          _buildMenuTile(
            icon: Icons.settings_outlined,
            title: 'Pengaturan',
            subtitle: 'Mode terang dan Mode gelap',
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
            onTap: _openPengaturan,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: AppColors.darkPrimary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.darkPrimary,
                      fontSize: 13.8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            trailing,
          ],
        ),
      ),
    );
  }
}
