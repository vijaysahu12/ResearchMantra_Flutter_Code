import 'package:research_mantra_official/data/models/perfomance/perfomance_header_response_model.dart';

class PerformanceHeaderState {
  final bool isLoading;
  final dynamic error;
  final List<GetPerformanceHeaderResponseModel> getPerformanceHeaders;

  PerformanceHeaderState(
      {required this.error,
      required this.isLoading,
      required this.getPerformanceHeaders});

  factory PerformanceHeaderState.inital() => PerformanceHeaderState(
      error: null, isLoading: false, getPerformanceHeaders: []);

  factory PerformanceHeaderState.loading() => PerformanceHeaderState(
      error: null, isLoading: true, getPerformanceHeaders: []);

  factory PerformanceHeaderState.success(
          List<GetPerformanceHeaderResponseModel> getPerformanceHeaders) =>
      PerformanceHeaderState(
          error: null,
          isLoading: false,
          getPerformanceHeaders: getPerformanceHeaders);

  factory PerformanceHeaderState.error(dynamic error) => PerformanceHeaderState(
      error: error, isLoading: false, getPerformanceHeaders: []);


}
