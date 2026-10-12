import 'package:flutter/material.dart';

import 'register_screen.dart';
import 'task_manager_screen.dart';

/// Екран входу до системи (email + пароль з валідацією)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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

  // Обробник кнопки «Увійти»: валідація → перехід у менеджер завдань
  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      // Ім'я користувача — з локальної частини email
      final String email = _emailController.text.trim();
      final String username = email.split('@').first;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TaskManagerScreen(username: username),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Будь ласка, перевірте дані входу!',
            style: TextStyle(
              color: Color(0xFF0D0F13),
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFFFF5252),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
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
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F13),
      appBar: AppBar(
        title: const Text(
          'Вхід до системи',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF15181F),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Заповнити тестовими даними',
            icon: const Icon(Icons.auto_fix_high, color: Color(0xFFD4FF00)),
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
                  color: const Color(0xFF15181F),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD4FF00)),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFFD4FF00),
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'З поверненням!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Введіть дані, щоб відкрити свої завдання',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF8B949E), fontSize: 14),
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
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color(0xFF8B949E),
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
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xFF8B949E),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFF8B949E),
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
                          backgroundColor: const Color(0xFFD4FF00),
                          foregroundColor: const Color(0xFF0D0F13),
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
                        const Text(
                          'Ще немає акаунта? ',
                          style: TextStyle(color: Color(0xFF8B949E)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Зареєструватися',
                            style: TextStyle(
                              color: Color(0xFFD4FF00),
                              fontWeight: FontWeight.bold,
                            ),
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
