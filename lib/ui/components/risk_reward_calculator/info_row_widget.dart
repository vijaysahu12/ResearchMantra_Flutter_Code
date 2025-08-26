import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/components/risk_reward_calculator/widgets/colors/app_colors.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class InfoRowWidget extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final Color? backgroundColor;
  final Color? titleColor;
  final double labelFontSize;
  final double valueFontSize;

  const InfoRowWidget({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
    this.backgroundColor,
    this.titleColor,
    this.labelFontSize = 16,
    this.valueFontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? CAppColors.card(context);
    final txtColor = titleColor ?? CAppColors.title(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: CAppColors.border(context), width: 1),
        borderRadius: BorderRadius.circular(8),
        color: bgColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: txtColor,
              fontSize: labelFontSize,
              fontFamily: fontFamily,
            ),
          ),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: valueColor,
                fontSize: valueFontSize,
                fontFamily: fontFamily,
              ),
            ),
          )
        ],
      ),
    );
  }
}