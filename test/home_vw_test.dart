import 'package:flutter_test/flutter_test.dart';
import 'package:pp_lightning/main.dart';
import 'package:pp_lightning/views/table_vw.dart';

void main() {
  testWidgets('Pushing "START GAME" button should show the game table', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('START GAME'));
      await tester.pumpAndSettle();
      expect(find.byType(TableVw), findsOneWidget);
    });
  });
}
