import 'package:clear_all_notifications/clear_all_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/notifications/notificationcount/notification_count_provider.dart';
import 'package:research_mantra_official/providers/notifications/notificationmain/notification_provider.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/home/home_navigator.dart';
import 'package:research_mantra_official/ui/screens/notification/widgets/notification_list.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import 'package:sliding_switch/sliding_switch.dart';
import '../../../providers/notifications/notificationmain/notification_state.dart';
import '../../components/common_error/oops_screen.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  final int selectedIndex;
  const NotificationScreen({super.key, this.selectedIndex = 0});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen>
    with WidgetsBindingObserver {
  int currentCategoryId = 0;
  bool showUnreadOnly = false;
  bool showMarkAsRead = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _checkAndFetch(true);
      initClearNotificationsState();
    });
  }

  Future<void> initClearNotificationsState() async {
    ClearAllNotifications.clear();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (mounted) {
        Connectivity().checkConnectivity().then((result) {
          // Update the StreamProvider state or handle the result directly
          if (result != ConnectivityResult.none) {
            // Fetch data if internet is available
            _checkAndFetch(true);
          } else {
            ToastUtils.showToast(noInternetConnectionText, "");
          }
        });
      }
    }
  }

  Future<void> _checkAndFetch(isRefresh) async {
    final connectivityResult = ref.watch(connectivityStreamProvider);

    //Checking result based on that displaying connection screen
    final connectionResult = connectivityResult.value;

    bool isConnection = connectionResult != ConnectivityResult.none;

    if (isConnection) {
      // ref.read(notificationsCategoryProvider.notifier).getCategories();
      ref.read(notificationsProvider.notifier).fetchNotifications(
          currentCategoryId.toString(), 1, isRefresh, showUnreadOnly);
    } else {
      ToastUtils.showToast(noInternetConnectionText, "");
    }
  }

  //Function Delete the notification
  void onDeleteNotification(String notificationId) async {
    await ref
        .read(notificationsProvider.notifier)
        .manageNotificationDelete(notificationId, showUnreadOnly);
    // _checkAndFetch(true);
  }

  void onBackButtonPressed() {
    ref
        .read(notificationunReadCountProvider.notifier)
        .getNotificationUnreadCount();
    //When we go back to Notification it will go to the 4 th index of tabs
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HomeNavigatorWidget(
          initialIndex: widget.selectedIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final connectivityResult = ref.watch(connectivityStreamProvider);
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        onBackButtonPressed();
        return true;
      },
      child: Scaffold(
        backgroundColor: theme.primaryColor,
        appBar: CommonAppBarWithBackButton(
          appBarText: notificationScreenTitle,
          handleBackButton: () {
            onBackButtonPressed();
          },
        ),
        body: _buildCategoryAndList(connectivityResult),
      ),
    );
  }

//widget binding
  Widget _buildCategoryAndList(connectivityResult) {
    final theme = Theme.of(context);
    final notificationState = ref.watch(notificationsProvider);
    //Checking result based on that displaying connection screen

    //Checking result based on that displaying connection screen
    final connectionResult = connectivityResult.value;

    bool isConnection = connectionResult == ConnectivityResult.none;
    if (isConnection && notificationState.notifications.isEmpty) {
      // Show a no internet screen if there is no connectivity
      return NoInternet(
        handleRefresh: () => _checkAndFetch(true),
      );
    }

    // final categoriesListState = ref.watch(notificationsCategoryProvider);
    return Scaffold(
        backgroundColor: theme.primaryColor,
        body: Column(
          children: [
            //Todo: As of no need to show categories
            // NotificationCategoryList(
            //   ref: ref,
            //   categoriesListState: categoriesListState,
            //   onCategoryChanged: (int categoryId) {
            //     setState(() {
            //       currentCategoryId = categoryId;
            //     });
            //   },
            // ),
            notificationState.isLoading
                ? SizedBox.shrink()
                : Container(
                    padding: const EdgeInsets.all(8.0),
                    color: theme.focusColor.withOpacity(0.25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Text("Show Unread",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.primaryColorDark, fontSize: 14)),
                          SizedBox(width: 5),
                          SlidingSwitch(
                              value: showUnreadOnly,
                              onChanged: (bool value) {
                                setState(() {
                                  showUnreadOnly = value;
                                });
                                Future.delayed(
                                    const Duration(milliseconds: 200), () {
                                  _checkAndFetch(true);
                                });
                              },
                              onTap: () {},
                              onDoubleTap: () {},
                              onSwipe: () {},
                              height: 20,
                              width: 40,
                              animationDuration:
                                  const Duration(milliseconds: 0),
                              textOn: '',
                              textOff: '',
                              background: showUnreadOnly
                                  ? Colors.green
                                  : theme.shadowColor
                              // buttonColor:
                              //     theme.primaryColorDark.withOpacity(0.7)

                              ),
                        ]),
                        InkWell(
                          onTap: () {
                            ref
                                .read(notificationsProvider.notifier)
                                .markAsRead()
                                .then((success) {
                              if (success) {
                                // Handle successful mark as read
                                setState(() {
                                  showMarkAsRead = true;
                                });
                                ref
                                    .read(notificationunReadCountProvider
                                        .notifier)
                                    .updateNotificationCount(null);
                              } else {
                                setState(() {
                                  showMarkAsRead = false;
                                });
                              }
                            });
                            // ClearAllNotifications.clear();
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.done_all,
                                size: 16,
                                color: showMarkAsRead
                                    ? theme.disabledColor
                                    : theme.primaryColorDark,
                                weight: 0.1,
                              ),
                              SizedBox(width: 5),
                              Text("Mark All as Read",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                      color: showMarkAsRead
                                          ? theme.disabledColor
                                          : theme.primaryColorDark,
                                      fontSize: 14)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

            Expanded(
              child: notificationState.isLoading &&
                      notificationState.notifications.isEmpty
                  ? const CommonLoaderGif()
                  : notificationState.error != null
                      ? const ErrorScreenWidget()
                      : _buildNotificationListWidget(
                          context, notificationState, isConnection),
            ),
          ],
        ));
  }

  Widget _buildNotificationListWidget(
      BuildContext context, NotificationState notificationState, isConnection) {
    return NotificationListWidget(
      showUnreadOnly: showUnreadOnly,
      onDeleteNotification: onDeleteNotification,
      notifications: notificationState.notifications,
      onPullToRefresh: () {
        _checkAndFetch(true);
      },
      onReachEnd: () {
        if (!isConnection) {
          if (!notificationState.isLoadingMore) {
            ref
                .read(notificationsProvider.notifier)
                .loadMoreNotifications(showUnreadOnly);
          }
        } else {
          ToastUtils.showToast(noInternetConnectionText, "");
        }
      },
      isLoadingMore: notificationState.isLoadingMore,
      onNotificationTap: (String notificationId) async {
        await ref
            .read(notificationsProvider.notifier)
            .manageNotificationReadUnread(notificationId);
        // _refreshNotificationsList();
      },
    );
  }
}
