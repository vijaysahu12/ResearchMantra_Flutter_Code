import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/assets.dart';

import 'package:research_mantra_official/ui/themes/text_styles.dart';

// Empty content screen widget
class NoContentWidget extends StatelessWidget {
  final String message;
  const NoContentWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              scale: 5,
              noDataImagePath,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.focusColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: fontFamily,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
