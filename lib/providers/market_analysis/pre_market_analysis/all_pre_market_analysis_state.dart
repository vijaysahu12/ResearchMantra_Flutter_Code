import 'package:research_mantra_official/data/models/market_analysis/all_premarket_analysis.dart';

class AllPreMarketAnalysisState {
  final dynamic error;
  final bool isLoading;
  final List<AllPreMarketAnalysisDataModel>? preMarketAnalysisDataModel;

  AllPreMarketAnalysisState({
    required this.isLoading,
    this.error,
    this.preMarketAnalysisDataModel,
  });

  factory AllPreMarketAnalysisState.initial() => AllPreMarketAnalysisState(
        isLoading: false,
      );
  factory AllPreMarketAnalysisState.loading() => AllPreMarketAnalysisState(
        isLoading: true,
      );

  factory AllPreMarketAnalysisState.loaded(
          List<AllPreMarketAnalysisDataModel>? preMarketAnalysisDataModel) =>
      AllPreMarketAnalysisState(
        isLoading: false,
        preMarketAnalysisDataModel: preMarketAnalysisDataModel,
      );
  factory AllPreMarketAnalysisState.error(dynamic error) => AllPreMarketAnalysisState(
        isLoading: false,
        error: error,
      );
}
