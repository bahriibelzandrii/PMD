import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import '../models/task_model.dart';

/// Сервіс для роботи з JSON-файлами (зчитування з assets та локальне збереження)
class TaskStorageService {
  static const String assetPath = 'assets/data/tasks.json';
  static const String localFileName = 'tasks.json';

  File? _cachedFile;

  /// 1. Зчитування початкового JSON-файлу з папки assets (п. 4 ТЗ)
  Future<String> readJsonFromAssets() async {
    return await rootBundle.loadString(assetPath);
  }

  /// 2. Отримання шляху до локального файлу в документах застосунку (path_provider)
  Future<File> _getLocalFile() async {
    if (_cachedFile != null) return _cachedFile!;

    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      final tempDir = Directory.systemTemp;
      _cachedFile = File('${tempDir.path}/tasks_test_$pid.json');
      return _cachedFile!;
    }

    final directory = await getApplicationDocumentsDirectory();
    _cachedFile = File('${directory.path}/$localFileName');
    return _cachedFile!;
  }

  /// 3. Зчитування завдань:
  /// Якщо існує локальний файл — читаємо з нього.
  /// Якщо це перший запуск — зчитуємо з assets та копіюємо у локальний файл.
  Future<List<TaskModel>> loadTasks() async {
    try {
      final file = await _getLocalFile();
      if (file.existsSync()) {
        final content = file.readAsStringSync();
        if (content.trim().isNotEmpty) {
          return tasksFromJson(content);
        }
      }
    } catch (_) {
      // У разі відсутності або помилки переходимо до assets
    }

    final assetJson = await readJsonFromAssets();
    final tasks = tasksFromJson(assetJson);
    await saveTasks(tasks);
    return tasks;
  }

  /// 4. Запис списку моделей у локальний JSON-файл (п. 13 ТЗ)
  Future<void> saveTasks(List<TaskModel> tasks) async {
    try {
      final file = await _getLocalFile();
      final jsonString = tasksToJson(tasks);
      file.writeAsStringSync(jsonString, flush: true);
    } catch (_) {
      // Ігноруємо помилки I/O
    }
  }

  /// 5. Скидання списку до початкового стану з assets
  Future<List<TaskModel>> resetToDefault() async {
    final assetJson = await readJsonFromAssets();
    final tasks = tasksFromJson(assetJson);
    await saveTasks(tasks);
    return tasks;
  }
}
