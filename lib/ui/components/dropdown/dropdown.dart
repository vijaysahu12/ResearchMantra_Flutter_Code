import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class DropdownMenuItemWidget extends StatelessWidget {
  final String value;
  final Function(String) onSelect;
  final String displayText;

  const DropdownMenuItemWidget(
      {super.key,
      required this.value,
      required this.onSelect,
      required this.displayText});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.height;

    // Truncate text if longer than 15 characters
    String truncatedText = displayText.length > 16
        ? '${displayText.substring(0, 16)}...'
        : displayText;

    return InkWell(
      onTap: () {
        onSelect(value);
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Text(
          truncatedText,
          maxLines: 2,
          style: TextStyle(
              fontSize: fontSize * 0.015,
              color: theme.primaryColorDark,
              fontFamily: fontFamily),
        ),
      ),
    );
  }
}
