import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/repositories/interfaces/INotification_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/notifications/notificationcount/notification_count_state.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';

//Notifier for Notification Count
class NotificationCountNotifier extends StateNotifier<NotificationCountState> {
  final INotificationRepository _countRepository;

  NotificationCountNotifier(this._countRepository)
      : super(NotificationCountState.initial());

  final UserSecureStorageService _commonDetails = UserSecureStorageService();

//get Notification unRead count
  void getNotificationUnreadCount() async {
    final String mobileUserPublicKey = await _commonDetails.getPublicKey();
    // state = NotificationCountState.loading();
    try {
      final unReadCount =
          await _countRepository.getNotificationsCount(mobileUserPublicKey);
      state = NotificationCountState.success(unReadCount ?? 0);
    } catch (error) {
      state = NotificationCountState.error(error.toString());
    }
  }
  void updateNotificationCount(int? count) async {
 
    try {
 
      state = NotificationCountState.success(count ?? 0);
    } catch (error) {
      state = NotificationCountState.error(error.toString());
    }
  }
}

///Provider for NotificationCount;
final notificationunReadCountProvider =
    StateNotifierProvider<NotificationCountNotifier, NotificationCountState>(
        (ref) {
  final INotificationRepository notificationRepository =
      getIt<INotificationRepository>();
  return NotificationCountNotifier(notificationRepository);
});
