import 'package:research_mantra_official/data/models/calculater/caliculate_future_model.dart';

class CalculateFutureState {
  final CalculateMyFuturePlanModel? calculateMyFuturePlanModel;
  final bool isLoading;
  final dynamic error;

  const CalculateFutureState({
    this.calculateMyFuturePlanModel,
    required this.isLoading,
    this.error,
  });

  factory CalculateFutureState.initial() => const CalculateFutureState(
        isLoading: false,
        calculateMyFuturePlanModel: null,
        error: null,
      );

  factory CalculateFutureState.loading() => const CalculateFutureState(
        isLoading: true,
        calculateMyFuturePlanModel: null,
        error: null,
      );

  factory CalculateFutureState.success(
          CalculateMyFuturePlanModel calculateMyFuturePlanModel) =>
      CalculateFutureState(
        isLoading: false,
        calculateMyFuturePlanModel: calculateMyFuturePlanModel,
        error: null,
      );

  factory CalculateFutureState.error(dynamic error) => CalculateFutureState(
        isLoading: false,
        calculateMyFuturePlanModel: null,
        error: error,
      );
}
