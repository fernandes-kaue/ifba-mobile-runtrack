import 'package:flutter_test/flutter_test.dart';
import 'package:runtrack/main.dart';

void main() {
  testWidgets('Smoke test de inicializacao do aplicativo', (WidgetTester tester) async {
    await tester.pumpWidget(const RunTrack());
    expect(find.byType(RunTrack), findsOneWidget);
  });
}
