import 'package:research_mantra_official/data/models/common_api_response.dart';

class FormsState {
  final bool isLoading;
  final dynamic error;
  final CommonHelperResponseModel? commonHelperResponseModel;

  FormsState(
      {required this.isLoading,
      required this.error,
      required this.commonHelperResponseModel});

  factory FormsState.initial() => FormsState(
      isLoading: false, error: null, commonHelperResponseModel: null);

  factory FormsState.loading() =>
      FormsState(isLoading: true, error: null, commonHelperResponseModel: null);
  factory FormsState.success(
          CommonHelperResponseModel activeProductCountModel) =>
      FormsState(
          isLoading: false,
          error: null,
          commonHelperResponseModel: activeProductCountModel);
  factory FormsState.error(dynamic error) => FormsState(
      isLoading: false, error: error, commonHelperResponseModel: null);
}
