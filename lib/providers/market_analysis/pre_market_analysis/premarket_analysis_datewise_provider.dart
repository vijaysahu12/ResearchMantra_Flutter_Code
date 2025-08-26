import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/market_analysis/specifc_premarket_analysis.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IAnalysis_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/market_analysis/pre_market_analysis/premarket_analysis_datewise_state.dart';

class PreMarketAnalysisDateWiseNotifier extends StateNotifier<PreMarketAnalysisDateWiseState> {
  PreMarketAnalysisDateWiseNotifier(this._analysisRepository)
      : super(PreMarketAnalysisDateWiseState.initial());

  final IAnalysisRepository _analysisRepository;

  Future<void> getPreMarketAnalysisById( String id) async {
    try {
      state = PreMarketAnalysisDateWiseState.loading();
      // }
      PreMarketAnalysisData? getPreMarketAnalysisData =
          await _analysisRepository.getPreMarketAnalysisById(id);
      state = PreMarketAnalysisDateWiseState.loaded(getPreMarketAnalysisData);
    } catch (e) {
      state = PreMarketAnalysisDateWiseState.error(e.toString());
    }
  }
}

final preMarketAnalysisDateWiseProvider =
    StateNotifierProvider<PreMarketAnalysisDateWiseNotifier, PreMarketAnalysisDateWiseState>(
        ((ref) {
  final IAnalysisRepository analysisRepository = getIt<IAnalysisRepository>();
  return PreMarketAnalysisDateWiseNotifier(analysisRepository);
}));
