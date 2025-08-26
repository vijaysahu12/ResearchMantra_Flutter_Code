import 'package:flutter/material.dart';

class PopUpButton extends StatelessWidget {
  final String buttonText;
  final void Function()? onTap;
  final Color buttonColor;
  const PopUpButton(
      {super.key,
      required this.buttonText,
      this.onTap,
      required this.buttonColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                buttonText,
                style: TextStyle(
                  color: theme.floatingActionButtonTheme.foregroundColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
