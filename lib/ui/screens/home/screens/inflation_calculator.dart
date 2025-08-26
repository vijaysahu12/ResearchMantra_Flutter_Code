import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/calculate_future/plans/get_plans_provider.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/components/risk_reward_calculator/risk_reward_calculator.dart';
import 'package:research_mantra_official/ui/components/sip_calculator/sip_calculator.dart';
import 'package:research_mantra_official/ui/screens/home/screens/monthly_expanses.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import 'widgets/inflation_container_common.dart';

class RetirementCalculator extends ConsumerStatefulWidget {
  const RetirementCalculator({super.key});

  @override
  ConsumerState<RetirementCalculator> createState() =>
      _RetirementCalculatorState();
}

class _RetirementCalculatorState extends ConsumerState<RetirementCalculator> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshData();
    });
  }

  String? selectedPlan;

  Future<void> _refreshData() async {
    // Check connectivity before attempting to refresh
    final connectivityResult = ref.watch(connectivityStreamProvider);

    // Checking result based on that displaying connection screen
    final result = connectivityResult.value;

    if (result != ConnectivityResult.none) {
      // If we have connectivity, refresh plans data

      try {
        await ref.read(getPlansProvider.notifier).getPlas();
      } catch (e) {
        print('Failed to refresh plans: $e');
      }
    } else {
      ToastUtils.showToast(noInternetConnectionText, "");
    }
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final plansList = ref.watch(getPlansProvider);
    final connectivityResult = ref.watch(connectivityStreamProvider);
    final theme = Theme.of(context);

    // Checking result based on that displaying connection screen
    final result = connectivityResult.value;
    bool isConnection = result != ConnectivityResult.none;

    return Scaffold(
        backgroundColor: theme.primaryColor,
        appBar: CommonAppBarWithBackButton(
          appBarText: "Plan For Future",
          handleBackButton: () {
            Navigator.pop(context);
          },
        ),
        body: _buildCalculatorList(theme, isConnection, plansList));
  }

  // Widget for calculating screen

  Widget _buildCalculatorList(theme, isConnection, plansList) {
    final planData = plansList.getPlansResponseModel;
    // Show loader while fetching
    if (plansList.isLoading || isLoading) {
      return const Center(child: CommonLoaderGif());
    }

    // Show no internet screen if there's no connection and no cached data
    if (!isConnection && planData == null) {
      return NoInternet(
        handleRefresh: () {
          _refreshData();
        },
      ); // No Internet widget
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemCount: planData.length,
        itemBuilder: (context, index) {
          final plan = planData[index];
          if (!plan.visible) return const SizedBox();

          return GestureDetector(
            onTap: () => _handlePlanSelection(plan.planName),
            child: InflationContainer(theme: theme, planName: plan.planName),
          );
        },
      ),
    );
  }

  void _handlePlanSelection(String planName) {
    final normalizedPlan = planName.replaceAll(' ', '').toLowerCase();

    switch (normalizedPlan) {
      case "sipcalculator":
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => SipCalculator()));
        break;
      case "riskrewardcalculator":
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => RiskRewardCalculator()));
        break;
      // case "tradingjournalscreen":
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (_) => TradingJournalScreen()));
      //   break;
      case "retirementplans":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MonthlyExpanses(selectedPlans: planName),
          ),
        );
        break;
      default:
        print("No Redirection");
    }
  }
}
