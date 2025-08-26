import 'package:research_mantra_official/data/models/get_free_trial/get_free_trial_data_model.dart';

class GetFreeTrialState {
  final dynamic error;
  final bool isLoading;
  final GetFreeTrialDataModel? getFreeTrialDataModel;

  GetFreeTrialState({
    required this.isLoading,
    this.error,
    this.getFreeTrialDataModel,
  });

  factory GetFreeTrialState.initial() => GetFreeTrialState(
        isLoading: false,
        getFreeTrialDataModel: null,
      );
  factory GetFreeTrialState.loading() =>
      GetFreeTrialState(isLoading: true, getFreeTrialDataModel: null);

  factory GetFreeTrialState.loaded(
          GetFreeTrialDataModel getFreeTrialDataModel) =>
      GetFreeTrialState(
        isLoading: false,
        getFreeTrialDataModel: getFreeTrialDataModel,
      );
  factory GetFreeTrialState.error(dynamic error) => GetFreeTrialState(
        isLoading: false,
        error: error,
        getFreeTrialDataModel: null,
      );
}
