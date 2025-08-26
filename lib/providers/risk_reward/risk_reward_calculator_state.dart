import 'package:research_mantra_official/data/models/risk_reward_calculator/risk_reward_response_model.dart';

class RiskRewardState {
  final bool isLoading;
  final dynamic error;
  final RiskRewardResponseModel? riskRewardResponseModel;

  RiskRewardState(
      {required this.isLoading,
      required this.error,
      required this.riskRewardResponseModel});

  factory RiskRewardState.initial() => RiskRewardState(
      isLoading: false, error: null, riskRewardResponseModel: null);

  factory RiskRewardState.loading() => RiskRewardState(
      isLoading: true, error: null, riskRewardResponseModel: null);

  factory RiskRewardState.success(
          RiskRewardResponseModel  riskRewardResponseModel) =>
      RiskRewardState(
          isLoading: false,
          error: null,
          riskRewardResponseModel: riskRewardResponseModel);

  factory RiskRewardState.error(dynamic error) => RiskRewardState(
      isLoading: false, error: error, riskRewardResponseModel: null);
  factory RiskRewardState.empty() => RiskRewardState(
      isLoading: false, error: null, riskRewardResponseModel: null);
}
