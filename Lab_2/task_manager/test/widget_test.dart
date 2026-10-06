import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/main.dart';

void main() {
  testWidgets('Lab 2 UI verification test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify AppBar title
    expect(find.text('Менеджер завдань'), findsOneWidget);

    // Verify Center ElevatedButton
    expect(find.text('Додати завдання'), findsOneWidget);

    // Verify BottomNavigationBar items
    expect(find.text('Список'), findsOneWidget);
    expect(find.text('Завдання'), findsOneWidget);

    // Tap the button and verify SnackBar
    await tester.tap(find.text('Додати завдання'));
    await tester.pump(); // Start animation
    expect(find.text('Нове завдання успішно додано!'), findsOneWidget);
  });
}
