import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/main.dart';

void main() {
  testWidgets('Lab 3 Layout and Widget Verification Test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // 1. Verify AppBar title
    expect(find.text('Деталі'), findsOneWidget);

    // 2. Verify task title & description
    expect(find.text('Оптимізація бази даних'), findsOneWidget);
    expect(find.byType(Expanded), findsWidgets);
    expect(find.byType(Spacer), findsWidgets);
    expect(find.byType(Flexible), findsWidgets);
    expect(find.byType(Column), findsWidgets);
    expect(find.byType(Row), findsWidgets);
    expect(find.byType(Container), findsWidgets);

    // 3. Verify action buttons
    expect(find.text('Виконати'), findsOneWidget);
    expect(find.text('Відкласти'), findsOneWidget);

    // 4. Test button interaction & SnackBar
    await tester.tap(find.text('Виконати'));
    await tester.pump();
    expect(find.text('Завдання успішно виконано!'), findsOneWidget);
    await tester.pumpAndSettle();

    // 5. Test favorite toggle
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.text('Додано до обраного'), findsOneWidget);
  });
}
