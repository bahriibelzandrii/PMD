import 'package:flutter/material.dart';

class TaskHeader extends StatelessWidget {
  final String title;
  final bool isFavorite;
  final bool isUrgent;
  final VoidCallback onFavoriteToggle;

  const TaskHeader({
    super.key,
    required this.title,
    required this.isFavorite,
    required this.isUrgent,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isUrgent ? const Color(0xFFFF6B6B) : Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
              if (isUrgent) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFFFF6B6B),
                      width: 1,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFFF6B6B),
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'ВИСОКИЙ ПРІОРИТЕТ',
                        style: TextStyle(
                          color: Color(0xFFFF6B6B),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        IconButton(
          tooltip: isFavorite ? 'Видалити з обраного' : 'Додати в обране',
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite
                ? const Color(0xFFFF4B6E)
                : const Color(0xFF8B949E),
            size: 28,
          ),
          onPressed: onFavoriteToggle,
        ),
      ],
    );
  }
}
