import 'package:flutter/material.dart';

class TaskInfoCard extends StatelessWidget {
  final String description;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const TaskInfoCard({
    super.key,
    required this.description,
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
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Text(
        description,
        style: TextStyle(
          fontSize: 15,
          height: 1.5,
          color: textColor,
        ),
        maxLines: 6,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
