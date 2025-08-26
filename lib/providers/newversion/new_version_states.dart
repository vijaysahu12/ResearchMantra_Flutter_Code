import 'package:research_mantra_official/data/models/app_version_response_model.dart';

class NewVersionState {
  final bool isLoading;
  final dynamic error;
  final AppVersionResponseModel? newVersionResponseModel;

  const NewVersionState({
    required this.newVersionResponseModel,
    required this.isLoading,
    required this.error,
  });

  factory NewVersionState.loading() => const NewVersionState(
      newVersionResponseModel: null, isLoading: true, error: null);
  factory NewVersionState.loaded(
          AppVersionResponseModel newVersionResponseModel) =>
      NewVersionState(
          newVersionResponseModel: newVersionResponseModel,
          isLoading: false,
          error: null);
  factory NewVersionState.error(dynamic error) => NewVersionState(
      newVersionResponseModel: null, isLoading: false, error: error);
}
