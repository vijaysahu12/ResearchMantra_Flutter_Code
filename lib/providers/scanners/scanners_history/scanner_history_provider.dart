

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/scanners/scanners_response_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IScanners_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/scanners/scanners_history/scanner_history_state.dart';

class ScannersHistoryStateNotifier extends StateNotifier<ScannersHistoryState> {
  ScannersHistoryStateNotifier(this._iScannersRepository)
      : super(ScannersHistoryState.initial());

  final IScannersRepository _iScannersRepository;

  int _page = 1;

//To Get All The ScannersNotification
  Future<void> getScannersHistoryNotification(
      int pageSize,
      int pageNumber,
      dynamic primaryKey,
      String fromDate,
      String toDate,
      dynamic loggedInUser) async {
    try {
    
      // Check if primaryKey is an empty string and assign null, otherwise assign the actual value
      dynamic primaryValue = (primaryKey == "") ? null : primaryKey;

      _page = pageNumber;
      state = ScannersHistoryState.loading();

      final List<ScannersResponseModel> allScannersNotification =
          await _iScannersRepository.getScannersNotification(
              pageSize, _page, primaryValue, fromDate, toDate, loggedInUser);

      state = ScannersHistoryState.loadedHistory(allScannersNotification);
    } catch (error) {
      state = ScannersHistoryState.error(error);
    }
  }

//Method to get loadmore scanners
  Future<void> getLoadMoreScannersHistoryNotification(
      int pageSize,
      int pageNumber,
      dynamic primaryKey,
      String fromDate,
      String toDate,
      String loggedInUser) async {
    if (state.isLoadmore) return;
    final int page = _page + 1;
    final List<ScannersResponseModel> currentScanners =
        state.scannersResponseModel;
    state = ScannersHistoryState.loadingMoreHistory(currentScanners);

    try {
      final List<ScannersResponseModel> newScannersNotification =
          await _iScannersRepository.loadMoreScannerNotifications(
              pageSize, page, primaryKey, fromDate, toDate, loggedInUser);
      final List<ScannersResponseModel> allScannersNotification = [
        ...currentScanners,
        ...newScannersNotification
      ];
      state = ScannersHistoryState.loadedHistory(allScannersNotification);
      _page++;
    } catch (error) {
      state = ScannersHistoryState.error(error);
    }
  }
}

final getScannersHistoryStateNotifierProvider =
    StateNotifierProvider<ScannersHistoryStateNotifier, ScannersHistoryState>(
        (ref) {
  final IScannersRepository getScannersNotificationRepository =
      getIt<IScannersRepository>();
  return ScannersHistoryStateNotifier(getScannersNotificationRepository);
});
