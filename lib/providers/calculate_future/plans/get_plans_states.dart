import 'package:research_mantra_official/data/models/calculater/plans_response_model.dart';

class GetPlansState {
  final List<GetPlansResponseModel>? getPlansResponseModel;
  final bool isLoading;
  final dynamic error;

  const GetPlansState({
    this.getPlansResponseModel,
    required this.isLoading,
    this.error,
  });

  factory GetPlansState.initial() => const GetPlansState(
        isLoading: false,
        getPlansResponseModel: null,
        error: null,
      );

  factory GetPlansState.loading() => const GetPlansState(
        isLoading: true,
        getPlansResponseModel: null,
        error: null,
      );

  factory GetPlansState.success(
          List<GetPlansResponseModel> getPlansResponseModel) =>
      GetPlansState(
        isLoading: false,
        getPlansResponseModel: getPlansResponseModel,
        error: null,
      );

  factory GetPlansState.error(dynamic error) => GetPlansState(
        isLoading: false,
        getPlansResponseModel: null,
        error: error,
      );
}
