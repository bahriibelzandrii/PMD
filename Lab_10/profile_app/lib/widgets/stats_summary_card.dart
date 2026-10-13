import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Віджет для відображення статистики завдань на основі `Map<String, int>`
class StatsSummaryCard extends StatelessWidget {
  final Map<String, int> stats;

  final bool isDark;

  const StatsSummaryCard({super.key, required this.stats, this.isDark = true});

  @override
  Widget build(BuildContext context) {
    final total = stats['total'] ?? 0;
    final favorites = stats['favorites'] ?? 0;
    final done = stats['done'] ?? 0;
    final active = stats['active'] ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card(isDark),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border(isDark), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Статистика завдань',
                style: TextStyle(
                  color: AppColors.text(isDark),
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
                color: AppColors.text(isDark),
              ),
              const SizedBox(width: 8),
              _buildStatItem(
                label: 'Активні',
                value: '$active',
                icon: Icons.bolt,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 8),
              _buildStatItem(
                label: 'Виконано',
                value: '$done',
                icon: Icons.check_circle_outline,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              _buildStatItem(
                label: 'Обрані',
                value: '$favorites',
                icon: Icons.favorite,
                color: AppColors.favorite,
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
          color: AppColors.surface(isDark),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
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
              style: TextStyle(
                color: AppColors.textSecondary(isDark),
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
