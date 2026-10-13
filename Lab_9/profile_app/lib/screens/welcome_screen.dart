import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import 'login_screen.dart';
import 'register_screen.dart';

/// Вступний екран застосунку з вибором дії: вхід або реєстрація
class WelcomeScreen extends StatelessWidget {
  /// Колбек перемикання теми, який передається далі по навігації (п. 2 ТЗ ЛР 9)
  final ValueChanged<bool>? onToggleTheme;

  const WelcomeScreen({super.key, this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background(isDark),
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
                  color: AppColors.card(isDark),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accent(isDark), width: 2),
                ),
                child: Icon(
                  Icons.task_alt,
                  color: AppColors.accent(isDark),
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Менеджер завдань',
                textAlign: TextAlign.center,
                style: AppStyles.title(isDark: isDark)
                    .copyWith(fontSize: 28, height: 1.2),
              ),
              const SizedBox(height: 8),
              Text(
                'Організуй завдання, відстежуй статуси та обране — '
                'усі дані зберігаються у JSON',
                textAlign: TextAlign.center,
                style: AppStyles.subtitle(isDark: isDark)
                    .copyWith(fontSize: 15, height: 1.4),
              ),
              const SizedBox(height: 40),
              // Кнопка входу
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent(isDark),
                    foregroundColor: AppColors.onAccent(isDark),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LoginScreen(onToggleTheme: onToggleTheme),
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
                    foregroundColor: AppColors.accent(isDark),
                    side: BorderSide(color: AppColors.accent(isDark)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RegisterScreen(onToggleTheme: onToggleTheme),
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
              Text(
                'Лабораторна робота №9 · Теми оформлення та ресурси',
                textAlign: TextAlign.center,
                style: AppStyles.caption(isDark: isDark).copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
