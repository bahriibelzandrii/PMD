# ЗВІТ
про виконання лабораторної роботи №7  
«Робота з JSON та підготовка даних для відображення»  
з дисципліни «Програмування мобільних додатків»  
Студента групи КН-2327Б  
**Багрія-Белза Андрія**  

---

**Завдання на лабораторну роботу:**
1. Створити JSON-файл із початковими даними (мінімум 5 елементів: `id`, `title`, `isFavorite`, `status`).
2. Додати створений JSON-файл у Flutter-проєкт (у папку assets).
3. Додати шлях до JSON-файлу у файл `pubspec.yaml`, щоб застосунок міг отримувати доступ до цього ресурсу.
4. Реалізувати зчитування JSON-файлу у застосунку та перетворення даних у структури Dart.
5. Створити модель даних (`TaskModel`) для опису одного елемента JSON.
6. Реалізувати у моделі методи:
   - `fromJson()` — для створення об’єкта з JSON;
   - `toJson()` — для перетворення об’єкта у JSON.
7. Перетворити JSON-масив у список моделей (`List<TaskModel>`).
8. Відобразити дані у застосунку за допомогою `ListView.builder`.
9. Реалізувати додавання нового елемента до списку.
10. Реалізувати редагування існуючого елемента (наприклад, зміну назви або статусу).
11. Реалізувати видалення елемента зі списку.
12. Реалізувати перемикання стану елемента залежно від варіанту (додати до обраного, змінити статус).
13. Реалізувати запис оновлених даних у JSON-файл.
14. Перевірити правильність відображення та оновлення даних у застосунку.

---

### 1 Написання коду-розв’язку завдання:

#### Початковий файл даних (`Lab_7/task_manager/assets/data/tasks.json`):
```json
[
  {
    "id": 1,
    "title": "Оптимізація запитів до бази даних",
    "isFavorite": true,
    "status": "active"
  },
  {
    "id": 2,
    "title": "Рефакторинг архітектури Flutter-екранів",
    "isFavorite": false,
    "status": "done"
  },
  {
    "id": 3,
    "title": "Інтеграція REST API та обробка помилок",
    "isFavorite": false,
    "status": "active"
  },
  {
    "id": 4,
    "title": "Написання віджет-тестів та перевірка стану",
    "isFavorite": true,
    "status": "done"
  },
  {
    "id": 5,
    "title": "Оновлення темної палітри кольорів Material 3",
    "isFavorite": false,
    "status": "active"
  },
  {
    "id": 6,
    "title": "Підготовка збірки та публікація в Play Store",
    "isFavorite": false,
    "status": "active"
  }
]
```

#### Точка входу в застосунок (`Lab_7/task_manager/lib/main.dart`):
```dart
import 'package:flutter/material.dart';
import 'screens/lab7_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Менеджер завдань — Лабораторна №7',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4FF00),
          brightness: Brightness.dark,
          primary: const Color(0xFFD4FF00),
          surface: const Color(0xFF15181F),
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0F13),
      ),
      home: const Lab7Screen(),
    );
  }
}
```

#### Модель даних із методами `fromJson` та `toJson` (`Lab_7/task_manager/lib/models/task_model.dart`):
```dart
import 'dart:convert';

/// Перелік можливих статусів завдання (enum)
enum TaskStatus {
  active,
  done,
}

/// Модель завдання (Model class) із 4 обов'язковими типами полів:
/// - int (ідентифікатор)
/// - String (назва завдання)
/// - bool (прапорець обраного)
/// - enum TaskStatus (поточний статус виконання)
class TaskModel {
  final int id;
  String title;
  bool isFavorite;
  TaskStatus status;

  TaskModel({
    required this.id,
    required this.title,
    this.isFavorite = false,
    this.status = TaskStatus.active,
  });

  /// Конструктор для створення об'єкта з JSON (п. 6 ТЗ)
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int,
      title: json['title'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
      status: json['status'] == 'done' ? TaskStatus.done : TaskStatus.active,
    );
  }

  /// Метод для серіалізації об'єкта у JSON-мапу (п. 6 ТЗ)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isFavorite': isFavorite,
      'status': status.name,
    };
  }

  /// Зручний геттер для перевірки завершеності
  bool get isDone => status == TaskStatus.done;

  /// Метод для створення модифікованої копії
  TaskModel copyWith({
    int? id,
    String? title,
    bool? isFavorite,
    TaskStatus? status,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isFavorite: isFavorite ?? this.isFavorite,
      status: status ?? this.status,
    );
  }
}

/// Перетворення JSON-рядка у список моделей (п. 7 ТЗ)
List<TaskModel> tasksFromJson(String jsonString) {
  final List<dynamic> data = jsonDecode(jsonString) as List<dynamic>;
  return data.map((e) => TaskModel.fromJson(e as Map<String, dynamic>)).toList();
}

/// Серіалізація списку моделей у відформатований JSON-рядок
String tasksToJson(List<TaskModel> tasks) {
  const encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(tasks.map((e) => e.toJson()).toList());
}
```

#### Сервіс збереження та роботи з JSON (`Lab_7/task_manager/lib/services/task_storage_service.dart`):
```dart
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
```

#### Головний екран зі списком, редагуванням та синхронізацією (`Lab_7/task_manager/lib/screens/lab7_screen.dart`):
```dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_storage_service.dart';
import '../widgets/stats_summary_card.dart';
import '../widgets/task_list_item.dart';

enum TaskFilter {
  all,
  active,
  done,
  favorites,
}

class Lab7Screen extends StatefulWidget {
  const Lab7Screen({super.key});

  @override
  State<Lab7Screen> createState() => _Lab7ScreenState();
}

class _Lab7ScreenState extends State<Lab7Screen> {
  final TaskStorageService _storageService = TaskStorageService();

  // Основне джерело даних: список моделей List<TaskModel> (п. 7 ТЗ)
  List<TaskModel> _tasks = [];
  bool _isLoading = true;

  // Фільтр для перегляду
  TaskFilter _currentFilter = TaskFilter.all;

  @override
  void initState() {
    super.initState();
    _loadTasksFromJson();
  }

  // 1. Зчитування даних із JSON-файлу (п. 4 ТЗ)
  Future<void> _loadTasksFromJson() async {
    try {
      final loadedTasks = await _storageService.loadTasks();
      if (mounted) {
        setState(() {
          _tasks = loadedTasks;
          _isLoading = false;
        });
      }
    } catch (e, st) {
      debugPrint('Error loading tasks: $e\n$st');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // 2. Збереження оновлених даних у JSON-файл (п. 13 ТЗ)
  Future<void> _persistTasks() async {
    await _storageService.saveTasks(_tasks);
  }

  // Обчислення статистики у вигляді Map<String, int>
  Map<String, int> get _statistics => {
        'total': _tasks.length,
        'favorites': _tasks.where((t) => t.isFavorite).length,
        'done': _tasks.where((t) => t.status == TaskStatus.done).length,
        'active': _tasks.where((t) => t.status == TaskStatus.active).length,
      };

  // Фільтрований список завдань
  List<TaskModel> get _filteredTasks {
    switch (_currentFilter) {
      case TaskFilter.active:
        return _tasks.where((t) => t.status == TaskStatus.active).toList();
      case TaskFilter.done:
        return _tasks.where((t) => t.status == TaskStatus.done).toList();
      case TaskFilter.favorites:
        return _tasks.where((t) => t.isFavorite).toList();
      case TaskFilter.all:
        return _tasks;
    }
  }

  // 3. Зміна стану елемента (обране, п. 12 ТЗ)
  void _toggleFavorite(TaskModel task) {
    setState(() {
      task.isFavorite = !task.isFavorite;
    });
    _persistTasks();
    _showSnackBar(
      task.isFavorite
          ? 'Додано до обраного ❤️ (JSON оновлено)'
          : 'Видалено з обраного 🤍 (JSON оновлено)',
    );
  }

  // 4. Зміна статусу enum (п. 12 ТЗ)
  void _toggleStatus(TaskModel task) {
    setState(() {
      task.status =
          task.status == TaskStatus.done ? TaskStatus.active : TaskStatus.done;
    });
    _persistTasks();
    _showSnackBar(
      task.status == TaskStatus.done
          ? 'Завдання виконано! 🎉 (JSON оновлено)'
          : 'Завдання активне (JSON оновлено)',
    );
  }

  // 5. Видалення елемента зі списку (п. 11 ТЗ)
  void _deleteTask(TaskModel task) {
    final int index = _tasks.indexOf(task);
    setState(() {
      _tasks.remove(task);
    });
    _persistTasks();

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          'Завдання "${task.title}" видалено з JSON',
          style: const TextStyle(
            color: Color(0xFF0D0F13),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFD4FF00),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'СКАСУВАТИ',
          textColor: const Color(0xFF0D0F13),
          onPressed: () {
            setState(() {
              _tasks.insert(index, task);
            });
            _persistTasks();
          },
        ),
      ),
    );
  }

  // 6. Додавання нового елемента до списку (п. 9 ТЗ)
  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    bool isFavorite = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF15181F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF2A3142)),
              ),
              title: const Row(
                children: [
                  Icon(Icons.add_task, color: Color(0xFFD4FF00)),
                  SizedBox(width: 8),
                  Text(
                    'Нове завдання (JSON)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Назва завдання',
                        labelStyle: const TextStyle(color: Color(0xFF8B949E)),
                        hintText: 'Введіть тему або завдання...',
                        hintStyle: const TextStyle(color: Color(0xFF555F70)),
                        filled: true,
                        fillColor: const Color(0xFF1F2430),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFD4FF00),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Додати в обране',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      value: isFavorite,
                      activeThumbColor: const Color(0xFFD4FF00),
                      onChanged: (val) {
                        setDialogState(() {
                          isFavorite = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'Скасувати',
                    style: TextStyle(color: Color(0xFF8B949E)),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4FF00),
                    foregroundColor: const Color(0xFF0D0F13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    final text = titleController.text.trim();
                    if (text.isEmpty) return;

                    final nextId = _tasks.isEmpty
                        ? 1
                        : _tasks.map((e) => e.id).reduce(max) + 1;

                    final newTask = TaskModel(
                      id: nextId,
                      title: text,
                      isFavorite: isFavorite,
                      status: TaskStatus.active,
                    );

                    setState(() {
                      _tasks.add(newTask);
                    });
                    _persistTasks();

                    Navigator.pop(ctx);
                    _showSnackBar('Завдання додано та збережено в JSON! 🚀');
                  },
                  child: const Text(
                    'Додати',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 7. Редагування існуючого елемента (п. 10 ТЗ)
  void _showEditTaskDialog(TaskModel task) {
    final titleController = TextEditingController(text: task.title);
    bool isFavorite = task.isFavorite;
    bool isDone = task.status == TaskStatus.done;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF15181F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF2A3142)),
              ),
              title: Row(
                children: [
                  const Icon(Icons.edit_note, color: Color(0xFF4FC3F7)),
                  const SizedBox(width: 8),
                  Text(
                    'Редагувати #${task.id}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Назва завдання',
                        labelStyle: const TextStyle(color: Color(0xFF8B949E)),
                        filled: true,
                        fillColor: const Color(0xFF1F2430),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF4FC3F7),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Обране завдання',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      value: isFavorite,
                      activeThumbColor: const Color(0xFFFF4B6E),
                      onChanged: (val) {
                        setDialogState(() {
                          isFavorite = val;
                        });
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Статус: Виконано',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      value: isDone,
                      activeThumbColor: const Color(0xFFD4FF00),
                      onChanged: (val) {
                        setDialogState(() {
                          isDone = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'Скасувати',
                    style: TextStyle(color: Color(0xFF8B949E)),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4FC3F7),
                    foregroundColor: const Color(0xFF0D0F13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    final text = titleController.text.trim();
                    if (text.isEmpty) return;

                    setState(() {
                      task.title = text;
                      task.isFavorite = isFavorite;
                      task.status =
                          isDone ? TaskStatus.done : TaskStatus.active;
                    });
                    _persistTasks();

                    Navigator.pop(ctx);
                    _showSnackBar('Зміни збережено в JSON-файл! ✏️');
                  },
                  child: const Text(
                    'Зберегти',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Скидання до початкових даних з assets
  Future<void> _resetToAssets() async {
    setState(() {
      _isLoading = true;
    });
    final resetTasks = await _storageService.resetToDefault();
    if (mounted) {
      setState(() {
        _tasks = resetTasks;
        _isLoading = false;
      });
      _showSnackBar('Дані скинуто до початкових із assets/data/tasks.json 🔄');
    }
  }

  void _showSnackBar(String text) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF0D0F13),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFD4FF00),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Лабораторна робота №7'),
        centerTitle: true,
        backgroundColor: const Color(0xFF15181F),
        actions: [
          IconButton(
            tooltip: 'Скинути до assets JSON',
            icon: const Icon(Icons.restore, color: Color(0xFF8B949E)),
            onPressed: _resetToAssets,
          ),
          IconButton(
            tooltip: 'Додати завдання',
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFFD4FF00)),
            onPressed: _showAddTaskDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sync, color: Color(0xFFD4FF00), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Завантаження завдань із JSON...',
                      style: TextStyle(color: Color(0xFF8B949E), fontSize: 14),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    // 1. Статистика у вигляді Map<String, int>
                    StatsSummaryCard(stats: _statistics),
                    const SizedBox(height: 14),

                    // 2. Фільтри завдань
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('Всі (${_tasks.length})', TaskFilter.all),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            'Активні (${_statistics['active']})',
                            TaskFilter.active,
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            'Виконані (${_statistics['done']})',
                            TaskFilter.done,
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            'Обрані (${_statistics['favorites']})',
                            TaskFilter.favorites,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 3. Основний список завдань ListView.builder (п. 8 ТЗ)
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.inbox_outlined,
                                    size: 48,
                                    color: Color(0xFF555F70),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _currentFilter == TaskFilter.favorites
                                        ? 'Немає обраних завдань'
                                        : 'Список порожній',
                                    style: const TextStyle(
                                      color: Color(0xFF8B949E),
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 80),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final task = filtered[index];
                                return TaskListItem(
                                  task: task,
                                  onToggleFavorite: () => _toggleFavorite(task),
                                  onToggleStatus: () => _toggleStatus(task),
                                  onEdit: () => _showEditTaskDialog(task),
                                  onDelete: () => _deleteTask(task),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFD4FF00),
        foregroundColor: const Color(0xFF0D0F13),
        icon: const Icon(Icons.add),
        label: const Text(
          'Нове завдання',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: _showAddTaskDialog,
      ),
    );
  }

  Widget _buildFilterChip(String label, TaskFilter filter) {
    final isSelected = _currentFilter == filter;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _currentFilter = filter;
          });
        }
      },
      selectedColor: const Color(0xFFD4FF00),
      backgroundColor: const Color(0xFF15181F),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF0D0F13) : const Color(0xFF8B949E),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        fontSize: 12,
      ),
      side: BorderSide(
        color: isSelected ? const Color(0xFFD4FF00) : const Color(0xFF2A3142),
      ),
      showCheckmark: false,
    );
  }
}
```

#### Рядок списку із кнопкою редагування (`Lab_7/task_manager/lib/widgets/task_list_item.dart`):
```dart
import 'package:flutter/material.dart';
import '../models/task_model.dart';

/// Віджет для відображення одного рядка завдання за допомогою ListTile
class TaskListItem extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggleFavorite;
  final VoidCallback onToggleStatus;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onToggleFavorite,
    required this.onToggleStatus,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == TaskStatus.done;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: const Color(0xFF15181F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDone
                ? const Color(0xFF1F2430)
                : (task.isFavorite
                    ? const Color(0xFFFF4B6E).withValues(alpha: 0.3)
                    : const Color(0xFF2A3142)),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          // 1. leading: іконка "обране"
          leading: IconButton(
            tooltip: task.isFavorite ? 'Видалити з обраного' : 'Додати в обране',
            icon: Icon(
              task.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: task.isFavorite ? const Color(0xFFFF4B6E) : const Color(0xFF8B949E),
              size: 24,
            ),
            onPressed: onToggleFavorite,
          ),
          // 2. title: назва завдання з перекресленням для done
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              decoration: isDone ? TextDecoration.lineThrough : null,
              decorationColor: const Color(0xFF8B949E),
              color: isDone ? const Color(0xFF6B7280) : Colors.white,
            ),
          ),
          // 3. subtitle: статус завдання (active / done)
          subtitle: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDone
                      ? const Color(0xFFD4FF00).withValues(alpha: 0.15)
                      : const Color(0xFF4FC3F7).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isDone ? 'Виконано' : 'Активне',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDone ? const Color(0xFFD4FF00) : const Color(0xFF4FC3F7),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'ID: #${task.id}',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF555F70),
              ),
            ),
          ],
        ),
        // 4. trailing: перемикач статусу, редагування та видалення
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Кнопка перемикання статусу
            IconButton(
              tooltip: isDone ? 'Позначити як активне' : 'Позначити як виконане',
              icon: Icon(
                isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isDone ? const Color(0xFFD4FF00) : const Color(0xFF8B949E),
                size: 20,
              ),
              onPressed: onToggleStatus,
            ),
            // Кнопка редагування (п. 10 ТЗ)
            IconButton(
              tooltip: 'Редагувати завдання',
              icon: const Icon(
                Icons.edit_outlined,
                color: Color(0xFF4FC3F7),
                size: 20,
              ),
              onPressed: onEdit,
            ),
            // Кнопка видалення
            IconButton(
              tooltip: 'Видалити завдання',
              icon: const Icon(
                Icons.delete_outline,
                color: Color(0xFFEF5350),
                size: 20,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
        // Зміна статусу при довгому натисканні згідно з п. 7 ТЗ
        onLongPress: onToggleStatus,
        // Перемикання статусу при кліку на картку
        onTap: onToggleStatus,
      ),
    ),
  );
  }
}
```

---

### 2 Результат виконання коду:
- Застосунок протестовано на емуляторі Android 16 (API 36).
- Трипанельний знімок демонстрації (початкове зчитування JSON, модальне редагування завдання #1 та синхронізація оновлених даних): `Lab_7/assets/emulator_duo.png`

---

### Контрольні запитання:

1. **Що таке JSON та для чого він використовується у програмуванні?**  
JSON (JavaScript Object Notation) — це легкозважений текстовий формат представлення та обміну структурованими даними. Завдяки незалежності від платформи й мови програмування, простоті синтаксису та легкій людиночитній формі, JSON є загальноприйнятим стандартом для взаємодії клієнтських мобільних застосунків із веб-серверами через REST API, а також для збереження локальних конфігурацій і кешу на пристрої.

2. **Які основні елементи структури JSON?**  
Основу синтаксису JSON складають два типи структур: об'єкти та масиви. Об'єкт — це невпорядкований набір пар «ключ : значення», який записується у фігурних дужках `{ }`, де ключ завжди є рядком у подвійних лапках. Масив — це впорядкована послідовність значень (елементів), яка записується у квадратних дужках `[ ]`, де елементи відокремлюються комами.

3. **Які типи даних можуть використовуватися у JSON?**  
У форматі JSON підтримуються такі базові типи значень: рядок (String, обов'язково у подвійних лапках `"...\"`), число (Number, цілі або з плаваючою крапкою), логічне значення (Boolean: `true` або `false`), порожнє значення (`null`), масив (Array: `[ ... ]`) та вкладений об'єкт (Object: `{ ... }`).

4. **Яку бібліотеку використовують у Dart для роботи з JSON?**  
Для роботи з форматом JSON у мові Dart використовується стандартна бібліотека `dart:convert` (`import 'dart:convert';`). Вона надає готові утиліти для серіалізації та десеріалізації: функції `jsonDecode()` та `jsonEncode()`, а також класи `JsonDecoder` і `JsonEncoder`.

5. **Яка різниця між функціями jsonDecode() та jsonEncode()?**  
Функція `jsonDecode()` приймає текстовий рядок у форматі JSON (`String`) та виконує парсинг, перетворюючи його на відповідні структури даних Dart (`Map` або `List`). Навпаки, функція `jsonEncode()` виконує серіалізацію — перетворює об'єкти Dart (наприклад, `Map`, `List` чи примітивні типи) на текстовий рядок формату JSON.

6. **У який тип даних перетворюється JSON-об’єкт після декодування?**  
Після виконання функції `jsonDecode()` кореневий або вкладений JSON-об'єкт `{ }` перетворюється у мові Dart на асоціативний масив типу `Map<String, dynamic>`, де ключами є рядки, а значеннями — динамічні сутності, тип яких визначається за вмістом кожного поля.

7. **У який тип даних перетворюється JSON-масив після декодування?**  
Після виклику `jsonDecode()` кореневий або вкладений JSON-масив `[ ]` перетворюється у мові Dart на список динамічних елементів типу `List<dynamic>`. Надалі кожен елемент цього списку зазвичай кастується до `Map<String, dynamic>` або обробляється фабричним конструктором моделі.

8. **Як зчитати JSON-файл з папки assets у Flutter?**  
Для зчитування вбудованого ресурсу з каталогу assets використовують клас `rootBundle` із пакету `flutter/services.dart`: `final String jsonString = await rootBundle.loadString('assets/data/tasks.json');`. Для коректної роботи шлях до файлу або каталогу обов'язково попередньо декларується у секції `flutter -> assets` файлу конфігурації `pubspec.yaml`.

9. **Як записати JSON-дані у файл на пристрої?**  
Запис здійснюється за допомогою класу `File` із бібліотеки `dart:io`: `final file = File(filePath); await file.writeAsString(jsonString);`. Попередньо шлях до каталогу файлів застосунку (наприклад, Documents directory) отримують за допомогою функції `getApplicationDocumentsDirectory()` із плагіна `path_provider`, після чого перетворюють колекцію моделей у JSON-рядок через `jsonEncode()` і зберігають його на диску.

10. **Для чого використовується пакет path_provider?**  
Пакет `path_provider` надає уніфікований міжплатформний доступ до стандартних системних шляхів збереження файлів на мобільних і десктопних операційних системах (Android, iOS, Windows, macOS, Linux). Він дозволяє без прив'язки до специфіки конкретної ОС отримати шлях до каталогу документів користувача (`getApplicationDocumentsDirectory()`), каталогу тимчасових файлів кешу (`getTemporaryDirectory()`) тощо.

11. **Яке призначення методу fromJson()?**  
Метод `fromJson()` (найчастіше реалізований як фабричний конструктор `factory Model.fromJson(Map<String, dynamic> json)`) призначений для створення типізованого об'єкта моделі на основі десеріалізованої з JSON мапи. Він виконує безпечне перетворення типів, встановлює значення за замовчуванням та конвертує примітивні типи (наприклад, `String`) у спеціалізовані сутності (`enum` або `DateTime`).

12. **Яке призначення методу toJson()?**  
Метод `toJson()` виконує зворотну операцію серіалізації: він перетворює екземпляр моделі Dart у мапу `Map<String, dynamic>`. У цій мапі всі складні типи (наприклад, `enum` чи `DateTime`) переводяться у стандартні типи, зрозумілі формату JSON (рядки, числа, логічні значення), що дає змогу передати мапу у функцію `jsonEncode()`.

13. **Як перетворити JSON-масив у список моделей?**  
Спочатку вхідний JSON-рядок декодується за допомогою `jsonDecode()` у список dynamic-елементів (`List<dynamic>`). Потім за допомогою методу `.map()` кожен елемент списку (який є `Map<String, dynamic>`) передається у фабричний конструктор моделі `fromJson()` і результат приводиться до типізованого списку через `.toList()`: `final List<TaskModel> items = (jsonDecode(jsonString) as List).map((e) => TaskModel.fromJson(e)).toList();`.

14. **Які операції можна виконувати з даними, що зберігаються у JSON-файлі?**  
Із даними у JSON-файлі можна виконувати повний набір операцій CRUD: Create (додавання нових записів із подальшим перезаписом файлу), Read (зчитування та парсинг файлу під час завантаження екрана), Update (редагування властивостей існуючих записів, наприклад, зміна назви, прапорця обраного чи статусу enum) та Delete (видалення запису зі списку та збереження актуального стану колекції у файл).

---

**Висновок:** На цій лабораторній роботі, я опанував практичні навички роботи з форматом JSON у мові Dart та фреймворку Flutter, створив початковий файл assets/data/tasks.json та зареєстрував його в pubspec.yaml, реалізував типізовану модель даних TaskModel із методами серіалізації fromJson() та toJson(), побудував сервіс збереження даних TaskStorageService з використанням бібліотеки path_provider та пакету dart:convert, реалізував відображення динамічного списку через ListView.builder та ListTile, додав операції створення, редагування, вилучення завдань та перемикання станів із миттєвою синхронізацією у локальний JSON-файл, а також перевірив коректність роботи бізнес-логіки та інтерфейсу за допомогою автоматизованих тестів та на емуляторі Android.
