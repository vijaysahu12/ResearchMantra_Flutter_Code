import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:research_mantra_official/data/models/notifications/notification_response_model.dart';
import 'package:research_mantra_official/services/url_launcher_helper.dart';
import 'package:research_mantra_official/ui/components/common_text_checker/text_checker.dart';
import 'package:research_mantra_official/ui/components/empty_notification/empty_notification.dart';

import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationListWidget extends StatefulWidget {
  final List<NotificationModel>
      notifications; // List of notifications to display
  final VoidCallback
      onReachEnd; // Callback function when reaching the end of the list
  final bool
      isLoadingMore; // Flag to indicate whether more items are being loaded

  final Function(String) onNotificationTap; // Function for notification tap
  final VoidCallback onPullToRefresh; // Function for pull-to-refresh
  final void Function(String notificationId) onDeleteNotification;
  bool showUnreadOnly;
  NotificationListWidget({
    super.key,
    required this.notifications,
    required this.onReachEnd,
    required this.isLoadingMore,
    required this.onPullToRefresh,
    required this.onNotificationTap,
    required this.onDeleteNotification,
    required this.showUnreadOnly,
  });

  @override
  State<NotificationListWidget> createState() => _NotificationListWidgetState();
}

class _NotificationListWidgetState extends State<NotificationListWidget> {
  bool _isNavigationInProgress = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController
        .addListener(_scrollListener); // Add listener to scroll controller
  }

  @override
  Widget build(BuildContext context) {
    if (widget.notifications.isEmpty) {
      return const NotificationEmptyWidget();
    }

    return RefreshIndicator(
      onRefresh: () async {
        widget.onPullToRefresh();
        await Future.delayed(const Duration(seconds: 2));
      },
      child: ListView.builder(
        physics:
            const AlwaysScrollableScrollPhysics(), // Ensure the list is always scrollable
        itemCount: widget.notifications.length +
            (widget.isLoadingMore
                ? 1
                : 0), // Adjust item count based on loading state
        itemBuilder: (context, index) {
          if (index == widget.notifications.length) {
            return _buildLoadMoreIndicator(
                context); // Show load more indicator at the end of the list
          } else {
            return _buildNotificationsList(
                index, widget.notifications[index].isRead, context);
          }
        },
        controller:
            _scrollController, // Assign scroll controller to the ListView
      ),
    );
  }

  // Widget to build the load more indicator
  Widget _buildLoadMoreIndicator(context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: widget.onReachEnd, // Call onReachEnd function when tapped
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
                height: 15, width: 15, child: CircularProgressIndicator()),
            const SizedBox(width: 10),
            Text(
              'Loading...', // Display loading text
              style: TextStyle(
                  color: theme.primaryColorDark, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build the notification list
  Widget _buildNotificationsList(int index, bool? isRead, context) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.height;
    final isNotificationType = widget.notifications[index].topic;
    return InkWell(
      onTap: () async {
        final String? notificationId = widget.notifications[index].objectId;
        widget.onNotificationTap(notificationId!);

        if (_isNavigationInProgress) return; // Prevent multiple taps

        setState(() {
          _isNavigationInProgress = true; // Set the flag before navigating
        });

        final String productName =
            widget.notifications[index].productName ?? 'King Research';
        final dynamic productId = widget.notifications[index].productId;

        if (widget.notifications[index].screenName.isNotEmpty) {
          UrlLauncherHelper.handleToNavigatePathScreen(
              context,
              widget.notifications[index].screenName,
              productId,
              productName,
              false);
        }
        // Introduce a short delay to prevent rapid multiple taps
        await Future.delayed(Duration(seconds: 1));

        if (mounted) {
          setState(() {
            _isNavigationInProgress =
                false; // Reset the flag only after navigation completes
          });
        }
      },
      child: Slidable(
        endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.2,
            children: [
              SlidableAction(
                onPressed: (context) {
                  widget.onDeleteNotification(
                      widget.notifications[index].objectId!);
                },
                backgroundColor: theme.disabledColor.withOpacity(0.2),
                foregroundColor: theme.disabledColor,
                icon: Icons.delete,
              ),
            ]),
        child: Container(
          decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: theme.shadowColor, width: 1)),
            color: isRead ?? true
                ? theme.primaryColor
                : theme.shadowColor.withOpacity(0.2),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 4,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Aligns content to the top
                        children: [
                          Expanded(
                            flex: 3, // Give title more space if needed
                            child: Text(
                              "${widget.notifications[index].title}",
                              style: TextStyle(
                                fontSize: fontSize * 0.016,
                                fontWeight: FontWeight.bold,
                                color: (!isRead!)
                                    ? theme.primaryColorDark
                                    : theme.primaryColorDark.withOpacity(0.5),
                                fontFamily: fontFamily,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  // Show topic if it's not "announcement"
                                  if (isNotificationType!.toLowerCase() !=
                                      "announcement")
                                    Text(
                                      isNotificationType, // Display the topic name
                                      style: TextStyle(
                                          fontSize: fontSize * 0.012,
                                          fontWeight: FontWeight.w600,
                                          color: (!isRead)
                                              ? theme.primaryColorDark
                                              : theme.primaryColorDark
                                                  .withOpacity(0.6),
                                          fontFamily: fontFamily),
                                    ),

                                  // Show the date only if the notification type is "announcement"
                                  if (isNotificationType.toLowerCase() ==
                                      "announcement")
                                    Text(
                                      "${widget.notifications[index].createdOn}",
                                      style: TextStyle(
                                          fontSize: fontSize * 0.012,
                                          color: (!isRead)
                                              ? theme.primaryColorDark
                                              : theme.primaryColorDark
                                                  .withOpacity(0.6),
                                          fontFamily: fontFamily),
                                    ),

                                  // Spacer between the topic/date and pin icon
                                  const SizedBox(
                                    width: 4,
                                  ),

                                  // Show the pin icon if the notification is pinned
                                  Visibility(
                                    visible:
                                        widget.notifications[index].isPinned ==
                                            true,
                                    child: Icon(Icons.push_pin_rounded,
                                        color: theme.disabledColor, size: 20),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  if (!isRead)
                                    Container(
                                      height: 8,
                                      width: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: theme.disabledColor,
                                      ),
                                    ),
                                ],
                              ),

                              // Show the date again if the notification type is not "announcement"
                              if (isNotificationType.toLowerCase() !=
                                  "announcement")
                                Text(
                                  "${widget.notifications[index].createdOn} ",
                                  style: TextStyle(
                                      fontSize: fontSize * 0.012,
                                      color: (!isRead)
                                          ? theme.primaryColorDark
                                          : theme.primaryColorDark
                                              .withOpacity(0.6),
                                      fontFamily: fontFamily),
                                ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                  children: CommonTextChecker().getStyledText(
                                    widget.notifications[index].message ?? '',
                                    (!isRead)
                                        ? theme.focusColor
                                        : theme.focusColor.withOpacity(0.6),
                                    fontFamily,
                                    fontSize: fontSize * 0.013,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      String message =
                                          widget.notifications[index].message ??
                                              '';
                                      if (message.startsWith("http")) {
                                        await launchUrl(Uri.parse(message));
                                      }
                                    }),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
        .dispose(); // Dispose the controller when widget is removed
    super.dispose();
  }

  // Scroll listener function to detect reaching the end of the list
  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !widget.isLoadingMore) {
      widget.onReachEnd();
    }
  }
}
