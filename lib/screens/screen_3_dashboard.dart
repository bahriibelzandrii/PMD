import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_typography.dart';
import '../design_system/app_widgets.dart';
import '../design_system/task_model.dart';

/// Екран 3: Головний дашборд — Гібрид A + C (Studio Focus + Bento Metric Hub)
/// Цільові лабораторні: Лабораторна №2, №3, №4, №5.
class DashboardScreen extends StatefulWidget {
  final VoidCallback onAddTask;
  final Function(TaskModel) onTaskTap;
  final VoidCallback onViewAllTasks;

  const DashboardScreen({
    super.key,
    required this.onAddTask,
    required this.onTaskTap,
    required this.onViewAllTasks,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Список задач для демонстрації
  late List<TaskModel> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = [
      TaskModel(
        id: '1',
        title: 'JSON серіалізація моделей (Лаб 7)',
        description: 'Парсинг TaskModel.fromJson та збереження',
        priority: TaskPriority.high,
        status: TaskStatus.inProgress,
        category: '🎓 Програмування МД',
        deadline: DateTime.now().add(const Duration(days: 2)),
        estimatedHours: 2.5,
        subtasks: [
          Subtask(id: 's1', title: 'Створити клас TaskModel', isCompleted: true),
          Subtask(id: 's2', title: 'Додати методи fromJson/toJson', isCompleted: false),
        ],
      ),
      TaskModel(
        id: '2',
        title: 'Layout розмітка карток (Лаб 3)',
        description: 'Побудова Bento-сітки з Row, Column, Expanded',
        priority: TaskPriority.medium,
        status: TaskStatus.done,
        category: '🎓 Програмування МД',
        deadline: DateTime.now().subtract(const Duration(days: 1)),
        estimatedHours: 3.0,
      ),
      TaskModel(
        id: '3',
        title: 'Управління станом setState (Лаб 5)',
        description: 'Реалізація інтерактивного чеклиста та лічильника',
        priority: TaskPriority.high,
        status: TaskStatus.todo,
        category: '🎓 Програмування МД',
        deadline: DateTime.now().add(const Duration(days: 4)),
        estimatedHours: 2.0,
      ),
    ];
  }

  void _toggleTask(TaskModel task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
      if (task.isCompleted) {
        task.status = TaskStatus.done;
      } else {
        task.status = TaskStatus.inProgress;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgObsidian,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          children: [
            // Заголовок з аватаром
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.limePrimary,
                      child: const Text(
                        'АК',
                        style: TextStyle(
                          color: AppColors.textInverse,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Привіт, Андрію! 👋',
                          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                        ),
                        Text(
                          'Головний дашборд',
                          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: widget.onAddTask,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.bgSurface,
                    shape: const CircleBorder(),
                  ),
                  icon: const Icon(Icons.add, color: AppColors.limePrimary),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Bento Progress Row (Гібрид A + C: з Референсу 3)
            Row(
              children: [
                // Кільце прогресу
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 64,
                          height: 64,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                value: 0.75,
                                strokeWidth: 6,
                                backgroundColor: AppColors.borderSubtle,
                                color: AppColors.limePrimary,
                              ),
                              const Center(
                                child: Text(
                                  '75%',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '24 / 32 задач',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                        Text(
                          'Завершено у семестрі',
                          style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Дві міні-плитки активності
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.cardBlue,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '4',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.cardBlueText,
                              ),
                            ),
                            Text(
                              'Активні проєкти',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.cardBlueText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.cardPeach,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '92%',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.cardPeachText,
                              ),
                            ),
                            Text(
                              'Дедлайни вчасно',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.cardPeachText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Лічильники статусів (4 пігулки)
            Row(
              children: [
                _buildStatPill('8', 'В роботі', AppColors.limePrimary),
                const SizedBox(width: 8),
                _buildStatPill('24', 'Готово', AppColors.textPrimary),
                const SizedBox(width: 8),
                _buildStatPill('2', 'Дедлайн', AppColors.highPriorityRed),
                const SizedBox(width: 8),
                _buildStatPill('13', 'Беклог', AppColors.textMuted),
              ],
            ),

            const SizedBox(height: 20),

            // Карусель пріоритетних завдань
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Сьогодні у фокусі',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800),
                ),
                TextButton(
                  onPressed: widget.onViewAllTasks,
                  child: const Text('Всі →', style: TextStyle(color: AppColors.limePrimary)),
                ),
              ],
            ),

            const SizedBox(height: 8),

            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFocusCard(
                    title: 'Wireframes для Лаб 3',
                    category: '🔥 Високий • ⏱ 3 год',
                    icon: '🎨',
                    bgColor: AppColors.cardBlue,
                    textColor: AppColors.cardBlueText,
                  ),
                  const SizedBox(width: 12),
                  _buildFocusCard(
                    title: 'State Management',
                    category: '⚡ Лаб 5 • ⏱ 1.5 год',
                    icon: '⚡',
                    bgColor: AppColors.cardPeach,
                    textColor: AppColors.cardPeachText,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Черга завдань
            Text(
              'Черга завдань',
              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800),
            ),

            const SizedBox(height: 10),

            // Список завдань з чекбоксами
            ..._tasks.map(
              (task) => TaskCard(
                task: task,
                onTap: () => widget.onTaskTap(task),
                onToggleComplete: () => _toggleTask(task),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatPill(String number, String label, Color numberColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          children: [
            Text(
              number,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: numberColor,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFocusCard({
    required String title,
    required String category,
    required String icon,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(icon, style: const TextStyle(fontSize: 22)),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: textColor, width: 2),
                ),
                child: Center(
                  child: Icon(Icons.arrow_forward_rounded, size: 12, color: textColor),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: textColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                category,
                style: TextStyle(
                  fontSize: 11,
                  color: textColor.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
