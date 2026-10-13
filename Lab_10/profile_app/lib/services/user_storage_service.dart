import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_data.dart';

/// Сервіс локального збереження даних через SharedPreferences (п. 1 ТЗ ЛР 10):
/// - дані користувача з екрана реєстрації (ім'я, email, пароль) — п. 2, 3 ТЗ;
/// - список ідентифікаторів обраних елементів (favorites ids) — п. 6, 7 ТЗ.
class UserStorageService {
  // Ключі збереження даних користувача (п. 3 ТЗ)
  static const String keyName = 'user_name';
  static const String keyEmail = 'user_email';
  static const String keyPassword = 'user_password';
  static const String keyIsRegistered = 'is_registered';

  // Ключ списку favorites ids (п. 7 ТЗ)
  static const String keyFavoriteIds = 'favorite_ids';

  /// Збереження даних користувача, введених на екрані реєстрації (п. 2, 3 ТЗ)
  Future<void> saveUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyName, name);
    await prefs.setString(keyEmail, email);
    await prefs.setString(keyPassword, password);
    await prefs.setBool(keyIsRegistered, true);
  }

  /// Завантаження даних користувача після повторного запуску (п. 4 ТЗ).
  /// Повертає null, якщо користувач ще не реєструвався.
  Future<UserData?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(keyIsRegistered) ?? false) {
      return UserData(
        name: prefs.getString(keyName) ?? '',
        email: prefs.getString(keyEmail) ?? '',
        password: prefs.getString(keyPassword) ?? '',
      );
    }
    return null;
  }

  /// Прапорець наявності збереженого користувача (п. 4 ТЗ)
  Future<bool> isRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsRegistered) ?? false;
  }

  /// Отримання збережених favorites ids (п. 8 ТЗ)
  Future<List<String>> loadFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(keyFavoriteIds) ?? const [];
  }

  /// Збереження списку favorites ids (п. 6, 7 ТЗ)
  Future<void> saveFavoriteIds(List<String> favoriteIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(keyFavoriteIds, favoriteIds);
  }

  /// Видалення даних користувача (вихід з облікового запису)
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyName);
    await prefs.remove(keyEmail);
    await prefs.remove(keyPassword);
    await prefs.remove(keyIsRegistered);
  }

  /// Видалення збережених favorites ids
  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyFavoriteIds);
  }

  /// Повне очищення локального сховища (вихід + скидання обраного)
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
