import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_app/main.dart';
import 'package:storage_app/models/course_item.dart';
import 'package:storage_app/models/user_model.dart';
import 'package:storage_app/services/storage_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('StorageService Unit Tests (п. 1-8 ТЗ)', () {
    test('Збереження та завантаження даних користувача', () async {
      SharedPreferences.setMockInitialValues({});
      final service = StorageService();

      expect(await service.loadUser(), isNull);
      expect(await service.isUserRegistered(), isFalse);

      const user = UserModel(
        name: 'Багрій-Белз Андрій',
        email: 'andrii.bagriy@nulp.ua',
        password: 'SuperPassword123',
        phone: '+380 67 123 45 67',
        bio: 'Студент групи КН-2327Б',
        registeredAt: '2026-10-06 14:00:00',
      );

      await service.saveUser(user);

      expect(await service.isUserRegistered(), isTrue);
      final loaded = await service.loadUser();
      expect(loaded, isNotNull);
      expect(loaded!.name, 'Багрій-Белз Андрій');
      expect(loaded.email, 'andrii.bagriy@nulp.ua');
      expect(loaded.password, 'SuperPassword123');
      expect(loaded.phone, '+380 67 123 45 67');
      expect(loaded.bio, 'Студент групи КН-2327Б');
    });

    test('Збереження та перемикання favorites ids (п. 6, 7 ТЗ)', () async {
      SharedPreferences.setMockInitialValues({});
      final service = StorageService();

      expect(await service.loadFavoriteIds(), isEmpty);

      // Додавання course_1
      final added1 = await service.toggleFavorite('course_1');
      expect(added1, isTrue);
      expect(await service.loadFavoriteIds(), ['course_1']);
      expect(await service.isFavorite('course_1'), isTrue);

      // Додавання course_2
      final added2 = await service.toggleFavorite('course_2');
      expect(added2, isTrue);
      expect(await service.loadFavoriteIds(), ['course_1', 'course_2']);

      // Вилучення course_1
      final removed1 = await service.toggleFavorite('course_1');
      expect(removed1, isFalse);
      expect(await service.loadFavoriteIds(), ['course_2']);
      expect(await service.isFavorite('course_1'), isFalse);
      expect(await service.isFavorite('course_2'), isTrue);

      // Очищення
      await service.clearFavorites();
      expect(await service.loadFavoriteIds(), isEmpty);
    });

    test('Очищення облікових даних користувача (clearUser)', () async {
      SharedPreferences.setMockInitialValues({});
      final service = StorageService();

      const user = UserModel(
        name: 'Тестовий Користувач',
        email: 'test@example.com',
        password: 'pass',
      );
      await service.saveUser(user);
      expect(await service.isUserRegistered(), isTrue);

      await service.clearUser();
      expect(await service.isUserRegistered(), isFalse);
      expect(await service.loadUser(), isNull);
    });
  });

  group('Віджет-тести UI та інтеграції (п. 2, 4, 5, 8, 9, 10 ТЗ)', () {
    testWidgets('Початковий запуск без даних відкриває екран реєстрації', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(const StorageApp());
      await tester.pumpAndSettle();

      expect(find.text('Реєстрація користувача'), findsOneWidget);
      expect(find.byKey(const Key('name_field')), findsOneWidget);
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('register_button')), findsOneWidget);
    });

    testWidgets(
      'Реєстрація користувача зберігає дані та веде до каталогу/профілю',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        await tester.pumpWidget(const StorageApp());
        await tester.pumpAndSettle();
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        // Заповнення форми через кнопку демо-даних
        await tester.ensureVisible(find.byKey(const Key('demo_fill_button')));
        await tester.tap(find.byKey(const Key('demo_fill_button')));
        await tester.pumpAndSettle();

        expect(find.text('Багрій-Белз Андрій'), findsOneWidget);
        expect(find.text('andrii.bagriy@nulp.ua'), findsOneWidget);

        // Натискання кнопки реєстрації
        await tester.ensureVisible(find.byKey(const Key('register_button')));
        await tester.tap(find.byKey(const Key('register_button')));
        await tester.pumpAndSettle();

        // Повинен відобразитися головний екран з каталогом
        expect(find.text('Каталог курсів'), findsOneWidget);
        expect(find.byKey(const Key('nav_profile')), findsOneWidget);

        // Перехід на екран профілю
        await tester.tap(find.byKey(const Key('nav_profile')));
        await tester.pumpAndSettle();

        // Перевірка відображення збережених даних на ProfileScreen (п. 5 ТЗ)
        expect(find.byKey(const Key('profile_name_text')), findsOneWidget);
        expect(find.text('Багрій-Белз Андрій'), findsWidgets);
        expect(find.byKey(const Key('profile_email_text')), findsOneWidget);
        expect(find.text('andrii.bagriy@nulp.ua'), findsOneWidget);
      },
    );

    testWidgets('Додавання в обране та фільтрація на FavoritesScreen (п. 6, 8, 9 ТЗ)', (
      tester,
    ) async {
      // Початкові збережені дані
      SharedPreferences.setMockInitialValues({
        StorageService.keyIsRegistered: true,
        StorageService.keyName: 'Багрій-Белз Андрій',
        StorageService.keyEmail: 'andrii.bagriy@nulp.ua',
        StorageService.keyPassword: 'SecurePassword123',
        StorageService.keyFavoriteIds: <String>['course_1'],
      });

      await tester.pumpWidget(const StorageApp());
      await tester.pumpAndSettle();

      // Має завантажитися одразу головний екран
      expect(find.text('Каталог курсів'), findsOneWidget);

      // Перехід до вкладки "Обране"
      await tester.tap(find.byKey(const Key('nav_favorites')));
      await tester.pumpAndSettle();

      // На FavoritesScreen має відображатися ТІЛЬКИ course_1 (п. 9 ТЗ)
      expect(find.text('Обрані курси'), findsOneWidget);
      expect(
        find.text(CourseItem.sampleCourses[0].title),
        findsOneWidget,
      ); // course_1
      expect(
        find.text(CourseItem.sampleCourses[1].title),
        findsNothing,
      ); // course_2 не в обраному

      // Повернення до каталогу та додавання course_2
      await tester.tap(find.byKey(const Key('nav_catalog')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('fav_btn_course_2')));
      await tester.pumpAndSettle();

      // Знову перехід до обраного
      await tester.tap(find.byKey(const Key('nav_favorites')));
      await tester.pumpAndSettle();

      // Тепер обидва курси присутні
      expect(find.text(CourseItem.sampleCourses[0].title), findsOneWidget);
      expect(find.text(CourseItem.sampleCourses[1].title), findsOneWidget);
    });

    testWidgets(
      'Перевірка збереження даних після перезапуску застосунку (п. 10 ТЗ)',
      (tester) async {
        // Симуляція стану після тривалої роботи
        SharedPreferences.setMockInitialValues({
          StorageService.keyIsRegistered: true,
          StorageService.keyName: 'Багрій-Белз Андрій',
          StorageService.keyEmail: 'andrii.bagriy@nulp.ua',
          StorageService.keyPassword: 'MySecretPassword99',
          StorageService.keyPhone: '+380 67 999 88 77',
          StorageService.keyBio: 'Студент кафедри АСУ НУ ЛП',
          StorageService.keyFavoriteIds: <String>['course_2', 'course_4'],
        });

        // "Перезапуск" застосунку: новий інстанс StorageApp
        await tester.pumpWidget(const StorageApp());
        await tester.pumpAndSettle();

        // 1. Перевірка збереження профілю
        await tester.tap(find.byKey(const Key('nav_profile')));
        await tester.pumpAndSettle();

        expect(find.text('Багрій-Белз Андрій'), findsWidgets);
        expect(find.text('andrii.bagriy@nulp.ua'), findsOneWidget);
        expect(find.text('+380 67 999 88 77'), findsOneWidget);
        expect(find.text('Студент кафедри АСУ НУ ЛП'), findsOneWidget);

        // 2. Перевірка збереження обраних елементів
        await tester.tap(find.byKey(const Key('nav_favorites')));
        await tester.pumpAndSettle();

        expect(find.text(CourseItem.sampleCourses[1].title), findsOneWidget); // course_2
        expect(find.text(CourseItem.sampleCourses[3].title), findsOneWidget); // course_4
        expect(find.text(CourseItem.sampleCourses[0].title), findsNothing); // course_1 немає
      },
    );
  });
}
