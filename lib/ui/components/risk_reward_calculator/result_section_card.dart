import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/components/risk_reward_calculator/widgets/colors/app_colors.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class ResultSectionCard extends StatelessWidget {
  final String title;
  final Widget content;
  final EdgeInsets? padding;

  const ResultSectionCard({
    super.key,
    required this.title,
    required this.content,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = CAppColors.border(context);
    final cardColor = CAppColors.card(context).withAlpha(120);
    final titleColor = CAppColors.title(context);

    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(16),
        color: cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: fontFamily,
            ).copyWith(color: titleColor),
          ),
          const SizedBox(height: 18),
          content,
        ],
      ),
    );
  }
}