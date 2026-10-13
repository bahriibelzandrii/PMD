import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const RegistrationApp());
}

/// Головний застосунок: продовження Лаборатної №8 (форми, навігація,
/// JSON-менеджер завдань) + теми оформлення та екран профілю (ЛР 9).
class RegistrationApp extends StatefulWidget {
  const RegistrationApp({super.key});

  @override
  State<RegistrationApp> createState() => _RegistrationAppState();
}

class _RegistrationAppState extends State<RegistrationApp> {
  /// Стан активної теми: true — темна, false — світла (п. 1, 2 ТЗ ЛР 9).
  /// Зберігається у класі State та оновлюється виключно через setState().
  bool _isDarkMode = true;

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Профіль, теми та ресурси — Лабораторна №9',
      debugShowCheckedModeBanner: false,
      // Світла та темна теми через ThemeData (п. 1, 11 ТЗ ЛР 9)
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: WelcomeScreen(onToggleTheme: _toggleTheme),
    );
  }
}
