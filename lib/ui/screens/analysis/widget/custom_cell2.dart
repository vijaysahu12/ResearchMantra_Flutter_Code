import 'package:flutter/material.dart';

Widget customCell2({
  required String text,
  double? width,
  required BuildContext context,
  // Color? color,

  String? changeText,
  Color? textColor,
  EdgeInsetsGeometry? padding,
  bool? isHead,
}) {
  // Check if the text represents a numeric value or a percentage
  final isNumeric = double.tryParse(text.replaceAll('%', '')) != null;
  final theme = Theme.of(context);
  // Determine text color based on the value
  Color? computedTextColor;
  if (isNumeric && changeText != null) {
    final number = double.parse(changeText.replaceAll('%', ''));
    if (number < 0) {
      computedTextColor = theme.disabledColor; // Negative values
    } else {
      computedTextColor = theme.secondaryHeaderColor;

      // Positive values
    }
  }

  return Container(
    color: theme.primaryColor,
    width: width ?? MediaQuery.of(context).size.width / 4,
    padding: padding ?? const EdgeInsets.only(bottom: 12, top: 12, left: 10),
    child: Text(text,
        overflow: TextOverflow.ellipsis,
        style: isHead == null
            ? TextStyle(
                fontSize: 11,
                color: computedTextColor ??
                    textColor ??
                    Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.bold,
              )
            : TextStyle(
                fontSize: 12,
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.bold)),
  );
}
