import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/scanners/scanners_strategies_response_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IScanners_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/scanners/scanners_strategies/scanners_strategies_state.dart';

class ScannersNotificationStrategiesStateNotifier
    extends StateNotifier<ScannersStrategiesState> {
  ScannersNotificationStrategiesStateNotifier(this._iScannersRepository)
      : super(ScannersStrategiesState.initial());

  final IScannersRepository _iScannersRepository;

//To Get All The ScannersNotification
  Future<void> getAllStrategies(String strategyName) async {
    try {
      state = ScannersStrategiesState.loading();
      final List<GetStrategiesResponseModel> getAllStrategiesListData =
          await _iScannersRepository.getScannersStratgies(strategyName);

      state = ScannersStrategiesState.loaded(getAllStrategiesListData);
    } catch (error) {
      state = ScannersStrategiesState.error(error);
    }
  }

  void empty() {
    state = ScannersStrategiesState.loading();
  }
}

final getScannersNotificationStrategiesStateNotifierProvider =
    StateNotifierProvider<ScannersNotificationStrategiesStateNotifier,
        ScannersStrategiesState>((ref) {
  final IScannersRepository getScannersNotificationNotificationRepository =
      getIt<IScannersRepository>();
  return ScannersNotificationStrategiesStateNotifier(
      getScannersNotificationNotificationRepository);
});
