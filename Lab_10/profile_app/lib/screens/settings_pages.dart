import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

/// Спільний каркас сторінок налаштувань: AppBar із поверненням
/// та прокрутуваний список карток з інтерактивними елементами.
class _SettingsShell extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<Widget> children;

  const _SettingsShell({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.children,
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppStyles.title(isDark: isDark).copyWith(fontSize: 20),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: AppColors.card(isDark),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}

/// Обгортка-картка для групи налаштувань
class _SettingsCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.card(isDark),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider(isDark)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              title,
              style: AppStyles.caption(isDark: isDark)
                  .copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.6),
            ),
          ),
          ...children,
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Рядок з перемикачем: іконка, назва, підпис, Switch
class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      secondary: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: iconColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: AppStyles.fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: isDark ? AppColors.textDark : AppColors.textLight,
        ),
      ),
      subtitle: Text(subtitle, style: AppStyles.caption(isDark: isDark)),
      value: value,
      onChanged: onChanged,
    );
  }
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: AppStyles.fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
}

/// Сторінка 1: Персональні дані — редагування імені, контактів, біографії
class PersonalDataPage extends StatefulWidget {
  final String name;
  final String email;

  const PersonalDataPage({super.key, required this.name, required this.email});

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _bioCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.name);
    _emailCtrl = TextEditingController(text: widget.email);
    _bioCtrl = TextEditingController(text: 'Розробник мобільних додатків');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _SettingsShell(
      title: 'Персональні дані',
      icon: Icons.person_outline,
      iconColor: AppColors.secondary,
      children: [
        _SettingsCard(
          title: 'Основна інформація',
          children: [
            TextField(
              controller: _nameCtrl,
              style: TextStyle(color: AppColors.text(isDark)),
              decoration: InputDecoration(
                labelText: 'Ім’я та прізвище',
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: AppColors.textSecondary(isDark),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailCtrl,
              style: TextStyle(color: AppColors.text(isDark)),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(
                  Icons.alternate_email,
                  color: AppColors.textSecondary(isDark),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bioCtrl,
              maxLines: 2,
              style: TextStyle(color: AppColors.text(isDark)),
              decoration: InputDecoration(
                labelText: 'Біографія',
                prefixIcon: Icon(
                  Icons.notes,
                  color: AppColors.textSecondary(isDark),
                ),
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent(isDark),
            foregroundColor: AppColors.onAccent(isDark),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.save_outlined, size: 20),
          label: Text(
            'Зберегти зміни',
            style: AppStyles.button.copyWith(color: AppColors.onAccent(isDark)),
          ),
          onPressed: () {
            if (_nameCtrl.text.trim().isEmpty ||
                _emailCtrl.text.trim().isEmpty) {
              _showMessage(context, 'Заповніть ім’я та email!');
              return;
            }
            _showMessage(context, 'Персональні дані збережено ✓');
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

/// Сторінка 2: Безпека та конфіденційність — 2FA, біометрія, пароль
class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool _twoFactor = false;
  bool _biometrics = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _SettingsShell(
      title: 'Безпека',
      icon: Icons.shield_outlined,
      iconColor: AppColors.success,
      children: [
        _SettingsCard(
          title: 'Захист облікового запису',
          children: [
            _SwitchRow(
              icon: Icons.verified_user_outlined,
              iconColor: AppColors.success,
              title: 'Двофакторна автентифікація',
              subtitle: 'Код із застосунку-генератора при вході',
              value: _twoFactor,
              onChanged: (v) {
                setState(() => _twoFactor = v);
                _showMessage(context, '2FA ${v ? 'увімкнено' : 'вимкнено'}');
              },
            ),
            _SwitchRow(
              icon: Icons.fingerprint,
              iconColor: AppColors.secondary,
              title: 'Біометричне розблокування',
              subtitle: 'Відбиток пальця або розпізнавання обличчя',
              value: _biometrics,
              onChanged: (v) {
                setState(() => _biometrics = v);
                _showMessage(
                  context,
                  'Біометрія ${v ? 'увімкнена' : 'вимкнена'}',
                );
              },
            ),
          ],
        ),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.accent(isDark),
            side: BorderSide(color: AppColors.accent(isDark), width: 1.2),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.lock_outline, size: 20),
          label: Text(
            'Змінити пароль',
            style: AppStyles.button.copyWith(color: AppColors.accent(isDark)),
          ),
          onPressed: () => _showChangePasswordDialog(context),
        ),
      ],
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: AppColors.card(isDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Зміна пароля',
            style: AppStyles.title(isDark: isDark).copyWith(fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldCtrl,
                obscureText: true,
                style: TextStyle(color: AppColors.text(isDark)),
                decoration: const InputDecoration(labelText: 'Поточний пароль'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newCtrl,
                obscureText: true,
                style: TextStyle(color: AppColors.text(isDark)),
                decoration: const InputDecoration(labelText: 'Новий пароль'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Скасувати',
                style: TextStyle(color: AppColors.textSecondary(isDark)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent(isDark),
                foregroundColor: AppColors.onAccent(isDark),
              ),
              onPressed: () {
                if (oldCtrl.text.isEmpty || newCtrl.text.length < 6) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Пароль: мінімум 6 символів')),
                  );
                  return;
                }
                Navigator.pop(ctx);
                _showMessage(context, 'Пароль змінено ✓');
              },
              child: const Text('Зберегти'),
            ),
          ],
        );
      },
    );
  }
}

/// Сторінка 3: Сповіщення — push, нагадування, звук, «не турбувати»
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _push = true;
  bool _reminders = true;
  bool _sound = true;
  bool _dnd = false;

  @override
  Widget build(BuildContext context) {
    return _SettingsShell(
      title: 'Сповіщення',
      icon: Icons.notifications_outlined,
      iconColor: AppColors.warning,
      children: [
        _SettingsCard(
          title: 'Параметри сповіщень',
          children: [
            _SwitchRow(
              icon: Icons.notifications_active_outlined,
              iconColor: AppColors.warning,
              title: 'Push-сповіщення',
              subtitle: 'Сповіщення, коли застосунок закрито',
              value: _push,
              onChanged: (v) {
                setState(() => _push = v);
                _showMessage(context, 'Push ${v ? 'увімкнено' : 'вимкнено'}');
              },
            ),
            _SwitchRow(
              icon: Icons.alarm,
              iconColor: AppColors.secondary,
              title: 'Системні нагадування',
              subtitle: 'Нагадування про активні завдання',
              value: _reminders,
              onChanged: (v) {
                setState(() => _reminders = v);
                _showMessage(
                  context,
                  'Нагадування ${v ? 'увімкнено' : 'вимкнено'}',
                );
              },
            ),
            _SwitchRow(
              icon: Icons.volume_up_outlined,
              iconColor: AppColors.favorite,
              title: 'Звук сповіщень',
              subtitle: 'Мелодія при новому сповіщенні',
              value: _sound,
              onChanged: (v) {
                setState(() => _sound = v);
                _showMessage(context, 'Звук ${v ? 'увімкнено' : 'вимкнено'}');
              },
            ),
            _SwitchRow(
              icon: Icons.nightlight_outlined,
              iconColor: AppColors.textSecondary(
                Theme.of(context).brightness == Brightness.dark,
              ),
              title: 'Режим «Не турбувати»',
              subtitle: 'Тихий режим без вібрації та звуку',
              value: _dnd,
              onChanged: (v) {
                setState(() => _dnd = v);
                _showMessage(
                  context,
                  '«Не турбувати» ${v ? 'увімкнено' : 'вимкнено'}',
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

/// Сторінка 4: Параметри застосунку — мова, синхронізація, кеш
class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  String _language = 'uk';
  bool _sync = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _SettingsShell(
      title: 'Параметри застосунку',
      icon: Icons.settings_outlined,
      iconColor: AppColors.textSecondary(isDark),
      children: [
        _SettingsCard(
          title: 'Інтерфейс',
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Мова інтерфейсу',
                    style: TextStyle(
                      fontFamily: AppStyles.fontFamily,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isDark ? AppColors.textDark : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'uk', label: Text('Українська')),
                      ButtonSegment(value: 'en', label: Text('English')),
                    ],
                    selected: {_language},
                    onSelectionChanged: (s) {
                      setState(() => _language = s.first);
                      _showMessage(
                        context,
                        'Мову змінено на ${_language == 'uk' ? 'українську' : 'англійську'}',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        _SettingsCard(
          title: 'Синхронізація та пам’ять',
          children: [
            _SwitchRow(
              icon: Icons.cloud_sync_outlined,
              iconColor: AppColors.secondary,
              title: 'Синхронізація даних',
              subtitle: 'Автоматичне зберігання змін на сервері',
              value: _sync,
              onChanged: (v) {
                setState(() => _sync = v);
                _showMessage(
                  context,
                  'Синхронізація ${v ? 'увімкнена' : 'вимкнена'}',
                );
              },
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Кеш застосунку',
                          style: TextStyle(
                            fontFamily: AppStyles.fontFamily,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isDark
                                ? AppColors.textDark
                                : AppColors.textLight,
                          ),
                        ),
                        Text(
                          'Зайнято: 24 МБ',
                          style: AppStyles.caption(isDark: isDark),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accent(isDark),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      side: BorderSide(
                        color: AppColors.accent(isDark),
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () =>
                        _showMessage(context, 'Кеш очищено: 24 МБ звільнено ✓'),
                    child: const Text('Очистити'),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'TaskManager · версія 1.0.0 · Flutter',
            textAlign: TextAlign.center,
            style: AppStyles.caption(isDark: isDark),
          ),
        ),
      ],
    );
  }
}
