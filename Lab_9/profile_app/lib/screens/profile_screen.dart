import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

import 'settings_pages.dart';

/// Екран профілю користувача ProfileScreen (п. 6 ТЗ)
class ProfileScreen extends StatelessWidget {
  /// Ім'я користувача (п. 6 ТЗ)
  final String? username;

  /// Email користувача (п. 6 ТЗ)
  final String? email;

  /// Колбек для перемикання теми (п. 2 ТЗ)
  final ValueChanged<bool>? onToggleTheme;

  const ProfileScreen({
    super.key,
    this.username,
    this.email,
    this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background(isDark),
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Назад',
          icon: Icon(Icons.arrow_back, color: AppColors.textSecondary(isDark)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Профіль користувача',
          style: AppStyles.title(isDark: isDark).copyWith(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: AppColors.card(isDark),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Блок аватара та основної інформації (п. 4, 6 ТЗ)
              _buildHeaderCard(context, isDark),

              const SizedBox(height: 16),

              // 2. Блок статистики та відомостей про навчання
              _buildStatsCard(isDark),

              const SizedBox(height: 16),

              // 3. Блок налаштування теми застосунку (п. 1, 2, 6 ТЗ)
              _buildThemeSwitchCard(context, isDark),

              const SizedBox(height: 16),

              // 4. Блок опцій профілю (п. 5, 6 ТЗ)
              _buildOptionsCard(context, isDark),

              const SizedBox(height: 20),

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

  /// Мінімалістичний заголовок: монограма, ім'я, контакти та опис
  /// (без банера та об'ємної картки)
  Widget _buildHeaderCard(BuildContext context, bool isDark) {
    final name = username ?? 'Багрій-Белз Андрій';
    return Column(
      children: [
        // Аватар-монограма на градієнті
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.accent(isDark), AppColors.secondary],
            ),
          ),
          child: Center(
            child: Text(
              _initials(name),
              style: const TextStyle(
                fontFamily: AppStyles.fontFamily,
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        // Ім'я користувача (п. 6 ТЗ)
        Text(
          name,
          textAlign: TextAlign.center,
          style: AppStyles.title(isDark: isDark),
        ),
        const SizedBox(height: 4),
        // Контактна інформація (email) (п. 6 ТЗ)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.alternate_email,
              size: 15,
              color: AppColors.textSecondary(isDark),
            ),
            const SizedBox(width: 6),
            Text(
              email ?? 'andrii.bagriy@nulp.ua',
              style: AppStyles.subtitle(isDark: isDark),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Розробник мобільних додатків на Flutter',
          textAlign: TextAlign.center,
          style: AppStyles.caption(isDark: isDark).copyWith(fontSize: 12),
        ),
      ],
    );
  }

  /// Монограма аватара: «АБ» для профіля курсанта, інакше —
  /// ініціали перших двох слів імені
  String _initials(String name) {
    if (name == 'Багрій-Белз Андрій') {
      return 'АБ';
    }
    final parts = name.trim().split(RegExp(r'\s+'));
    final buf = StringBuffer();
    for (final part in parts.take(2)) {
      if (part.isNotEmpty) {
        buf.write(part[0].toUpperCase());
      }
    }
    return buf.isEmpty ? 'АБ' : buf.toString();
  }

  /// Картка статистики та показників (стиль як у менеджера завдань)
  Widget _buildStatsCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card(isDark),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border(isDark)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.school_outlined,
                color: AppColors.accent(isDark),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Особисті дані',
                style: TextStyle(
                  color: AppColors.text(isDark),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatItem(
                'Курс',
                '4-й',
                isDark,
                color: AppColors.text(isDark),
              ),
              const SizedBox(width: 8),
              _buildStatItem(
                'Лабораторна',
                '№9',
                isDark,
                color: AppColors.accent(isDark),
              ),
              const SizedBox(width: 8),
              _buildStatItem(
                'Тема',
                isDark ? 'Dark' : 'Light',
                isDark,
                color: AppColors.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    bool isDark, {
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.surface(isDark),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary(isDark),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Картка перемикання теми (п. 1, 2 ТЗ)
  Widget _buildThemeSwitchCard(BuildContext context, bool isDark) {
    return Material(
      color: AppColors.card(isDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppColors.divider(isDark)),
      ),
      child: SwitchListTile(
        key: const Key('theme_switch_tile'),
        secondary: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.accent(isDark).withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isDark ? Icons.dark_mode : Icons.light_mode,
            size: 22,
            color: isDark ? AppColors.secondary : AppColors.text(isDark),
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
          onToggleTheme?.call(value);
        },
      ),
    );
  }

  /// Картка списку налаштувань та іконок оформлення (п. 5, 6 ТЗ)
  Widget _buildOptionsCard(BuildContext context, bool isDark) {
    final options = [
      {
        'icon': Icons.person_outline,
        'color': AppColors.secondary,
        'title': 'Персональні дані',
        'subtitle': 'Редагування імені, контактів та біографії',
      },
      {
        'icon': Icons.shield_outlined,
        'color': AppColors.success,
        'title': 'Безпека та конфіденційність',
        'subtitle': 'Пароль, двофакторна автентифікація',
      },
      {
        'icon': Icons.notifications_outlined,
        'color': AppColors.warning,
        'title': 'Сповіщення',
        'subtitle': 'Push-сповіщення, системні нагадування',
      },
      {
        'icon': Icons.settings_outlined,
        'color': AppColors.textSecondary(isDark),
        'title': 'Параметри застосунку',
        'subtitle': 'Мова інтерфейсу, синхронізація, кеш',
      },
    ];
    return Material(
      color: AppColors.card(isDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppColors.divider(isDark)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: options.length,
        separatorBuilder: (context, index) =>
            Divider(color: AppColors.divider(isDark), height: 1, indent: 56),
        itemBuilder: (context, index) {
          final opt = options[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            leading: Icon(
              opt['icon'] as IconData,
              size: 22,
              color: opt['color'] as Color,
            ),
            title: Text(
              opt['title'] as String,
              style: TextStyle(
                fontFamily: AppStyles.fontFamily,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
            subtitle: Text(
              opt['subtitle'] as String,
              style: AppStyles.caption(isDark: isDark),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: isDark ? AppColors.textSecondaryDark : AppColors.grey,
              size: 20,
            ),
            onTap: () => _openOptionPage(context, index),
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
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Перехід на реальні сторінки налаштувань (навігація між екранами)
  void _openOptionPage(BuildContext context, int index) {
    final Widget page;
    switch (index) {
      case 0:
        page = PersonalDataPage(
          name: username ?? 'Багрій-Белз Андрій',
          email: email ?? 'andrii.bagriy@nulp.ua',
        );
      case 1:
        page = const SecurityPage();
      case 2:
        page = const NotificationsPage();
      default:
        page = const AppSettingsPage();
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
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
