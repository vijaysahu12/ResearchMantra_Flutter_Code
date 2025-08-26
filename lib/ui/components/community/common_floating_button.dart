import 'package:flutter/material.dart';

class CommonFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CommonFloatingButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton(
      backgroundColor: theme.secondaryHeaderColor,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      mini: true,
      child: Icon(
        Icons.add,
        size: 40,
        color: theme.floatingActionButtonTheme.backgroundColor,
      ),
    );
  }
}
