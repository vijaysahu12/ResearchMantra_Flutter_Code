import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:research_mantra_official/ui/components/risk_reward_calculator/trade_buy_sell_button.dart';
import 'package:research_mantra_official/ui/components/risk_reward_calculator/widgets/colors/app_colors.dart';
import 'package:research_mantra_official/ui/components/risk_reward_calculator/widgets/textfiled_input.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/validator.dart';

class RiskRewardInput extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController entryPriceController;
  final TextEditingController targetPriceController;
  final TextEditingController stopLossController;
  final TextEditingController capitalAmountController;
  final TextEditingController riskPercentageController;
  final bool isBuySelected;
  final Function(bool) onToggleTradeDirection;

  const RiskRewardInput({
    super.key,
    required this.formKey,
    required this.entryPriceController,
    required this.targetPriceController,
    required this.stopLossController,
    required this.capitalAmountController,
    required this.riskPercentageController,
    required this.isBuySelected,
    required this.onToggleTradeDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trade Details',
            style: TextStyle(
                color: CAppColors.subtitle(context),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily),
          ),
          const SizedBox(height:20),
            // Trade Direction Toggle
          TradeDirectionToggle(
            isBuySelected: isBuySelected,
            onToggle: onToggleTradeDirection,
          ),
          const SizedBox(height: 16),

          // Capital Amount Input
          RiskRewardAppInputField(
            label: "Capital Amount",
            hint: 'Ex:- 2,000',
            controller: capitalAmountController,
            prefixText: '₹',
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.digitsOnly
            ],
            validator: Validator.validateCapitalAmount,
          ),

          const SizedBox(width: 10),

          // Risk % per Trade Input
          RiskRewardAppInputField(
            label: "Risk % per Trade",
            labelSize: 12,
            hint: 'Ex:- 2%',
            controller: riskPercentageController,
            suffixText: '%',
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(2),
              FilteringTextInputFormatter.digitsOnly
            ],
            validator: Validator.validateRiskPercentage,
          ),

          // Entry Price Input
          RiskRewardAppInputField(
            label: "Entry Price",
            hint: 'Ex:- 80',
            controller: entryPriceController,
            prefixText: '₹',
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(8),
              FilteringTextInputFormatter.digitsOnly
            ],
            validator: Validator.validateEntryPrice,
          ),

          const SizedBox(height: 10),

          // Stop Loss Price Input
          RiskRewardAppInputField(
            label: "Stop Loss Price",
            hint: 'Ex:- 70',
            prefixText: '₹',
            controller: stopLossController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(8),
              FilteringTextInputFormatter.digitsOnly
            ],
            validator: (value) => Validator.validateStopLoss(value, isBuySelected, entryPriceController.text),
          ),

          // Target Price Input
          RiskRewardAppInputField(
            label: "Target Price",
            hint: 'Ex:- 90',
            controller: targetPriceController,
            prefixText: '₹',
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(8),
              FilteringTextInputFormatter.digitsOnly
            ],
            validator: (value) => Validator.validateTargetPrice(value, isBuySelected , entryPriceController.text),
          ),
        ],
      ),
    );
  }


}