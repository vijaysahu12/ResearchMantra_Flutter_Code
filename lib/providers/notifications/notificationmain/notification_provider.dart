// ignore_for_file: prefer_interpolation_to_compose_strings
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/notifications/notification_response_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/INotification_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import 'notification_state.dart';

/// [NotificationsNotifier] manages the state and logic related to notifications.
class NotificationsNotifier extends StateNotifier<NotificationState> {
  NotificationsNotifier(this._repository) : super(NotificationState.initial());

  final INotificationRepository _repository;
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  int _page = 1;
  final int _perPage = 15;
  String _categoryId = "0";

  /// Fetch notifications from the repository.
  Future<void> fetchNotifications(String categoryid, int pageNumber,
      bool isRefresh, bool showUnread) async {
    try {
      final String mobileUserPublicKey = await _commonDetails.getPublicKey();
      _page = pageNumber;
      _categoryId = categoryid;

      if (state.notifications.isEmpty && !isRefresh) {
        // Set the state to loading before resetting the notification list
        state = NotificationState.loading();
      } else if (isRefresh == true) {
        state = NotificationState.loading();
      }

      final List<NotificationModel> newNotifications =
          await _repository.getNotifications(
              categoryid, _page, _perPage, mobileUserPublicKey, showUnread);

      if (newNotifications.isEmpty) {
        // Set the state to loaded if there's no new data
        state = NotificationState.loaded(state.notifications);
      } else {
        // Set the state to loaded with the new data
        state = NotificationState.loaded(newNotifications);
      }
    } catch (e) {
      state = NotificationState.error(e.toString());
    }
  }

  /// Load more notifications from the repository.
  Future<void> loadMoreNotifications(bool showunread) async {
    final String mobileUserPublicKey = await _commonDetails.getPublicKey();
    if (state.isLoadingMore) return;
    final int page = _page + 1;
    final List<NotificationModel> currentNotifications = state.notifications;
    state = NotificationState.loadingMore(currentNotifications);

    try {
      final List<NotificationModel> newNotifications =
          await _repository.loadMoreNotifications(
              page, _perPage, mobileUserPublicKey, _categoryId, showunread);
      final List<NotificationModel> allNotifications = [
        ...currentNotifications,
        ...newNotifications
      ];

      state = NotificationState.loaded(allNotifications);
      _page++;

      print("Page size is: $_page");
    } catch (e) {
      state = NotificationState.error(e.toString());
    }
  }

  /// manageNotificationReadUnread from the repository.
  Future<void> manageNotificationReadUnread(String id) async {
    if (state.isLoadingMore) return;
    try {
      // changing isRead state first then api calling
      state = NotificationState.isRead(state.notifications, id);

      var response = await _repository.manageNotificationReadUnread(id);
      print(response);
      if (response["status"]) {
        print("Notification read successfully!");
      } else {
        ToastUtils.showToast(
            "We are facing some issues while processing your request.",
            'error');
      }
    } catch (e) {
      state = NotificationState.error(e.toString());
    }
  }

  //Method to delete notification
  Future<void> manageNotificationDelete(String id, bool showunread) async {
    if (state.isDeleted) return;
    try {
      // // changing isRead state first then api calling
      state = NotificationState.loaded(state.notifications);

      var response = await _repository.manageNotificationDelete(id);

      if (response == true) {
        final updatedNotifications = state.notifications
            .where((notification) =>
                notification.objectId != id) // Compare with the passed id
            .toList();
        // If there are no notifications left or if it's the last notification,
        // load more notifications

        if (updatedNotifications.length <= 10) {
          if (updatedNotifications.isEmpty) {
            state = NotificationState.loaded([]);
          } else {
            state = NotificationState.loaded(updatedNotifications);
            await loadMoreNotifications(showunread);
          }
          // Fetch the next set of notifications
        } else {
          state = NotificationState.loaded(updatedNotifications);
        }

        print("Notification Deleted successfully!");
      } else {
        ToastUtils.showToast(somethingWentWrong, 'error');
      }
    } catch (e) {
      state = NotificationState.error(e.toString());
    }
  }

  /// Fetch notifications from the repository.
  Future<bool> markAsRead() async {
    try {
      List<NotificationModel> notification = state.notifications;
      state = NotificationState.loading();
      bool markAsReadResponse = await _repository.markAllNotificationRead();

      if (markAsReadResponse) {
        notification = notification.map((notification) {
          notification.isRead = true;
          return notification;
        }).toList();

        state = NotificationState.loaded(notification);
        return true;
      } else {
        state = NotificationState.loaded(notification);
        return false; // Failed to mark as read
      }
    } catch (e) {
      state = NotificationState.loaded(state.notifications);
      return false;
      // state = NotificationState.error(e.toString());
    }
  }

  // Future<void> showUnread() async {
  //   if (state.notifications.isNotEmpty) {
  //     List<NotificationModel> unreadNotifications = state.notifications
  //         .where((notification) => !(notification.isRead ?? false))
  //         .toList();

  //     state = NotificationState.loaded(unreadNotifications);
  //   }
  // }
}

/// Provider for [NotificationsNotifier].
final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationState>((ref) {
  final INotificationRepository notificationRepository =
      getIt<INotificationRepository>();
  return NotificationsNotifier(notificationRepository);
});
