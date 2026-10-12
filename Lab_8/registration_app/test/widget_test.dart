import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registration_app/main.dart';
import 'package:registration_app/models/task_model.dart';
import 'package:registration_app/screens/login_screen.dart';
import 'package:registration_app/screens/register_screen.dart';
import 'package:registration_app/screens/task_manager_screen.dart';
import 'package:registration_app/screens/welcome_screen.dart';
import 'package:registration_app/services/task_storage_service.dart';
import 'package:registration_app/widgets/task_list_item.dart';

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

  // Локalний JSON-файл, з якого TaskManagerScreen читає дані в тестах
  final storageService = TaskStorageService();

  setUp(() {
    storageService.saveTasks(getTestInitialTasks());
  });

  void setPhoneSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
  }

  Future<void> loadWelcome(WidgetTester tester) async {
    await tester.pumpWidget(const RegistrationApp());
    await tester.pumpAndSettle();
    expect(find.byType(WelcomeScreen), findsOneWidget);
  }

  Future<void> openRegister(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(OutlinedButton, 'Зареєструватися'));
    await tester.pumpAndSettle();
    expect(find.byType(RegisterScreen), findsOneWidget);
  }

  Future<void> openLogin(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(ElevatedButton, 'Увійти'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  }

  Future<void> fillRegisterForm(
    WidgetTester tester, {
    String username = 'Андрій',
    String birthDate = '2004-05-15',
    String email = 'test@example.com',
    String password = 'secret123',
    String confirm = 'secret123',
  }) async {
    await tester.enterText(find.byType(TextFormField).at(0), username);
    await tester.enterText(find.byType(TextFormField).at(1), birthDate);
    await tester.enterText(find.byType(TextFormField).at(2), email);
    await tester.enterText(find.byType(TextFormField).at(3), password);
    await tester.enterText(find.byType(TextFormField).at(4), confirm);
  }

  testWidgets('1. Welcome-екран: заголовок та кнопки входу й реєстрації', (
    WidgetTester tester,
  ) async {
    setPhoneSize(tester);
    addTearDown(tester.view.resetPhysicalSize);

    await loadWelcome(tester);

    expect(find.text('Менеджер завдань'), findsWidgets);
    expect(find.widgetWithText(ElevatedButton, 'Увійти'), findsOneWidget);
    expect(
      find.widgetWithText(OutlinedButton, 'Зареєструватися'),
      findsOneWidget,
    );
  });

  testWidgets('2. Перехід на екран реєстрації з 5 полями та кнопкою', (
    WidgetTester tester,
  ) async {
    setPhoneSize(tester);
    addTearDown(tester.view.resetPhysicalSize);

    await loadWelcome(tester);
    await openRegister(tester);

    expect(find.text('Реєстрація'), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(5));
    expect(find.text("Ім'я користувача"), findsOneWidget);
    expect(find.text('Дата народження'), findsOneWidget);
    expect(find.text('Електронна пошта (Email)'), findsOneWidget);
    expect(find.text('Підтвердження пароля'), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, 'Зареєструватися'),
      findsOneWidget,
    );
  });

  testWidgets(
    '3. Порожня форма реєстрації блокує перехід до менеджера завдань',
    (WidgetTester tester) async {
      setPhoneSize(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await loadWelcome(tester);
      await openRegister(tester);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Зареєструватися'));
      await tester.pumpAndSettle();

      expect(find.byType(TaskManagerScreen), findsNothing);
      expect(find.textContaining('не може бути порожнім'), findsWidgets);
    },
  );

  testWidgets(
    '4. Некоректні дані реєстрації блокують перехід (формати, @, паролі)',
    (WidgetTester tester) async {
      setPhoneSize(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await loadWelcome(tester);
      await openRegister(tester);
      await fillRegisterForm(
        tester,
        username: 'А',
        birthDate: 'не-дата',
        email: 'bezpoglushky',
        password: '123',
        confirm: 'inshy',
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Зареєструватися'));
      await tester.pumpAndSettle();

      expect(find.byType(TaskManagerScreen), findsNothing);
      expect(find.textContaining('щонайменше 3 символи'), findsOneWidget);
      expect(find.textContaining('Некоректний формат дати'), findsOneWidget);
      expect(find.textContaining('символ @'), findsOneWidget);
      expect(find.textContaining('не менше 6 символів'), findsOneWidget);
      expect(find.textContaining('збігатися'), findsOneWidget);
    },
  );

  testWidgets(
    '5. Успішна реєстрація: перехід до менеджера завдань з іменем та списком із JSON',
    (WidgetTester tester) async {
      setPhoneSize(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await loadWelcome(tester);
      await openRegister(tester);
      await fillRegisterForm(tester);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Зареєструватися'));
      await tester.pumpAndSettle();

      expect(find.byType(TaskManagerScreen), findsOneWidget);
      expect(find.text('Вітаємо, Андрій! 👋'), findsOneWidget);
      expect(find.byType(TaskListItem), findsNWidgets(6));
      expect(find.text('Менеджер завдань'), findsOneWidget);
    },
  );

  testWidgets('6. Кнопка демо-даних заповнює валідну форму реєстрації', (
    WidgetTester tester,
  ) async {
    setPhoneSize(tester);
    addTearDown(tester.view.resetPhysicalSize);

    await loadWelcome(tester);
    await openRegister(tester);

    // Іконка автозаповнення в AppBar
    await tester.tap(find.byTooltip('Заповнити тестовими даними'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Зареєструватися'));
    await tester.pumpAndSettle();

    expect(find.byType(TaskManagerScreen), findsOneWidget);
    expect(find.textContaining('Вітаємо, '), findsOneWidget);
  });

  testWidgets('7. Вхід: порожня форма блокується, коректна веде до менеджера', (
    WidgetTester tester,
  ) async {
    setPhoneSize(tester);
    addTearDown(tester.view.resetPhysicalSize);

    await loadWelcome(tester);
    await openLogin(tester);

    // Спроба входу з порожніми полями
    await tester.tap(find.widgetWithText(ElevatedButton, 'Увійти'));
    await tester.pumpAndSettle();
    expect(find.byType(TaskManagerScreen), findsNothing);
    expect(find.text('Введіть пароль'), findsOneWidget);

    // Коректний вхід: ім'я бере з локальної частини email
    await tester.enterText(find.byType(TextFormField).at(0), 'ivan@ukr.net');
    await tester.enterText(find.byType(TextFormField).at(1), 'password1');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Увійти'));
    await tester.pumpAndSettle();

    expect(find.byType(TaskManagerScreen), findsOneWidget);
    expect(find.text('Вітаємо, ivan! 👋'), findsOneWidget);
    expect(find.byType(TaskListItem), findsNWidgets(6));
  });

  testWidgets(
    '8. Вхід: чарівна кнопка автозаповнює форму та веде до менеджера',
    (WidgetTester tester) async {
      setPhoneSize(tester);
      addTearDown(tester.view.resetPhysicalSize);

      await loadWelcome(tester);
      await openLogin(tester);

      // Чарівна кнопка у AppBar заповнює обидва поля
      await tester.tap(find.byTooltip('Заповнити тестовими даними'));
      await tester.pumpAndSettle();
      expect(find.text('andrii.bagriy@nulp.ua'), findsOneWidget);

      // Вхід з заповненою формою
      await tester.tap(find.widgetWithText(ElevatedButton, 'Увійти'));
      await tester.pumpAndSettle();

      expect(find.byType(TaskManagerScreen), findsOneWidget);
      expect(find.text('Вітаємо, andrii.bagriy! 👋'), findsOneWidget);
      expect(find.byType(TaskListItem), findsNWidgets(6));
    },
  );
}
