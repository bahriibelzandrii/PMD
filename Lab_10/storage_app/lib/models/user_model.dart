/// Модель користувача для збереження та завантаження через SharedPreferences
class UserModel {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String bio;
  final String registeredAt;

  const UserModel({
    required this.name,
    required this.email,
    required this.password,
    this.phone = '+380 67 123 45 67',
    this.bio = 'Студент НУ «Львівська політехніка», група КН-2327Б',
    this.registeredAt = '',
  });

  bool get isEmpty => name.isEmpty && email.isEmpty;
  bool get isNotEmpty => !isEmpty;

  /// Створення копії з можливістю оновлення окремих полів
  UserModel copyWith({
    String? name,
    String? email,
    String? password,
    String? phone,
    String? bio,
    String? registeredAt,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      registeredAt: registeredAt ?? this.registeredAt,
    );
  }

  /// Порожній користувач (стан до реєстрації)
  static const UserModel empty = UserModel(
    name: '',
    email: '',
    password: '',
    phone: '',
    bio: '',
    registeredAt: '',
  );
}
