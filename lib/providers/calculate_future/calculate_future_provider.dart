import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/calculater/caliculate_future_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ICalculate_future_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/calculate_future/calculate_future_state.dart';

class CalculateFutureStateProvider extends StateNotifier<CalculateFutureState> {
  CalculateFutureStateProvider(this._calculateMyFutureRepository)
      : super(CalculateFutureState.initial());
  final ICalculateMyFutureRepository _calculateMyFutureRepository;

  Future<void> getCalculateFuturePlansData(
      int currentAge,
      int retirementAge,
      double currentMonthlyExpense,
      double inflationRate,
      int anyCurrentInvestment,
      double currentInvestmentAmountInterstRate) async {
    try {
      state = CalculateFutureState.loading();

      final CalculateMyFuturePlanModel? data =
          await _calculateMyFutureRepository.getFuturePlanData(
              currentAge,
              retirementAge,
              currentMonthlyExpense,
              inflationRate,
              anyCurrentInvestment,
              currentInvestmentAmountInterstRate);
      state = CalculateFutureState.success(data!);
    } catch (e) {
      state = CalculateFutureState.error(e);
    }
  }
}

final getCalculateFuturePlansDataProvider =
    StateNotifierProvider<CalculateFutureStateProvider, CalculateFutureState>(
        (ref) {
  final ICalculateMyFutureRepository getCalculateFutureplan =
      getIt<ICalculateMyFutureRepository>();
  return CalculateFutureStateProvider(getCalculateFutureplan);
});
