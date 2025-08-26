import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/providers/notifications/notificationcategory/notification_category_state.dart';
import '../../../../providers/notifications/notificationcategory/notification_category_provider.dart';
import '../../../../providers/notifications/notificationmain/notification_provider.dart';

//NotificationCategories list widget
class NotificationCategoryList extends StatelessWidget {
  final WidgetRef ref;
  final NotificationCategoryState categoriesListState;
  final Function onCategoryChanged;

   NotificationCategoryList({ 
    super.key,
    required this.ref,
    required this.categoriesListState,
    required this.onCategoryChanged,
  });
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 60,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: categoriesListState.categories.length,
        itemBuilder: (context, index) {
          final category = categoriesListState.categories[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                final int categoryId = category.id;
                onCategoryTap(ref, categoryId.toString(), category);
                //based on selected category it will scroll ;
                final int selectedIndex =
                    categoriesListState.categories.indexOf(category);
                final double targetOffset = selectedIndex * 90.0;

                _scrollController.animateTo(
                  targetOffset,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor:
                    categoriesListState.selectedCategory!.id == category.id
                        ? theme.primaryColorLight
                        : theme.focusColor,
              ),
              child: Text(
                category.name,
                style: TextStyle(
                    color:
                        categoriesListState.selectedCategory!.id == category.id
                            ? theme.primaryColor
                            : theme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }

// Function for select category
  void onCategoryTap(WidgetRef ref, String categoryId, category) {
    ref
        .read(notificationsCategoryProvider.notifier)
        .updateSelectedCategory(category);
    ref
        .read(notificationsProvider.notifier)
        .fetchNotifications(categoryId, 1, true ,false) ;
    onCategoryChanged(int.parse(categoryId));
  }
}
