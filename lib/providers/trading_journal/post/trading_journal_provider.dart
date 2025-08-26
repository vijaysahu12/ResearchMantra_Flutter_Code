

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:research_mantra_official/data/models/trading_journal/trading_journal_model.dart';

import 'package:research_mantra_official/data/repositories/interfaces/ITrading_journal_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/trading_journal/post/trading_journal_state.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';


class TradingJournalStateNotifier extends StateNotifier<TradingJournalState> {
  TradingJournalStateNotifier(this._tradingJournalRepository)
      : super(TradingJournalState.initial());

  final ITradingJournalRepository _tradingJournalRepository;

//Post data and getting ID passing to model
  Future<void> postTradingJournal(TradingJournalModel model) async {
   
    try {
     
      if (state.tradingJournalResponse == null) {
        state = TradingJournalState.loading(null, true);
      }

      final postTradingJournal =
          await _tradingJournalRepository.postTradingJournal(model);

      TradingJournalModel customModel = model;
      customModel.id = postTradingJournal.id;

      List<TradingJournalModel> tradingJournalResponse = [
        customModel,
        ...state.tradingJournalResponse ?? []
      ];

      state = TradingJournalState.success(tradingJournalResponse);
    } catch (e) {
      state = TradingJournalState.error(state.error);
    }
  }

  Future<void> emptyTradingJournal() async {
    state = TradingJournalState.empty();
  }

  // GET provider
  Future<void> getTradingJournalList(int pageNumber) async {
    final UserSecureStorageService commonDetails = UserSecureStorageService();
    try {
// 
      if (pageNumber == 1) {
        state = TradingJournalState.loading(null, true);
      } else {
        state =
            TradingJournalState.loading(state.tradingJournalResponse, false);
      }

      final String mobileUserPublicKey = await commonDetails.getPublicKey();
     
      final List<TradingJournalModel> tradingJournalList =
          await _tradingJournalRepository.getTradingJournalList(
              mobileUserPublicKey, pageNumber);
      // 
      if (pageNumber == 1) {
        state = TradingJournalState.success(
          tradingJournalList,
        );
      } else {
        state = TradingJournalState.success([
          ...state.tradingJournalResponse ?? [],
          ...tradingJournalList,
        ]);
      }
    } catch (e) {
      state = TradingJournalState.error(e.toString());
    }
  }

  List<TradingJournalModel> updateJournalInList(List<TradingJournalModel> list,
      TradingJournalModel updatedModel, String actions) {
    List<TradingJournalModel> updatedList = [...list];

    final index = list.indexWhere((journal) => journal.id == updatedModel.id);

    if (index != -1) {
      switch (actions) {
        case 'edit':
          updatedList[index] = updatedModel;

          break;
        case 'delete':
          updatedList.removeAt(index);
          break;
        default:
          break;
      }
    }
    return updatedList;
  }

  Future<void> editTradingJournalList(TradingJournalModel model) async {
    try {
      if (state.tradingJournalResponse == null) {
        state = TradingJournalState.loading(null, true);
      }

      await _tradingJournalRepository.postEditJournal(model);
     //
      state = TradingJournalState.success(updateJournalInList(
          state.tradingJournalResponse ?? [], model, 'edit'));
    } catch (e) {
      state = TradingJournalState.error(e.toString());
    }
  }

  Future<void> deleteTradingJournalList(int id) async {
    try {
      if (state.tradingJournalResponse == null) {
        state = TradingJournalState.loading(null, true);
      }

      await _tradingJournalRepository.deleteTradingJournal(id);

      state = TradingJournalState.success(updateJournalInList(
          state.tradingJournalResponse ?? [],
          TradingJournalModel(id: id),
          'delete'));
    } catch (e) {
      state = TradingJournalState.error(e.toString());
    }
  }

  Future<void> getDownloadJournalList(DateTime start, DateTime end) async {

    final UserSecureStorageService commonDetails = UserSecureStorageService();
    try {

      state = TradingJournalState.downloadingData(
        state.tradingJournalResponse,
      );

      final String mobileUserPublicKey = await commonDetails.getPublicKey();

      final List<TradingJournalModel> tradingJournalDataList =
          await _tradingJournalRepository.getDownloadJournalList(
              mobileUserPublicKey, start, end);

      state = TradingJournalState.download(
        existingResponse: state.tradingJournalResponse,
        downloadResponse: tradingJournalDataList,
      );
    } catch (e) {
      state = TradingJournalState.error(e.toString());
    }
  }
}

//StateNotifierProvider
final tradingJournalStateNotifierProvider =
    StateNotifierProvider<TradingJournalStateNotifier, TradingJournalState>(
        (ref) {
  final ITradingJournalRepository tradingJournalRepository =
      getIt<ITradingJournalRepository>();
  return TradingJournalStateNotifier(tradingJournalRepository);
});

class PaginationStateNotifier extends StateNotifier<int> {
  PaginationStateNotifier() : super(0); // Initial state as false

  void updatePageNumber(int value) {
    state = value;
  }
}

final paginationStateNotifierProvider =
    StateNotifierProvider<PaginationStateNotifier, int>((ref) {
  return PaginationStateNotifier();
});
