import 'package:research_mantra_official/data/models/common_api_response.dart';
import 'package:research_mantra_official/data/models/notifications/notification_category_response_model.dart';
import 'package:research_mantra_official/data/models/notifications/notification_response_model.dart';

// InterFace for Notifications
abstract class INotificationRepository {
  //Get All Notifications
  Future<List<NotificationModel>> getNotifications(
      String categoryId, int page, int perPage, String mobileUserPublicKey,bool showUnread);

  //Loadmore method for loading more Notifactions
  Future<List<NotificationModel>> loadMoreNotifications(
      int page, int perPage, String mobileUserPublicKey, String categoryId,bool showUnread);

  //This method manages the read  action for the Notification identified by [productId].
  Future<dynamic> manageNotificationReadUnread(String id);

//get product categories
  Future<List<NotificationCategoryResponseModel>> getProductCategories();

  //get notification unRead count
  Future getNotificationsCount(String mobileUserPublicKey);

  Future<CommonHelperResponseModel> manageProductNotifications(
      bool isToggleNotification, String mobileUserPublicKey, int productId);

  //This method manages the read  action for the Notification identified by [productId].
  Future<dynamic> manageNotificationDelete(String id);

  //Method to validate the product validity for the user
  Future<bool> checkProductValidity(int productId);
  //Method to validate the product validity for the user
  Future<bool> markAllNotificationRead();
}
