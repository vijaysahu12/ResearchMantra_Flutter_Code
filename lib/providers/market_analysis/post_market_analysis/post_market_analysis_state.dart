
import 'package:research_mantra_official/data/models/market_analysis/specifc_postmarket_analysis.dart';
class PostMarketAnalysisState {
  final dynamic error;
  final bool isLoading;
  final PostMarketAnalysisStockData? postMarketAnalysisStockData;

  PostMarketAnalysisState({
    required this.isLoading,
    this.error,
    this.postMarketAnalysisStockData,
  });

  factory PostMarketAnalysisState.initial() => PostMarketAnalysisState(
        isLoading: false,
      );
  factory PostMarketAnalysisState.loading() => PostMarketAnalysisState(
        isLoading: true,
      );

  factory PostMarketAnalysisState.loaded(
          PostMarketAnalysisStockData? postMarketAnalysisStockData) =>
      PostMarketAnalysisState(
        isLoading: false,
        postMarketAnalysisStockData: postMarketAnalysisStockData,
      );
  factory PostMarketAnalysisState.error(dynamic error) => PostMarketAnalysisState(
        isLoading: false,
        error: error,
      );
}
