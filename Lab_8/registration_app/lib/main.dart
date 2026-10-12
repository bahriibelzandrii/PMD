import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';

void main() {
  runApp(const RegistrationApp());
}

class RegistrationApp extends StatelessWidget {
  const RegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Форми та навігація — Лабораторна №8',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0F13),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4FF00),
          surface: Color(0xFF15181F),
          onSurface: Colors.white,
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}
