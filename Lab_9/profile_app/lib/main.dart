import 'package:flutter/material.dart';
import 'screens/profile_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ProfileApp());
}

/// Головний кореневий віджет застосунку ProfileApp
class ProfileApp extends StatefulWidget {
  const ProfileApp({super.key});

  @override
  State<ProfileApp> createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
  // Стан активної теми: true — темна, false — світла (п. 1, 2 ТЗ)
  bool _isDarkMode = true;

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Профіль та теми — Лабораторна №9',
      debugShowCheckedModeBanner: false,
      // Налаштування світлої та темної тем через ThemeData (п. 1, 11 ТЗ)
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: ProfileScreen(
        isDarkMode: _isDarkMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}
