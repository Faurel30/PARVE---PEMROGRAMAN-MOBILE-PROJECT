import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'admin_dashboard_tab.dart';
import 'admin_verification_masuk_tab.dart';
import 'admin_slot_screen.dart';
import 'admin_barcode_screen.dart';

// =============================================================================
// MAIN ADMIN NAVIGATION WRAPPER
// =============================================================================
class AdminMainScreen extends StatefulWidget {
  final int initialIndex;
  const AdminMainScreen({super.key, this.initialIndex = 0});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ParveColors.darkBg,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          AdminDashboardTab(onNavigateToVerification: () => _onTabTapped(1)),
          const AdminVerificationMasukTab(),
          const AdminSlotScreen(),
          const AdminBarcodeScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF131517),
          border: Border(top: BorderSide(color: Color(0xFF1E2227), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          backgroundColor: const Color(0xFF131517),
          selectedItemColor: ParveColors.gold,
          unselectedItemColor: ParveColors.textMuted,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_filled),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car_outlined),
              activeIcon: Icon(Icons.directions_car),
              label: 'Verifikasi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              activeIcon: Icon(Icons.grid_view_rounded),
              label: 'Slot',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              activeIcon: Icon(Icons.qr_code_scanner),
              label: 'Barcode',
            ),
          ],
        ),
      ),
    );
  }
}

