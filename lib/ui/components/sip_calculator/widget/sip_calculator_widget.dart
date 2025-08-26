import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/sip_calculator/sip_request_model.dart';
import 'package:research_mantra_official/data/models/sip_calculator/sip_response_model.dart';
import 'package:research_mantra_official/providers/sip_calculator/sip_calculator_provider.dart';
import 'package:research_mantra_official/providers/sip_calculator/sip_calculator_state.dart';
import 'package:research_mantra_official/ui/components/button.dart';
import 'package:research_mantra_official/ui/components/sip_calculator/sip_results_screen.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class SipCalculatorWidget extends ConsumerStatefulWidget {
  const SipCalculatorWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SipCalculatorWidgetState();
}

class _SipCalculatorWidgetState extends ConsumerState<SipCalculatorWidget> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _sipAmountController = TextEditingController();
  final TextEditingController _investmentPeriodController =
      TextEditingController();
  final TextEditingController _annualReturnsController =
      TextEditingController();
  final TextEditingController _incrementalRateController =
      TextEditingController();
  //bool _adjustForInflation = false;
  bool _isLoading = false;

  double monthlyInvestment = 1000;
  int investmentPeriod = 25;
  bool isValueChanged = true;
  int incrementalRate = 10;
  int currentAge = 1;

  @override
  void dispose() {
    // _sipAmountControllerChanged.dispose();
    _sipAmountController.dispose();
    _investmentPeriodController.dispose();
    _annualReturnsController.dispose();
    _incrementalRateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _sipAmountController.text = monthlyInvestment.toStringAsFixed(0);
    _investmentPeriodController.text = investmentPeriod.toString();
    _annualReturnsController.text = investmentPeriod.toString();
    _incrementalRateController.text = incrementalRate.toString();
    super.initState();
  }

  // Function to convert the formatted string to double by removing commas
  double getFormattedAmount() {
    String rawValue =
        _sipAmountController.text.replaceAll(',', ''); // Remove commas
    double amount = double.tryParse(rawValue) ?? 0.0; // Convert to double
    return amount;
  }

  void _onCalculatePressed() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_isLoading) return; // Prevent multiple taps
      setState(() {
        _isLoading = true;
      });

      final request = SipRequestModel(
        monthlyInvestment: getFormattedAmount(),
        investmentPeriod: int.tryParse(_investmentPeriodController.text) ?? 0,
        annualReturns: double.tryParse(_annualReturnsController.text) ?? 0.0,
        incrementalRate: int.tryParse(_incrementalRateController.text) ?? 0,
      );

      // Validation check for empty or zero values
      if (request.monthlyInvestment == 0.0 ||
          request.investmentPeriod == 0 ||
          request.annualReturns == 0.0) {
        setState(() {
          _isLoading = false;
        });
        ToastUtils.showToast("Please fill all the fields correctly.", "");
        return;
      }

      try {
        await ref
            .read(sipCalculatorStateNotifierProvider.notifier)
            .postSipCalculator(request);
      } catch (error) {
        ToastUtils.showToast("Error occurred: $error", "");
      } finally {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ref.listen<SipCalculatorState>(sipCalculatorStateNotifierProvider,
        (previous, current) {
      if (!mounted) return;
      if (current.sipResponseModel != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SipResults(
              response: current.sipResponseModel ??
                  SipResponseModel(
                    expectedAmount: 0.0,
                    amountInvested: 0.0,
                    wealthGain: 0.0,
                    projectedSipReturnsTable: [],
                    inflationRate: 0.0,
                  ),
              incrementalRate: incrementalRate != 0,
            ),
          ),
        );
      } else if (current.error != null) {
        ToastUtils.showToast(
          current.error ??
              "Invalid input. Please check your details and try again.",
          "",
        );
      }
    });

    return Form(
      key: _formKey,
      child: Column(
        spacing: 8,
        children: [
          //  Monthly Investment
          _buildSlider(
            theme,
            "Monthly Investment Amount",
            '0',
            "Enter your monthly SIP amount",
            monthlyInvestment,
            1000.0,
            5000000.0,
            2500,
            (value) {
              setState(() {
                monthlyInvestment = value.toDouble();
              });
            },
            _sipAmountController,
            '₹',
          ),
          // Age
          buildAgeSlider(
            theme: Theme.of(context),
            title: "Investment Period",
            hintText: '10',
            subTitle: "Enter your investment period",
            value: currentAge,
            onValueChanged: (newAge) {
              setState(() {
                currentAge = newAge;
              });
            },
            controller: _investmentPeriodController,
          ),
          // Expected Annual Returns
          _buildSlider(
            theme,
            "Expected Annual Returns",
            '0',
            "Enter your expected annual returns",
            investmentPeriod,
            10.0,
            35.0,
            100,
            (value) {
              setState(() {
                investmentPeriod = value.toInt();
              });
            },
            _annualReturnsController,
            '%',
          ),
          // Incremental Rate
          _buildSlider(
            theme,
            "Annual Step up Rate",
            '0',
            "Enter Annual Step up Rate to Calculate",
            incrementalRate,
            10.0,
            20.0,
            50,
            (value) {
              setState(() {
                incrementalRate = value.toInt();
              });
            },
            _incrementalRateController,
            '%',
          ),

          const SizedBox(height: 16),

          // Calculate Button
          Button(
            text: 'Calculate',
            onPressed: _onCalculatePressed,
            backgroundColor: theme.indicatorColor,
            textColor: theme.primaryColor,
          ),
        ],
      ),
    );
  }

//widget to build slider
  Widget _buildSlider(theme, title, hintText, subTitle, num value, minValue,
      maxValue, divisions, Function(num) onValueChanged, controller, prefix) {
    // Function to check if value is below minValue
    bool isBelowMin = value < minValue;
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: theme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: theme.focusColor.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.focusColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.primaryColorDark,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 7,
                child: Slider(
                  value: value.toDouble(),
                  min: minValue,
                  max: maxValue,
                  activeColor:
                      isBelowMin ? theme.disabledColor : theme.indicatorColor,
                  divisions: divisions,
                  onChanged: (newValue) {
                    setState(() {
                      isValueChanged = true;
                      // Mark value as changed
                    });
                    onValueChanged(newValue);
                    controller.text =
                        newValue.toStringAsFixed(value is int ? 0 : 0);
                  },
                ),
              ),
              const SizedBox(width: 3),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.shadowColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(8),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: TextStyle(
                        color: theme.primaryColorDark,
                        fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      prefixIcon: prefix == "₹"
                          ? Text(
                              prefix,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            )
                          : Text(""),
                      prefixIconConstraints:
                          BoxConstraints(minWidth: 0, minHeight: 0),
                      suffixIcon: prefix != "₹"
                          ? Text(
                              prefix,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            )
                          : Text(""),
                      suffixIconConstraints:
                          BoxConstraints(minWidth: 0, minHeight: 0),
                    ),
                    onChanged: (value) {
                      if (value.isEmpty || value == " ") {
                        return; // Fixed Debug Console Issue
                      }
                      if (value.isNotEmpty) {
                        num newValue = num.parse(value);
                        if (newValue >= minValue && newValue <= maxValue) {
                          setState(() {
                            // Mark value as changed
                          });
                          onValueChanged(newValue);
                        }
                      }
                      // Prevent values above maxAge
                      num newValue = num.parse(value);
                      if (newValue > maxValue) {
                        controller.text = maxValue.toString();
                        controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length),
                        );
                        setState(() {
                          isValueChanged = true; // Mark value as changed
                        });
                        onValueChanged(maxValue);
                        return;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

// Widget to build investment period slider

  Widget buildAgeSlider({
    required ThemeData theme,
    required String title,
    required String hintText,
    required String subTitle,
    required int value,
    required Function(int) onValueChanged,
    required TextEditingController controller,
  }) {
    // Constants for age limits
    const int minAge = 0;
    const int maxAge = 60;

    // Function to check if age is valid
    bool isValidAge(int age) => age >= minAge && age <= maxAge;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: theme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: theme.focusColor.withValues(alpha: 0.4),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.focusColor,
            ),
          ),
          Text(
            subTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.primaryColorDark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 7,
                child: Slider(
                  value: value
                      .toDouble()
                      .clamp(minAge.toDouble(), maxAge.toDouble()),
                  min: minAge.toDouble(),
                  max: maxAge.toDouble(),
                  divisions: maxAge - minAge,
                  activeColor: isValidAge(value)
                      ? theme.indicatorColor
                      : theme.disabledColor,
                  onChanged: (newValue) {
                    int roundedValue = newValue.round();
                    onValueChanged(roundedValue);
                    controller.text = roundedValue.toString();
                    setState(() {
                      isValueChanged = true; // Mark value as changed
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.shadowColor),
                    borderRadius: BorderRadius.circular(8),
                    // color: theme.disabledColor,
                  ),
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2), // Limit to 2 digits
                    ],
                    style: TextStyle(
                        color: theme.primaryColorDark,
                        fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      suffixIcon: Text(
                        'years',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      suffixIconConstraints:
                          BoxConstraints(minWidth: 0, minHeight: 0),
                    ),
                    onChanged: (input) {
                      if (input.isEmpty) {
                        onValueChanged(0);
                        return;
                      }

                      int? newValue = int.tryParse(input);
                      if (newValue == null) {
                        return;
                      }
                      // Prevent values above maxAge
                      if (newValue > maxAge) {
                        controller.text = maxAge.toString();
                        controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length),
                        );
                        onValueChanged(maxAge);
                        return;
                      }

                      // Allow any value but show validation feedback
                      setState(() {
                        isValueChanged = true; // Mark value as changed
                      });
                      onValueChanged(newValue);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
