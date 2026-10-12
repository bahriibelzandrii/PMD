import 'package:flutter/material.dart';

class ActionButtonsRow extends StatelessWidget {
  final int executionCount;
  final VoidCallback onExecute;
  final VoidCallback onReset;

  const ActionButtonsRow({
    super.key,
    required this.executionCount,
    required this.onExecute,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF15181F),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF2A3142), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.trending_up, color: Color(0xFFD4FF00), size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Кількість виконань:',
                    style: TextStyle(color: Color(0xFF8B949E), fontSize: 14),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4FF00).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD4FF00), width: 1),
                ),
                child: Text(
                  '$executionCount',
                  style: const TextStyle(
                    color: Color(0xFFD4FF00),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: ElevatedButton.icon(
                onPressed: onExecute,
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: Text('Виконати (+1)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4FF00),
                  foregroundColor: const Color(0xFF0D0F13),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: OutlinedButton.icon(
                onPressed: executionCount > 0 ? onReset : null,
                icon: const Icon(Icons.restart_alt, size: 18),
                label: const Text('Скинути'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  disabledForegroundColor: const Color(0xFF555F70),
                  side: BorderSide(
                    color: executionCount > 0
                        ? const Color(0xFF2A3142)
                        : const Color(0xFF1F2430),
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
