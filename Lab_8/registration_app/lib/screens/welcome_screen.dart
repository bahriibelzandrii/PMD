import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'register_screen.dart';

/// Вступний екран застосунку з вибором дії: вхід або реєстрація
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F13),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Логотип застосунку
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: const Color(0xFF15181F),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD4FF00), width: 2),
                ),
                child: const Icon(
                  Icons.task_alt,
                  color: Color(0xFFD4FF00),
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Менеджер завдань',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Організуй завдання, відстежуй статуси та обране — '
                'усі дані зберігаються у JSON',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF8B949E),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),
              // Кнопка входу
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4FF00),
                    foregroundColor: const Color(0xFF0D0F13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  ),
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
              const SizedBox(height: 12),
              // Кнопка реєстрації
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFD4FF00),
                    side: const BorderSide(color: Color(0xFFD4FF00)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Зареєструватися',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Лабораторна робота №8 · Форми та навігація',
                style: TextStyle(color: Color(0xFF555F70), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
