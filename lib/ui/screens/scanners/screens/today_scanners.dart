import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/providers/active_products_count/active_products_count_provider.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/firebase_manage_provider.dart';
import 'package:research_mantra_official/providers/scanners/scanner_today/scanners_today_provider.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/scanners/screens/widgets/subscribe_scanners_card.dart';
import 'package:research_mantra_official/ui/screens/scanners/widgets/today/scanner_notification_db.dart';

class TodayScannersScreen extends ConsumerStatefulWidget {
  final VoidCallback handleRefresh;
  final String? id;

  const TodayScannersScreen({
    super.key,
    required this.handleRefresh,
    this.id,
  });

  @override
  ConsumerState<TodayScannersScreen> createState() =>
      _TodayScannersScreenState();
}

class _TodayScannersScreenState extends ConsumerState<TodayScannersScreen> {
  String? scannersCurrentDate;
  List<String> displayedTitles = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => handleToGetData(false));
  }

  //Function To Get Dataz
  // This function is called to fetch data from the API and update the state
  // It checks the connectivity status and fetches the data accordingly
  Future<void> handleToGetData(isRefresh) async {
    final connectivityResult = ref.read(connectivityStreamProvider);
    final isConnected = connectivityResult.value != ConnectivityResult.none;
    if (!mounted) return;
    if (isConnected) {
      await ref
          .read(getTodayScannersStateNotifierProvider.notifier)
          .getTodayScannerNotifications(
              widget.id); // wait until data is fetched
      await ref
          .read(activeProductsCountStateNotifierProvider.notifier)
          .getActiveProducts();
    }
    await Future.delayed(const Duration(milliseconds: 500)); // short delay
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  String normalizeString(String input) =>
      input.trim().toLowerCase().replaceAll(' ', '');

  @override
  Widget build(BuildContext context) {
    final connectivityResult = ref.watch(connectivityStreamProvider);
    final isConnected = connectivityResult.value != ConnectivityResult.none;
    final getTodayScannerNotification =
        ref.watch(getTodayScannersStateNotifierProvider);
    final getActiveProductsCount =
        ref.watch(activeProductsCountStateNotifierProvider);

    // 🌐 No Internet
    if (!isConnected) {
      return NoInternet(handleRefresh: widget.handleRefresh);
    }

    // ⏳ Loading State
    if (getTodayScannerNotification.isLoading ||
        isLoading ||
        getActiveProductsCount.isLoading) {
      return const Center(child: CommonLoaderGif());
    }

    final notifications =
        getTodayScannerNotification.scannersResponseModel?.notifications;

    final model = getActiveProductsCount.activeProductCountModel;
    final hasNoNotifications = notifications?.isEmpty;
    final breakfast = model?.breakfast ?? false;
    final scanner = model?.scanner ?? false;
    final research = model?.research ?? false;
    final allScannerNotificationState =
        ref.watch(allScannerNotificationStreamProvider);
    final firebaseData = allScannerNotificationState.value;

    // // ❌ Error State
    if (getTodayScannerNotification.error != null) {
      return const ErrorScreenWidget();
    }

    // // 🧩 Case 1: No notifications && breakfast == false
    if (hasNoNotifications == true && !breakfast) {
      return Center(
        child: ExclusiveTradingInsightsCard(
          isResearch: research,
          isScanner: scanner,
        ),
      );
    }

    if (notifications == null) {
      return Center(
        child: ExclusiveTradingInsightsCard(
          isResearch: research,
          isScanner: scanner,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() => isLoading = true);
        await handleToGetData(true);
        widget.handleRefresh();
        setState(() => isLoading = false);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          ScannerNotificationScreen(
              getTodayScannerNotification: notifications,
              firebaseData: firebaseData),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
