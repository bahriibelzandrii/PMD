import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/main.dart';

void main() {
  testWidgets('TaskManagerApp smoke test - verifies title and task toggling', (WidgetTester tester) async {
    // 1. Build our app and trigger a frame.
    await tester.pumpWidget(const TaskManagerApp());
    await tester.pumpAndSettle();

    // 2. Verify that the title and headers are present.
    expect(find.text('Менеджер завдань'), findsWidgets);
    expect(find.text('Варіант 1: Менеджер завдань'), findsOneWidget);
    expect(find.text('3 / 5'), findsOneWidget);

    // 3. Verify task checkbox toggle
    final checkbox = find.byType(Checkbox).first;
    await tester.tap(checkbox);
    await tester.pumpAndSettle();

    // After toggling the first item (was completed), completed count becomes 2
    expect(find.text('2 / 5'), findsOneWidget);
  });
}
