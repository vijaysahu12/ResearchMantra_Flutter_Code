import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final String assetPath;
  final double height;
  final VoidCallback onTap;

  const ImageButton({
    super.key,
    required this.assetPath,
    required this.onTap,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          height: height,
          width: double.infinity, // ensures it expands properly inside Expanded
        ),
      ),
    );
  }
}
