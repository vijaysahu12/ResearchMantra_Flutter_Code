import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/risk_reward_calculator/risk_reward_request_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ISip_calculator_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/risk_reward/risk_reward_calculator_state.dart';

class RiskRewardStateNotifier extends StateNotifier<RiskRewardState> {
  RiskRewardStateNotifier(this._sipCalculatorRepository)
      : super(RiskRewardState.initial());

  final ISipCalculatorRepository _sipCalculatorRepository;

  Future<void> postRiskRewardCalculator(RiskRewardRequestModel model) async {
    try {
      state = RiskRewardState.loading();
      final postRiskReward =
          await _sipCalculatorRepository.postRiskRewardCalculator(model);

      state = RiskRewardState.success(postRiskReward);
    } catch (e) {
      state = RiskRewardState.error(state.error);
    }
  }

  Future<void> emptyRiskRewardCalculator() async {
    state = RiskRewardState.empty();
  }
}

final riskRewardStateNotifierProvider =
    StateNotifierProvider<RiskRewardStateNotifier, RiskRewardState>((ref) {
  final ISipCalculatorRepository sipCalculatorRepository =
      getIt<ISipCalculatorRepository>();
  return RiskRewardStateNotifier(sipCalculatorRepository);
});
