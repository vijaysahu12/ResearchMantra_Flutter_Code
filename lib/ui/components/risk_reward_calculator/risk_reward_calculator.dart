import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/risk_reward_calculator/risk_reward_request_model.dart';
import 'package:research_mantra_official/providers/risk_reward/risk_reward_calculator_provider.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/components/risk_reward_calculator/info_row_widget.dart';
import 'package:research_mantra_official/ui/components/risk_reward_calculator/result_section_card.dart';
import 'package:research_mantra_official/ui/components/risk_reward_calculator/risk_reward_input.dart';
import 'package:research_mantra_official/ui/components/risk_reward_calculator/risk_reward_output.dart';
import 'package:research_mantra_official/ui/components/risk_reward_calculator/widgets/colors/app_colors.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class RiskRewardCalculator extends ConsumerStatefulWidget {
  const RiskRewardCalculator({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RiskRewardCalculatorState();
}

class _RiskRewardCalculatorState extends ConsumerState<RiskRewardCalculator> {
  bool _showOutput = false;
  bool _isBuySelected = true;

  late final FocusNode _textFieldFocusNode;

  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _entryPriceController;
  late final TextEditingController _targetPriceController;
  late final TextEditingController _stopLossController;
  late final TextEditingController _capitalAmountController;
  late final TextEditingController _riskPercentageController;

  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _entryPriceController = TextEditingController();
    _targetPriceController = TextEditingController();
    _stopLossController = TextEditingController();
    _capitalAmountController = TextEditingController();
    _riskPercentageController = TextEditingController();

    _controller = ScrollController();
    _textFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _entryPriceController.dispose();
    _targetPriceController.dispose();
    _stopLossController.dispose();
    _capitalAmountController.dispose();
    _riskPercentageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _calculateRiskReward() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _showOutput = true;
      });

      final request = RiskRewardRequestModel(
        riskFactor: double.tryParse(_riskPercentageController.text) ?? 0.0,
        entryPrice: double.tryParse(_entryPriceController.text) ?? 0.0,
        targetPrice: double.tryParse(_targetPriceController.text) ?? 0.0,
        stopLoss: double.tryParse(_stopLossController.text) ?? 0.0,
        capitalAmount: double.tryParse(_capitalAmountController.text) ?? 0.0,
        isBuy: _isBuySelected,
      );
      // Validation check for empty or zero values
      if (request.entryPrice == 0.0 ||
          request.targetPrice == 0.0 ||
          request.capitalAmount == 0.0 ||
          request.stopLoss == 0.0) {
        setState(() {
          _showOutput = false;
        });
        ToastUtils.showToast("Please fill all the fields correctly.", "");
        return;
      }
      try {
        await ref
            .read(riskRewardStateNotifierProvider.notifier)
            .postRiskRewardCalculator(request);
      } catch (error) {
        ToastUtils.showToast("Error occurred: $error", "");
      }
    }
  }

  // Helper method to toggle between Buy and Sell
  void _toggleTradeDirection(bool isBuy) {
    if (_isBuySelected != isBuy) {
      setState(() {
        _isBuySelected = isBuy;
        // Clear the fields to prevent validation errors when switching

        _targetPriceController.clear();
        _stopLossController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final riskRewardData = ref.watch(riskRewardStateNotifierProvider);

    ref.listen(riskRewardStateNotifierProvider, (previous, next) {
      if (next.riskRewardResponseModel != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _controller.animateTo(
            _controller.position.maxScrollExtent,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      }
      if (next.error != null) {
        ToastUtils.showToast(next.error!, "");
      }
    });

    ///TODO: make resuable widgets
    return SafeArea(
      top: false,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor:
              // CAppColors.bg(context),
              theme.primaryColor,
          appBar: CommonAppBarWithBackButton(
            appBarText: "Risk Calculator",
            handleBackButton: () {
              Navigator.pop(context);

              ref
                  .read(riskRewardStateNotifierProvider.notifier)
                  .emptyRiskRewardCalculator();
            },
          ),
          body: SingleChildScrollView(
            controller: _controller,
            child: Column(
              children: [
                //Input Container
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: CAppColors.border(context), width: 1),
                      borderRadius: BorderRadius.circular(16),
                      color: CAppColors.card(context).withAlpha(120),
                    ),
                    child: RiskRewardInput(
                      formKey: _formKey,
                      entryPriceController: _entryPriceController,
                      targetPriceController: _targetPriceController,
                      stopLossController: _stopLossController,
                      capitalAmountController: _capitalAmountController,
                      riskPercentageController: _riskPercentageController,
                      isBuySelected: _isBuySelected,
                      onToggleTradeDirection: _toggleTradeDirection,
                    ),
                  ),
                ),
                //Output Section
                if (riskRewardData.isLoading)
                  CommonLoaderGif()
                else if (riskRewardData.riskRewardResponseModel != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ResultSectionCard(
                              title: 'Calculate Your Risk Amount',
                              content: InfoRowWidget(
                                label: 'Risk Amount',
                                value:
                                    '₹${riskRewardData.riskRewardResponseModel?.riskAmount?.toStringAsFixed(0)}',
                                valueColor: CAppColors.subtitle(context),
                                backgroundColor:
                                    CAppColors.button(context).withAlpha(20),
                                labelFontSize: 16,
                                valueFontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        ResultSectionCard(
                          title: 'Calculate Your Quantity',
                          content: InfoRowWidget(
                            label: 'Recommended Quantity',
                            value:
                                '${riskRewardData.riskRewardResponseModel?.recommendedQuantity?.toStringAsFixed(0)}',
                            valueColor: CAppColors.subtitle(context),
                            backgroundColor:
                                CAppColors.button(context).withAlpha(20),
                            labelFontSize: 16,
                            valueFontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 18),
                        if (riskRewardData.riskRewardResponseModel != null)
                          RiskRewardSection(
                            responseModel:
                                riskRewardData.riskRewardResponseModel!,
                          ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
            child: ElevatedButton(
              onPressed: () {
                _calculateRiskReward();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CAppColors.button(context),
                disabledBackgroundColor:
                    CAppColors.button(context).withAlpha(160),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Calculate',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: fontFamily,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
