import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/market_analysis/specifc_postmarket_analysis.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IAnalysis_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/market_analysis/post_market_analysis/post_market_analysis_state.dart';


class PostMarketAnalysisNotifier extends StateNotifier<PostMarketAnalysisState> {
  PostMarketAnalysisNotifier(this._analysisRepository)
      : super(PostMarketAnalysisState.initial());

  final IAnalysisRepository _analysisRepository;

  Future<void> getPostMarketAnalysisData(String id ) async {
    try {
   
      state = PostMarketAnalysisState.loading();
      // }
      PostMarketAnalysisStockData getPostMarketAnalysisData =
          await _analysisRepository.getPostMarketAnalysisById(id ) ??PostMarketAnalysisStockData();
      state = PostMarketAnalysisState.loaded(getPostMarketAnalysisData);
    } catch (e) {
      state = PostMarketAnalysisState.error(e.toString());
    }
  }
}

final postMarketAnalysisProvider =
    StateNotifierProvider<PostMarketAnalysisNotifier, PostMarketAnalysisState>(
        ((ref) {
  final IAnalysisRepository analysisRepository = getIt<IAnalysisRepository>();
  return PostMarketAnalysisNotifier(analysisRepository);
}));