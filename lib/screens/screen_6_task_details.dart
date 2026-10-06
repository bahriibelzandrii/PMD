import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_typography.dart';
import '../design_system/app_widgets.dart';
import '../design_system/task_model.dart';

/// Екран 6: Деталі завдання та чеклист — Варіант A (Документ + Чеклист)
/// Цільові лабораторні: Лабораторна №4 (Custom Widgets), №5 (StatefulWidget & setState) та №7.
class TaskDetailsScreen extends StatefulWidget {
  final TaskModel task;
  final VoidCallback onToggleFavorite;

  const TaskDetailsScreen({
    super.key,
    required this.task,
    required this.onToggleFavorite,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final _newSubtaskController = TextEditingController();

  @override
  void dispose() {
    _newSubtaskController.dispose();
    super.dispose();
  }

  void _toggleSubtask(Subtask subtask) {
    setState(() {
      subtask.isCompleted = !subtask.isCompleted;
    });
  }

  void _addSubtask() {
    final text = _newSubtaskController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        widget.task.subtasks.add(
          Subtask(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: text,
            isCompleted: false,
          ),
        );
        _newSubtaskController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = widget.task.subtasks.where((s) => s.isCompleted).length;
    final totalCount = widget.task.subtasks.length;
    final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;

    return Scaffold(
      backgroundColor: AppColors.bgObsidian,
      appBar: AppBar(
        title: const Text('Деталі завдання'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                widget.task.isFavorite = !widget.task.isFavorite;
              });
              widget.onToggleFavorite();
            },
            icon: Icon(
              widget.task.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
              color: widget.task.isFavorite ? AppColors.limePrimary : AppColors.textSecondary,
              size: 26,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Бейджі статусу та пріоритету
              Row(
                children: [
                  PriorityBadge(priority: widget.task.priority),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.bgSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Text(
                      widget.task.category,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Назва задачі
              Text(
                widget.task.title,
                style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w800),
              ),

              const SizedBox(height: 12),

              // Опис
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Опис та вимоги:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.task.description.isEmpty ? 'Опис відсутній.' : widget.task.description,
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Чеклист підзавдань (Лаб 5: StatefulWidget & setState)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Підзавдання ($completedCount/$totalCount)',
                    style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      color: AppColors.limePrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.bgSurface,
                  valueColor: const AlwaysStoppedAnimation(AppColors.limePrimary),
                  minHeight: 6,
                ),
              ),

              const SizedBox(height: 14),

              // Список підзавдань
              if (widget.task.subtasks.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Немає підзавдань. Додайте перше нижче.', style: TextStyle(color: AppColors.textMuted)),
                )
              else
                ...widget.task.subtasks.map((subtask) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    color: AppColors.bgCard,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppColors.borderSubtle),
                    ),
                    child: CheckboxListTile(
                      value: subtask.isCompleted,
                      activeColor: AppColors.limePrimary,
                      checkColor: AppColors.textInverse,
                      title: Text(
                        subtask.title,
                        style: TextStyle(
                          decoration: subtask.isCompleted ? TextDecoration.lineThrough : null,
                          color: subtask.isCompleted ? AppColors.textMuted : AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                      onChanged: (_) => _toggleSubtask(subtask),
                    ),
                  );
                }),

              const SizedBox(height: 14),

              // Поле додавання підзавдання
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _newSubtaskController,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Додати пункт чеклиста...',
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      onSubmitted: (_) => _addSubtask(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _addSubtask,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.limePrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.add, color: AppColors.textInverse),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
