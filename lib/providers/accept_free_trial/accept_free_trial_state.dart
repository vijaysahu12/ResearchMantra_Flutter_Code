

import 'package:research_mantra_official/data/models/get_free_trial/activate_free_trial_response_model.dart';

class AcceptFreeTrialState {
  final dynamic error;
  final bool isLoading;
  final ActivateFreeTrialResponseModel ? acceptFreeTrialDataModel;

  AcceptFreeTrialState({
    required this.isLoading,
    this.error,
    this.acceptFreeTrialDataModel,
  });

  factory AcceptFreeTrialState.initial() => AcceptFreeTrialState(
        isLoading: false,
        acceptFreeTrialDataModel: null,
      );
  factory AcceptFreeTrialState.loading() => AcceptFreeTrialState(
        isLoading: true,
      );

  factory AcceptFreeTrialState.loaded(ActivateFreeTrialResponseModel acceptFreeTrialDataModel) =>
      AcceptFreeTrialState(
        isLoading: false,
        acceptFreeTrialDataModel: acceptFreeTrialDataModel,
      );
  factory AcceptFreeTrialState.error(dynamic error) => AcceptFreeTrialState(
        isLoading: false,
        error: error,
        acceptFreeTrialDataModel: null,
      );

       factory AcceptFreeTrialState.activated(dynamic value ) => AcceptFreeTrialState(
        isLoading: false,
        error: null,
        acceptFreeTrialDataModel: value,
      );
}