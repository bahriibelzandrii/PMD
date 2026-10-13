import 'package:flutter/material.dart';

/// Власна палітра кольорів застосунку AppColors (п. 7 ТЗ ЛР 9).
/// Єдине джерело всіх кольорів застосунку, яке використовується замість
/// стандартних (Colors.blue, Colors.black тощо, п. 8 ТЗ).
///
/// Палітра поєднує неоново-темний стиль, розпочатий у Лаборатрні №8,
/// з новою світлою темою (Light / Dark mode, п. 1 ТЗ).
class AppColors {
  AppColors._();

  // ─── Основні брендові кольори ───────────────────────────────────────────
  static const Color primary = Color(0xFFD4FF00); // Неоновий лайм (акцент, темна тема)
  /// Читабельна зелень для світлої теми (лайм «зникає» на світлому фоні)
  static const Color primaryLight = Color(0xFF4C7C00);
  static const Color onPrimary = Color(0xFF0D0F13); // Текст на neon-фоні
  /// Акцентний колір активної теми (єдине джерело акценту)
  static Color accent(bool isDark) => isDark ? primary : primaryLight;
  /// Читаний колір тексту/іконок на акцентному фоні
  static Color onAccent(bool isDark) => isDark ? onPrimary : Colors.white;
  static const Color secondary = Color(
    0xFF4FC3F7,
  ); // Небесний (активні статуси)
  static const Color favorite = Color(0xFFFF4B6E); // Рожевий (обране)

  // ─── Станові кольори ─────────────────────────────────────────────────────
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF5A623);
  static const Color error = Color(0xFFE53935);
  static const Color alert = Color(0xFFFF5252); // Фон попереджень (snackbar)

  // ─── Темна тема (неонова, продовження ЛР 8) ────────────────────────────
  static const Color darkBackground = Color(0xFF0D0F13);
  static const Color darkCard = Color(0xFF15181F);
  static const Color darkSurface = Color(0xFF1F2430);
  static const Color darkBorder = Color(0xFF2A3142);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF8B949E);
  static const Color darkTextHint = Color(0xFF555F70);
  static const Color darkTextDone = Color(0xFF6B7280);

  // ─── Світла тема ─────────────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF1F3F6);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFE8ECF1);
  static const Color lightBorder = Color(0xFFD8DEE6);
  static const Color lightText = Color(0xFF171B21);
  static const Color lightTextSecondary = Color(0xFF5F6772);
  static const Color lightTextHint = Color(0xFF98A0AB);
  static const Color lightTextDone = Color(0xFFA6ADB8);

  // ─── Динамічні селектори за активною темою ─────────────────────────────
  static Color background(bool isDark) =>
      isDark ? darkBackground : lightBackground;
  static Color card(bool isDark) => isDark ? darkCard : lightCard;
  static Color surface(bool isDark) => isDark ? darkSurface : lightSurface;
  static Color border(bool isDark) => isDark ? darkBorder : lightBorder;
  static Color text(bool isDark) => isDark ? darkText : lightText;
  static Color textSecondary(bool isDark) =>
      isDark ? darkTextSecondary : lightTextSecondary;
  static Color textHint(bool isDark) => isDark ? darkTextHint : lightTextHint;
  static Color textDone(bool isDark) => isDark ? darkTextDone : lightTextDone;

  // Зворотно сумісні псевдоніми (використовувались у першій версії ЛР 9)
  static Color divider(bool isDark) => border(isDark);

  // ─── Зворотно сумісні константи (перша версія ЛР 9) ─────────────────
  static const Color textDark = darkText;
  static const Color textLight = lightText;
  static const Color textSecondaryDark = darkTextSecondary;
  static const Color textSecondaryLight = lightTextSecondary;
  static const Color grey = lightTextSecondary;
}
