import 'package:flutter/material.dart';

class TaskHeader extends StatelessWidget {
  final String title;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const TaskHeader({
    super.key,
    required this.title,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.redAccent : Colors.grey,
          ),
          onPressed: onFavoriteToggle,
        ),
      ],
    );
  }
}
