import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/providers/notifications/notificationcount/notification_count_provider.dart';

//Notification Unread Count Widget
class NotificationCountWidget extends ConsumerStatefulWidget {
  const NotificationCountWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationCountWidget();
}

class _NotificationCountWidget extends ConsumerState<NotificationCountWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(notificationunReadCountProvider.notifier)
          .getNotificationUnreadCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unReadCount = ref.watch(notificationunReadCountProvider);
    if (unReadCount.isLoading) {
      return Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            color: theme.disabledColor,
            borderRadius: BorderRadius.circular(100)),
        child: Center(
          child: Text(
            "0",
            style: TextStyle(
              color: theme.floatingActionButtonTheme.foregroundColor,
              fontSize: 8,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      );
    } else if (unReadCount.data == 0 || unReadCount.data == null) {
      return Container();
    } else {
      return Container(
        width: 18,
        height: 18,
        decoration: unReadCount.data.toString().isEmpty
            ? null
            : BoxDecoration(
                color: theme.disabledColor,
                borderRadius: BorderRadius.circular(100)),
        child: Center(
          child: Text(
            (unReadCount.data != null) ? unReadCount.data.toString() : "0",
            style: TextStyle(
              color: theme.floatingActionButtonTheme.foregroundColor,
              fontSize: 8,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      );
    }
  }
}
