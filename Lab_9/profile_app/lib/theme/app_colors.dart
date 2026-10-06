import 'package:flutter/material.dart';

/// Власна палітра кольорів застосунку AppColors (п. 7 ТЗ)
/// Використовується замість стандартних кольорів (Colors.blue тощо, п. 8 ТЗ)
class AppColors {
  // Основні брендові кольори
  static const Color primary = Color(0xFF4A90E2);       // Елегантний сапфіровий синій
  static const Color primaryDark = Color(0xFF2A68B2);   // Темно-синій акцент
  static const Color secondary = Color(0xFFF5A623);     // Сонячний бурштиновий
  static const Color accent = Color(0xFFD4FF00);        // Неоновий лайм

  // Кольори фону для світлої та темної тем
  static const Color lightBackground = Color(0xFFF8F9FA); // Світло-сірий м'який фон
  static const Color darkBackground = Color(0xFF121212);  // Глибокий графітовий темний фон
  static const Color lightCard = Color(0xFFFFFFFF);       // Біла картка
  static const Color darkCard = Color(0xFF1E1E1E);        // Темна картка
  static const Color lightSurface = Color(0xFFEFF2F6);    // Поверхня для світлої теми
  static const Color darkSurface = Color(0xFF252932);     // Поверхня для темної теми

  // Кольори тексту
  static const Color textLight = Color(0xFF1A1D20);       // Основний текст (світла тема)
  static const Color textDark = Color(0xFFFFFFFF);        // Основний текст (темна тема)
  static const Color textSecondaryLight = Color(0xFF6C757D); // Вторинний текст (світла)
  static const Color textSecondaryDark = Color(0xFFA0A6B2);  // Вторинний текст (темна)

  // Додаткові кольори
  static const Color grey = Color(0xFF9E9E9E);
  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color dividerDark = Color(0xFF2D3748);
  static const Color success = Color(0xFF2ECC71);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF17A2B8);

  // Динамічні селектори за ознакою теми
  static Color background(bool isDark) => isDark ? darkBackground : lightBackground;
  static Color card(bool isDark) => isDark ? darkCard : lightCard;
  static Color text(bool isDark) => isDark ? textDark : textLight;
  static Color textSecondary(bool isDark) => isDark ? textSecondaryDark : textSecondaryLight;
  static Color divider(bool isDark) => isDark ? dividerDark : dividerLight;
  static Color surface(bool isDark) => isDark ? darkSurface : lightSurface;
}
