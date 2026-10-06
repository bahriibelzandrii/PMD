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
