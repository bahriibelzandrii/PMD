import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_typography.dart';
import '../design_system/app_widgets.dart';

/// Екран 1: Onboarding & Welcome Flow — Варіант A (Hero Icon)
/// Цільові лабораторні: Лабораторна №1, №2, №3 (Група 1: Менеджер завдань).
class OnboardingScreen extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onLogin;

  const OnboardingScreen({
    super.key,
    required this.onStart,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgObsidian,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Центральна Hero-іконка з неоновим обрамленням
              Center(
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(
                      color: AppColors.limePrimary,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.limePrimary.withValues(alpha: 0.3),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle_outline_rounded,
                      size: 64,
                      color: AppColors.limePrimary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // Слоган та назва
              Text(
                'Керуй завданнями\nпродуктивно',
                textAlign: TextAlign.center,
                style: AppTypography.headlineLarge.copyWith(
                  height: 1.25,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 16),

              // Опис
              Text(
                'Повний контроль дедлайнів, лабораторних робіт та щоденних справ у єдиному мобільному центрі.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const Spacer(),

              // Кнопки переходу
              AppButton(
                text: 'Розпочати роботу →',
                onPressed: onStart,
              ),

              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: onLogin,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.borderSubtle),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  'Увійти в акаунт',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
