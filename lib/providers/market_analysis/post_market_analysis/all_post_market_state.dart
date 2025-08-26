
import 'package:research_mantra_official/data/models/market_analysis/all_post_market_analysis.dart';


class AllPostMarketAnalysisState {
  final dynamic error;
  final bool isLoading;
  final List<AllPostMarketStockReport?>? allpostmarketStockreport;

  AllPostMarketAnalysisState({
    required this.isLoading,
    this.error,
    this.allpostmarketStockreport,
  });

  factory AllPostMarketAnalysisState.initial() => AllPostMarketAnalysisState(
        isLoading: false,
      );
  factory AllPostMarketAnalysisState.loading() => AllPostMarketAnalysisState(
        isLoading: true,
      );

  factory AllPostMarketAnalysisState.loaded(
        List<AllPostMarketStockReport?>?allpostmarketStockreport) =>
      AllPostMarketAnalysisState(
        isLoading: false,
        allpostmarketStockreport: allpostmarketStockreport,
      );
  factory AllPostMarketAnalysisState.error(dynamic error) => AllPostMarketAnalysisState(
        isLoading: false,
        error: error,
      );
}
