import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:research_mantra_official/services/url_launcher_helper.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart'; // if you store fontFamily separately

class DevelopedByText extends StatelessWidget {
  const DevelopedByText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Developed by ",
            style: TextStyle(
              color: theme.primaryColorDark,
              fontFamily: fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: "@codeline.in",
            style: TextStyle(
              color: theme.indicatorColor,
              fontFamily: fontFamily,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                UrlLauncherHelper.launchUrlIfPossible("https://codeline.in/");
              },
          ),
        ],
      ),
    );
  }
}

  // Widget _buildForDevelopedText(theme) {
  //   return GestureDetector(
  //     onTap: () {
  //       UrlLauncherHelper.launchUrlIfPossible("https://codeline.in/");
  //     },
  //     child: Text(
  //       "Innovated by CodeLine Tech",
  //       style: TextStyle(
  //         color: theme.primaryColorDark,
  //         fontFamily: fontFamily,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //   );
  // }
