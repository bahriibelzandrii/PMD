import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Стандартизовані стилі тексту AppStyles (п. 9 ТЗ)
/// Використовують підключений власний шрифт Inter (п. 3 ТЗ)
class AppStyles {
  // Назва підключеного шрифту
  static const String fontFamily = 'Inter';

  // 1. Заголовок (title)
  static TextStyle title({bool isDark = false, Color? color}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
      color: color ?? (isDark ? AppColors.textDark : AppColors.textLight),
    );
  }

  // 2. Підзаголовок (subtitle)
  static TextStyle subtitle({bool isDark = false, Color? color}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: color ??
          (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
    );
  }

  // 3. Основний текст (body)
  static TextStyle body({bool isDark = false, Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: fontWeight ?? FontWeight.normal,
      height: 1.45,
      color: color ?? (isDark ? AppColors.textDark : AppColors.textLight),
    );
  }

  // 4. Стиль для кнопок (button)
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: Colors.white,
  );

  // 5. Стиль підпису або дати / статусу (caption)
  static TextStyle caption({bool isDark = false, Color? color}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color ??
          (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
    );
  }

  // 6. Стиль бейджа або плашки
  static const TextStyle badge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  // Статичні константи для швидкого застосування без параметрів
  static const TextStyle titleStatic = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static const TextStyle subtitleStatic = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyStatic = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.45,
  );
}
