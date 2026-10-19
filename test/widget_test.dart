import 'package:flutter_test/flutter_test.dart';
import 'package:parve_valet/main.dart';

void main() {
  testWidgets('AktivitasScreen renders ticket details and navigates to PantauKendaraanScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ParveApp());

    expect(find.text('Aktivitas'), findsWidgets);
    expect(find.text('Tiket aktif'), findsOneWidget);
    expect(find.text('Riwayat parkir'), findsOneWidget);
    expect(find.text('PARVE / TIKET DIGITAL'), findsOneWidget);
    expect(find.text('Senayan City'), findsOneWidget);
    expect(find.text('PV-081026-0248'), findsOneWidget);
    expect(find.text('Terparkir aman'), findsOneWidget);
    expect(find.text('Toyota Veloz'), findsOneWidget);
    expect(find.text('B 2148 SJD'), findsOneWidget);
    expect(find.text('Putih • MPV • 2024'), findsOneWidget);
    expect(find.text('8 Okt 2026 • 13.00'), findsOneWidget);
    expect(find.text('B1 • Blok A-12'), findsOneWidget);
    expect(find.text('Rp35.000'), findsOneWidget);
    expect(find.text('Pantau kendaraan'), findsOneWidget);

    // Scroll and tap "Pantau kendaraan" button and verify PantauKendaraanScreen loads
    await tester.ensureVisible(find.text('Pantau kendaraan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pantau kendaraan'));
    await tester.pumpAndSettle();

    expect(find.text('Pantau kendaraan'), findsOneWidget);
    expect(find.text('Diperbarui 14.30 WIB'), findsOneWidget);
    expect(find.text('Denah area parkir'), findsOneWidget);
    expect(find.text('SENAYAN CITY'), findsOneWidget);
    expect(find.text('B1 • A-12'), findsOneWidget);
    expect(find.text('Senayan City • B1 A-12'), findsOneWidget);
    expect(find.text('1 jam 30 menit'), findsOneWidget);
    expect(find.text('Perjalanan kendaraan'), findsOneWidget);
    expect(find.text('Diserahkan ke petugas'), findsOneWidget);
    expect(find.text('Lobi utama • Pintu selatan'), findsOneWidget);
    expect(find.text('Andi Saputra'), findsOneWidget);
    expect(find.text('Hubungi'), findsOneWidget);
    expect(find.text('Ambil kendaraan'), findsOneWidget);
  });
}
