import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

//Common box shadow button
class CommonBoxShadowButtons extends StatelessWidget {
  final String buttonText;
  final IconData iconTextName;
  final Function handleNavigateToScreen;

  const CommonBoxShadowButtons(
      {super.key,
      required this.buttonText,
      required this.iconTextName,
      required this.handleNavigateToScreen});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    return Expanded(
      child: GestureDetector(
        onTap: () => handleNavigateToScreen(),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: theme.primaryColor,
          ),
          child: Row(
            children: [
              Icon(
                iconTextName,
                color: theme.primaryColorDark,
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                buttonText,
                style: TextStyle(
                  color: theme.primaryColorDark,
                  fontFamily: fontFamily,
                  fontSize: height * 0.015,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.primaryColorDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
