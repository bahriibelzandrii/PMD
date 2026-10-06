import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/widgets/stats_summary_card.dart';
import 'package:task_manager/widgets/task_list_item.dart';

void main() {
  testWidgets('Lab6: Перевірка ініціалізації моделі та початкового списку',
      (WidgetTester tester) async {
    final tasks = getInitialTasks();
    expect(tasks.length, greaterThanOrEqualTo(5));
    expect(tasks.first.id, 1);
    expect(tasks.first.title, isNotEmpty);
    expect(tasks.first.status, isA<TaskStatus>());
    expect(tasks.first.isFavorite, isA<bool>());
  });

  testWidgets('Lab6: Відображення початкового списку та статистики на екрані',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Перевірка заголовка
    expect(find.text('Лабораторна робота №6'), findsOneWidget);

    // Перевірка віджета статистики
    expect(find.byType(StatsSummaryCard), findsOneWidget);
    expect(find.text('Статистика завдань (Map<String, int>)'), findsOneWidget);
    expect(find.text('Всього'), findsOneWidget);
    expect(find.text('Активні'), findsOneWidget);

    // Перевірка початкових завдань у ListView
    expect(find.byType(TaskListItem), findsWidgets);
    expect(find.text('Оптимізація запитів до бази даних'), findsOneWidget);
    expect(find.text('Рефакторинг архітектури Flutter-екранів'), findsOneWidget);
  });

  testWidgets('Lab6: Перемикання "обране" (isFavorite) та зміна статистики',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Знаходимо іконку "обране" саме всередині TaskListItem
    final taskFavoriteIcon = find.descendant(
      of: find.byType(TaskListItem),
      matching: find.byIcon(Icons.favorite),
    );
    expect(taskFavoriteIcon, findsWidgets);

    // Натискаємо на іконку обраного в першому елементі
    await tester.tap(taskFavoriteIcon.first);
    await tester.pumpAndSettle();

    expect(find.text('Видалено з обраного 🤍'), findsOneWidget);
  });

  testWidgets('Lab6: Перемикання статусу (TaskStatus enum) через кнопку або клік',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Перше завдання активне - знаходимо unchecked іконку
    final uncheckIcons = find.byIcon(Icons.radio_button_unchecked);
    expect(uncheckIcons, findsWidgets);

    await tester.tap(uncheckIcons.first);
    await tester.pumpAndSettle();

    expect(find.text('Завдання виконано! 🎉'), findsOneWidget);
  });

  testWidgets('Lab6: Додавання нового елемента через діалог',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Натискаємо кнопку FAB "Нове завдання"
    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    // Перевіряємо відкриття діалогу
    expect(find.byType(AlertDialog), findsOneWidget);

    // Вводимо текст у TextField діалогу
    final dialogTextField = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextField),
    );
    expect(dialogTextField, findsOneWidget);
    await tester.enterText(dialogTextField, 'Тестове нове завдання');
    await tester.pumpAndSettle();

    // Натискаємо кнопку "Додати" всередині діалогу
    final addButton = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.text('Додати'),
    );
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Перевіряємо, що з'явився SnackBar про успішне додавання
    expect(find.text('Завдання успішно додано! 🚀'), findsOneWidget);

    // Прокручуємо список вниз, щоб побачити додане завдання
    final listViewScrollable = find.byType(Scrollable).last;
    await tester.scrollUntilVisible(
      find.text('Тестове нове завдання'),
      100.0,
      scrollable: listViewScrollable,
    );
    expect(find.text('Тестове нове завдання'), findsOneWidget);
  });

  testWidgets('Lab6: Видалення елемента зі списку',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Оптимізація запитів до бази даних'), findsOneWidget);

    // Знаходимо кнопку видалення в першому елементі
    final deleteButtons = find.byIcon(Icons.delete_outline);
    expect(deleteButtons, findsWidgets);

    await tester.tap(deleteButtons.first);
    await tester.pumpAndSettle();

    // Перевіряємо видалення і появу SnackBar
    expect(find.textContaining('видалено'), findsOneWidget);
    expect(find.text('Оптимізація запитів до бази даних'), findsNothing);
  });

  testWidgets('Lab6: Фільтрація списку за категоріями',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Натискаємо на ChoiceChip "Обрані (2)"
    final favoritesChip = find.widgetWithText(ChoiceChip, 'Обрані (2)');
    expect(favoritesChip, findsOneWidget);
    await tester.tap(favoritesChip);
    await tester.pumpAndSettle();

    // Тільки обрані повинні показуватися (завдання 1 і 4)
    expect(find.text('Оптимізація запитів до бази даних'), findsOneWidget);
    expect(find.text('Написання віджет-тестів та перевірка стану'), findsOneWidget);
    // Необрані завдання повинні бути відфільтровані
    expect(find.text('Рефакторинг архітектури Flutter-екранів'), findsNothing);
  });
}
