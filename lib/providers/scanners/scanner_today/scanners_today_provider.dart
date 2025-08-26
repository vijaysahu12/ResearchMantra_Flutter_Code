import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/scanners/scanners_model.dart';

import 'package:research_mantra_official/data/repositories/interfaces/IScanners_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/scanners/scanner_today/scanners_today_state.dart';

class ScannersStateNotifier extends StateNotifier<ScannersTodayState> {
  ScannersStateNotifier(this._iScannersRepository)
      : super(ScannersTodayState.initial());

  final IScannersRepository _iScannersRepository;

//To get all the TodayScannerNotifications
  Future<void> getTodayScannerNotifications(String ?id) async {
    try {
      state = ScannersTodayState.loading();

      final ScannerNotificationResponseModel allScannersNotification =
          await _iScannersRepository.getTodayScannerNotification(id);

      state = ScannersTodayState.loaded(allScannersNotification);
    } catch (error) {
      state = ScannersTodayState.error(error.toString());
    }
  }

  void empty() {
    state = ScannersTodayState.loading();
  }
}

final getTodayScannersStateNotifierProvider =
    StateNotifierProvider<ScannersStateNotifier, ScannersTodayState>((ref) {
  final IScannersRepository getScannersNotificationRepository =
      getIt<IScannersRepository>();
  return ScannersStateNotifier(getScannersNotificationRepository);
});
