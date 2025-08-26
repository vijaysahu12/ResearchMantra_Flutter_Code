import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/assets.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final bool? fromtable;

  const GradientButton({super.key, required this.text, this.fromtable});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(
        top: 12.0,
        // bottom: 8,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
            // border: Border.all(color: theme.focusColor.withOpacity(0.4)),
            color: theme.primaryColor,
            boxShadow: [
              BoxShadow(
                color: theme.focusColor.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
            borderRadius: fromtable == true
                ? const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  )
                : BorderRadius.circular(8)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 225, 7, 7),
                shape: BoxShape.circle,
                border: Border.all(color: theme.primaryColor),
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xffAD0000),
                    Color(0xffFF2929),
                  ],
                ),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    kingResearchIcon,
                    // stockLogo,
                    scale: 5,
                    fit: BoxFit.cover,
                  )),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              text,
              style: TextStyle(
                color: theme.primaryColorDark,
                //  Color.fromARGB(255, 238, 30, 30),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
