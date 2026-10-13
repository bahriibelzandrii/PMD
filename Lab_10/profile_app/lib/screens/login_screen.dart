import 'package:flutter/material.dart';

import '../models/user_data.dart';
import '../services/user_storage_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import 'register_screen.dart';
import 'task_manager_screen.dart';

/// Екран входу до системи (email + пароль з валідацією)
class LoginScreen extends StatefulWidget {
  /// Колбек перемикання теми, який передається далі по навігації (п. 2 ТЗ ЛР 9)
  final ValueChanged<bool>? onToggleTheme;

  const LoginScreen({super.key, this.onToggleTheme});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Обробник кнопки «Увійти»: валідація → перехід у менеджер завдань.
  // П. 4 ТЗ ЛР 10: якщо користувач збережено у SharedPreferences, дані
  // входу звіряються зі збереженими та сесія відновлюється.
  Future<void> _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text;

      // Завантаження збереженого користувача з локального сховища
      final UserData? saved = await UserStorageService().loadUser();
      if (!mounted) return;

      // Ім'я користувача: зі збережених даних або з локальної частини email
      String username;
      if (saved != null) {
        if (saved.email != email || saved.password != password) {
          _showError('Невірний email або пароль');
          return;
        }
        username = saved.name;
      } else {
        username = email.split('@').first;
      }

      // Навігація на TaskManagerScreen із відновленими даними користувача
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TaskManagerScreen(
            username: username,
            email: email,
            password: password,
            onToggleTheme: widget.onToggleTheme,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Будь ласка, перевірте дані входу!'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Показ помилки входу через SnackBar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.alert,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Допоміжна функція швидкого заповнення демо-даними
  void _fillDemoData() {
    setState(() {
      _emailController.text = 'andrii.bagriy@nulp.ua';
      _passwordController.text = 'flutter2026';
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background(isDark),
      appBar: AppBar(
        title: Text(
          'Вхід до системи',
          style: AppStyles.title(isDark: isDark).copyWith(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: AppColors.card(isDark),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Заповнити тестовими даними',
            icon: Icon(Icons.auto_fix_high, color: AppColors.accent(isDark)),
            onPressed: _fillDemoData,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              // Іконка профілю
              Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.card(isDark),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accent(isDark)),
                ),
                child: Icon(
                  Icons.person,
                  color: AppColors.accent(isDark),
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'З поверненням!',
                textAlign: TextAlign.center,
                style: AppStyles.title(isDark: isDark).copyWith(fontSize: 22),
              ),
              const SizedBox(height: 6),
              Text(
                'Введіть дані, щоб відкрити свої завдання',
                textAlign: TextAlign.center,
                style: AppStyles.subtitle(isDark: isDark),
              ),
              const SizedBox(height: 28),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Введіть адресу електронної пошти';
                        }
                        if (!value.contains('@')) {
                          return 'Email повинен містити символ @';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Електронна пошта (Email)',
                        hintText: 'name@example.com',
                        prefixIcon: Icon(
                          Icons.email,
                          color: AppColors.textSecondary(isDark),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Пароль
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введіть пароль';
                        }
                        if (value.length < 6) {
                          return 'Пароль повинен містити щонайменше 6 символів';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Пароль',
                        hintText: '••••••••',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: AppColors.textSecondary(isDark),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textSecondary(isDark),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Кнопка входу
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent(isDark),
                          foregroundColor: AppColors.onAccent(isDark),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _submitLogin,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.login, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Увійти',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Посилання на реєстрацію
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ще немає акаунта? ',
                          style: AppStyles.subtitle(isDark: isDark),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(
                                  onToggleTheme: widget.onToggleTheme,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Зареєструватися',
                            style: AppStyles.subtitle(
                              isDark: isDark,
                              color: AppColors.accent(isDark),
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
