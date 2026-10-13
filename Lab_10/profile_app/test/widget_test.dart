import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile_app/main.dart';
import 'package:profile_app/models/task_model.dart';
import 'package:profile_app/screens/login_screen.dart';
import 'package:profile_app/screens/register_screen.dart';
import 'package:profile_app/screens/task_manager_screen.dart';
import 'package:profile_app/screens/profile_screen.dart';
import 'package:profile_app/screens/welcome_screen.dart';
import 'package:profile_app/services/task_storage_service.dart';
import 'package:profile_app/services/user_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:profile_app/widgets/task_list_item.dart';

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

  setUp(() async {
    // Локальне сховище для тестів (п. 1 ТЗ ЛР 10)
    SharedPreferences.setMockInitialValues({});
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

  // ============================================================
  // ЛАБОРАТОРНА №10: локальне збереження даних (SharedPreferences)
  // ============================================================

  testWidgets(
    '9. UserStorageService: збереження та завантаження даних користувача (п. 2-5 ТЗ ЛР 10)',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final service = UserStorageService();

      // Спочатку записів немає
      expect(await service.isRegistered(), isFalse);
      expect(await service.loadUser(), isNull);

      // Зберігаємо дані користувача
      await service.saveUser(
        name: 'Андрій Багрій-Белз',
        email: 'andrii.bagriy@nulp.ua',
        password: 'flutter2026',
      );

      // Дані зчитуються після «перезавантаження»
      expect(await service.isRegistered(), isTrue);
      final user = await service.loadUser();
      expect(user, isNotNull);
      expect(user!.name, 'Андрій Багрій-Белз');
      expect(user.email, 'andrii.bagriy@nulp.ua');
      expect(user.password, 'flutter2026');
    },
  );

  testWidgets(
    '10. UserStorageService: збереження та завантаження favorites ids (п. 6, 7 ТЗ ЛР 10)',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final service = UserStorageService();

      expect(await service.loadFavoriteIds(), isEmpty);
      await service.saveFavoriteIds(['1', '3', '5']);
      expect(await service.loadFavoriteIds(), ['1', '3', '5']);

      // Очищення
      await service.clearFavorites();
      expect(await service.loadFavoriteIds(), isEmpty);
    },
  );

  testWidgets(
    '11. Успішна реєстрація зберігає користувача, повторний запуск відновлює сесію (п. 2-5 ТЗ ЛР 10)',
    (WidgetTester tester) async {
      setPhoneSize(tester);
      addTearDown(tester.view.resetPhysicalSize);
      SharedPreferences.setMockInitialValues({});

      // Перший запуск: реєстрація
      await loadWelcome(tester);
      await openRegister(tester);
      await fillRegisterForm(
        tester,
        username: 'Андрій',
        email: 'andrii@nulp.ua',
        password: 'flutter2026',
        confirm: 'flutter2026',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Зареєструватися'));
      await tester.pumpAndSettle();
      expect(find.byType(TaskManagerScreen), findsOneWidget);

      // Дані збережені у SharedPreferences
      expect(await UserStorageService().isRegistered(), isTrue);

      // Повторний запуск застосунку: сесія відновлюється автоматично
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(const RegistrationApp());
      await tester.pumpAndSettle();
      expect(find.byType(TaskManagerScreen), findsOneWidget);
      expect(find.text('Вітаємо, Андрій! 👋'), findsOneWidget);
    },
  );

  testWidgets(
    '12. Перемикання обраного синхронізує favorites ids у SharedPreferences (п. 6-9 ТЗ ЛР 10)',
    (WidgetTester tester) async {
      setPhoneSize(tester);
      addTearDown(tester.view.resetPhysicalSize);
      SharedPreferences.setMockInitialValues({});

      await loadWelcome(tester);
      await openRegister(tester);
      await fillRegisterForm(tester);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Зареєструватися'));
      await tester.pumpAndSettle();
      expect(find.byType(TaskManagerScreen), findsOneWidget);

      // Спочатку жодних обраних
      expect(await UserStorageService().loadFavoriteIds(), isEmpty);

      // Означаємо перше завдання як обране (іконка favorite_border)
      await tester.tap(find.byIcon(Icons.favorite_border).first);
      await tester.pumpAndSettle();

      // Id збережено у SharedPreferences
      final ids = await UserStorageService().loadFavoriteIds();
      expect(ids, isNotEmpty);

      // Переходимо у фільтр «Обране» — бачимо рівно один елемент
      await tester.tap(
        find.ancestor(
          of: find.textContaining('Обрані (1)'),
          matching: find.byType(GestureDetector),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TaskListItem), findsNWidgets(1));
    },
  );

  testWidgets(
    '13. Вихід: очищення SharedPreferences і повернення на Welcome (п. 6-7 ТЗ ЛР 10)',
    (WidgetTester tester) async {
      setPhoneSize(tester);
      addTearDown(tester.view.resetPhysicalSize);
      SharedPreferences.setMockInitialValues({});

      final service = UserStorageService();
      await service.saveUser(
        name: 'Андрій',
        email: 'andrii@nulp.ua',
        password: 'pass123',
      );
      await service.saveFavoriteIds(['1']);

      await tester.pumpWidget(
        MaterialApp(
          home: ProfileScreen(
            username: 'Андрій',
            email: 'andrii@nulp.ua',
            password: 'pass123',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Картка зі збереженими даними відображається (п. 4, 5 ТЗ ЛР 10)
      expect(find.textContaining('Дані зі сховища'), findsOneWidget);

      // Натискання «Вийти з акаунта» → діалог підтвердження
      final logout = find.widgetWithText(OutlinedButton, 'Вийти з акаунта');
      await tester.ensureVisible(logout);
      await tester.pumpAndSettle();
      await tester.tap(logout);
      await tester.pumpAndSettle();
      expect(find.text('Вихід із профілю'), findsOneWidget);

      // Підтвердження виходу
      await tester.tap(find.widgetWithText(ElevatedButton, 'Вийти'));
      await tester.pumpAndSettle();

      // Повернення на Welcome-екран
      expect(find.byType(ProfileScreen), findsNothing);
      expect(find.byType(WelcomeScreen), findsOneWidget);

      // SharedPreferences очищено: користувач і favorites видалені
      expect(await service.isRegistered(), isFalse);
      expect(await service.loadUser(), isNull);
      expect(await service.loadFavoriteIds(), isEmpty);
    },
  );
}
