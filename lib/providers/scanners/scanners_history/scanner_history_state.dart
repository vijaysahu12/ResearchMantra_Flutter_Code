import 'package:research_mantra_official/data/models/scanners/scanners_response_model.dart';

class ScannersHistoryState {
  final List<ScannersResponseModel> scannersResponseModel;
  final bool isLoading;
  final dynamic error;
  final bool isLoadmore;

  const ScannersHistoryState({
    required this.scannersResponseModel,
    required this.isLoading,
    required this.isLoadmore,
    required this.error,
  });

  factory ScannersHistoryState.initial() => const ScannersHistoryState(
      scannersResponseModel: [],
      error: null,
      isLoading: false,
      isLoadmore: false);

  factory ScannersHistoryState.loading() => const ScannersHistoryState(
      scannersResponseModel: [],
      error: null,
      isLoading: true,
      isLoadmore: false);

  factory ScannersHistoryState.loadedHistory(
          final List<ScannersResponseModel> scannersResponseModel) =>
      ScannersHistoryState(
          scannersResponseModel: scannersResponseModel,
          error: null,
          isLoading: false,
          isLoadmore: false);

  factory ScannersHistoryState.loadingMoreHistory(
          final List<ScannersResponseModel> scannersResponseModel) =>
      ScannersHistoryState(
          scannersResponseModel: scannersResponseModel,
          error: null,
          isLoading: false,
          isLoadmore: true);

  factory ScannersHistoryState.error(dynamic error) => ScannersHistoryState(
      scannersResponseModel: [],
      error: error,
      isLoading: false,
      isLoadmore: false);
}
