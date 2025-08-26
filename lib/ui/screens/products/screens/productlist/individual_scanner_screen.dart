import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/firebase_manage_provider.dart';
import 'package:research_mantra_official/providers/subscriptions_topics_providers/subscription_topics_provider.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/screens/scanners/screens/widgets/subscribe_scanners_card.dart';
import 'package:research_mantra_official/ui/screens/scanners/widgets/today/common_scanner.dart';
import 'package:research_mantra_official/ui/screens/scanners/screens/widgets/scanner_realtime_data.dart';
import 'package:shimmer/shimmer.dart';

class IndividualScannerScreen extends ConsumerStatefulWidget {
  final bool ispurchased;
  final bool expanded;

  const IndividualScannerScreen({
    super.key,
    required this.ispurchased,
    required this.expanded,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _IndividualScannerScreenState();
}

class _IndividualScannerScreenState
    extends ConsumerState<IndividualScannerScreen> {
  String? scannersCurrentDate;

  @override
  Widget build(BuildContext context) {
    final activeSubscriptions =
        ref.watch(getActiveSubscriptionTopicsStateNotifierProvider);
    final connectivityResult = ref.watch(connectivityStreamProvider);
    final hasConnection = connectivityResult.value;
    if (hasConnection == ConnectivityResult.none) {
      return NoInternet(handleRefresh: () {});
    }

    if (!widget.ispurchased) {
      return Center(
        child: ExclusiveTradingInsightsCard(
          isResearch: true,
          isScanner: false,
        ),
      );
    }
    return _buildMainContent(activeSubscriptions);
  }

  Widget _buildMainContent(activeSubscriptions) {
    final allScannerNotificationState =
        ref.watch(allScannerNotificationStreamProvider);
    final firebaseData = allScannerNotificationState.value;
    final hasFirebaseData = firebaseData != null &&
        firebaseData['Breakfast'] != null &&
        firebaseData['Breakfast'] is List &&
        (firebaseData['Breakfast'] as List).isNotEmpty;

    if (allScannerNotificationState.hasError) return ErrorScreenWidget();

    return allScannerNotificationState.when(
      loading: () => SizedBox(
        // height: MediaQuery.of(context).size.height * 0.4,
        child: buildFirebaseShimmer(),
      ),
      data: (event) => buildScannerContent(
          event, "BreakFast Scanner", activeSubscriptions, hasFirebaseData),
      error: (_, __) => const NoContentWidget(
        message: "No matching stocks right now—check back soon!",
      ),
    );
  }

  Widget buildScannerContent(Map<dynamic, dynamic> topValues, currenttopicName,
      activeSubscriptions, bool hasFirebaseData) {
    final sections = extractSections(topValues);
    scannersCurrentDate = topValues["CurrentDate"];
    if (sections.isEmpty) {
      return ScannerCategory(
        currentDate: scannersCurrentDate ?? '',
        title: "BreakFast",
        stocks: [],
        expanded: true,
        onExpand: () {},
        stockCount: topValues.length.toString(),
      );
    }
    return SingleChildScrollView(
      child: TodayScannersRealtimeWidget(
        expanded: widget.expanded,
        sections: sections,
        currentDate: scannersCurrentDate ?? "",
      ),
    );
  }

  List<Map<String, dynamic>> extractSections(Map<dynamic, dynamic> topValues) {
    return topValues.entries
        .where((entry) => entry.value is List && entry.value.isNotEmpty)
        .map((entry) => {
              'title': entry.key,
              'data': List<Map<dynamic, dynamic>>.from(entry.value)
            })
        .toList();
  }

  Widget buildFirebaseShimmer() {
    return Column(
      children: List.generate(5, (_) => shimmerListTile()),
    );
  }

  Widget shimmerListTile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1 - Two Shimmering Boxes
            Row(
              children: [
                Container(
                  height: 12,
                  width: 100,
                  color: Colors.grey,
                ),
                const Spacer(),
                Container(
                  height: 12,
                  width: 60,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Row 2 - Two Shimmering Boxes
            Row(
              children: [
                Container(
                  height: 12,
                  width: 80,
                  color: Colors.white,
                ),
                const Spacer(),
                Container(
                  height: 12,
                  width: 80,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
