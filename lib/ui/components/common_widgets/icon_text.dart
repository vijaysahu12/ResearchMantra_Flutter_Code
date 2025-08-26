import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isFirstTextThenIcon;
  final TextStyle? style;
  final double iconSize;
  final Color? iconColor;
  final Color? textColor;
  final double textSize;
  final double sizedBox;
  final int? maxLines;
  final EdgeInsetsGeometry padding;
  final BoxDecoration? decoration;

  const IconText({
    super.key,
    required this.icon,
    required this.text,
    this.iconSize = 24.0,
    this.iconColor,
    this.textColor,
    this.textSize = 14.0,
    this.padding = const EdgeInsets.all(8.0),
    this.decoration,
    this.style,
    this.maxLines = 1,
    this.isFirstTextThenIcon = false,
    this.sizedBox = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTextStyle = style ??
        TextStyle(
          color: textColor ?? theme.primaryColorDark,
          fontSize: textSize,
        );
    final effectiveIconColor =
        iconColor ?? theme.primaryColorDark.withAlpha(150);
    return Container(
      padding: padding,
      decoration: decoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (!isFirstTextThenIcon)
            Icon(icon, size: iconSize, color: effectiveIconColor),
          if (!isFirstTextThenIcon) SizedBox(width: sizedBox),
          Flexible(
            child: Text(
              text,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: effectiveTextStyle,
            ),
          ),
          if (isFirstTextThenIcon) SizedBox(width: sizedBox),
          if (isFirstTextThenIcon)
            Icon(icon, size: iconSize, color: effectiveIconColor),
        ],
      ),
    );
  }
}
