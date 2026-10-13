import 'dart:math';

import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../services/task_storage_service.dart';
import '../services/user_storage_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import '../widgets/stats_summary_card.dart';
import '../widgets/task_list_item.dart';
import 'profile_screen.dart';

enum TaskFilter { all, active, done, favorites }

class TaskManagerScreen extends StatefulWidget {
  /// Ім'я користувача для привітання на екрані
  final String? username;

  /// Email користувача для екрана профілю
  final String? email;

  /// Пароль користувача для екрана профілю (п. 3, 5 ТЗ ЛР 10)
  final String? password;

  /// Колбек перемикання теми (п. 2 ТЗ ЛР 9)
  final ValueChanged<bool>? onToggleTheme;

  const TaskManagerScreen({
    super.key,
    this.username,
    this.email,
    this.password,
    this.onToggleTheme,
  });

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  final TaskStorageService _storageService = TaskStorageService();

  // Сервіс локального збереження (SharedPreferences) — дані користувача
  // та favorites ids (п. 1 ТЗ ЛР 10)
  final UserStorageService _userStorage = UserStorageService();

  // Основне джерело даних: список моделей List<TaskModel> (п. 7 ТЗ)
  List<TaskModel> _tasks = [];
  bool _isLoading = true;

  // Збережені ідентифікатори обраних елементів (п. 7, 8 ТЗ ЛР 10)
  List<String> _favoriteIds = [];

  // Фільтр для перегляду
  TaskFilter _currentFilter = TaskFilter.all;

  @override
  void initState() {
    super.initState();
    _loadTasksFromJson();
  }

  // 1. Зчитування даних із JSON-файлу та відновлення favorites ids
  //    із SharedPreferences (п. 8, 9 ТЗ ЛР 10)
  Future<void> _loadTasksFromJson() async {
    try {
      final loadedTasks = await _storageService.loadTasks();
      // Відновлення обраних елементів за збереженими id
      final savedIds = await _userStorage.loadFavoriteIds();
      for (final task in loadedTasks) {
        task.isFavorite = savedIds.contains(task.id.toString());
      }
      if (mounted) {
        setState(() {
          _tasks = loadedTasks;
          _favoriteIds = savedIds;
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

  // 3. Синхронізація favorites ids у SharedPreferences (п. 6, 7 ТЗ ЛР 10)
  //    — зберігається лише список ідентифікаторів обраних елементів
  Future<void> _persistFavoriteIds() async {
    final ids =
        _tasks.where((t) => t.isFavorite).map((t) => t.id.toString()).toList();
    _favoriteIds = ids;
    await _userStorage.saveFavoriteIds(ids);
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
      // П. 9 ТЗ ЛР 10: лише ті елементи, id яких містяться у списку збережених
      case TaskFilter.favorites:
        return _tasks
            .where((t) => _favoriteIds.contains(t.id.toString()))
            .toList();
      case TaskFilter.all:
        return _tasks;
    }
  }

  // 4. Зміна стану елемента (обране, п. 12 ТЗ)
  void _toggleFavorite(TaskModel task) {
    setState(() {
      task.isFavorite = !task.isFavorite;
    });
    _persistTasks();
    _persistFavoriteIds();
    _showSnackBar(
      task.isFavorite
          ? 'Додано до обраного ❤️ (id збережено в SharedPreferences)'
          : 'Видалено з обраного 🤍 (id видалено з SharedPreferences)',
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
    final bool wasFavorite = task.isFavorite;
    setState(() {
      _tasks.remove(task);
    });
    _persistTasks();
    // Якщо видалене завдання було обрано — оновлюємо favorites ids (п. 7 ТЗ ЛР 10)
    if (wasFavorite) {
      _persistFavoriteIds();
    }

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          'Завдання "${task.title}" видалено з JSON',
          style: const TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'СКАСУВАТИ',
          textColor: AppColors.onPrimary,
          onPressed: () {
            setState(() {
              _tasks.insert(index, task);
            });
            _persistTasks();
            if (wasFavorite) {
              _persistFavoriteIds();
            }
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
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.card(isDark),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: AppColors.border(isDark)),
              ),
              title: Row(
                children: [
                  const Icon(Icons.add_task, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Нове завдання (JSON)',
                    style:
                        AppStyles.title(isDark: isDark).copyWith(fontSize: 18),
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
                      style: TextStyle(color: AppColors.text(isDark)),
                      decoration: InputDecoration(
                        labelText: 'Назва завдання',
                        labelStyle: TextStyle(
                          color: AppColors.textSecondary(isDark),
                        ),
                        hintText: 'Введіть тему або завдання...',
                        hintStyle: TextStyle(color: AppColors.textHint(isDark)),
                        filled: true,
                        fillColor: AppColors.surface(isDark),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Додати в обране',
                        style: TextStyle(
                          color: AppColors.text(isDark),
                          fontSize: 14,
                        ),
                      ),
                      value: isFavorite,
                      activeThumbColor: AppColors.primary,
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
                  child: Text(
                    'Скасувати',
                    style: TextStyle(color: AppColors.textSecondary(isDark)),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
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
                    if (isFavorite) {
                      _persistFavoriteIds();
                    }

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
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.card(isDark),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: AppColors.border(isDark)),
              ),
              title: Row(
                children: [
                  const Icon(Icons.edit_note, color: AppColors.secondary),
                  SizedBox(width: 8),
                  Text(
                    'Редагувати #${task.id}',
                    style:
                        AppStyles.title(isDark: isDark).copyWith(fontSize: 18),
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
                      style: TextStyle(color: AppColors.text(isDark)),
                      decoration: InputDecoration(
                        labelText: 'Назва завдання',
                        labelStyle: TextStyle(
                          color: AppColors.textSecondary(isDark),
                        ),
                        filled: true,
                        fillColor: AppColors.surface(isDark),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.secondary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Обране завдання',
                        style: TextStyle(
                          color: AppColors.text(isDark),
                          fontSize: 14,
                        ),
                      ),
                      value: isFavorite,
                      activeThumbColor: AppColors.favorite,
                      onChanged: (val) {
                        setDialogState(() {
                          isFavorite = val;
                        });
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Статус: Виконано',
                        style: TextStyle(
                          color: AppColors.text(isDark),
                          fontSize: 14,
                        ),
                      ),
                      value: isDone,
                      activeThumbColor: AppColors.primary,
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
                  child: Text(
                    'Скасувати',
                    style: TextStyle(color: AppColors.textSecondary(isDark)),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: AppColors.onPrimary,
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
      // Початкові дані не містять обраних — очищаємо favorites ids
      await _userStorage.clearFavorites();
      _favoriteIds = [];
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
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTasks;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Менеджер завдань'),
        centerTitle: true,
        backgroundColor: AppColors.card(isDark),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            tooltip: 'Скинути до assets JSON',
            icon: Icon(Icons.restore, color: AppColors.textSecondary(isDark)),
            onPressed: _resetToAssets,
          ),
          IconButton(
            tooltip: 'Вийти з акаунта',
            icon: Icon(Icons.logout, color: AppColors.textSecondary(isDark)),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            tooltip: 'Профіль користувача',
            icon: Icon(
              Icons.person_outline,
              size: 22,
              color: AppColors.textSecondary(isDark),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    username: widget.username,
                    email: widget.email,
                    password: widget.password,
                    onToggleTheme: widget.onToggleTheme,
                  ),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Додати завдання',
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppColors.primary,
            ),
            onPressed: _showAddTaskDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sync, color: AppColors.primary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Завантаження завдань із JSON...',
                      style: AppStyles.subtitle(isDark: isDark)
                          .copyWith(fontSize: 14),
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
                    // Привітання для зареєстрованого користувача
                    if (widget.username != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.card(isDark),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border(isDark)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.waving_hand,
                              color: AppColors.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Вітаємо, ${widget.username}! 👋',
                                style: AppStyles.body(isDark: isDark).copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                    StatsSummaryCard(stats: _statistics, isDark: isDark),
                    const SizedBox(height: 14),

                    // 2. Фільтри завдань
                    Row(
                      children: [
                        _buildFilterChip(
                          'Всі (${_tasks.length})',
                          TaskFilter.all,
                        ),
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
                    const SizedBox(height: 12),

                    // 3. Основний список завдань ListView.builder (п. 8 ТЗ)
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.inbox_outlined,
                                    size: 48,
                                    color: AppColors.textHint(isDark),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _currentFilter == TaskFilter.favorites
                                        ? 'Немає обраних завдань'
                                        : 'Список порожній',
                                    style: AppStyles.subtitle(isDark: isDark)
                                        .copyWith(fontSize: 15),
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
                                  isDark: isDark,
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
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_currentFilter != filter) {
            setState(() {
              _currentFilter = filter;
            });
          }
        },
        child: Container(
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.card(isDark),
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border(isDark),
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isSelected
                  ? AppColors.onPrimary
                  : AppColors.textSecondary(isDark),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
