import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/market_analysis/all_premarket_analysis.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IAnalysis_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/market_analysis/pre_market_analysis/all_pre_market_analysis_state.dart';

class PreMarketAnalysisNotifier
    extends StateNotifier<AllPreMarketAnalysisState> {
  PreMarketAnalysisNotifier(this._analysisRepository)
      : super(AllPreMarketAnalysisState.initial());

  final IAnalysisRepository _analysisRepository;

  Future<void> getPreMarketAnalysisData(int id) async {
    try {
      if (id == 1) {
        state = AllPreMarketAnalysisState.loading();
      }
      List<AllPreMarketAnalysisDataModel> getPreMarketAnalysisData =
          await _analysisRepository.getAllPreMarketAnalysis(id) ?? [];
      print(
          "${getPreMarketAnalysisData.isNotEmpty}  $id   ${getPreMarketAnalysisData.length}---not empty");

      if (getPreMarketAnalysisData.isNotEmpty && id != 1) {
        state = AllPreMarketAnalysisState.loaded([
          ...state.preMarketAnalysisDataModel ?? [],
          ...getPreMarketAnalysisData
        ]);
      } else if (id == 1) {
        state = AllPreMarketAnalysisState.loaded(getPreMarketAnalysisData);
      }
    } catch (e) {
      state = AllPreMarketAnalysisState.error(e.toString());
    }
  }
}

final preMarketAnalysisProvider =
    StateNotifierProvider<PreMarketAnalysisNotifier, AllPreMarketAnalysisState>(
        ((ref) {
  final IAnalysisRepository analysisRepository = getIt<IAnalysisRepository>();
  return PreMarketAnalysisNotifier(analysisRepository);
}));
