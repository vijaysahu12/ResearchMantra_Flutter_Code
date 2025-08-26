import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/calculater/plans_response_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ICalculate_future_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/calculate_future/plans/get_plans_states.dart';

class GetPlansStateProvider extends StateNotifier<GetPlansState> {
  GetPlansStateProvider(this._calculateMyFutureRepository)
      : super(GetPlansState.initial());
  final ICalculateMyFutureRepository _calculateMyFutureRepository;

  Future<void> getPlas() async {
    try {
      state = GetPlansState.loading();

      final List<GetPlansResponseModel> data =
          await _calculateMyFutureRepository.getPlans();
      state = GetPlansState.success(data);
    } catch (e) {
      state = GetPlansState.error(e);
    }
  }
}

final getPlansProvider =
    StateNotifierProvider<GetPlansStateProvider, GetPlansState>((ref) {
  final ICalculateMyFutureRepository getCalculateFutureplan =
      getIt<ICalculateMyFutureRepository>();
  return GetPlansStateProvider(getCalculateFutureplan);
});
