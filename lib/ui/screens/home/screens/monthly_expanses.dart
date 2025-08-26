import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/providers/calculate_future/calculate_future_provider.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/button.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';

import 'package:research_mantra_official/ui/screens/home/screens/selection_screen.dart';

import 'package:research_mantra_official/utils/toast_utils.dart';
import 'package:research_mantra_official/utils/utils.dart';

class MonthlyExpanses extends ConsumerStatefulWidget {
  final String selectedPlans;

  const MonthlyExpanses({
    super.key,
    required this.selectedPlans,
  });

  @override
  ConsumerState<MonthlyExpanses> createState() => _MonthlyExpansesState();
}

class _MonthlyExpansesState extends ConsumerState<MonthlyExpanses> {
  final TextEditingController currentInvestInterstRatePercentageController =
      TextEditingController();

  final TextEditingController currentAgeController = TextEditingController();
  final TextEditingController monthlyExpenseController =
      TextEditingController();
  final TextEditingController currentInvestmentController =
      TextEditingController();
  int currentAge = 25;
  double monthlyExpense = 5000;
  int currentInvestMent = 0;
  double inflationRate = 6.0;
  double currentInvestInterstRatePercentage = 12.0;
  bool isCalledApi = false;
  bool isValueChanged = true;

  @override
  void initState() {
    super.initState();
    currentInvestInterstRatePercentageController.text =
        currentInvestInterstRatePercentage.toStringAsFixed(0);
    currentAgeController.text = currentAge.toStringAsFixed(0);
    monthlyExpenseController.text = monthlyExpense.toStringAsFixed(0);
    currentInvestmentController.text = currentInvestMent.toStringAsFixed(0);
  }

  @override
  void dispose() {
    currentInvestInterstRatePercentageController.dispose();
    currentAgeController.dispose();
    monthlyExpenseController.dispose();
    currentInvestmentController.dispose();
    super.dispose();
  }

  Map<String, double> dataMap = {
    "Monthly WithDraw Amount": 70,
    "Inflation Rate": 10,
    "Time Frame": 20,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: widget.selectedPlans,
        handleBackButton: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Age Section

              buildAgeSlider(
                theme: Theme.of(context),
                title: "Current Age",
                value: currentAge,
                onValueChanged: (newAge) {
                  setState(() {
                    currentAge = newAge;
                  });
                },
                controller: currentAgeController,
              ),
              const SizedBox(height: 20),
              // Retirement Age Row (Static)
              Container(
                padding: const EdgeInsets.all(10),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Retirement Age',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '60 years',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryColorDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Monthly Expenses Section
              _buildSlider(
                theme,
                'Current Monthly Expenses',
                monthlyExpense,
                5000.0,
                1000000.0,
                199,
                (value) {
                  setState(() {
                    monthlyExpense = value.toDouble();
                  });
                },
                monthlyExpenseController,
                '₹',
              ),
              if (isValueChanged)
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Button(
                          text: "Generate Future Expense",
                          onPressed: () => navigateToSectionScreen(),
                          backgroundColor: theme.indicatorColor,
                          textColor:
                              theme.floatingActionButtonTheme.foregroundColor,
                        ),
                      )
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              if (isCalledApi) _buildForRetirementData(theme),
              if (isCalledApi && !isValueChanged)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.only(bottom: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: Button(
                            text: "Get Options",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SelectOptionsScreen(
                                    currentAge: currentAge,
                                    retirementAge: 60,
                                    currentMonthlyExpense: monthlyExpense,
                                    inflationRate: inflationRate,
                                    anyCurrentInvestment: currentInvestMent,
                                    currentInvestInterstRatePercentage:
                                        currentInvestInterstRatePercentage,
                                  ),
                                ),
                              );
                            },
                            backgroundColor: theme.indicatorColor,
                            textColor: theme
                                .floatingActionButtonTheme.foregroundColor),
                      )
                    ],
                  ),
                )
            ],
          )),
    );
  }

  getFuturePlansData(
      currentAge, retirementAge, currentMonthlyExpense, inflationRate) async {
    ref
        .read(getCalculateFuturePlansDataProvider.notifier)
        .getCalculateFuturePlansData(
          currentAge,
          retirementAge,
          currentMonthlyExpense,
          inflationRate,
          0, //CurrentInvestment
          0, // Interst Rate
        );
  }

  //Slider
  Widget _buildSlider(theme, title, num value, minValue, maxValue, divisions,
      Function(num) onValueChanged, controller, prefix) {
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
            "Retirement planning made easy! See your future expenses now!.",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.focusColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Enter your current monthly expense to get started.",
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
                      isValueChanged = true; // Mark value as changed
                    });
                    onValueChanged(newValue);
                    controller.text =
                        newValue.toStringAsFixed(value is int ? 0 : 2);
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
                  ),
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: TextStyle(
                        color: theme.primaryColorDark,
                        fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefix: prefix == "₹" ? Text(prefix) : Text(""),
                        suffix: prefix != "₹" ? Text(prefix) : Text("")),
                    onChanged: (value) {
                      if (value.isEmpty || num.tryParse(value) == null) {
                        // onValueChanged(5000);
                        return; // Ignore invalid input
                      }
                      if (value.isNotEmpty) {
                        num newValue = num.parse(value);
                        if (newValue >= minValue && newValue <= maxValue) {
                          setState(() {
                            isValueChanged = true; // Mark value as changed
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

  Widget buildAgeSlider({
    required ThemeData theme,
    required String title,
    required int value,
    required Function(int) onValueChanged,
    required TextEditingController controller,
  }) {
    // Constants for age limits
    const int minAge = 18;
    const int maxAge = 59;

    // Function to check if age is valid
    bool isValidAge(int age) => age >= minAge && age <= maxAge;

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
            "Your future, your plan! 📅",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.focusColor,
            ),
          ),
          Text(
            "Enter your age to start planning.",
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
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      suffixText: 'yrs',
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

//Function navigate SectionScreen
  void navigateToSectionScreen() {
    if (currentAge >= 18 &&
        currentAge <= 59 &&
        inflationRate >= 1.0 &&
        inflationRate <= 20.0) {
      setState(() {
        isCalledApi = true; // Trigger UI update
        isValueChanged = false;
      });

      getFuturePlansData(
              currentAge,
              60, // retirementAge
              monthlyExpense,
              6.0 // inflationRate
              )
          .then((_) {
        // Delay showing the gauge for smooth UI transition
        // Future.delayed(Duration(seconds: 4), () {
        //   setState(() {}); // Rebuild UI after 4 seconds
        // });
      });
    } else {
      ToastUtils.showToast(
          "Invalid input. Please check your details and try again.", "");
    }
  }

  Widget _buildBreakdownRow(String label, String amount, Color color, theme) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: theme.primaryColorDark,
            ),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.primaryColorDark,
          ),
        ),
      ],
    );
  }

  Widget _buildForRetirementData(theme) {
    final getData = ref.watch(getCalculateFuturePlansDataProvider);
    if (getData.error != null) {
      return ErrorScreenWidget();
    }
    return getData.isLoading
        ? CommonLoaderGif()
        : Column(
            children: [
              // Top Container with Chart
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.7),
                  // borderRadius: const BorderRadius.only(
                  //   bottomLeft: Radius.circular(500),
                  //   bottomRight: Radius.circular(500),
                  // ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Plan today for a comfortable tomorrow - know your retirement capital needs.',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // Bottom Sheet
              Container(
                height: 200,
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                child: Column(
                  children: [
                    _buildBreakdownRow(
                        "Future Monthly Expense",
                        Utils.formatValue(getData.calculateMyFuturePlanModel!
                                .futureMonthlyExpenseAtAgeOf60 ??
                            ''),
                        const Color(0xFF56C47F),
                        theme),
                    const SizedBox(height: 16),
                    _buildBreakdownRow(
                        "Inflation Rate",
                        "  ${(getData.calculateMyFuturePlanModel!.inflationRate * 100).toStringAsFixed(0)} %",
                        const Color(0xFF4A6FFF),
                        theme),
                    const SizedBox(height: 16),
                    _buildBreakdownRow(
                        "Time Frame",
                        (60 -
                                getData.calculateMyFuturePlanModel!
                                    .currentAge) //Todo: We need time frame from back end
                            .toString(),
                        const Color(0xFFFF7AA2),
                        theme),
                  ],
                ),
              ),
            ],
          );
  }
}
