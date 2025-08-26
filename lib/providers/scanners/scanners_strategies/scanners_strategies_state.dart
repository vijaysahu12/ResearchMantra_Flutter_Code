import 'package:research_mantra_official/data/models/scanners/scanners_strategies_response_model.dart';

class ScannersStrategiesState {
  final List<GetStrategiesResponseModel> getStrategiesResponse;
  final dynamic error;
  final bool isLoading;

  const ScannersStrategiesState({
    required this.getStrategiesResponse,
    required this.error,
    required this.isLoading,
  });

  factory ScannersStrategiesState.initial() => const ScannersStrategiesState(
      getStrategiesResponse: [], error: null, isLoading: false);

  factory ScannersStrategiesState.loading() => const ScannersStrategiesState(
      getStrategiesResponse: [], error: null, isLoading: true);

  factory ScannersStrategiesState.loaded(List<GetStrategiesResponseModel> getStrategiesResponse) =>  ScannersStrategiesState(
      getStrategiesResponse:getStrategiesResponse, error: null, isLoading: false);

  factory ScannersStrategiesState.error(dynamic error) =>  ScannersStrategiesState(
      getStrategiesResponse: [], error: error, isLoading: false);
}
