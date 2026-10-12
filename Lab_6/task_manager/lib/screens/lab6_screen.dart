import 'dart:math';

import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../widgets/stats_summary_card.dart';
import '../widgets/task_list_item.dart';

enum TaskFilter { all, active, done, favorites }

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
      task.status = task.status == TaskStatus.done
          ? TaskStatus.active
          : TaskStatus.done;
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
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            tooltip: 'Додати завдання',
            icon: const Icon(
              Icons.add_circle_outline,
              color: Color(0xFFD4FF00),
            ),
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

              // 2. Фільтри завдань (всі 4 види на одному рядку, без обрізання)
              Row(
                children: [
                  _buildFilterChip('Всі (${_tasks.length})', TaskFilter.all),
                  const SizedBox(width: 6),
                  _buildFilterChip(
                    'Активні (${_statistics['active']})',
                    TaskFilter.active,
                  ),
                  const SizedBox(width: 6),
                  _buildFilterChip(
                    'Виконані (${_statistics['done']})',
                    TaskFilter.done,
                  ),
                  const SizedBox(width: 6),
                  _buildFilterChip(
                    'Обрані (${_statistics['favorites']})',
                    TaskFilter.favorites,
                  ),
                ],
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
            color: isSelected
                ? const Color(0xFFD4FF00)
                : const Color(0xFF15181F),
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFD4FF00)
                  : const Color(0xFF2A3142),
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF0D0F13)
                  : const Color(0xFF8B949E),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
