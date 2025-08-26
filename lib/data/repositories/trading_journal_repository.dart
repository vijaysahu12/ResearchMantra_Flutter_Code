

import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/trading_journal/trading_journal_model.dart';

import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ITrading_journal_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import 'package:research_mantra_official/utils/utils.dart';

class TradingJournalRepository implements ITradingJournalRepository {
  final HttpClient _httpClient = getIt<HttpClient>();
  final UserSecureStorageService _commonDetails = UserSecureStorageService();

  // Posting trading journal into DB
  @override
  Future<TradingJournalModel> postTradingJournal(
      TradingJournalModel model) async {
    try {
      //
      final response =
          await _httpClient.post(tradingJournalApiPost, model.toJson());
      if (response.statusCode == 200) {
        final journalResponse = TradingJournalModel.fromJson(response.data);
        ToastUtils.showToast('Journal Added Successfully', '');
        // 
        return journalResponse;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //Get method for List
  @override
  Future<List<TradingJournalModel>> getTradingJournalList(
      String mobileUserPublicKey, int pageNumber) async {

    final String mobileUserPublicKey = await _commonDetails.getPublicKey();

    try {
      final response = await _httpClient.get(
        "$tradingJournalApiGet?PrimaryKey=$mobileUserPublicKey&PageSize=3&PageNumber=$pageNumber",
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        final List<TradingJournalModel> journalList = responseData
            .map((journalList) => TradingJournalModel.fromJson(journalList))
            .toList();
        return journalList;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //Get method for List
  @override
  Future<void> postEditJournal(TradingJournalModel model) async {
    try {
      final response =
          await _httpClient.post(tradingJournalApiPost, model.toJson());
      if (response.statusCode == 200) {
        ToastUtils.showToast('Journal Updated Successfully', '');
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Delete Trading Journal Record

  @override
  Future<void> deleteTradingJournal(int id) async {
    try {
      final response = await _httpClient.delete("$tradingJournalApiDelete/$id");
      if (response.statusCode == 200 && response.data != null) {
        final responseMessage = response.message;
        ToastUtils.showToast(responseMessage, '');
        // return journalList;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //Download Journal Report
  @override
  Future<List<TradingJournalModel>> getDownloadJournalList(
      String mobileUserPublicKey, DateTime start, DateTime end) async {
 
     final fromDate = Utils.formatDateTime(dateTimeString: start.toString(), format: mmddyy);  
    final endDate = Utils.formatDateTime(dateTimeString: end.toString(), format: mmddyy); 
    try {
     
    
      final response = await _httpClient.get(
        "$tradingJournalApiGet?PrimaryKey=$mobileUserPublicKey&FromDate=$fromDate&ToDate=$endDate",
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        final List<TradingJournalModel> journalListDownload = responseData
            .map((journalList) => TradingJournalModel.fromJson(journalList))
            .toList();
        return journalListDownload;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
