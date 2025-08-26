import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
 
class InflationContainer extends StatelessWidget {
  const InflationContainer({
    super.key,
    required this.theme,
    required this.planName,
  });
 
  final ThemeData theme;
  final String planName;
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:4.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.shadowColor, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColorDark.withValues(alpha: 0.3),
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                planName,
                style: TextStyle(
                  color: theme.primaryColorDark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                  fontFamily: fontFamily,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              decoration: BoxDecoration(
                color: theme.appBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColorDark.withValues(alpha: 0.3),
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                futureGrowthImagePath,
                scale: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}