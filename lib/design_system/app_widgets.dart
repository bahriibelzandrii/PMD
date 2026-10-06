import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'task_model.dart';

/// Reusable Component Library for TaskMaster Flutter Labs (Lab 4, 5, 6, 8, 9)

// =============================================================================
// 1. PRIORITY BADGE
// =============================================================================
class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;

  const PriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (priority) {
      case TaskPriority.high:
        bg = AppColors.priorityHighBg;
        fg = AppColors.priorityHigh;
        break;
      case TaskPriority.medium:
        bg = AppColors.priorityMediumBg;
        fg = AppColors.priorityMedium;
        break;
      case TaskPriority.low:
        bg = AppColors.priorityLowBg;
        fg = AppColors.priorityLow;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        priority.displayName,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          fontFamily: 'Courier',
        ),
      ),
    );
  }
}

// =============================================================================
// 2. STATUS PILL
// =============================================================================
class StatusPill extends StatelessWidget {
  final TaskStatus status;
  final bool isSelected;
  final VoidCallback? onTap;

  const StatusPill({
    super.key,
    required this.status,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bg = isSelected
        ? theme.colorScheme.primary
        : (isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle);

    final fg = isSelected
        ? theme.colorScheme.onPrimary
        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: Text(
          status.displayName,
          style: TextStyle(
            color: fg,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 3. STAT COUNTER CARD
// =============================================================================
class StatCounterCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const StatCounterCard({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTypography.monoStats.copyWith(
              color: valueColor ?? (isDark ? AppColors.white : AppColors.lightTextPrimary),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 4. PROGRESS BAR
// =============================================================================
class CustomProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color? fillColor;

  const CustomProgressBar({
    super.key,
    required this.progress,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clamped = progress.clamp(0.0, 1.0);

    return Container(
      height: 6,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? AppColors.darkSurfaceSubtle
            : AppColors.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(999),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: clamped,
        child: Container(
          decoration: BoxDecoration(
            color: fillColor ?? theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 5. TASK CARD (Lab 4, 5, 6, 7)
// =============================================================================
class TaskCard extends StatelessWidget {
  final TaskModel task;
  final ValueChanged<bool?>? onCheckboxChanged;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const TaskCard({
    super.key,
    required this.task,
    this.onCheckboxChanged,
    this.onToggleComplete,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDone = task.status == TaskStatus.completed;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Checkbox
                GestureDetector(
                  onTap: () {
                    if (onToggleComplete != null) {
                      onToggleComplete!();
                    } else if (onCheckboxChanged != null) {
                      onCheckboxChanged!(!isDone);
                    }
                  },
                  child: Container(
                    width: 22,
                    height: 22,
                    margin: const EdgeInsets.only(right: 12, top: 2),
                    decoration: BoxDecoration(
                      color: isDone ? theme.colorScheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isDone ? theme.colorScheme.primary : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                        width: 1.8,
                      ),
                    ),
                    child: isDone
                        ? Icon(Icons.check, size: 16, color: theme.colorScheme.onPrimary)
                        : null,
                  ),
                ),

                // Title & Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: AppTypography.headlineMedium.copyWith(
                          color: isDone
                              ? (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)
                              : (isDark ? AppColors.white : AppColors.lightTextPrimary),
                          decoration: isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 8),
                PriorityBadge(priority: task.priority),
              ],
            ),

            if (task.subtasks.isNotEmpty) ...[
              const SizedBox(height: 12),
              CustomProgressBar(progress: task.progress),
            ],

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 13, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    const SizedBox(width: 4),
                    Text(
                      '${task.dueDate.day}.${task.dueDate.month}.${task.dueDate.year}',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
                if (onFavoriteTap != null)
                  GestureDetector(
                    onTap: onFavoriteTap,
                    child: Icon(
                      task.isFavorite ? Icons.star : Icons.star_border,
                      size: 18,
                      color: task.isFavorite ? theme.colorScheme.primary : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 6. PRIMARY BUTTON
// =============================================================================
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {

    Widget btn = ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 8)],
          Text(text),
        ],
      ),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: btn);
    }
    return btn;
  }
}
