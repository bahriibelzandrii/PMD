import 'package:flutter/material.dart';

class ImageBannerCard extends StatelessWidget {
  final IconData icon;
  final double height;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;

  const ImageBannerCard({
    super.key,
    required this.icon,
    required this.height,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Center(child: Icon(icon, size: 72, color: iconColor)),
    );
  }
}
