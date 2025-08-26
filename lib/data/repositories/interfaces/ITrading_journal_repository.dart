import 'package:research_mantra_official/data/models/trading_journal/trading_journal_model.dart';


abstract class ITradingJournalRepository {
  //This method used to post value along with mobileUserPublicKey
  Future<TradingJournalModel> postTradingJournal(TradingJournalModel model);
  Future<List<TradingJournalModel>> getTradingJournalList(
      String mobileUserPublicKey, int pageNumber);
  Future<void> postEditJournal(TradingJournalModel model);

  Future<void> deleteTradingJournal(int id);

  Future<List<TradingJournalModel>> getDownloadJournalList(
      String mobileUserPublicKey, DateTime start, DateTime end);
}
