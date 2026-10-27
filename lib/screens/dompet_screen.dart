import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../models/auth_store.dart';
import '../models/wallet_model.dart';
import '../widgets/parve_bottom_nav.dart';
import '../widgets/parve_header.dart';
import 'aktivitas_screen.dart';
import 'beranda_screen.dart';
import 'isi_saldo_screen.dart';
import 'profil_screen.dart';

class DompetScreen extends StatefulWidget {
  const DompetScreen({super.key});

  @override
  State<DompetScreen> createState() => _DompetScreenState();
}

class _DompetScreenState extends State<DompetScreen> {
  // 0: Semua, 1: Masuk, 2: Keluar
  int _filterIndex = 0;

  List<WalletTransaction> get _filteredTransactions {
    final all = AuthStore.walletTransactions;
    if (_filterIndex == 1) {
      return all.where((t) => t.isCredit).toList();
    } else if (_filterIndex == 2) {
      return all.where((t) => !t.isCredit).toList();
    }
    return all;
  }

  Future<void> _openIsiSaldo() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const IsiSaldoScreen()),
    );
    if (mounted) setState(() {});
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
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          settings: const RouteSettings(name: '/profil'),
          pageBuilder: (_, _, _) => const ProfilScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Bantuan Dompet PARVE',
          style: TextStyle(color: AppColors.darkPrimary),
        ),
        content: Text(
          'Saldo Dompet PARVE digunakan untuk pembayaran layanan valet dan parkir gedung secara otomatis tanpa uang tunai.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ownerName = AuthStore.currentUser?.fullName ?? 'Dimas Pratama';

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
                      ParveHeader(
                        title: 'Dompet saya',
                        onHelpTap: _showHelpDialog,
                      ),
                      const SizedBox(height: 16),
                      _buildHeroWalletCard(ownerName),
                      const SizedBox(height: 14),
                      _buildTopUpButton(),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Transaksi terbaru',
                            style: TextStyle(
                              color: AppColors.darkPrimary,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _filterIndex = 0),
                            child: Text(
                              'Semua',
                              style: TextStyle(
                                color: AppColors.navActive,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildFilterChipsRow(),
                      const SizedBox(height: 14),
                      _buildTransactionsCard(),
                      const SizedBox(height: 14),
                      _buildSecurityNoticeBanner(),
                      const SizedBox(height: 14),
                      Text(
                        'Data contoh untuk ilustrasi layanan.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ParveBottomNav(
                currentIndex: 2,
                onTap: _onBottomNavTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroWalletCard(String ownerName) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.heroDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'DOMPET PARVE',
                style: TextStyle(
                  color: Color(0xFFA0A39E),
                  fontSize: 11.2,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () =>
                        setState(() => AuthStore.toggleBalanceVisibility()),
                    child: Icon(
                      AuthStore.isBalanceVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xFFA0A39E),
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: AppColors.goldText,
                    size: 22,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            AuthStore.displayWalletBalance,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 29.0,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ownerName,
                style: const TextStyle(
                  color: Color(0xFFA0A39E),
                  fontSize: 12.0,
                ),
              ),
              const Text(
                'Saldo tersedia',
                style: TextStyle(
                  color: AppColors.goldText,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopUpButton() {
    return Material(
      color: AppColors.goldButton,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: _openIsiSaldo,
        borderRadius: BorderRadius.circular(12),
        child: const SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded, size: 20, color: AppColors.onGold),
              SizedBox(width: 7),
              Text(
                'Isi saldo',
                style: TextStyle(
                  color: AppColors.onGold,
                  fontSize: 14.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChipsRow() {
    const labels = ['Semua', 'Masuk', 'Keluar'];
    return Row(
      children: List.generate(labels.length, (i) {
        final selected = _filterIndex == i;
        return Padding(
          padding: EdgeInsets.only(right: i < labels.length - 1 ? 8 : 0),
          child: GestureDetector(
            onTap: () => setState(() => _filterIndex = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? AppColors.softGoldCard : AppColors.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: selected
                      ? const Color(0xFFD6BE8A)
                      : AppColors.cardBorder,
                  width: 1.2,
                ),
              ),
              child: Text(
                labels[i],
                style: TextStyle(
                  color: selected
                      ? AppColors.navActive
                      : AppColors.textSecondary,
                  fontSize: 12.4,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTransactionsCard() {
    final items = _filteredTransactions;
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.cardBorder, width: 1.2),
        ),
        child: Text(
          'Belum ada transaksi pada kategori ini.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textMuted, fontSize: 12.5),
        ),
      );
    }

    final dateOrder = <String>[];
    final grouped = <String, List<WalletTransaction>>{};
    for (final trx in items) {
      if (!grouped.containsKey(trx.dateGroup)) {
        dateOrder.add(trx.dateGroup);
        grouped[trx.dateGroup] = [];
      }
      grouped[trx.dateGroup]!.add(trx);
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int g = 0; g < dateOrder.length; g++) ...[
            if (g > 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.divider,
                ),
              ),
            Text(
              dateOrder[g],
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            for (int i = 0; i < grouped[dateOrder[g]]!.length; i++) ...[
              if (i > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.divider,
                  ),
                ),
              _buildTransactionRow(grouped[dateOrder[g]]![i]),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildTransactionRow(WalletTransaction trx) {
    final isCredit = trx.isCredit;
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isCredit ? AppColors.badgeBg : AppColors.navPillBg,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            isCredit ? Icons.south_west_rounded : Icons.north_east_rounded,
            size: 18,
            color: isCredit ? AppColors.badgeGreen : AppColors.navActive,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trx.title,
                style: TextStyle(
                  color: AppColors.darkPrimary,
                  fontSize: 13.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                trx.subtitle,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11.6,
                ),
              ),
            ],
          ),
        ),
        Text(
          trx.formattedSignedAmount,
          style: TextStyle(
            color: isCredit ? AppColors.badgeGreen : AppColors.darkPrimary,
            fontSize: 13.8,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityNoticeBanner() {
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
              'Saldo ini milik Anda dan hanya digunakan untuk pembayaran layanan PARVE.',
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
}
