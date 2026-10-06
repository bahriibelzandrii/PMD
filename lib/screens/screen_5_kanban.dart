import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_typography.dart';
import '../design_system/app_widgets.dart';
import '../design_system/task_model.dart';

/// Екран 5: Дошка завдань / Канбан — Варіант A (Фільтр-чіпи)
/// Цільові лабораторні: Лабораторна №6 (Моделі даних, enum, фільтрація списків) та №7 (ListView.builder).
class KanbanBoardScreen extends StatefulWidget {
  final Function(TaskModel) onTaskTap;

  const KanbanBoardScreen({super.key, required this.onTaskTap});

  @override
  State<KanbanBoardScreen> createState() => _KanbanBoardScreenState();
}

class _KanbanBoardScreenState extends State<KanbanBoardScreen> {
  // Активний фільтр статусу (null = Всі)
  TaskStatus? _selectedStatus;

  final List<TaskModel> _allTasks = [
    TaskModel(
      id: '1',
      title: 'Підготувати звіт до Лаб 3',
      description: 'Скласти діаграми віджетів та контрольні запитання',
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      category: '🎓 Програмування МД',
      deadline: DateTime.now().add(const Duration(days: 1)),
      estimatedHours: 2.0,
    ),
    TaskModel(
      id: '2',
      title: 'Розробити StatefulWidget чеклист (Лаб 5)',
      description: 'Реалізація динамічного оновлення прогресу',
      priority: TaskPriority.high,
      status: TaskStatus.todo,
      category: '🎓 Програмування МД',
      deadline: DateTime.now().add(const Duration(days: 3)),
      estimatedHours: 3.0,
    ),
    TaskModel(
      id: '3',
      title: 'JSON моделі та серіалізація (Лаб 7)',
      description: 'Генерація згідно специфікації task_model.dart',
      priority: TaskPriority.medium,
      status: TaskStatus.review,
      category: '🎓 Програмування МД',
      deadline: DateTime.now().add(const Duration(days: 5)),
      estimatedHours: 1.5,
    ),
    TaskModel(
      id: '4',
      title: 'Базовий каркас Scaffold (Лаб 2)',
      description: 'AppBar, Body, BottomNavigationBar створено',
      priority: TaskPriority.low,
      status: TaskStatus.done,
      category: '🎓 Програмування МД',
      estimatedHours: 2.5,
    ),
    TaskModel(
      id: '5',
      title: 'Схема БД для курсової',
      description: 'Розробка концептуальної моделі та зв\'язків',
      priority: TaskPriority.medium,
      status: TaskStatus.inProgress,
      category: '💼 Курсова',
      estimatedHours: 4.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Фільтрація задач (Лаб 6)
    final filteredTasks = _selectedStatus == null
        ? _allTasks
        : _allTasks.where((t) => t.status == _selectedStatus).toList();

    return Scaffold(
      backgroundColor: AppColors.bgObsidian,
      appBar: AppBar(
        title: const Text('Дошка статусів'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Горизонтальний рядок фільтрів (Лаб 6)
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildFilterChip('Всі (${_allTasks.length})', null),
                  const SizedBox(width: 8),
                  _buildFilterChip('To Do (${_countByStatus(TaskStatus.todo)})', TaskStatus.todo),
                  const SizedBox(width: 8),
                  _buildFilterChip('В процесі (${_countByStatus(TaskStatus.inProgress)})', TaskStatus.inProgress),
                  const SizedBox(width: 8),
                  _buildFilterChip('На рев\'ю (${_countByStatus(TaskStatus.review)})', TaskStatus.review),
                  const SizedBox(width: 8),
                  _buildFilterChip('Готово (${_countByStatus(TaskStatus.done)})', TaskStatus.done),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Список відфільтрованих задач (Лаб 7: ListView.builder)
            Expanded(
              child: filteredTasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.inbox_outlined, size: 48, color: AppColors.textMuted),
                          const SizedBox(height: 8),
                          Text(
                            'Немає завдань у цьому статусі',
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return TaskCard(
                          task: task,
                          onTap: () => widget.onTaskTap(task),
                          onToggleComplete: () {
                            setState(() {
                              task.isCompleted = !task.isCompleted;
                              task.status = task.isCompleted ? TaskStatus.done : TaskStatus.inProgress;
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  int _countByStatus(TaskStatus status) {
    return _allTasks.where((t) => t.status == status).length;
  }

  Widget _buildFilterChip(String label, TaskStatus? status) {
    final isSelected = _selectedStatus == status;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedStatus = status),
      selectedColor: AppColors.limePrimary,
      backgroundColor: AppColors.bgSurface,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.textInverse : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
        fontSize: 12,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.limePrimary : AppColors.borderSubtle,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
