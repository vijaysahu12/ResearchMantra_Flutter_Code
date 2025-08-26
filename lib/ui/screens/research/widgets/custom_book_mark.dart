import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class CustombookMark extends StatelessWidget {
  final String bookMarkName;
  final Color bookMarkColor;
  final BorderRadiusGeometry? borderRadius;
  final TextStyle? bookMarkTextStyle;
  const CustombookMark(
      {super.key,
      required this.bookMarkName,
      required this.bookMarkColor,
      this.borderRadius,
      this.bookMarkTextStyle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: borderRadius ??
              const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                topRight: Radius.circular(5),
              ),
          color: bookMarkColor),
      padding: const EdgeInsets.only(left: 15.0, right: 15, top: 5, bottom: 5),
      child: Text(
        bookMarkName,
        style: bookMarkTextStyle ??
            TextStyle(
              color: theme.primaryColor,
              fontSize: 10,
              fontFamily: fontFamily,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
