import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile_app/main.dart';
import 'package:profile_app/theme/app_colors.dart';
import 'package:profile_app/theme/app_styles.dart';

void main() {
  testWidgets('1. Відображення екрана ProfileScreen та обов’язкових елементів', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProfileApp());
    await tester.pumpAndSettle();

    // Перевірка наявності AppBar та імені користувача
    expect(find.text('Профіль користувача'), findsOneWidget);
    expect(find.text('Багрій-Белз Андрій'), findsOneWidget);

    // Перевірка email та статусу
    expect(find.text('andrii.bagriy@nulp.ua'), findsOneWidget);
    expect(
      find.textContaining('Студент НУ «Львівська політехніка»'),
      findsOneWidget,
    );

    // Перевірка наявності перемикача теми
    expect(find.text('Темна тема (Dark Mode)'), findsOneWidget);
    expect(find.byKey(const Key('theme_switch_tile')), findsOneWidget);

    // Перевірка наявності кнопок
    expect(find.text('Редагувати профіль'), findsOneWidget);
    expect(find.text('Вийти з акаунта'), findsOneWidget);
  });

  testWidgets('2. Перемикання теми з темної (Dark) на світлу (Light)', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProfileApp());
    await tester.pumpAndSettle();

    // За замовчуванням темний режим
    expect(find.text('Увімкнено нічний режим'), findsOneWidget);

    // Натискаємо на SwitchListTile для перемикання на світлу тему
    await tester.tap(find.byKey(const Key('theme_switch_tile')));
    await tester.pumpAndSettle();

    // Стан повинен оновитися на денний режим
    expect(find.text('Увімкнено денний режим'), findsOneWidget);
  });

  testWidgets('3. Повторне перемикання теми зі світлої назад у темну', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProfileApp());
    await tester.pumpAndSettle();

    // Перше перемикання: Dark -> Light
    await tester.tap(find.byKey(const Key('theme_switch_tile')));
    await tester.pumpAndSettle();
    expect(find.text('Увімкнено денний режим'), findsOneWidget);

    // Друге перемикання: Light -> Dark
    await tester.tap(find.byKey(const Key('theme_switch_tile')));
    await tester.pumpAndSettle();
    expect(find.text('Увімкнено нічний режим'), findsOneWidget);
  });

  testWidgets('4. Перевірка цілісності палітри AppColors та стилів AppStyles', (
    WidgetTester tester,
  ) async {
    // Перевірка узгодженості кольорів
    expect(AppColors.primary, const Color(0xFF4A90E2));
    expect(AppColors.secondary, const Color(0xFFF5A623));
    expect(AppColors.lightBackground, isNot(equals(AppColors.darkBackground)));
    expect(AppColors.textLight, isNot(equals(AppColors.textDark)));

    // Перевірка налаштування шрифту
    expect(AppStyles.fontFamily, 'Inter');
    expect(AppStyles.titleStatic.fontFamily, 'Inter');
    expect(AppStyles.button.fontFamily, 'Inter');
  });

  testWidgets('5. Відображення діалогу підтвердження виходу з акаунта', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProfileApp());
    await tester.pumpAndSettle();

    // Знаходимо та натискаємо кнопку виходу
    final logoutButton = find.text('Вийти з акаунта');
    await tester.ensureVisible(logoutButton);
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    // Перевіряємо відображення діалогового вікна AlertDialog
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Вихід із профілю'), findsOneWidget);
    expect(find.text('Скасувати'), findsOneWidget);

    // Скасовуємо вихід
    await tester.tap(find.text('Скасувати'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
  });
}
