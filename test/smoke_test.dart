import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskmaster_app/main.dart';
import 'package:taskmaster_app/design_system/app_motion.dart';

void main() {
  testWidgets('TaskMasterApp smoke test — pump app and verify tabs', (WidgetTester tester) async {
    // 1. Побудувати додаток
    await tester.pumpWidget(const TaskMasterApp());
    await tester.pumpAndSettle();

    // 2. Перевірити наявність дашборду (Гібрид A+C)
    expect(find.text('Головний дашборд'), findsOneWidget);
    expect(find.text('75%'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('Активні проєкти'), findsOneWidget);

    // 3. Перехід на вкладку "Проєкти" (Екран 4, Варіант A)
    await tester.tap(find.byIcon(Icons.folder_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Проєкти та категорії'), findsOneWidget);
    expect(find.text('ПМД Лабораторні'), findsOneWidget);

    // 4. Перехід на вкладку "Дошка" (Екран 5, Варіант A)
    await tester.tap(find.byIcon(Icons.view_kanban_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Дошка статусів'), findsOneWidget);

    // 5. Перехід на вкладку "Аналітика" (Екран 9, Гібрид A+B)
    await tester.tap(find.byIcon(Icons.bar_chart_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Аналітика та темп'), findsOneWidget);
    expect(find.text('Годин за тиждень: 35.5 год'), findsOneWidget);
    expect(find.text('84%'), findsOneWidget);

    // 6. Перехід на вкладку "Профіль" (Екран 10, Варіант A)
    await tester.tap(find.byIcon(Icons.person_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Профіль та налаштування'), findsOneWidget);
    expect(find.text('Андрій Коваленко'), findsOneWidget);
  });

  testWidgets('Design System Motion Widgets test', (WidgetTester tester) async {
    bool clicked = false;
    bool checked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              SpringButton(
                onTap: () => clicked = true,
                child: const Text('Spring Action'),
              ),
              MorphCheckbox(
                isChecked: false,
                onChanged: (val) => checked = val,
              ),
              const CountUpProgressRing(targetProgress: 0.84),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Spring Action'), findsOneWidget);
    expect(find.text('84%'), findsOneWidget);

    // Tap spring button
    await tester.tap(find.text('Spring Action'));
    await tester.pumpAndSettle();
    expect(clicked, isTrue);

    // Tap morph checkbox
    await tester.tap(find.byType(MorphCheckbox));
    await tester.pumpAndSettle();
    expect(checked, isTrue);
  });
}
