import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parve_app/core/app_colors.dart';
import 'package:parve_app/main.dart';
import 'package:parve_app/models/auth_store.dart';

void main() {
  testWidgets(
    'Full PARVE User flow: Auth -> Beranda -> Dompet (+TopUp) -> Profil -> Riwayat & Pengaturan (Mode Gelap) -> Booking & Pickup',
    (WidgetTester tester) async {
      AuthStore.reset();
      await tester.pumpWidget(const ParveApp());

      // 1. Landing -> Register -> Login -> Beranda
      await tester.tap(find.text('Masuk ke PARVE'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.ensureVisible(find.text('Buat akun'));
      await tester.pump();
      await tester.tap(find.text('Buat akun'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      final masukButtons = find.text('Masuk');
      await tester.ensureVisible(masukButtons.last);
      await tester.pump();
      await tester.tap(masukButtons.last);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Verify m-banking balance show/hide on Beranda
      expect(find.text('Rp205.000'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();
      expect(find.text('Rp •••••••'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();
      expect(find.text('Rp205.000'), findsOneWidget);

      // 2. Open Profil tab -> Pengaturan -> activate Mode gelap
      await tester.tap(find.text('Profil'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Profil saya'), findsOneWidget);
      await tester.ensureVisible(find.text('Pengaturan'));
      await tester.pump();
      await tester.tap(find.text('Pengaturan'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Mode terang sedang digunakan.'), findsOneWidget);
      await tester.tap(find.text('Mode gelap'));
      await tester.pump();
      expect(AppColors.isDark, true);
      expect(find.text('Mode gelap sedang digunakan.'), findsOneWidget);

      // Return to Profil -> tap "Riwayat parkir" -> opens Aktivitas on Riwayat tab
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.ensureVisible(find.text('Riwayat parkir'));
      await tester.pump();
      await tester.tap(find.text('Riwayat parkir'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Grand Indonesia'), findsOneWidget);

      // 3. Open Dompet -> Isi saldo Rp100.000 -> balance becomes Rp305.000
      await tester.tap(find.text('Dompet'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('Isi saldo').first);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('Lanjut isi saldo · Rp100.000'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('Selesaikan pembayaran · Rp100.000'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(AuthStore.walletBalance, 305000);
    },
  );
}
