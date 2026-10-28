import 'package:flutter_test/flutter_test.dart';
import 'package:tugas_pemmob/main.dart';

void main() {
  testWidgets('PARVE app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ParveApp());

    // Verify that onboarding screen shows PARVE welcome text.
    expect(find.text('LAYANAN VALET PRIBADI ANDA'), findsOneWidget);
  });
}
