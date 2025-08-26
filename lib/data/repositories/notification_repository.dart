import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/common_api_response.dart';
import 'package:research_mantra_official/data/models/notifications/notification_category_response_model.dart';
import 'package:research_mantra_official/data/models/notifications/notification_response_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/INotification_repository.dart';
import 'package:research_mantra_official/main.dart';


import 'package:research_mantra_official/utils/toast_utils.dart';

// [NotificationRepository] implements [INotificationRepository].
class NotificationRepository implements INotificationRepository {
  final HttpClient _httpClient = getIt<HttpClient>();

  @override
  Future<List<NotificationModel>> getNotifications(String categoryId, int page,
      int perPage, String mobileUserPublicKey, bool showUnread) async {
    try {
      //post request body
      final data = {
        "categoryId": categoryId,
        "mobileUserKey": mobileUserPublicKey,
        "pageSize": perPage,
        "pageNumber": page,
        "showUnread": showUnread,
      };

// Make HTTP post request to get all notification list
      final response = await _httpClient.post(getNotificationsUrl, data);

      if (response.statusCode == 200) {
        final List<dynamic> notificationData = response.data;

        final List<NotificationModel> newNotifications = notificationData
            .map((notification) => NotificationModel.fromJson(notification))
            .toList();

        return newNotifications;
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      throw Exception('Failed to load notifications: $e');
    }
  }

  @override
  Future<List<NotificationModel>> loadMoreNotifications(int page, int perPage,
      String mobileUserPublicKey, String categoryId, bool showUnread) async {
    try {
      //post request body
      final data = {
        "categoryId": categoryId,
        "mobileUserKey": mobileUserPublicKey,
        "pageSize": perPage,
        "pageNumber": page,
        "showUnread": showUnread,
      };

      // Make HTTP Post request to load more Notifications
      final response = await _httpClient.post(getNotificationsUrl, data);
      if (response.statusCode == 200) {
        final List<dynamic> notificationData = response.data;

        final List<NotificationModel> newNotifications = notificationData
            .map((notification) => NotificationModel.fromJson(notification))
            .toList();

        return newNotifications;
      } else {
        throw Exception('Failed to load more notifications');
      }
    } catch (e) {
      throw Exception('Failed to load more notifications: $e');
    }
  }

  @override
  Future<dynamic> manageNotificationReadUnread(String id) async {
    try {
      final notificationId = {"id": id};

      //manage read action by notification id
      final response =
          await _httpClient.post(markNotificationsIsRead, notificationId);
      if (response.statusCode == 200) {
        return {"status": true};
      } else {
        print("${response.message}:${response.statusCode}");
        return {"status": false};
      }
    } catch (e) {
      print(e);
      return {"status": false};
    }
  }

// List of categories getting from categoryApi
  @override
  Future<List<NotificationCategoryResponseModel>> getProductCategories() async {
    try {
      //Make http Call to get All Notification categories
      final response = await _httpClient.get(getProductCategoriesApi);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        // Assuming NotificationCategoryResponseModel has a factory method for conversion
        final List<NotificationCategoryResponseModel> notificationCategories =
            data
                .map((json) => NotificationCategoryResponseModel.fromJson(json))
                .toList();

        //Inserting all category Button data manually , {all} is not availble in category response,
        final NotificationCategoryResponseModel allCategories =
            NotificationCategoryResponseModel(id: 0, name: "All");
        notificationCategories.insert(0, allCategories);

        return notificationCategories;
      } else {
        // Handle non-200 status code

        throw Exception(
            "Failed to load categories. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // Handle exceptions

      throw Exception("Exception while loading categories: $e");
    }
  }

  //Notifications UnreadCount
  @override
  Future getNotificationsCount(String mobileUserPublicKey) async {
    try {
      //Make Http call to get Notification unRead Count number
      final response = await _httpClient
          .get("$getUnreadNotificationCount?userKey=$mobileUserPublicKey");
      final data = response.data;
      return data;
    } catch (ex) {
      throw Exception(ex);
    }
  }

  @override
  Future<CommonHelperResponseModel> manageProductNotifications(
      bool isToggleNotification,
      String mobileUserPublicKey,
      int productId) async {
    try {
      Map<dynamic, dynamic> body = {
        "AllowNotify": isToggleNotification,
        "mobileUserKey": mobileUserPublicKey,
        "productId": productId,
      };
      final response =
          await _httpClient.post(manageProductNotificationsApi, body);

      final result = CommonHelperResponseModel.fromJson(response);
      return result;
    } catch (error) {
      throw Exception("Failed to manage blog post. Please try again later.");
    }
  }

  @override
  Future<dynamic> manageNotificationDelete(String id) async {
    try {
      //manage read action by notification id
      final response = await _httpClient.delete(
        "$manageNotificationDeleteApi?notificationId=$id",
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print("${response.message}:${response.statusCode}");
        return false;
      }
    } catch (e) {
      return false;
    }
  }

//Method to validate the product validity for the user
  @override
  Future<bool> checkProductValidity(int productId) async {
    try {
      final response = await _httpClient.get(
        "$checkProductValidityApi?productId=$productId",
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data) {
          //If data is true then return false means alredy have subscription
          return false;
        } else {
          return true;
        }
      } else {
        return true;
      }
    } catch (e) {
      return true;
    }
  }

  @override
  Future<bool> markAllNotificationRead() async {
    try {

      final response = await _httpClient.get(
        markNotificationAllRed,
      );
      if (response.statusCode == 200) {

        ToastUtils.showToast(
        response.message, '');
    
        return response.data;
      } else {
            ToastUtils.showToast(
        response.message, '');
        return false;
      }
    } catch (e) {
      throw Exception("Something went wrong ,Please Try again later.");
    }
  }
}
