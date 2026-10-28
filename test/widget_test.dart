import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyek_pemmob/core/models/ticket_data.dart';
import 'package:proyek_pemmob/core/services/auth_service.dart';
import 'package:proyek_pemmob/main.dart';
import 'package:proyek_pemmob/presentation/screens/petugas_home_screen.dart';

void main() {
  setUp(() {
    AuthService.instance.logout();
  });
  testWidgets('Auth flow: Welcome Screen to Login and Quick Account selection', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // 1. Build Welcome Screen
    await tester.pumpWidget(const ParvePetugasApp());
    await tester.pumpAndSettle();

    // Verify Welcome elements from Figma design
    expect(find.text('SISTEM VALET TERBAIK ANDA'), findsOneWidget);
    expect(find.text('Parkir harap tenang,\nPergi tanpa repot'), findsOneWidget);
    expect(find.text('Petugas terpercaya'), findsOneWidget);
    expect(find.text('Tarif transparan'), findsOneWidget);
    expect(find.text('Masuk ke PARVE'), findsOneWidget);
    expect(find.text('Daftar akun baru'), findsOneWidget);

    // 2. Tap "Masuk ke PARVE"
    await tester.tap(find.text('Masuk ke PARVE'));
    await tester.pumpAndSettle();

    // Verify Login Screen
    expect(find.text('Masuk Petugas'), findsOneWidget);
    expect(find.text('PORTAL RESMI PETUGAS'), findsOneWidget);
    expect(find.text('Rizky Saputra'), findsOneWidget);

    // 3. Tap Quick Demo Account (Rizky Saputra)
    await tester.tap(find.text('Rizky Saputra'));
    await tester.pumpAndSettle();

    // 4. Tap "Masuk sebagai Petugas"
    await tester.tap(find.text('Masuk sebagai Petugas'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify successfully entered PetugasHomeScreen
    expect(find.text('Pacific Place'), findsOneWidget);
    expect(find.text('Petugas Parkir'), findsOneWidget);
    expect(find.text('Scan Barcode'), findsOneWidget);
  });

  testWidgets('Auth flow: Welcome Screen to Register new Officer and into Home', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const ParvePetugasApp());
    await tester.pumpAndSettle();

    // 1. Tap "Daftar akun baru"
    await tester.tap(find.text('Daftar akun baru'));
    await tester.pumpAndSettle();

    // Verify Register Screen elements
    expect(find.text('Registrasi Petugas'), findsOneWidget);
    expect(find.text('FORMULIR AKUN BARU'), findsOneWidget);

    // 2. Fill registration fields
    final textFields = find.byType(TextFormField);
    await tester.enterText(textFields.at(0), 'Budi Santoso');
    await tester.enterText(textFields.at(1), 'PET-2026-009');
    await tester.enterText(textFields.at(2), 'budi.santoso@parve.id');
    await tester.enterText(textFields.at(3), '081234567890');
    await tester.enterText(textFields.at(4), 'password123');
    await tester.enterText(textFields.at(5), 'password123');

    // 3. Agree to SOP
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    // 4. Tap "Daftar Akun Petugas"
    await tester.tap(find.text('Daftar Akun Petugas'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // 5. Success modal appears
    expect(find.text('Registrasi Berhasil!'), findsOneWidget);

    // 6. Tap "Mulai Bertugas"
    await tester.tap(find.text('Mulai Bertugas'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify inside Home with Budi Santoso
    expect(find.text('Budi Santoso'), findsOneWidget);
  });

  testWidgets('Complete Petugas flow with Live Camera Scan and Parking Slot Monitoring', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // 1. Build our app (Screen 1: Petugas · Scan Barcode)
    await tester.pumpWidget(const ParvePetugasApp(
      animateLaser: false,
      home: PetugasHomeScreen(
        animateLaser: false,
        initialOfficer: Officer.rizky,
      ),
    ));
    await tester.pumpAndSettle();

    // Verify Screen 1 elements
    expect(find.text('Pacific Place'), findsOneWidget);
    expect(find.text('Petugas Parkir'), findsOneWidget);
    expect(find.text('Rizky Saputra'), findsOneWidget);
    expect(find.text('Bertugas'), findsOneWidget);
    expect(find.text('Scan Barcode'), findsOneWidget);
    expect(find.text('Ketersediaan Slot Parkir'), findsOneWidget);
    expect(find.text('Scan barcode user'), findsOneWidget);

    // 2. Test Parking Slot Tab
    await tester.tap(find.text('Slot'));
    await tester.pumpAndSettle();

    // Verify Parking Slot Screen elements
    expect(find.text('Slot Parkir'), findsOneWidget);
    expect(find.text('Tersedia'), findsOneWidget);
    expect(find.text('Terisi'), findsOneWidget);
    expect(find.text('Booking'), findsOneWidget);
    expect(find.text('A-018'), findsOneWidget);

    // Tap on slot A-018 to view details
    await tester.tap(find.text('A-018'));
    await tester.pumpAndSettle();

    // Verify modal detail for A-018 (Toyota Alphard Aditya Wijaya)
    expect(find.text('Toyota Alphard · Hitam'), findsAtLeastNWidgets(1));
    expect(find.text('Aditya Wijaya'), findsAtLeastNWidgets(1));
    expect(find.text('B 1234 PAR'), findsAtLeastNWidgets(1));

    // Close modal
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

    // 3. Return to Scan tab
    await tester.tap(find.text('Scan'));
    await tester.pumpAndSettle();

    // 4. Tap "Scan barcode user" -> Opens CameraScanScreen
    await tester.tap(find.text('Scan barcode user'));
    await tester.pumpAndSettle();

    // Verify CameraScanScreen opened
    expect(find.text('Kamera Aktif Petugas'), findsOneWidget);
    expect(find.text('Deteksi Barcode Tiket (PV-081026-0248)'), findsOneWidget);

    // 5. Trigger Barcode detection in camera
    await tester.tap(find.text('Deteksi Barcode Tiket (PV-081026-0248)'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // 6. Verify Screen 2 (Hasil Scan Keluar)
    expect(find.text('Hasil Scan Keluar'), findsOneWidget);
    expect(find.text('Barcode valid · Scan diterima Admin'), findsOneWidget);
    expect(find.text('Menunggu verifikasi Admin'), findsOneWidget);
    expect(find.text('B 1234 PAR'), findsOneWidget);
    expect(find.text('PV-081026-0248'), findsOneWidget);

    // 7. Tap "Simulasikan Keputusan Admin" -> Transitions to Screen 3 (Notifikasi)
    await tester.tap(find.text('Simulasikan Keputusan Admin (Terima Notifikasi)'));
    await tester.pumpAndSettle();

    // Verify Screen 3 elements
    expect(find.text('Notifikasi'), findsAtLeastNWidgets(1));
    expect(find.text('Keluar Disetujui'), findsAtLeastNWidgets(1));
    expect(find.text('Detail persetujuan keluar'), findsAtLeastNWidgets(1));
    expect(find.text('Kembali ke scan'), findsOneWidget);

    // 8. Tap "Kembali ke scan"
    await tester.tap(find.text('Kembali ke scan'));
    await tester.pumpAndSettle();

    // Verify back to dashboard scan screen
    expect(find.text('Scan Barcode'), findsOneWidget);
  });
}
