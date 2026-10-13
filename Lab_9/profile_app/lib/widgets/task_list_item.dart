import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../theme/app_colors.dart';

/// Віджет для відображення одного рядка завдання за допомогою ListTile
class TaskListItem extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggleFavorite;
  final VoidCallback onToggleStatus;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  final bool isDark;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onToggleFavorite,
    required this.onToggleStatus,
    required this.onEdit,
    required this.onDelete,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == TaskStatus.done;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.card(isDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDone
                ? AppColors.surface(isDark)
                : (task.isFavorite
                      ? AppColors.favorite.withValues(alpha: 0.3)
                      : AppColors.border(isDark)),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 2,
          ),
          // 1. leading: іконка "обране"
          leading: IconButton(
            tooltip: task.isFavorite
                ? 'Видалити з обраного'
                : 'Додати в обране',
            icon: Icon(
              task.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: task.isFavorite
                  ? AppColors.favorite
                  : AppColors.textSecondary(isDark),
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
              decorationColor: AppColors.textSecondary(isDark),
              color: isDone
                  ? AppColors.textDone(isDark)
                  : AppColors.text(isDark),
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
                      ? AppColors.accent(isDark).withValues(alpha: 0.15)
                      : AppColors.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isDone ? 'Виконано' : 'Активне',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDone ? AppColors.accent(isDark) : AppColors.secondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'ID: #${task.id}',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textHint(isDark),
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
                tooltip: isDone
                    ? 'Позначити як активне'
                    : 'Позначити як виконане',
                icon: Icon(
                  isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isDone
                      ? AppColors.accent(isDark)
                      : AppColors.textSecondary(isDark),
                  size: 20,
                ),
                onPressed: onToggleStatus,
              ),
              // Кнопка редагування (п. 10 ТЗ)
              IconButton(
                tooltip: 'Редагувати завдання',
                icon: Icon(
                  Icons.edit_outlined,
                  color: AppColors.secondary,
                  size: 20,
                ),
                onPressed: onEdit,
              ),
              // Кнопка видалення
              IconButton(
                tooltip: 'Видалити завдання',
                icon: Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
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
