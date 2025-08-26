// notification_category_notifier.dart

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/notifications/notification_category_response_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/INotification_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'notification_category_state.dart';

//Notifier for Notification category
class NotificationCategoryNotifier
    extends StateNotifier<NotificationCategoryState> {
  NotificationCategoryNotifier(this._repository)
      : super(NotificationCategoryState.loading());

  final INotificationRepository _repository;

//get all categories
  Future<void> getCategories() async {
    try {
      state = NotificationCategoryState.loading();

      final List<NotificationCategoryResponseModel> categories =
          await _repository.getProductCategories();

      // Get the selected category, you can change this based on your logic
      final selectedCategory = categories.isNotEmpty ? categories.first : null;

      state = NotificationCategoryState.loaded(categories,
          selectedCategory:
              selectedCategory); // Update state with selected category
    } catch (e) {
      state = NotificationCategoryState.error(e.toString());
    }
  }

  // Function to update the selected category
  void updateSelectedCategory(NotificationCategoryResponseModel category) {
    state = state.copyWith(selectedCategory: category);
  }
}

//Provider for Notification categories
final notificationsCategoryProvider = StateNotifierProvider<
    NotificationCategoryNotifier, NotificationCategoryState>((ref) {
  final INotificationRepository notificationCategoryRepository =
      getIt<INotificationRepository>();
  return NotificationCategoryNotifier(notificationCategoryRepository);
});
