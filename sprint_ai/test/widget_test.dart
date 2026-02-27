import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sprint_ai/main.dart';

import '../lib/main.dart';


void main() {
  testWidgets('SprintAI smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('SprintAI'), findsOneWidget);
  });
}
