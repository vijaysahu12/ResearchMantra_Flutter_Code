import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class CommonTextSpan extends StatelessWidget {
  final String mandatoryFieldName;
  const CommonTextSpan({super.key, required this.mandatoryFieldName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.height;
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: mandatoryFieldName,
          style: TextStyle(
              fontSize: fontSize * 0.014,
              fontWeight: FontWeight.w600,
              color: theme.primaryColorDark,
              fontFamily: fontFamily),
        ),
        TextSpan(
          text: ' *',
          style: TextStyle(
              fontSize: fontSize * 0.013,
              fontWeight: FontWeight.w600,
              color: theme.disabledColor,
              fontFamily: fontFamily),
        ),
      ]),
    );
  }
}
