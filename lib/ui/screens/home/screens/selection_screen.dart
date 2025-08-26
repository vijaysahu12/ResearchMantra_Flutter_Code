import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/providers/calculate_future/calculate_future_provider.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/button.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/home/screens/final_output.dart';

class SelectOptionsScreen extends ConsumerStatefulWidget {
  final int currentAge;
  final int retirementAge;
  final double currentMonthlyExpense;
  final double inflationRate;
  final int anyCurrentInvestment;
  final double currentInvestInterstRatePercentage;

  const SelectOptionsScreen({
    super.key,
    required this.currentAge,
    required this.retirementAge,
    required this.currentMonthlyExpense,
    required this.inflationRate,
    required this.anyCurrentInvestment,
    required this.currentInvestInterstRatePercentage,
  });

  @override
  ConsumerState<SelectOptionsScreen> createState() =>
      _SelectOptionsScreenState();
}

class _SelectOptionsScreenState extends ConsumerState<SelectOptionsScreen> {
  int currentInvestment = 0;
  final TextEditingController _investmentController = TextEditingController();
  bool isValueChanged = false;

  @override
  void initState() {
    super.initState();
    _investmentController.text = currentInvestment.toStringAsFixed(0);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getFuturePlansData();
    });
  }

  void getFuturePlansData() async {
    ref
        .read(getCalculateFuturePlansDataProvider.notifier)
        .getCalculateFuturePlansData(
          widget.currentAge,
          widget.retirementAge,
          widget.currentMonthlyExpense,
          widget.inflationRate,
          widget.anyCurrentInvestment,
          widget.currentInvestInterstRatePercentage,
        );
  }

  @override
  void dispose() {
    _investmentController.dispose();
    super.dispose();
  }

  //Function to Generate the Wealth Pdf based on the selected options
  void generateWealthPdf(calculateMyFuturePlanModel, getFuturePlanValues) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenerateWealthScreen(
            currentAge: calculateMyFuturePlanModel.currentAge,
            inflationRate: calculateMyFuturePlanModel.inflationRate,
            currentMonthlyExpense:
                calculateMyFuturePlanModel.currentMonthlyExpense,
            futureMonthlyExpenseAtAgeOf60:
                calculateMyFuturePlanModel.futureMonthlyExpenseAtAgeOf60,
            capitalNeededAt60: calculateMyFuturePlanModel.capitalNeededAt60,
            anyCurrentInvestment:
                calculateMyFuturePlanModel.anyCurrentInvestment,
            investmentPlans: getFuturePlanValues,
            summaryLabel1: calculateMyFuturePlanModel.summaryLabel1,
            summaryLabel2: calculateMyFuturePlanModel.summaryLabel2,
            allowPdf: calculateMyFuturePlanModel.allowPdf),
      ),
    );
  }

// Slider Widget for selecting the investment amount
  Widget _buildSlider({
    required String title,
    required int value,
    required int minValue,
    required int maxValue,
    required int divisions,
    required Function(int) onValueChanged,
    required TextEditingController controller,
    required String prefix,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: theme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 7,
                child: Slider(
                  value: value.toDouble(),
                  min: minValue.toDouble(),
                  max: maxValue.toDouble(),
                  divisions: divisions,
                  activeColor: theme.indicatorColor,
                  onChanged: (newValue) {
                    setState(() {
                      currentInvestment = newValue.toInt();
                      isValueChanged = true; // Mark value as changed
                    });
                    onValueChanged(newValue.toInt());
                    controller.text = newValue.toStringAsFixed(0);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefix: Text(prefix),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        int newValue = int.tryParse(value) ?? minValue;

                        // if (newValue >= minValue && newValue <= maxValue) {
                        setState(() {
                          currentInvestment = newValue;
                          isValueChanged = true; // Mark value as changed
                        });
                        onValueChanged(newValue);
                        // }
                      }
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

  //Function to Generate Sip Amount
  void generateSipAmount(
      currentAge, currentMonthlyExpense, currentInvestment) async {
    await ref
        .read(getCalculateFuturePlansDataProvider.notifier)
        .getCalculateFuturePlansData(
          currentAge,
          60,
          currentMonthlyExpense,
          6, //Inflation Rate //Todo
          currentInvestment, //CurrentInvestment
          0, // Interst Rate
        );
    setState(() {
      isValueChanged = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final getFuturePlans = ref.watch(getCalculateFuturePlansDataProvider);
    if (getFuturePlans.error != null) {
      return Scaffold(
          appBar: CommonAppBarWithBackButton(
            appBarText: "Get Best Options",
            handleBackButton: () {
              Navigator.pop(context);
            },
          ),
          body: ErrorScreenWidget());
    }
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: "Get Best Options",
        handleBackButton: () {
          Navigator.pop(context);
        },
      ),
      body: getFuturePlans.isLoading
          ? CommonLoaderGif()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    _buildSlider(
                        title: "Select your current investment amount?",
                        value: currentInvestment,
                        minValue: 0,
                        maxValue: 10000000,
                        divisions: 100,
                        onValueChanged: (value) {
                          setState(() {
                            currentInvestment = value;
                          });
                        },
                        controller: _investmentController,
                        prefix: "₹ ",
                        theme: theme),
                    if (isValueChanged)
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Button(
                                text: "Generate Sip Amount",
                                onPressed: () {
                                  generateSipAmount(
                                      widget.currentAge,
                                      widget.currentMonthlyExpense,
                                      currentInvestment);
                                },
                                backgroundColor: theme.indicatorColor,
                                textColor: theme
                                    .floatingActionButtonTheme.foregroundColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    _buildTable(
                        // getFuturePlans,
                        getFuturePlans.calculateMyFuturePlanModel,
                        getFuturePlans.calculateMyFuturePlanModel!
                            .investmentPlansWithoutAnyExistingInvestment,
                        theme,
                        "Select a plan from the options below."),
                    const SizedBox(height: 16),
                    if (currentInvestment > 0 && !isValueChanged)
                      _buildTable(
                          // getFuturePlans,
                          getFuturePlans.calculateMyFuturePlanModel,
                          getFuturePlans.calculateMyFuturePlanModel!
                              .investmentPlansWithExistingInvestment,
                          theme,
                          "You have $currentInvestment. Pick an investment option."),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTable(
      calculateMyFuturePlanModel, getFuturePlanValues, theme, title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 165, 61, 61),
                Color.fromARGB(255, 47, 37, 37),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor, // Use a more visible shadow color
                spreadRadius: 1, // Increase spread radius
                blurRadius: 1, // Increase blur for a softer shadow
                offset: const Offset(0, 1), // Slightly move shadow down
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: theme.floatingActionButtonTheme.foregroundColor,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.shadowColor),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            color: theme.primaryColor,
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor,
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              for (var index = 0; index < getFuturePlanValues.length; index++)
                _buildTableRow(
                  getFuturePlanValues[index].planName,
                  (getFuturePlanValues[index].interestRate).toString(),
                  calculateMyFuturePlanModel,
                  getFuturePlanValues[index],
                  theme,
                  sipAmount: getFuturePlanValues[index].monthlySipAmount,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableRow(
    String label,
    String inflationRate,
    calculateMyFuturePlanModel,
    getFuturePlanValuesForInvestDetails,
    theme, {
    String sipAmount = "",
  }) {
    return GestureDetector(
      onTap: () {
        generateWealthPdf(
            calculateMyFuturePlanModel, getFuturePlanValuesForInvestDetails);
      },
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: theme.shadowColor),
          borderRadius: BorderRadius.circular(8),
          color: theme.primaryColor,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor,
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.shadowColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "$inflationRate%",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.focusColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.primaryColorDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sipAmount,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.indicatorColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.indicatorColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Check',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.floatingActionButtonTheme.foregroundColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
