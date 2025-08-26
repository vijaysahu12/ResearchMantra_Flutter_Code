import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/ui/components/risk_reward_calculator/widgets/colors/app_colors.dart';
import 'package:research_mantra_official/ui/screens/home/widgets/animated_arrow_button.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class GradientContainer extends StatefulWidget {
  const GradientContainer({super.key});

  @override
  State<GradientContainer> createState() => _GradientContainerState();
}

class _GradientContainerState extends State<GradientContainer> {
  @override
  Widget build(BuildContext context) {
    return const FinancialCard();
  }
}

class FinancialCard extends StatelessWidget {
  const FinancialCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // Background with animated ripple
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        // Actual content
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: theme.shadowColor, width: 2.0),
            gradient: LinearGradient(
              colors: CAppColors.banners(context),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    futurePlansTitleText,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColorDark,
                      fontFamily: fontFamily,
                    ),
                  ),
                ],
              ),
              // Arrow button (no ripple here anymore)
              const AnimatedArrowButton(),
            ],
          ),
        ),
      ],
    );
  }
}
