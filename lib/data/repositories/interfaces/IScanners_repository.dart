import 'package:research_mantra_official/data/models/get_subscription_data/subscription_topics_model.dart';
import 'package:research_mantra_official/data/models/scanners/scanners_model.dart';
import 'package:research_mantra_official/data/models/scanners/scanners_response_model.dart';
import 'package:research_mantra_official/data/models/scanners/scanners_strategies_response_model.dart';

abstract class IScannersRepository {
  Future<List<ScannersResponseModel>> getScannersNotification(
      int pageSize,
      int pageNumber,
      dynamic primaryKey,
      String fromDate,
      String toDate,
      dynamic loggedInUser);

  Future<List<ScannersResponseModel>> loadMoreScannerNotifications(
      int pageSize,
      int pageNumber,
      dynamic primaryKey,
      String fromDate,
      String toDate,
      dynamic loggedInUser);

  Future<List<GetStrategiesResponseModel>> getScannersStratgies(
      String stratgyName);

  Future<List<GetMyActiveSubscriptionModel>> getActiveSubscriptionTopics(
      String mobileUserKey);

  Future<ScannerNotificationResponseModel> getTodayScannerNotification(String ? id);
}
