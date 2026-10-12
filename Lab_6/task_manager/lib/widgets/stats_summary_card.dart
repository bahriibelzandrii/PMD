import 'package:flutter/material.dart';

/// Віджет для відображення статистики завдань на основі `Map<String, int>`
class StatsSummaryCard extends StatelessWidget {
  final Map<String, int> stats;

  const StatsSummaryCard({super.key, required this.stats});

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
        border: Border.all(color: const Color(0xFF2A3142), width: 1),
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
                'Статистика завдань',
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
