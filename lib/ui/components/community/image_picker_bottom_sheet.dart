import 'package:flutter/material.dart';

class ImagePickerOptions extends StatelessWidget {
  final ThemeData theme;
  final Future<void> Function() onCameraTap;
  final Future<void> Function() onGalleryTap;

  const ImagePickerOptions({
    super.key,
    required this.theme,
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: theme.appBarTheme.backgroundColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildIconButton(
            icon: Icons.camera_alt_outlined,
            onTap: onCameraTap,
            label: 'Camera',
            theme: theme,
          ),
          buildIconButton(
            icon: Icons.photo_library_outlined,
            onTap: onGalleryTap,
            label: 'Gallery',
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget buildIconButton({
    required IconData icon,
    required Future<void> Function() onTap,
    required String label,
    required ThemeData theme,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: theme.shadowColor,
              width: 1,
            ),
          ),
          child: GestureDetector(
            onTap: () => onTap(),
            child: Icon(
              icon,
              size: 25,
              color: theme.primaryColorDark,
            ),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: theme.primaryColorDark,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
