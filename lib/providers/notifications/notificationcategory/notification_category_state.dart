import 'package:research_mantra_official/data/models/notifications/notification_category_response_model.dart';

// Manage the Notification Category State
class NotificationCategoryState {
  final List<NotificationCategoryResponseModel> categories;
  final NotificationCategoryResponseModel? selectedCategory;
  final bool isLoading;
  final dynamic error;

  NotificationCategoryState({
    required this.categories,
    required this.isLoading,
    this.error,
    this.selectedCategory,
  });

//Loading State
  factory NotificationCategoryState.loading() => NotificationCategoryState(
        categories: [],
        isLoading: true,
      );

//Loaded/Success State
  factory NotificationCategoryState.loaded(
    List<NotificationCategoryResponseModel> categories, {
    NotificationCategoryResponseModel? selectedCategory,
  }) =>
      NotificationCategoryState(
        categories: categories,
        isLoading: false,
        selectedCategory: selectedCategory,
      );

//Error State
  factory NotificationCategoryState.error(dynamic error) =>
      NotificationCategoryState(
        categories: [],
        isLoading: false,
        error: error,
      );

  // CopyWith method to update the selected category
  NotificationCategoryState copyWith({
    List<NotificationCategoryResponseModel>? categories,
    bool? isLoading,
    dynamic error,
    NotificationCategoryResponseModel? selectedCategory,
  }) {
    return NotificationCategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
