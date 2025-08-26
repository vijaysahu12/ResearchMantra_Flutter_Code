import 'package:clear_all_notifications/clear_all_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/scanners/scanner_buttons/scanners_buttons_provider.dart';
import 'package:research_mantra_official/providers/scanners/scanners_strategies/scanners_strategies_provider.dart';
import 'package:research_mantra_official/providers/subscriptions_topics_providers/subscription_topics_provider.dart';
import 'package:research_mantra_official/services/no_screen_shot.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/common_buttons/common_button.dart';
import 'package:research_mantra_official/ui/screens/scanners/screens/history_scanners.dart';
import 'package:research_mantra_official/ui/screens/scanners/screens/today_scanners.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class ScannersListScreen extends ConsumerStatefulWidget {
  final bool isNotification;
  final String topicName;

  const ScannersListScreen(
      {super.key, required this.isNotification, this.topicName = "Breakfast"});

  @override
  ConsumerState<ScannersListScreen> createState() => _ScannersListScreen();
}

class _ScannersListScreen extends ConsumerState<ScannersListScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final UserSecureStorageService _userStorage = UserSecureStorageService();
  bool isLoading = true;

  late TabController _tabController;

  //NO screen shot enabled
  final noScreenshotUtil = NoScreenshotUtil();

  void disableScreenshots() async {
    await noScreenshotUtil.disableScreenshots();
  }

  void enableScreenshots() async {
    await noScreenshotUtil.enableScreenshots();
  }

  @override
  void initState() {
    super.initState();
    //disabled screen shot when entering screen
    disableScreenshots();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 2, vsync: this);
    ref.read(scannersButtonsStateNotifierProvider.notifier).updateButton(0);
    _initializeScreen();
  }

  @override
  void dispose() {
    enableScreenshots();
    WidgetsBinding.instance.removeObserver(this);

    _tabController.dispose();

    super.dispose();
  }

  Future<void> _initializeScreen() async {
    await ClearAllNotifications.clear();
    await _refreshData();
  }

// Method to call the api and refresh the data

  Future<void> _refreshData() async {
    final connectivityResult = ref.watch(connectivityStreamProvider);
    final isConnected = connectivityResult.value != ConnectivityResult.none;

    if (isConnected) {
      // String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String userKey = await _userStorage.getPublicKey();
// TODO: Check if this is needed
      ref
          .read(getScannersNotificationStrategiesStateNotifierProvider.notifier)
          .getAllStrategies("strategy");
      ref
          .read(getActiveSubscriptionTopicsStateNotifierProvider.notifier)
          .getAllActiveSubscriptionList(userKey);
    } else {
      ToastUtils.showToast(noInternetConnectionText, "");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final scannerStrategies =
        ref.watch(getScannersNotificationStrategiesStateNotifierProvider);

    final activeSubscriptions =
        ref.watch(getActiveSubscriptionTopicsStateNotifierProvider);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Column(
        children: [
          CustomTabBar(
            tabController: _tabController,
            tabTitles: ['Today', 'History'],
          ),
          _buildForBody(scannerStrategies, activeSubscriptions),
        ],
      ),
    );
  }

  //Widget scanners body build
  Widget _buildForBody(scannerStrategies, activeSubscriptions) {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          TodayScannersScreen(
            handleRefresh: _refreshData,
          ),
          HistoryScannersScreen(
            allScannersStrategies: scannerStrategies,
          ),
        ],
      ),
    );
  }
}
