import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/services/task_storage_service.dart';
import 'package:task_manager/widgets/stats_summary_card.dart';
import 'package:task_manager/widgets/task_list_item.dart';

List<TaskModel> getTestInitialTasks() {
  return [
    TaskModel(
      id: 1,
      title: 'Оптимізація запитів до бази даних',
      isFavorite: true,
      status: TaskStatus.active,
    ),
    TaskModel(
      id: 2,
      title: 'Рефакторинг архітектури Flutter-екранів',
      isFavorite: false,
      status: TaskStatus.done,
    ),
    TaskModel(
      id: 3,
      title: 'Інтеграція REST API та обробка помилок',
      isFavorite: false,
      status: TaskStatus.active,
    ),
    TaskModel(
      id: 4,
      title: 'Написання віджет-тестів та перевірка стану',
      isFavorite: true,
      status: TaskStatus.done,
    ),
    TaskModel(
      id: 5,
      title: 'Оновлення темної палітри кольорів Material 3',
      isFavorite: false,
      status: TaskStatus.active,
    ),
    TaskModel(
      id: 6,
      title: 'Підготовка збірки та публікація в Play Store',
      isFavorite: false,
      status: TaskStatus.active,
    ),
  ];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final storageService = TaskStorageService();

  void resetTestStorage() {
    storageService.saveTasks(getTestInitialTasks());
  }

  setUp(() {
    resetTestStorage();
  });

  tearDownAll(() {
    try {
      final file = File('${Directory.systemTemp.path}/tasks_test_$pid.json');
      if (file.existsSync()) {
        file.deleteSync();
      }
    } catch (_) {}
  });

  group('Lab 7 Unit Tests: JSON & Model Serialization', () {
    testWidgets('TaskModel fromJson та toJson працюють коректно', (
      tester,
    ) async {
      final jsonMap = {
        'id': 42,
        'title': 'Тестове завдання JSON',
        'isFavorite': true,
        'status': 'done',
      };

      final task = TaskModel.fromJson(jsonMap);
      expect(task.id, 42);
      expect(task.title, 'Тестове завдання JSON');
      expect(task.isFavorite, isTrue);
      expect(task.status, TaskStatus.done);
      expect(task.isDone, isTrue);

      final serialized = task.toJson();
      expect(serialized['id'], 42);
      expect(serialized['title'], 'Тестове завдання JSON');
      expect(serialized['isFavorite'], isTrue);
      expect(serialized['status'], 'done');
    });

    testWidgets('tasksFromJson та tasksToJson коректно обробляють масиви', (
      tester,
    ) async {
      const jsonString = '''
      [
        {"id": 1, "title": "Task 1", "isFavorite": false, "status": "active"},
        {"id": 2, "title": "Task 2", "isFavorite": true, "status": "done"}
      ]
      ''';

      final tasks = tasksFromJson(jsonString);
      expect(tasks.length, 2);
      expect(tasks[0].id, 1);
      expect(tasks[1].id, 2);

      final encoded = tasksToJson(tasks);
      expect(encoded, contains('"title": "Task 1"'));
      expect(encoded, contains('"status": "done"'));
    });

    testWidgets('TaskStorageService зберігає та читає JSON локально', (
      tester,
    ) async {
      final tasks = await storageService.loadTasks();
      expect(tasks.length, 6);
      expect(tasks.first.title, 'Оптимізація запитів до бази даних');
    });
  });

  group('Lab 7 Widget Tests: UI, ListView.builder, Add, Edit, Delete', () {
    Future<void> loadApp(WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpAndSettle();
    }

    testWidgets(
      'Відображення списку завдань та статистики після завантаження',
      (WidgetTester tester) async {
        await loadApp(tester);

        expect(find.text('Лабораторна робота №7'), findsOneWidget);
        expect(find.byType(StatsSummaryCard), findsOneWidget);
        expect(find.byType(TaskListItem), findsWidgets);
        expect(find.text('Оптимізація запитів до бази даних'), findsOneWidget);
      },
    );

    testWidgets('Перемикання обраного та статусу', (WidgetTester tester) async {
      await loadApp(tester);

      // Знаходимо іконку обраного в першому елементі
      final favoriteIcon = find.descendant(
        of: find.byType(TaskListItem).first,
        matching: find.byIcon(Icons.favorite),
      );
      expect(favoriteIcon, findsOneWidget);

      await tester.tap(favoriteIcon);
      await tester.pumpAndSettle();

      expect(find.textContaining('Видалено з обраного'), findsOneWidget);

      // Перемикаємо статус
      final uncheckIcon = find.descendant(
        of: find.byType(TaskListItem).first,
        matching: find.byIcon(Icons.radio_button_unchecked),
      );
      expect(uncheckIcon, findsOneWidget);

      await tester.tap(uncheckIcon);
      await tester.pumpAndSettle();

      expect(find.textContaining('Завдання виконано!'), findsOneWidget);
    });

    testWidgets('Додавання нового елемента через діалог', (
      WidgetTester tester,
    ) async {
      await loadApp(tester);

      // Натискаємо FAB
      final fab = find.byType(FloatingActionButton);
      await tester.tap(fab);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Нове завдання (JSON)'), findsOneWidget);

      // Вводимо назву
      final textField = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      );
      await tester.enterText(textField, 'Автоматизоване тестування JSON');
      await tester.pumpAndSettle();

      // Натискаємо "Додати"
      final addButton = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Додати'),
      );
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Завдання додано та збережено в JSON'),
        findsOneWidget,
      );

      // Прокручуємо до нового елемента
      final scrollable = find.byType(Scrollable).last;
      await tester.scrollUntilVisible(
        find.text('Автоматизоване тестування JSON'),
        100.0,
        scrollable: scrollable,
      );
      expect(find.text('Автоматизоване тестування JSON'), findsOneWidget);
    });

    testWidgets('Редагування існуючого елемента через діалог', (
      WidgetTester tester,
    ) async {
      await loadApp(tester);

      // Знаходимо кнопку редагування в першому елементі
      final editButton = find.descendant(
        of: find.byType(TaskListItem).first,
        matching: find.byIcon(Icons.edit_outlined),
      );
      expect(editButton, findsOneWidget);

      await tester.tap(editButton);
      await tester.pumpAndSettle();

      // Перевіряємо відкриття діалогу редагування
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.textContaining('Редагувати #1'), findsOneWidget);

      // Змінюємо текст
      final textField = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      );
      await tester.enterText(textField, 'Оптимізація бази даних (Оновлено)');
      await tester.pumpAndSettle();

      // Натискаємо "Зберегти"
      final saveButton = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Зберегти'),
      );
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Зміни збережено в JSON-файл'),
        findsOneWidget,
      );
      expect(find.text('Оптимізація бази даних (Оновлено)'), findsOneWidget);
    });

    testWidgets('Видалення завдання зі списку', (WidgetTester tester) async {
      await loadApp(tester);

      // Знаходимо кнопку видалення в першому елементі
      final deleteButton = find.descendant(
        of: find.byType(TaskListItem).first,
        matching: find.byIcon(Icons.delete_outline),
      );
      expect(deleteButton, findsOneWidget);

      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      expect(find.textContaining('видалено з JSON'), findsOneWidget);
    });

    testWidgets('Фільтрація завдань за чіпами', (WidgetTester tester) async {
      await loadApp(tester);

      final favoritesChip = find.textContaining('Обрані (');
      expect(favoritesChip, findsOneWidget);

      await tester.tap(favoritesChip);
      await tester.pumpAndSettle();

      expect(find.byType(TaskListItem), findsWidgets);
    });
  });
}
