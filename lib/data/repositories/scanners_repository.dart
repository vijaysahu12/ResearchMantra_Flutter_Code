import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/get_subscription_data/subscription_topics_model.dart';
import 'package:research_mantra_official/data/models/scanners/scanners_model.dart';
import 'package:research_mantra_official/data/models/scanners/scanners_strategies_response_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/models/scanners/scanners_response_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IScanners_repository.dart';
import 'package:research_mantra_official/main.dart';

class ScannersRepository implements IScannersRepository {
  final HttpClient _httpClient = getIt<HttpClient>();

  //Method to get all the scanners Notifications
  @override
  Future<List<ScannersResponseModel>> getScannersNotification(
      int pageSize,
      int pageNumber,
      dynamic primaryKey,
      String fromDate,
      String toDate,
      dynamic loggedInUser) async {
    try {
      Map<String, dynamic> body = {
        "pageSize": pageSize,
        "pageNumber": pageNumber,
        "primaryKey": primaryKey,
        "fromDate": fromDate,
        "toDate": toDate,
        "loggedInUser": loggedInUser
      };

      final response = await _httpClient.post(getScannerNotification, body);

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> allTheScannersData = response.data;
        final List<ScannersResponseModel> scannersNotificationDetails =
            allTheScannersData
                .map((data) => ScannersResponseModel.fromJson(data))
                .toList();
        return scannersNotificationDetails;
      } else {
        return [];
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

//Method for getTodayScannerNotification
  @override
  Future<ScannerNotificationResponseModel> getTodayScannerNotification(
      String? id) async {
    try {
      final response =
          await _httpClient.get("$getTodayScannerNotificationApi?Ids=$id");

      if (response.statusCode == 200) {
        final dynamic allTheScannersData = response.data;

        final ScannerNotificationResponseModel scannersNotificationDetails =
            ScannerNotificationResponseModel.fromJson(allTheScannersData);

        return scannersNotificationDetails;
      } else {
        throw Exception(
            "Failed to fetch data, Status Code: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

//Method to get load more scanners
  @override
  Future<List<ScannersResponseModel>> loadMoreScannerNotifications(
      int pageSize,
      int pageNumber,
      dynamic primaryKey,
      String fromDate,
      String toDate,
      dynamic loggedInUser) async {
    try {
      Map<String, dynamic> body = {
        "pageSize": pageSize,
        "pageNumber": pageNumber,
        "primaryKey": primaryKey,
        "fromDate": fromDate,
        "toDate": toDate,
        "loggedInUser": loggedInUser
      };
      final response = await _httpClient.post(getScannerNotification, body);

      if (response.statusCode == 200) {
        final List<dynamic> allTheScannersData = response.data;
        final List<ScannersResponseModel> scannersNotificationDetails =
            allTheScannersData
                .map((data) => ScannersResponseModel.fromJson(data))
                .toList();
        return scannersNotificationDetails;
      } else {
        throw Exception('Failed to load tickets: ${response.message}');
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

//Method to get all strategies
  @override
  Future<List<GetStrategiesResponseModel>> getScannersStratgies(
      String stratgyName) async {
    try {
      final response = await _httpClient
          .get('$getScannersStrategies?strategyName=$stratgyName');

      if (response.statusCode == 200) {
        final List<dynamic> getStrategies = response.data;

        final List<GetStrategiesResponseModel> getAllScannersStrategies =
            getStrategies
                .map((data) => GetStrategiesResponseModel.fromJson(data))
                .toList();

        return getAllScannersStrategies;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

//Method to get the All active Subscription Topics list
  @override
  Future<List<GetMyActiveSubscriptionModel>> getActiveSubscriptionTopics(
      String mobileUserKey) async {
    try {
      final response = await _httpClient
          .get("$getMyActiveSubscriptionApi?mobileUserKey=$mobileUserKey");

      if (response.statusCode == 200) {
        final List<dynamic> getAllActiveTopics = response.data;
        final List<GetMyActiveSubscriptionModel>
            getAllActiveSubscriptionTopicsList = getAllActiveTopics
                .map((data) => GetMyActiveSubscriptionModel.fromJson(data))
                .toList();
        return getAllActiveSubscriptionTopicsList;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
