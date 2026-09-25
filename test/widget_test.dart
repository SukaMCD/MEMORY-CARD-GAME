import 'package:flutter_test/flutter_test.dart';
import 'package:ptsf/main.dart';

void main() {
  testWidgets('MemoryMatchApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MemoryMatchApp());
    expect(find.text('MEMORY\nMATCH CARD'), findsOneWidget);
    expect(find.text('SELECT LEVEL'), findsOneWidget);
  });
}
