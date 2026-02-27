import 'package:flutter_test/flutter_test.dart';
import 'package:sprint_ai/main.dart';

void main() {
  testWidgets('app renders title', (WidgetTester tester) async {
    await tester.pumpWidget(const SprintAiApp());
    expect(find.text('SprintAI'), findsWidgets);
  });
}
