import 'package:flutter/material.dart';
import 'package:research_mantra_official/data/models/notifications/notification_response_model.dart';
import 'package:research_mantra_official/ui/components/empty_notification/empty_notification.dart';
import 'package:research_mantra_official/ui/themes/light_theme.dart';

class TradingNotificationListWidget extends StatelessWidget {
  final List<NotificationModel>
      notifications; // List of notifications to display
  final VoidCallback
      onReachEnd; // Callback function when reaching the end of the list
  final bool
      isLoadingMore; // Flag to indicate whether more items are being loaded
  final ScrollController _scrollController =
      ScrollController(); // Scroll controller to handle list scrolling
  final Function(String) onNotificationTap; // function for notification read ;

  TradingNotificationListWidget(
      {super.key,
      required this.notifications,
      required this.onReachEnd,
      required this.isLoadingMore,
      required this.onNotificationTap}) {
    _scrollController
        .addListener(_scrollListener); // Add listener to scroll controller
  }

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const NotificationEmptyWidget();
    }
    return ListView.builder(
      itemCount: notifications.length +
          (isLoadingMore ? 1 : 0), // Adjust item count based on loading state
      itemBuilder: (context, index) {
        final bool? isRead =
            index < notifications.length ? notifications[index].isRead : false;

        return _buildNotificationsList(index, isRead);
      },
      controller: _scrollController, // Assign scroll controller to the ListView
    );
  }

  // Widget to build the notification List
  Widget _buildNotificationsList(int index, bool? isRead) {
    return GestureDetector(
      onTap: () {
        final String? notificationId = notifications[index].objectId;
        onNotificationTap(notificationId!);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isRead ?? true ? Colors.white : lightTheme.shadowColor,
          border: Border(
            bottom: BorderSide(
              color: lightTheme.shadowColor,
              width: 0.4,
            ),
          ),
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 2,
          // horizontal: 8,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 12,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${notifications[index].title}",
                            style: TextStyle(
                              fontSize: 14,
                              color: lightTheme.primaryColorDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${notifications[index].message}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          "${notifications[index].topic}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Scroll listener function to detect reaching the end of the list
  void _scrollListener() {
    if (_scrollController.position.extentAfter == 0 && !isLoadingMore) {
      onReachEnd(); // Call onReachEnd function when reaching the end
    }
  }
}
