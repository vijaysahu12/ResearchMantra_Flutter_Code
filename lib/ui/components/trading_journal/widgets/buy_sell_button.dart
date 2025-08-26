import 'package:flutter/material.dart';
//import 'package:research_mantra_official/ui/components/risk_reward_calculator/widgets/colors/app_colors.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class BuySellButton extends StatelessWidget {
  final bool isBuySelected;
  final ThemeData theme;
  final Function(bool) onToggle;

  const BuySellButton({
    super.key,
    required this.theme,
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
            color: theme.primaryColorDark, // CAppColors.label(context),
            fontFamily: fontFamily,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            _buildButton(
                label: "BUY",
                isSelected: isBuySelected,
                onPressed: () => onToggle(true),
                selectedColor: theme.secondaryHeaderColor,
                unselectedColor: theme.shadowColor),
            const SizedBox(width: 10),
            _buildButton(
                label: "SELL",
                isSelected: !isBuySelected,
                onPressed: () => onToggle(false),
                selectedColor: theme.disabledColor,
                unselectedColor: theme.shadowColor),
          ],
        ),
      ],
    );
  }

  Widget _buildButton(
      {required String label,
      required bool isSelected,
      required VoidCallback onPressed,
      required Color selectedColor,
      required Color unselectedColor}) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? selectedColor : unselectedColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected ? Colors.transparent : unselectedColor,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: fontFamily,
          ),
        ),
      ),
    );
  }
}
