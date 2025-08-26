import 'package:flutter/material.dart';
import 'package:research_mantra_official/data/models/risk_reward_calculator/risk_reward_response_model.dart';
import 'package:research_mantra_official/ui/components/risk_reward_calculator/info_row_widget.dart';
import 'package:research_mantra_official/ui/components/risk_reward_calculator/widgets/colors/app_colors.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class RiskRewardSection extends StatelessWidget {
  final RiskRewardResponseModel responseModel;

  const RiskRewardSection({
    super.key,
    required this.responseModel,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = CAppColors.border(context);
    final cardColor = CAppColors.card(context).withAlpha(120);
    final titleColor = CAppColors.title(context);
    final subtitleColor = CAppColors.subtitle(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(16),
        color: cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calculate Your Risk-Reward',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: titleColor,
              fontSize: 18,
              fontFamily: fontFamily,
            ),
          ),
          const SizedBox(height: 16),
          InfoRowWidget(
            label: 'Target 1',
            value: '₹${responseModel.profitAndLoss}',
            valueColor: CAppColors.green(context),
            backgroundColor: cardColor,
            titleColor: titleColor,
          ),
          const SizedBox(height: 16),
          InfoRowWidget(
            label: 'Exit',
            value: '₹${responseModel.targetPrice}',
            valueColor: CAppColors.red(context),
            backgroundColor: cardColor,
            titleColor: titleColor,
          ),
          const SizedBox(height: 16),
          _buildRiskRewardRatioCard(
              context, responseModel, titleColor, subtitleColor),
        ],
      ),
    );
  }

  Widget _buildRiskRewardRatioCard(
    BuildContext context,
    RiskRewardResponseModel model,
    Color titleColor,
    Color subtitleColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: CAppColors.border(context),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            CAppColors.button(context).withValues(alpha: 190),
            CAppColors.red(context).withValues(alpha: 210),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Risk-Reward Ratio',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: titleColor.withAlpha(200),
                fontSize: 14,
                fontFamily: fontFamily,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${model.riskRewardRatio}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: subtitleColor,
                fontSize: 32,
                fontFamily: fontFamily,
              ),
            )
          ],
        ),
      ),
    );
  }
}
