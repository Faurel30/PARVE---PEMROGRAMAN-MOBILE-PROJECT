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
    expect(find.text('Antrean & Daftar Kendaraan'), findsOneWidget);
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

  testWidgets('Complete Petugas flow with Vehicle Management and Parking Slot Monitoring', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // 1. Build our app (Default Landing Tab: Kendaraan)
    await tester.pumpWidget(const ParvePetugasApp(
      animateLaser: false,
      home: PetugasHomeScreen(
        animateLaser: false,
        initialOfficer: Officer.rizky,
      ),
    ));
    await tester.pumpAndSettle();

    // Verify Kendaraan screen elements
    expect(find.text('Pacific Place'), findsOneWidget);
    expect(find.text('Petugas Parkir'), findsOneWidget);
    expect(find.text('Rizky Saputra'), findsOneWidget);
    expect(find.text('Bertugas'), findsOneWidget);
    expect(find.text('Antrean & Daftar Kendaraan'), findsOneWidget);
    expect(find.text('B 1234 PAR'), findsOneWidget);
    expect(find.text('B 8899 LUX'), findsOneWidget);

    // 2. Tap on vehicle card to open detail sheet
    await tester.tap(find.text('B 1234 PAR'));
    await tester.pumpAndSettle();

    // Verify detail sheet opened
    expect(find.text('Pengemudi / Pemilik'), findsOneWidget);
    expect(find.text('Aditya Wijaya'), findsAtLeastNWidgets(1));
    expect(find.text('Tutup'), findsOneWidget);

    // Close detail sheet
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

    // 3. Test Parking Slot Tab
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

    // Verify modal detail for A-018
    expect(find.text('Toyota Alphard · Hitam'), findsAtLeastNWidgets(1));
    expect(find.text('Aditya Wijaya'), findsAtLeastNWidgets(1));

    // Close modal
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

    // 4. Test Notifikasi Tab
    await tester.tap(find.text('Notifikasi'));
    await tester.pumpAndSettle();

    // Verify Notifikasi Screen elements
    expect(find.text('Notifikasi'), findsAtLeastNWidgets(1));
    expect(find.text('Keluar Disetujui'), findsAtLeastNWidgets(1));
  });
}
