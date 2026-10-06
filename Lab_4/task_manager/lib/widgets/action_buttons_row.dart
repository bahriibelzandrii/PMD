import 'package:flutter/material.dart';

class ActionButtonsRow extends StatelessWidget {
  final String primaryText;
  final String secondaryText;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;

  const ActionButtonsRow({
    super.key,
    required this.primaryText,
    required this.secondaryText,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPrimaryPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4FF00),
              foregroundColor: const Color(0xFF0D0F13),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Text(primaryText),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: onSecondaryPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(
                color: Color(0xFF2A3142),
                width: 1.5,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Text(secondaryText),
          ),
        ),
      ],
    );
  }
}
