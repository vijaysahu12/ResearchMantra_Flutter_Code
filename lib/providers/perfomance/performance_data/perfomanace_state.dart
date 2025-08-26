import 'package:research_mantra_official/data/models/perfomance/perfomance_response_model.dart';

class PerformanceState {
  final bool isLoading;
  final dynamic error;
  final PerformanceResponseModel? perfomanceResponseModel;

  PerformanceState(
      {required this.error,
      required this.isLoading,
      required this.perfomanceResponseModel});

  factory PerformanceState.inital() => PerformanceState(
      error: null, isLoading: false, perfomanceResponseModel: null);

  factory PerformanceState.loading() => PerformanceState(
      error: null, isLoading: true, perfomanceResponseModel: null);

  factory PerformanceState.success(
          PerformanceResponseModel perfomanceResponseModel) =>
      PerformanceState(
          error: null,
          isLoading: false,
          perfomanceResponseModel: perfomanceResponseModel);

  factory PerformanceState.error(dynamic error) => PerformanceState(
      error: error, isLoading: false, perfomanceResponseModel: null);


}
