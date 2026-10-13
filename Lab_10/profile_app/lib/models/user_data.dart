/// Модель даних користувача, які зберігаються локально у SharedPreferences
/// (п. 3 ТЗ ЛР 10: ім'я, email, пароль)
class UserData {
  /// Ім'я користувача
  final String name;

  /// Email користувача
  final String email;

  /// Пароль (поле, передбачене формою реєстрації)
  final String password;

  const UserData({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  String toString() => 'UserData(name: $name, email: $email)';
}
