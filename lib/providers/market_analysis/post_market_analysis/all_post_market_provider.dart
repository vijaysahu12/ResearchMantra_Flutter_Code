import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/market_analysis/all_post_market_analysis.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IAnalysis_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/market_analysis/post_market_analysis/all_post_market_state.dart';

class AllPostMarketAnalysisNotifier
    extends StateNotifier<AllPostMarketAnalysisState> {
  AllPostMarketAnalysisNotifier(this._analysisRepository)
      : super(AllPostMarketAnalysisState.initial());

  final IAnalysisRepository _analysisRepository;

  Future<void> getAllPostMarketAnalysisData(int pageNumber) async {
    try {
      if (pageNumber == 1) {
        state = AllPostMarketAnalysisState.loading();
      }
      List<AllPostMarketStockReport?> getPostMarketAnalysisData =
          await _analysisRepository.getAllPostMarketAnalysis(pageNumber) ?? [];
      print("${getPostMarketAnalysisData.length} -----$pageNumber PROVIDER");
      if (getPostMarketAnalysisData.isNotEmpty && pageNumber != 1) {
        state = AllPostMarketAnalysisState.loaded([
          ...state.allpostmarketStockreport ?? [],
          ...getPostMarketAnalysisData
        ]);
      } else if (pageNumber == 1) {
        state = AllPostMarketAnalysisState.loaded(getPostMarketAnalysisData);
      }
    } catch (e) {
      state = AllPostMarketAnalysisState.error(e.toString());
    }
  }
}

final allPostMarketAnalysisProvider = StateNotifierProvider<
    AllPostMarketAnalysisNotifier, AllPostMarketAnalysisState>(((ref) {
  final IAnalysisRepository analysisRepository = getIt<IAnalysisRepository>();
  return AllPostMarketAnalysisNotifier(analysisRepository);
}));
