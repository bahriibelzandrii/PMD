import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

/// Екран профілю користувача ProfileScreen (п. 6 ТЗ)
class ProfileScreen extends StatelessWidget {
  /// Поточний стан теми (true — темна, false — світла)
  final bool isDarkMode;

  /// Колбек для перемикання теми (п. 2 ТЗ)
  final ValueChanged<bool> onToggleTheme;

  const ProfileScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.background(isDark),
      appBar: AppBar(
        title: Text(
          'Профіль користувача',
          style: AppStyles.title(isDark: isDark).copyWith(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: AppColors.card(isDark),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Налаштування',
            icon: Image.asset(
              'assets/icons/settings.png',
              width: 22,
              height: 22,
            ),
            onPressed: () {
              _showSnackBar(context, 'Відкрито налаштування профілю');
            },
          ),
          IconButton(
            tooltip: 'Вийти з облікового запису',
            icon: Image.asset(
              'assets/icons/logout.png',
              width: 22,
              height: 22,
            ),
            onPressed: () => _confirmLogout(context, isDark),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Картка аватара та основної інформації (п. 4, 6 ТЗ)
              _buildHeaderCard(context, isDark),

              const SizedBox(height: 16),

              // 2. Блок статистики та відомостей про навчання
              _buildStatsCard(isDark),

              const SizedBox(height: 16),

              // 3. Блок налаштування теми застосунку (п. 1, 2, 6 ТЗ)
              _buildThemeSwitchCard(context, isDark),

              const SizedBox(height: 16),

              // 4. Блок опцій профілю з власними іконками (п. 5, 6 ТЗ)
              _buildOptionsCard(context, isDark),

              const SizedBox(height: 20),

              // 5. Кнопка редагування профілю
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.edit_outlined, size: 20),
                label: const Text('Редагувати профіль', style: AppStyles.button),
                onPressed: () {
                  _showSnackBar(context, 'Режим редагування профілю активовано');
                },
              ),

              const SizedBox(height: 10),

              // 6. Кнопка виходу
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error, width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout, size: 20),
                label: Text(
                  'Вийти з акаунта',
                  style: AppStyles.button.copyWith(color: AppColors.error),
                ),
                onPressed: () => _confirmLogout(context, isDark),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Картка заголовка з банером, аватаром, ім'ям та статусом
  Widget _buildHeaderCard(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card(isDark),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider(isDark)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Банерне зображення зверху (п. 4 ТЗ)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
            child: Image.asset(
              'assets/images/banner.png',
              height: 90,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Аватар із накладанням на банер
          Transform.translate(
            offset: const Offset(0, -42),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.card(isDark),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 46,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                ),
                // Бейдж онлайн-статусу
                Container(
                  margin: const EdgeInsets.only(right: 6, bottom: 4),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.card(isDark),
                      width: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -32),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // Ім'я користувача (п. 6 ТЗ)
                  Text(
                    'Багрій-Белз Андрій',
                    textAlign: TextAlign.center,
                    style: AppStyles.title(isDark: isDark),
                  ),
                  const SizedBox(height: 4),
                  // Контактна інформація (email) (п. 6 ТЗ)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.email_outlined,
                        size: 15,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'andrii.bagriy@nulp.ua',
                        style: AppStyles.subtitle(isDark: isDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Короткий опис або статус (п. 6 ТЗ)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface(isDark),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Студент НУ «Львівська політехніка» | Група КН-2327Б\nРозробник мобільних додатків на Flutter 🚀',
                      textAlign: TextAlign.center,
                      style: AppStyles.body(isDark: isDark).copyWith(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Картка статистики та показників
  Widget _buildStatsCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.card(isDark),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider(isDark)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Курс', '3-й', isDark),
          _buildDivider(isDark),
          _buildStatItem('Лабораторна', '№9', isDark, isHighlight: true),
          _buildDivider(isDark),
          _buildStatItem('Тема', isDark ? 'Dark' : 'Light', isDark),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, bool isDark, {bool isHighlight = false}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: AppStyles.fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isHighlight
                ? AppColors.primary
                : (isDark ? AppColors.textDark : AppColors.textLight),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppStyles.caption(isDark: isDark),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      width: 1,
      height: 28,
      color: AppColors.divider(isDark),
    );
  }

  /// Картка перемикання теми (п. 1, 2 ТЗ)
  Widget _buildThemeSwitchCard(BuildContext context, bool isDark) {
    return Material(
      color: AppColors.card(isDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.divider(isDark)),
      ),
      child: SwitchListTile(
        key: const Key('theme_switch_tile'),
        secondary: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: (isDark ? AppColors.secondary : AppColors.primary)
                .withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            'assets/icons/theme.png',
            width: 24,
            height: 24,
          ),
        ),
        title: Text(
          'Темна тема (Dark Mode)',
          style: TextStyle(
            fontFamily: AppStyles.fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
        ),
        subtitle: Text(
          isDark ? 'Увімкнено нічний режим' : 'Увімкнено денний режим',
          style: AppStyles.caption(isDark: isDark),
        ),
        value: isDark,
        activeThumbColor: AppColors.secondary,
        onChanged: (bool value) {
          onToggleTheme(value);
        },
      ),
    );
  }

  /// Картка списку налаштувань та іконок оформлення (п. 5, 6 ТЗ)
  Widget _buildOptionsCard(BuildContext context, bool isDark) {
    final options = [
      {
        'iconPath': 'assets/icons/profile.png',
        'title': 'Персональні дані',
        'subtitle': 'Редагування імені, контактів та біографії',
      },
      {
        'iconPath': 'assets/icons/shield.png',
        'title': 'Безпека та конфіденційність',
        'subtitle': 'Пароль, двофакторна автентифікація',
      },
      {
        'iconPath': 'assets/icons/bell.png',
        'title': 'Сповіщення',
        'subtitle': 'Push-сповіщення, системні нагадування',
      },
      {
        'iconPath': 'assets/icons/settings.png',
        'title': 'Параметри застосунку',
        'subtitle': 'Мова інтерфейсу, синхронізація, кеш',
      },
    ];
    return Material(
      color: AppColors.card(isDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.divider(isDark)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: options.length,
        separatorBuilder: (context, index) => Divider(
          color: AppColors.divider(isDark),
          height: 1,
          indent: 56,
        ),
        itemBuilder: (context, index) {
          final opt = options[index];
          return ListTile(
            leading: Image.asset(
              opt['iconPath']!,
              width: 28,
              height: 28,
            ),
            title: Text(
              opt['title']!,
              style: TextStyle(
                fontFamily: AppStyles.fontFamily,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
            subtitle: Text(
              opt['subtitle']!,
              style: AppStyles.caption(isDark: isDark),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: isDark ? AppColors.textSecondaryDark : AppColors.grey,
              size: 20,
            ),
            onTap: () {
              _showSnackBar(context, 'Обрано: ${opt['title']}');
            },
          );
        },
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: AppStyles.fontFamily),
        ),
        backgroundColor: isDarkMode ? AppColors.darkCard : AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _confirmLogout(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card(isDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Вихід із профілю',
          style: AppStyles.title(isDark: isDark).copyWith(fontSize: 18),
        ),
        content: Text(
          'Ви впевнені, що бажаєте вийти зі свого облікового запису?',
          style: AppStyles.body(isDark: isDark),
        ),
        actions: [
          TextButton(
            child: Text(
              'Скасувати',
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Вийти'),
            onPressed: () {
              Navigator.of(ctx).pop();
              _showSnackBar(context, 'Ви успішно вийшли з облікового запису');
            },
          ),
        ],
      ),
    );
  }
}
