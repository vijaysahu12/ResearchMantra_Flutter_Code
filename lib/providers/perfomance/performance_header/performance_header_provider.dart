
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/perfomance/perfomance_header_response_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IPerfomance_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/perfomance/performance_header/performance_header_states.dart';

class PerformanceHeaderStateNotifier
    extends StateNotifier<PerformanceHeaderState> {
  PerformanceHeaderStateNotifier(this._perfomanceRepository)
      : super(PerformanceHeaderState.inital());

  final IPerformanceRepository _perfomanceRepository;

  Future<void> getPerfomanceHeadersList() async {
    try {
      state = PerformanceHeaderState.loading();

      final List<GetPerformanceHeaderResponseModel> getPerformanceHeadersData =
          await _perfomanceRepository.getPerformanceHeader();
      state = PerformanceHeaderState.success(getPerformanceHeadersData);
    } catch (e) {
      state = PerformanceHeaderState.error(state.getPerformanceHeaders);
    }
  }
}

final performanceHeaderStateNotifierProvider = StateNotifierProvider<
    PerformanceHeaderStateNotifier, PerformanceHeaderState>((ref) {
  final IPerformanceRepository perfomanceHeadersRepositoryData =
      getIt<IPerformanceRepository>();

  return PerformanceHeaderStateNotifier(perfomanceHeadersRepositoryData);
});
