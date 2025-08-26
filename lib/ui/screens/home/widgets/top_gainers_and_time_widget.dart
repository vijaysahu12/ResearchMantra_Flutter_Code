import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/providers/firebase_manage_provider.dart';
import 'package:research_mantra_official/services/secure_storage.dart';
import 'package:research_mantra_official/ui/components/shimmers/home_shimmer.dart';
import 'package:research_mantra_official/ui/screens/home/widgets/gainerlosers/top_gainers_losers.dart';
import 'package:research_mantra_official/ui/screens/home/widgets/nse/nse.dart';

class TopGainersAndTimeWidget extends ConsumerStatefulWidget {
  final bool hasConnection;

  const TopGainersAndTimeWidget({super.key, required this.hasConnection});

  @override
  ConsumerState<TopGainersAndTimeWidget> createState() =>
      _TopGainersAndTimeWidgetState();
}

class _TopGainersAndTimeWidgetState
    extends ConsumerState<TopGainersAndTimeWidget> {
  final SharedPref _sharedPref = SharedPref();

  dynamic latestUpdatedDateTime;
  Map<dynamic, dynamic> indexValues = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final latestUpdateDateAndTimeAllValues =
        ref.watch(allRealTimeValuesProvider);

    if (!widget.hasConnection) {
      return Column(
        children: [
          NseLivePriceWidget(
            latestUpdatedDateTime: latestUpdatedDateTime,
            indainMarketNseStockValues: indexValues,
          ),
          const SizedBox(height: 5),
          Expanded(
            child: TopGainersAndTopLosersWidget(
              latestUpdatedDateTime: latestUpdatedDateTime,
            ),
          ),
        ],
      );
    }

    return latestUpdateDateAndTimeAllValues.when(
      loading: () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: ListView(
          children: [
            buildIndainMArketValueShimmers(context, theme),
            const SizedBox(height: 5),
            buildTopGainersShimmers(context, theme),
          ],
        ),
      ),
      data: (event) {
        List<Map<dynamic, dynamic>> topGainersDataList = [];
        List<Map<dynamic, dynamic>> topLosersDataList = [];

        final Map<dynamic, dynamic> topValues = event;

        if (widget.hasConnection) {
          latestUpdatedDateTime = topValues['CurrentDate'];
          _sharedPref.save("LATEST_UPDATE_DATE", latestUpdatedDateTime);
        }

        if (topValues['TopGainers'] != null &&
            topValues['TopGainers'] is List) {
          topGainersDataList = List<Map<dynamic, dynamic>>.from(
            (topValues['TopGainers'] as List)
                .whereType<Map<dynamic, dynamic>>(),
          );

          if (topGainersDataList.isNotEmpty) {
            _sharedPref.save("TOP_GAINERS_DATA", topGainersDataList);
          }
        }

        if (topValues['TopLosers'] != null && topValues['TopLosers'] is List) {
          topLosersDataList = List<Map<dynamic, dynamic>>.from(
            (topValues['TopLosers'] as List)
                .whereType<Map<dynamic, dynamic>>(),
          );

          if (topLosersDataList.isNotEmpty) {
            _sharedPref.save("TOP_LOSERS_DATA", topLosersDataList);
          }
        }

        if (topValues['Index'] != null) {
          final marketData = topValues['Index'];
          if (marketData != null && marketData.isNotEmpty) {
            indexValues = marketData;
            _sharedPref.save("INDIAN_STOCK_MARKET_PRICES", marketData);
          }
        }

        return Column(
          children: [
            NseLivePriceWidget(
              latestUpdatedDateTime: latestUpdatedDateTime,
              indainMarketNseStockValues: indexValues,
            ),
            const SizedBox(height: 5),
            Expanded(
              child: TopGainersAndTopLosersWidget(
                topLosersDataList: topLosersDataList,
                topGainersDataList: topGainersDataList,
                latestUpdatedDateTime: latestUpdatedDateTime,
              ),
            ),
          ],
        );
      },
      error: (error, _) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: ListView(
          children: [
            buildIndainMArketValueShimmers(context, theme),
            const SizedBox(height: 5),
            buildTopGainersShimmers(context, theme),
          ],
        ),
      ),
    );
  }
}
