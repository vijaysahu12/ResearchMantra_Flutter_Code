
import 'package:research_mantra_official/data/models/trading_journal/trading_journal_model.dart';


class TradingJournalState {
  
  final bool isLoading;
  final dynamic error;
  final List<TradingJournalModel>? tradingJournalResponse;
  final List<TradingJournalModel>? tradingJournalDownloadResponse;
  final bool  isdownloadLoading;

  TradingJournalState(
      {required this.isLoading,


     required this.isdownloadLoading,
      required this.error,
      required this.tradingJournalResponse,
      this.tradingJournalDownloadResponse,});

  factory TradingJournalState.initial() => TradingJournalState(
      isLoading: false, error: null, tradingJournalResponse: null, isdownloadLoading: false);

  factory TradingJournalState.loading(List<TradingJournalModel>? tradingJournalResponse ,  bool? isLoading) => TradingJournalState(
      isLoading:isLoading?? true, error: null, tradingJournalResponse: tradingJournalResponse, isdownloadLoading: false);





  factory TradingJournalState.downloadingData(List<TradingJournalModel>? tradingJournalResponse ,  ) => TradingJournalState(
      isLoading:false, error: null, tradingJournalResponse: tradingJournalResponse, isdownloadLoading: true);
  factory TradingJournalState.success(
          List<TradingJournalModel> tradingJournalMessageResponse) =>
      TradingJournalState(
          isLoading: false,
          error: null,
          tradingJournalResponse: tradingJournalMessageResponse, isdownloadLoading: false);
  factory TradingJournalState.download({
  required List<TradingJournalModel>? existingResponse,
  required List<TradingJournalModel> downloadResponse,
}) =>
    TradingJournalState(
      isLoading: false,
      error: null,
      tradingJournalResponse: existingResponse,
      tradingJournalDownloadResponse: downloadResponse, isdownloadLoading: false,
    );


  factory TradingJournalState.error(dynamic error) => TradingJournalState(
      isLoading: false, error: error, tradingJournalResponse: null, isdownloadLoading: false);
  factory TradingJournalState.empty() => TradingJournalState(
      isLoading: false, error: null, tradingJournalResponse: null, isdownloadLoading: false);
}
