import 'package:research_mantra_official/data/models/notifications/notification_category_response_model.dart';
import 'package:research_mantra_official/data/models/notifications/notification_response_model.dart';

//Manage the Notification State
class NotificationState {
  final List<NotificationModel> notifications;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isDeleted;

  final dynamic error;

  NotificationState({
    required this.notifications,
    required this.isLoading,
    required this.isLoadingMore,
    required this.isDeleted,
    this.error,
  });

//inital State
  factory NotificationState.initial() => NotificationState(
        notifications: [],
        isLoading: false,
        isLoadingMore: false,
        isDeleted: false,
      );

//Loading State
  factory NotificationState.loading() => NotificationState(
        notifications: [],
        isLoading: true,
        isLoadingMore: false,
        isDeleted: false,
      );

//LoadMore State
  factory NotificationState.loadingMore(
          List<NotificationModel> notifications) =>
      NotificationState(
        notifications: notifications,
        isLoading: false,
        isLoadingMore: true,
        isDeleted: false,
      );

//InitailLoad State
  factory NotificationState.firstTimeloaded(
          List<NotificationModel> notifications,
          List<NotificationCategoryResponseModel> categories) =>
      NotificationState(
        notifications: notifications,
        isLoading: false,
        isLoadingMore: false,
        isDeleted: false,
      );

//Loaded State
  factory NotificationState.loaded(
    List<NotificationModel> notifications,
  ) =>
      NotificationState(
        notifications: notifications,
        isLoading: false,
        isLoadingMore: false,
        isDeleted: false,
      );

//Error State
  factory NotificationState.error(dynamic error) => NotificationState(
        notifications: [],
        isLoading: false,
        isLoadingMore: false,
        error: error,
        isDeleted: false,
      );

//Notification Read State
  factory NotificationState.isRead(
    List<NotificationModel> notifications,
    String notificationId,
  ) {
    final updatedNotifications = notifications.map((notification) {
      if (notification.objectId == notificationId) {
        return notification.copyWith(isRead: true);
      }
      return notification;
    }).toList();

    return NotificationState(
      notifications: updatedNotifications,
      isLoading: false,
      isLoadingMore: false,
      isDeleted: false,
    );
  }

  // //Notification Read State
  // factory NotificationState.isDelete(
  //   List<NotificationModel> notifications,
  //   String notificationId,
  // ) {
  //   final updatedNotifications = notifications.map((notification) {
  //     if (notification.objectId == notificationId) {
  //       return notification.copyWith(isDelete: true);
  //     }
  //     return notification;
  //   }).toList();

  //   return NotificationState(
  //     notifications: updatedNotifications,
  //     isLoading: false,
  //     isLoadingMore: false,
  //     isDeleted: false,
  //   );
  // }
}
