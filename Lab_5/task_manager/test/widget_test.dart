import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/widgets/action_buttons_row.dart';
import 'package:task_manager/widgets/image_banner_card.dart';
import 'package:task_manager/widgets/note_input_card.dart';
import 'package:task_manager/widgets/priority_switch_card.dart';
import 'package:task_manager/widgets/task_header.dart';
import 'package:task_manager/widgets/task_info_card.dart';

void main() {
  void setupPhoneSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  testWidgets('Lab5Screen contains all custom widgets and initial state', (
    WidgetTester tester,
  ) async {
    setupPhoneSize(tester);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify AppBar
    expect(find.text('Лабораторна робота №5'), findsOneWidget);

    // Verify custom widgets exist
    expect(find.byType(ImageBannerCard), findsOneWidget);
    expect(find.byType(TaskHeader), findsOneWidget);
    expect(find.byType(TaskInfoCard), findsOneWidget);
    expect(find.byType(PrioritySwitchCard), findsOneWidget);
    expect(find.byType(NoteInputCard), findsOneWidget);
    expect(find.byType(ActionButtonsRow), findsOneWidget);

    // Initial state checks
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.text('0'), findsOneWidget); // Counter initial value
    expect(find.text('— (поле порожнє)'), findsOneWidget); // Note initial value
    expect(find.text('ВИСОКИЙ ПРІОРИТЕТ'), findsNothing); // Badge not present initially
  });

  testWidgets('Favorite button toggles favorite state and icon', (
    WidgetTester tester,
  ) async {
    setupPhoneSize(tester);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final favoriteButton = find.byIcon(Icons.favorite_border);
    expect(favoriteButton, findsOneWidget);

    // Tap favorite
    await tester.tap(favoriteButton);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.text('Додано до обраного ❤️'), findsOneWidget);

    // Tap favorite again
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.text('Видалено з обраного 🤍'), findsOneWidget);
  });

  testWidgets('Priority Switch toggles urgent mode (badge, text, style)', (
    WidgetTester tester,
  ) async {
    setupPhoneSize(tester);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);

    // Initial: no badge, no urgent text
    expect(find.text('ВИСОКИЙ ПРІОРИТЕТ'), findsNothing);
    expect(
      find.text('Термінове завдання: вимагає першочергового закриття!'),
      findsNothing,
    );

    // Toggle switch ON
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    // Now badge and urgent text should appear
    expect(find.text('ВИСОКИЙ ПРІОРИТЕТ'), findsOneWidget);
    expect(
      find.text('Термінове завдання: вимагає першочергового закриття!'),
      findsOneWidget,
    );
    expect(find.text('Увімкнено терміновий пріоритет 🔥'), findsOneWidget);

    // Toggle switch OFF
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    expect(find.text('ВИСОКИЙ ПРІОРИТЕТ'), findsNothing);
    expect(
      find.text('Термінове завдання: вимагає першочергового закриття!'),
      findsNothing,
    );
  });

  testWidgets('TextField updates note display live via onChanged', (
    WidgetTester tester,
  ) async {
    setupPhoneSize(tester);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    await tester.enterText(textField, 'Тестова примітка до завдання');
    await tester.pumpAndSettle();

    expect(find.text('Тестова примітка до завдання'), findsNWidgets(2)); // in input and in display

    // Clear note using suffix icon
    final clearButton = find.byIcon(Icons.clear);
    expect(clearButton, findsOneWidget);
    await tester.tap(clearButton);
    await tester.pumpAndSettle();

    expect(find.text('— (поле порожнє)'), findsOneWidget);
  });

  testWidgets('Action button increments counter and reset resets it', (
    WidgetTester tester,
  ) async {
    setupPhoneSize(tester);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final executeButton = find.text('Виконати (+1)');
    final resetButton = find.text('Скинути');

    expect(find.text('0'), findsOneWidget);

    // Tap execute button twice
    await tester.tap(executeButton);
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(executeButton);
    await tester.pumpAndSettle();
    expect(find.text('2'), findsOneWidget);

    // Tap reset button
    await tester.tap(resetButton);
    await tester.pumpAndSettle();
    expect(find.text('0'), findsOneWidget);
  });
}
