# ЗВІТ
про виконання лабораторної роботи №6  
«Робота з різними типами даних та моделями та відображення списками»  
з дисципліни «Програмування мобільних додатків»  
Студента групи КН-2327Б  
**Багрія-Белза Андрія**  

---

**Завдання на лабораторну роботу:**
1. Продовжити роботу над проєктом, розпочатим у Лабораторній роботі №5.
2. Створити окремий файл моделі (наприклад, `item_model.dart` або `task_model.dart`).
3. Описати `class Model` з мінімум 4 полями: `int`, `String`, `bool`, `enum`.
4. Створити `List<Model>` — основне джерело даних екрану (мінімум 5 початкових елементів).
5. Відобразити список з `ListView.builder` та `ListTile`.
6. Реалізувати додавання, видалення елемента.
7. Реалізувати зміну стану елемента:
   - іконка «обране» перемикає `isFavorite`;
   - зміна значення `status` (enum) кнопкою або довгим натисканням;
   - оновлення через `setState()`.
8. Створити `Map<String, int>` для статистики:
   - загальна кількість елементів;
   - кількість обраних;
   - кількість виконаних (`status = done`).

---

### 1 Написання коду-розв’язку завдання:

#### Точка входу в застосунок (`Lab_6/task_manager/lib/main.dart`):
```dart
import 'package:flutter/material.dart';
import 'screens/lab6_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Менеджер завдань — Лабораторна №6',
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
      home: const Lab6Screen(),
    );
  }
}
```

#### Файл моделі даних та перелік статусів (`Lab_6/task_manager/lib/models/task_model.dart`):
```dart
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

  /// Зручний геттер для перевірки завершеності
  bool get isDone => status == TaskStatus.done;

  /// Метод для копіювання з модифікацією (за потреби)
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

/// Початковий список завдань (мінімум 5 елементів згідно з ТЗ)
List<TaskModel> getInitialTasks() {
  return [
    TaskModel(
      id: 1,
      title: 'Оптимізація запитів до бази даних',
      isFavorite: true,
      status: TaskStatus.active,
    ),
    TaskModel(
      id: 2,
      title: 'Рефакторинг архітектури Flutter-екранів',
      isFavorite: false,
      status: TaskStatus.done,
    ),
    TaskModel(
      id: 3,
      title: 'Інтеграція REST API та обробка помилок',
      isFavorite: false,
      status: TaskStatus.active,
    ),
    TaskModel(
      id: 4,
      title: 'Написання віджет-тестів та перевірка стану',
      isFavorite: true,
      status: TaskStatus.done,
    ),
    TaskModel(
      id: 5,
      title: 'Оновлення темної палітри кольорів Material 3',
      isFavorite: false,
      status: TaskStatus.active,
    ),
    TaskModel(
      id: 6,
      title: 'Підготовка збірки та публікація в Play Store',
      isFavorite: false,
      status: TaskStatus.active,
    ),
  ];
}
```

#### Головний екран зі списком та станом (`Lab_6/task_manager/lib/screens/lab6_screen.dart`):
```dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../widgets/stats_summary_card.dart';
import '../widgets/task_list_item.dart';

enum TaskFilter {
  all,
  active,
  done,
  favorites,
}

class Lab6Screen extends StatefulWidget {
  const Lab6Screen({super.key});

  @override
  State<Lab6Screen> createState() => _Lab6ScreenState();
}

class _Lab6ScreenState extends State<Lab6Screen> {
  // Основне джерело даних екрана: List<TaskModel> (п. 4 ТЗ)
  late List<TaskModel> _tasks;

  // Поточний фільтр для зручності перегляду
  TaskFilter _currentFilter = TaskFilter.all;

  @override
  void initState() {
    super.initState();
    // Ініціалізація мінімум 5 елементів
    _tasks = getInitialTasks();
  }

  // Обчислення статистики у вигляді Map<String, int> (п. 8 ТЗ)
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

  // Зміна обраного стану (п. 7 ТЗ)
  void _toggleFavorite(TaskModel task) {
    setState(() {
      task.isFavorite = !task.isFavorite;
    });
    _showSnackBar(
      task.isFavorite ? 'Додано до обраного ❤️' : 'Видалено з обраного 🤍',
    );
  }

  // Зміна статусу enum (п. 7 ТЗ)
  void _toggleStatus(TaskModel task) {
    setState(() {
      task.status =
          task.status == TaskStatus.done ? TaskStatus.active : TaskStatus.done;
    });
    _showSnackBar(
      task.status == TaskStatus.done
          ? 'Завдання виконано! 🎉'
          : 'Завдання позначено як активне',
    );
  }

  // Видалення елемента зі списку (п. 6 ТЗ)
  void _deleteTask(TaskModel task) {
    final int index = _tasks.indexOf(task);
    setState(() {
      _tasks.remove(task);
    });

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          'Завдання "${task.title}" видалено',
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
          },
        ),
      ),
    );
  }

  // Додавання нового елемента (п. 6 ТЗ)
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
                    'Нове завдання',
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

                    Navigator.pop(ctx);
                    _showSnackBar('Завдання успішно додано! 🚀');
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
        title: const Text('Лабораторна робота №6'),
        centerTitle: true,
        backgroundColor: const Color(0xFF15181F),
        actions: [
          IconButton(
            tooltip: 'Додати завдання',
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFFD4FF00)),
            onPressed: _showAddTaskDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
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

              // 3. Основний список завдань ListView.builder (п. 5 ТЗ)
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

#### Віджет статистики на основі `Map<String, int>` (`Lab_6/task_manager/lib/widgets/stats_summary_card.dart`):
```dart
import 'package:flutter/material.dart';

/// Віджет для відображення статистики завдань на основі `Map<String, int>`
class StatsSummaryCard extends StatelessWidget {
  final Map<String, int> stats;

  const StatsSummaryCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final total = stats['total'] ?? 0;
    final favorites = stats['favorites'] ?? 0;
    final done = stats['done'] ?? 0;
    final active = stats['active'] ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF15181F),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF2A3142),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: Color(0xFFD4FF00),
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'Статистика завдань (Map<String, int>)',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatItem(
                label: 'Всього',
                value: '$total',
                icon: Icons.format_list_bulleted,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              _buildStatItem(
                label: 'Активні',
                value: '$active',
                icon: Icons.bolt,
                color: const Color(0xFF4FC3F7),
              ),
              const SizedBox(width: 8),
              _buildStatItem(
                label: 'Виконано',
                value: '$done',
                icon: Icons.check_circle_outline,
                color: const Color(0xFFD4FF00),
              ),
              const SizedBox(width: 8),
              _buildStatItem(
                label: 'Обрані',
                value: '$favorites',
                icon: Icons.favorite,
                color: const Color(0xFFFF4B6E),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2430),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF8B949E),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
```

#### Віджет рядка списку (`Lab_6/task_manager/lib/widgets/task_list_item.dart`):
```dart
import 'package:flutter/material.dart';
import '../models/task_model.dart';

/// Віджет для відображення одного рядка завдання за допомогою ListTile
class TaskListItem extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggleFavorite;
  final VoidCallback onToggleStatus;
  final VoidCallback onDelete;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onToggleFavorite,
    required this.onToggleStatus,
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
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
          // 4. trailing: перемикач статусу та видалення
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Кнопка перемикання статусу
              IconButton(
                tooltip: isDone ? 'Позначити як активне' : 'Позначити як виконане',
                icon: Icon(
                  isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isDone ? const Color(0xFFD4FF00) : const Color(0xFF8B949E),
                  size: 22,
                ),
                onPressed: onToggleStatus,
              ),
              // Кнопка видалення
              IconButton(
                tooltip: 'Видалити завдання',
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFEF5350),
                  size: 22,
                ),
                onPressed: onDelete,
              ),
            ],
          ),
          // Зміна статусу при довгому натисканні згідно з п. 7 ТЗ
          onLongPress: onToggleStatus,
          // Перемикання статусу при звичайному кліку по всьому рядку
          onTap: onToggleStatus,
        ),
      ),
    );
  }
}
```

---

### 2 Результат виконання коду:
- Застосунок запущено та протестовано на емуляторі Android 16 (API 36).
- Знімок початкового списку та інтерактивного стану після додавання завдань і зміни статусів: `Lab_6/assets/emulator_duo.png`

---

### Контрольні запитання:

1. **Чим List відрізняється від Map у Dart?**  
`List` — це впорядкована індексована колекція елементів, доступ до яких здійснюється за цілочисельним індексом (починаючи з 0), де елементи можуть дублюватися. `Map` — це асоціативна колекція пар «ключ — значення», де кожен ключ є унікальним, а доступ до значень виконується за відповідним ключем довільного типу (найчастіше `String`), що робить `Map` зручною структурою для словників, конфігурацій та агрегованої статистики.

2. **Для чого використовують enum? Наведіть приклад.**  
Переліки (`enum`) використовують для визначення фіксованого, безпечного з точки зору типізації набору іменованих значень чи станів. Це запобігає друкарським помилкам, характерним для рядкових констант, та забезпечує вичерпну перевірку в операторах `switch`. Приклад у проєкті: `enum TaskStatus { active, done }`, де кожен об'єкт завдання може набувати лише одного зі суворо визначених статусів.

3. **Що таке модель даних (model class) і яку роль вона відіграє у Flutter-застосунку?**  
Модель даних (`Model Class`) — це типізований користувацький клас Dart, що інкапсулює поля та логіку сутності предметної області (наприклад, `TaskModel`). Вона відокремлює шар бізнес-даних від віджетів інтерфейсу (UI), гарантує сувору типізацію, спрощує серіалізацію/десеріалізацію, покращує читабельність коду та полегшує тестування.

4. **Як додати елемент у List<Model> та оновити інтерфейс?**  
Для додавання елемента викликається метод `.add()` (або `.insert()`) на екземплярі `List<Model>`. Щоб Flutter перемалював екран і відобразив новий рядок у списку, цю операцію огортають у виклик `setState()` всередині класу стану `StatefulWidget`: `setState(() { _tasks.add(newTask); });`. Це сигналізує фреймворку про необхідність повторного виклику `build()`.

5. **Яка різниця між методами map() і where() для списку?**  
Метод `where()` виконує фільтрацію елементів за предикатом (`bool Function(E)`), повертаючи лише ті елементи, які задовольняють умову (наприклад, `_tasks.where((t) => t.isFavorite)`). Метод `map()` здійснює трансформацію/проекцію: він викликає функцію перетворення для кожного елемента й повертає нову колекцію змінених значень (наприклад, `_tasks.map((t) => t.title)`). Обидва методи повертають лінивий `Iterable`.

6. **Як реалізувати фільтрацію списку (наприклад, показувати лише обрані елементи)?**  
Фільтрація реалізується за допомогою виклику методу `.where()` на основному списку: `List<TaskModel> get filteredTasks => _tasks.where((t) => t.isFavorite).toList();`. У `ListView.builder` передають довжину отриманого відфільтрованого списку в `itemCount`, а в `itemBuilder` будують елементи за індексом з `filteredTasks[index]`.

7. **Для чого використовується віджет ListView.builder? У чому його перевага?**  
`ListView.builder` використовується для відображення динамічних або потенційно великих прокручуваних списків. Його ключова перевага полягає в оптимізації продуктивності та пам'яті через лінивий рендеринг (lazy rendering): `itemBuilder` генерує віджети рядків виключно тоді, коли вони потрапляють у видиму область екрана (viewport), не створюючи заздалегідь весь список у пам'яті.

8. **Що таке itemCount, itemBuilder та index у ListView.builder?**  
- `itemCount` — це цілочисельний параметр, який визначає загальну кількість елементів у списку.
- `itemBuilder` — функція зворотного виклику типу `Widget Function(BuildContext, int)`, яка викликається рушієм рендерингу для побудови віджета конкретного рядка.
- `index` — порядковий номер (від 0 до `itemCount - 1`) поточного елемента, що рендериться у списку.

9. **Як змінити стан окремого елемента списку та оновити UI?**  
Для зміни стану окремого елемента списку знаходять відповідний об'єкт моделі (за індексом `index` або `id`), змінюють значення потрібного поля (наприклад, `task.isFavorite = !task.isFavorite` або `task.status = TaskStatus.done`) та викликають `setState()`. Flutter ініціює перезапуск методу `build()`, викликаючи `itemBuilder` для видимих рядків і оновлюючи їхнє графічне відображення.

10. **Що станеться, якщо змінити дані моделі без виклику setState()?**  
Змінна та відповідне поле об'єкта в оперативній пам'яті змінять своє значення, але фреймворк Flutter не отримає сповіщення про зміну стану. Екран не запланує перемалювання кадру, і користувацький інтерфейс залишиться зі застарілими даними доти, доки віджет випадково не перебудується внаслідок інших подій.

---

**Висновок:** На цій лабораторній роботі, я опанував практичні навички роботи зі структурами даних List та Map у мові Dart, створив типізовану модель даних TaskModel з обов'язковими полями різних типів (int, String, bool, enum TaskStatus), реалізував динамічне відображення колекції об'єктів за допомогою віджетів ListView.builder та ListTile, впровадив додавання нових завдань через модальний діалог і вилучення елементів, налаштував зміну внутрішнього стану моделей через setState() (перемикання прапорця обраного та зміну enum-статусу кліком і довгим натисканням), реалізував підрахунок та візуалізацію аналітичної статистики у вигляді Map<String, int>, а також верифікував коректність інтерфейсу та бізнес-логіки автоматизованими тестами й на емуляторі Android.
