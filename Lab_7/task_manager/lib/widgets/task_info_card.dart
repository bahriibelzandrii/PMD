import 'package:flutter/material.dart';

class TaskInfoCard extends StatelessWidget {
  final String description;
  final bool isUrgent;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const TaskInfoCard({
    super.key,
    required this.description,
    required this.isUrgent,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUrgent ? const Color(0xFF26181E) : backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUrgent ? const Color(0xFFFF6B6B) : borderColor,
          width: isUrgent ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isUrgent ? Colors.white : textColor,
              fontWeight: isUrgent ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
          if (isUrgent) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B6B).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.notification_important_rounded,
                    color: Color(0xFFFF6B6B),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Термінове завдання: вимагає першочергового закриття!',
                      style: TextStyle(
                        color: Color(0xFFFF8B8B),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
