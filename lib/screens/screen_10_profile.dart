import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_typography.dart';

/// Екран 10: Профіль та налаштування тем — Варіант A (Студійні налаштування)
/// Цільові лабораторні: Лабораторна №9 (ThemeData, Dark/Light mode) та №10 (SharedPreferences).
class ProfileScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final VoidCallback onClearCache;

  const ProfileScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onClearCache,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgObsidian,
      appBar: AppBar(
        title: const Text('Профіль та налаштування'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Картка студента
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.limePrimary,
                    child: const Text(
                      'АК',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textInverse,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Андрій Коваленко',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'andrii.koval@univ.edu.ua',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.bgSurface,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Студент',
                                style: TextStyle(fontSize: 11, color: AppColors.limePrimary, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.bgSurface,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Група КН-31',
                                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
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

            const SizedBox(height: 20),

            // Розділ налаштувань
            Text(
              'Системні налаштування',
              style: AppTypography.titleSmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // Тумблер темної теми (Лаб 9)
            Card(
              color: AppColors.bgCard,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.borderSubtle),
              ),
              child: SwitchListTile(
                title: const Text('Темна тема (Dark Mode)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                subtitle: const Text('ThemeData.dark() / light() (Лаб 9)', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                value: isDarkMode,
                activeThumbColor: AppColors.limePrimary,
                onChanged: onThemeChanged,
              ),
            ),

            const SizedBox(height: 10),

            // Сховище SharedPreferences (Лаб 10)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Локальне сховище (Лаб 10)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      SizedBox(height: 2),
                      Text('SharedPreferences: Синхронізовано', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    ],
                  ),
                  TextButton(
                    onPressed: onClearCache,
                    child: const Text('Очистити кеш', style: TextStyle(color: AppColors.highPriorityRed, fontSize: 12)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Про курс та варіант
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '📱 Курс: Програмування мобільних додатків',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Варіант: «Менеджер завдань» (Лабораторні роботи №1-10)',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
