import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/perfomance/perfomance_response_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IPerfomance_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/perfomance/performance_data/perfomanace_state.dart';

class PerformaceStateNotifier extends StateNotifier<PerformanceState> {
  PerformaceStateNotifier(this._perfomanceRepository)
      : super(PerformanceState.inital());
  final IPerformanceRepository _perfomanceRepository;

  Future<void> getPerformanceDetail(String code) async {
    try {
      state = PerformanceState.loading();

      final PerformanceResponseModel getPerfomanceData =
          await _perfomanceRepository.getPerfomanceData(code);

      state = PerformanceState.success(getPerfomanceData);
    } catch (error) {
      state = PerformanceState.error(state.perfomanceResponseModel);
    }
  }
}

final performanceStateNotifierProvider =
    StateNotifierProvider<PerformaceStateNotifier, PerformanceState>((ref) {
  final IPerformanceRepository perfomanceRepositoryData =
      getIt<IPerformanceRepository>();
  return PerformaceStateNotifier(perfomanceRepositoryData);
});
