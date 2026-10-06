import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/screens/lab4_screen.dart';
import 'package:task_manager/widgets/action_buttons_row.dart';
import 'package:task_manager/widgets/image_banner_card.dart';
import 'package:task_manager/widgets/task_header.dart';
import 'package:task_manager/widgets/task_info_card.dart';

void main() {
  testWidgets('Lab 4 custom widgets and layout tree test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify main screen exists
    expect(find.byType(Lab4Screen), findsOneWidget);

    // Verify all 4 custom widgets are present
    expect(find.byType(ImageBannerCard), findsOneWidget);
    expect(find.byType(TaskHeader), findsOneWidget);
    expect(find.byType(TaskInfoCard), findsOneWidget);
    expect(find.byType(ActionButtonsRow), findsOneWidget);

    // Verify layout widgets
    expect(find.byType(Column), findsWidgets);
    expect(find.byType(Row), findsWidgets);
    expect(find.byType(Container), findsWidgets);
    expect(find.byType(Padding), findsWidgets);
    expect(find.byType(Flexible), findsWidgets);
    expect(find.byType(Spacer), findsOneWidget);
    expect(find.byType(Expanded), findsWidgets);

    // Verify text contents
    expect(find.text('Лабораторна робота №4'), findsOneWidget);
    expect(find.text('Оптимізація бази даних'), findsOneWidget);
    expect(find.text('Виконати'), findsOneWidget);
    expect(find.text('Відкласти'), findsOneWidget);

    // Test favorite button interaction
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsNothing);

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.text('Додано до обраного'), findsOneWidget);

    // Test action buttons
    await tester.tap(find.text('Виконати'));
    await tester.pump();
    expect(find.text('Завдання успішно виконано!'), findsOneWidget);

    await tester.tap(find.text('Відкласти'));
    await tester.pump();
    expect(find.text('Завдання відкладено'), findsOneWidget);
  });
}
