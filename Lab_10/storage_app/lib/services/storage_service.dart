import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

/// Сервіс для роботи з локальним сховищем SharedPreferences (п. 1-8 ТЗ)
class StorageService {
  // Ключі для збереження даних користувача (п. 3 ТЗ)
  static const String keyName = 'user_name';
  static const String keyEmail = 'user_email';
  static const String keyPassword = 'user_password';
  static const String keyPhone = 'user_phone';
  static const String keyBio = 'user_bio';
  static const String keyRegisteredAt = 'user_registered_at';
  static const String keyIsRegistered = 'is_registered';

  // Ключ для збереження списку favorites ids (п. 7 ТЗ)
  static const String keyFavoriteIds = 'favorite_ids';

  /// Збереження даних користувача з екрана реєстрації (п. 2, 3 ТЗ)
  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyName, user.name);
    await prefs.setString(keyEmail, user.email);
    await prefs.setString(keyPassword, user.password);
    await prefs.setString(keyPhone, user.phone);
    await prefs.setString(keyBio, user.bio);
    await prefs.setString(
      keyRegisteredAt,
      user.registeredAt.isNotEmpty
          ? user.registeredAt
          : DateTime.now().toLocal().toString().split('.')[0],
    );
    await prefs.setBool(keyIsRegistered, true);
  }

  /// Завантаження даних користувача після повторного запуску (п. 4, 5 ТЗ)
  Future<UserModel?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isRegistered = prefs.getBool(keyIsRegistered) ?? false;
    final name = prefs.getString(keyName) ?? '';
    final email = prefs.getString(keyEmail) ?? '';

    if (!isRegistered && name.isEmpty && email.isEmpty) {
      return null;
    }

    return UserModel(
      name: name,
      email: email,
      password: prefs.getString(keyPassword) ?? '',
      phone: prefs.getString(keyPhone) ?? '+380 67 123 45 67',
      bio: prefs.getString(keyBio) ??
          'Студент НУ «Львівська політехніка», група КН-2327Б',
      registeredAt: prefs.getString(keyRegisteredAt) ?? '',
    );
  }

  /// Перевірка чи зареєстрований користувач
  Future<bool> isUserRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsRegistered) ?? false;
  }

  /// Видалення облікового запису (вихід)
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyName);
    await prefs.remove(keyEmail);
    await prefs.remove(keyPassword);
    await prefs.remove(keyPhone);
    await prefs.remove(keyBio);
    await prefs.remove(keyRegisteredAt);
    await prefs.setBool(keyIsRegistered, false);
  }

  /// Завантаження збереженого списку favorites ids (п. 7, 8 ТЗ)
  Future<List<String>> loadFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(keyFavoriteIds) ?? [];
  }

  /// Збереження оновленого списку favorites ids (п. 6, 7 ТЗ)
  Future<void> saveFavoriteIds(List<String> favoriteIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(keyFavoriteIds, favoriteIds);
  }

  /// Додавання або видалення елемента зі списку обраного (Toggle)
  Future<bool> toggleFavorite(String id) async {
    final ids = await loadFavoriteIds();
    final mutableIds = List<String>.from(ids);
    final isFav = mutableIds.contains(id);

    if (isFav) {
      mutableIds.remove(id);
    } else {
      mutableIds.add(id);
    }

    await saveFavoriteIds(mutableIds);
    return !isFav; // true якщо додано, false якщо видалено
  }

  /// Перевірка чи конкретний id входить до обраного
  Future<bool> isFavorite(String id) async {
    final ids = await loadFavoriteIds();
    return ids.contains(id);
  }

  /// Очищення списку обраного
  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyFavoriteIds);
  }

  /// Повне очищення всіх локальних даних
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
