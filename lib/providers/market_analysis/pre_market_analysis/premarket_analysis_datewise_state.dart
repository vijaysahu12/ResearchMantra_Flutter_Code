
import 'package:research_mantra_official/data/models/market_analysis/specifc_premarket_analysis.dart';

class PreMarketAnalysisDateWiseState {
  final dynamic error;
  final bool isLoading;
  final PreMarketAnalysisData? preMarketAnalysisDateWiseModel;

  PreMarketAnalysisDateWiseState({
    required this.isLoading,
    this.error,
    this.preMarketAnalysisDateWiseModel,
  });

  factory PreMarketAnalysisDateWiseState.initial() => PreMarketAnalysisDateWiseState(
        isLoading: false,
      );
  factory PreMarketAnalysisDateWiseState.loading() => PreMarketAnalysisDateWiseState(
        isLoading: true,
      );

  factory PreMarketAnalysisDateWiseState.loaded(
          PreMarketAnalysisData? preMarketAnalysisDateWiseModel) =>
      PreMarketAnalysisDateWiseState(
        isLoading: false,
        preMarketAnalysisDateWiseModel: preMarketAnalysisDateWiseModel,
      );
  factory PreMarketAnalysisDateWiseState.error(dynamic error) => PreMarketAnalysisDateWiseState(
        isLoading: false,
        error: error,
      );
}
