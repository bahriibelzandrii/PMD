import 'package:flutter/material.dart';

class PrioritySwitchCard extends StatelessWidget {
  final bool isUrgent;
  final ValueChanged<bool> onChanged;

  const PrioritySwitchCard({
    super.key,
    required this.isUrgent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF15181F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF2A3142), width: 1),
      ),
      child: SwitchListTile(
        title: const Text(
          'Терміновий статус',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          isUrgent
              ? 'Активовано бейдж, змінено стиль та підсвічування'
              : 'Увімкніть для виділення терміновості завдання',
          style: TextStyle(
            fontSize: 12,
            color: isUrgent ? const Color(0xFFFF8B8B) : const Color(0xFF8B949E),
          ),
        ),
        secondary: Icon(
          Icons.bolt,
          color: isUrgent ? const Color(0xFFFF6B6B) : const Color(0xFF8B949E),
        ),
        activeThumbColor: const Color(0xFFD4FF00),
        activeTrackColor: const Color(0xFFD4FF00).withValues(alpha: 0.3),
        inactiveThumbColor: const Color(0xFF8B949E),
        inactiveTrackColor: const Color(0xFF1F2430),
        value: isUrgent,
        onChanged: onChanged,
      ),
    );
  }
}
