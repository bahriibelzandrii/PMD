import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registration_app/main.dart';
import 'package:registration_app/screens/home_screen.dart';
import 'package:registration_app/screens/register_screen.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  void setPhoneSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
  }

  testWidgets('1. Відображення екрана реєстрації з усіма 5 полями та кнопкою',
      (WidgetTester tester) async {
    setPhoneSize(tester);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const RegistrationApp());
    await tester.pumpAndSettle();

    expect(find.text('Реєстрація'), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(5));
    expect(find.text("Ім'я користувача"), findsOneWidget);
    expect(find.text('Дата народження'), findsOneWidget);
    expect(find.text('Електронна пошта (Email)'), findsOneWidget);
    expect(find.text('Пароль'), findsOneWidget);
    expect(find.text('Підтвердження пароля'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Зареєструватися'), findsOneWidget);
  });

  testWidgets('2. Валідація: спроба відправки порожньої форми блокує перехід і виводить помилки',
      (WidgetTester tester) async {
    setPhoneSize(tester);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const RegistrationApp());
    await tester.pumpAndSettle();

    final submitBtn = find.widgetWithText(ElevatedButton, 'Зареєструватися');
    await tester.ensureVisible(submitBtn);
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    // Перевіряємо помилки для всіх полів
    expect(find.text("Поле імені користувача не може бути порожнім"), findsOneWidget);
    expect(find.text('Введіть дату народження'), findsOneWidget);
    expect(find.text('Введіть адресу електронної пошти'), findsOneWidget);
    expect(find.text('Введіть пароль'), findsOneWidget);
    expect(find.text('Підтвердіть пароль'), findsOneWidget);

    // HomeScreen НЕ повинен з'явитися (п. 13 ТЗ)
    expect(find.byType(HomeScreen), findsNothing);
  });

  testWidgets('3. Валідація: некоректні формати даних (довжина, @, паролі)',
      (WidgetTester tester) async {
    setPhoneSize(tester);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const RegistrationApp());
    await tester.pumpAndSettle();

    final textFields = find.byType(TextFormField);

    // 1. Коротке ім'я (< 3 символів)
    await tester.enterText(textFields.at(0), 'An');

    // 2. Некоректна дата
    await tester.enterText(textFields.at(1), 'не_дата');

    // 3. Email без @
    await tester.enterText(textFields.at(2), 'invalid-email');

    // 4. Пароль менше 6 символів
    await tester.enterText(textFields.at(3), '123');

    // 5. Підтвердження пароля не збігається
    await tester.enterText(textFields.at(4), '999999');

    final submitBtn = find.widgetWithText(ElevatedButton, 'Зареєструватися');
    await tester.ensureVisible(submitBtn);
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    expect(find.text("Ім'я користувача повинно містити щонайменше 3 символи"), findsOneWidget);
    expect(find.text('Некоректний формат дати (приклад: 2004-05-15 або 15.05.2004)'), findsOneWidget);
    expect(find.text('Email повинен містити символ @'), findsOneWidget);
    expect(find.text('Пароль повинен містити не менше 6 символів'), findsOneWidget);
    expect(find.text('Поле підтвердження пароля повинно збігатися з паролем'), findsOneWidget);

    expect(find.byType(HomeScreen), findsNothing);
  });

  testWidgets('4. Успішна валідація та перехід на HomeScreen із передачею імені',
      (WidgetTester tester) async {
    setPhoneSize(tester);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const RegistrationApp());
    await tester.pumpAndSettle();

    final textFields = find.byType(TextFormField);

    await tester.enterText(textFields.at(0), 'Андрій');
    await tester.enterText(textFields.at(1), '2004-05-15');
    await tester.enterText(textFields.at(2), 'andrii@example.com');
    await tester.enterText(textFields.at(3), 'secret123');
    await tester.enterText(textFields.at(4), 'secret123');

    final submitBtn = find.widgetWithText(ElevatedButton, 'Зареєструватися');
    await tester.ensureVisible(submitBtn);
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    // Перевіряємо перехід на HomeScreen (п. 8 ТЗ)
    expect(find.byType(HomeScreen), findsOneWidget);

    // Перевіряємо текст привітання з переданим ім'ям (п. 9, 10 ТЗ)
    expect(find.text('Вітаємо, Андрій! 🎉'), findsOneWidget);
    expect(find.text('andrii@example.com'), findsOneWidget);
    expect(find.text('2004-05-15'), findsOneWidget);

    // Перевіряємо кнопку повернення
    final backBtn = find.widgetWithText(OutlinedButton, 'Повернутися до реєстрації');
    await tester.ensureVisible(backBtn);
    await tester.tap(backBtn);
    await tester.pumpAndSettle();

    expect(find.byType(RegisterScreen), findsOneWidget);
  });

  testWidgets('5. Кнопка автозаповнення демо-даних заповнює валідну форму',
      (WidgetTester tester) async {
    setPhoneSize(tester);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const RegistrationApp());
    await tester.pumpAndSettle();

    // Тиснемо кнопку автозаповнення в AppBar
    await tester.tap(find.byIcon(Icons.auto_fix_high));
    await tester.pumpAndSettle();

    expect(find.text('Андрій Багрій-Белз'), findsOneWidget);
    expect(find.text('2004-05-15'), findsOneWidget);
    expect(find.text('andrii.bagriy@nulp.ua'), findsOneWidget);

    // Натискаємо «Зареєструватися»
    final submitBtn = find.widgetWithText(ElevatedButton, 'Зареєструватися');
    await tester.ensureVisible(submitBtn);
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Вітаємо, Андрій Багрій-Белз! 🎉'), findsOneWidget);
  });
}
