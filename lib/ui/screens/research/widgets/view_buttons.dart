import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class ViewButton extends StatelessWidget {
  final void Function()? onTap;
  final Color? buttonColor;
  final String buttonString;
  const ViewButton({
    super.key,
    required this.buttonString,
    required this.onTap,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: buttonColor ?? Theme.of(context).shadowColor),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              buttonString,
              style: TextStyle(
                color: buttonColor == null
                    ? Theme.of(context).primaryColorDark
                    : theme.floatingActionButtonTheme.foregroundColor,
                fontFamily: fontFamily,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
