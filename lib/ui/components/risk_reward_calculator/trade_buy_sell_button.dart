import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/components/risk_reward_calculator/widgets/colors/app_colors.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class TradeDirectionToggle extends StatelessWidget {
  final bool isBuySelected;
  final Function(bool) onToggle;

  const TradeDirectionToggle({
    super.key,
    required this.isBuySelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Trade Direction",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: CAppColors.label(context),
            fontFamily: fontFamily,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => onToggle(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBuySelected
                      ? CAppColors.green(context)
                      : CAppColors.card(context),
                  foregroundColor: isBuySelected
                      ? Colors.white
                      : CAppColors.subtitle(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isBuySelected
                          ? Colors.transparent
                          : CAppColors.border(context),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  "BUY",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () => onToggle(false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: !isBuySelected
                      ? CAppColors.red(context)
                      : CAppColors.card(context),
                  foregroundColor: !isBuySelected
                      ? Colors.white
                      : CAppColors.subtitle(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: !isBuySelected
                          ? Colors.transparent
                          : CAppColors.border(context),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  "SELL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}