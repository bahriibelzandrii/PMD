import 'package:flutter/material.dart';

/// Модель елемента каталогу (навчальні IT-курси)
class CourseItem {
  final String id;
  final String title;
  final String category;
  final String description;
  final double rating;
  final int studentsCount;
  final String duration;
  final IconData icon;
  final Color accentColor;

  const CourseItem({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.rating,
    required this.studentsCount,
    required this.duration,
    required this.icon,
    required this.accentColor,
  });

  /// Демонстраційний перелік курсів у каталозі
  static const List<CourseItem> sampleCourses = [
    CourseItem(
      id: 'course_1',
      title: 'Розробка мобільних додатків на Flutter & Dart',
      category: 'Mobile Dev',
      description:
          'Поглиблений курс з побудови кросплатформених мобільних застосунків, state management та архітектури.',
      rating: 4.9,
      studentsCount: 1240,
      duration: '48 год',
      icon: Icons.flutter_dash,
      accentColor: Color(0xFF02569B),
    ),
    CourseItem(
      id: 'course_2',
      title: 'Архітектура програмного забезпечення: BLoC & Clean Arch',
      category: 'Architecture',
      description:
          'Проєктування масштабованих корпоративних додатків, шар даних, репозиторії та інверсія залежностей.',
      rating: 4.8,
      studentsCount: 890,
      duration: '36 год',
      icon: Icons.account_tree_outlined,
      accentColor: Color(0xFF6C5CE7),
    ),
    CourseItem(
      id: 'course_3',
      title: 'UI/UX дизайн та дизайн-системи у Figma & Flutter',
      category: 'Design',
      description:
          'Створення інтерактивних інтерфейсів, токенти дизайну, Material 3 та анімації переходів.',
      rating: 4.95,
      studentsCount: 1560,
      duration: '28 год',
      icon: Icons.palette_outlined,
      accentColor: Color(0xFFFD79A8),
    ),
    CourseItem(
      id: 'course_4',
      title: 'Локальні бази даних та кешування: SQLite, Hive, SharedPreferences',
      category: 'Data Storage',
      description:
          'Робота з key-value сховищами, локальними реляційними базами даних та офлайн-режимом у мобільних додатках.',
      rating: 4.85,
      studentsCount: 1020,
      duration: '32 год',
      icon: Icons.storage_rounded,
      accentColor: Color(0xFF00B894),
    ),
    CourseItem(
      id: 'course_5',
      title: 'Кібербезпека мобільних платформ та криптографія',
      category: 'Security',
      description:
          'Захищене збереження токенів, шифрування SharedPreferences (EncryptedSharedPreferences) та захист від reverse-engineering.',
      rating: 4.75,
      studentsCount: 670,
      duration: '40 год',
      icon: Icons.security_rounded,
      accentColor: Color(0xFFE17055),
    ),
    CourseItem(
      id: 'course_6',
      title: 'DevOps, CI/CD та тестування у Flutter (Unit, Widget, Integration)',
      category: 'DevOps',
      description:
          'Автоматизація збірки APK/AAB, налаштування GitHub Actions, Fastlane та покриття коду тестами.',
      rating: 4.9,
      studentsCount: 810,
      duration: '30 год',
      icon: Icons.integration_instructions_outlined,
      accentColor: Color(0xFF0984E3),
    ),
  ];
}
