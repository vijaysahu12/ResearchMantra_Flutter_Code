import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/router/app_routes.dart';
import 'package:research_mantra_official/ui/screens/scanners/screens/widgets/common_scanner_container.dart';
import 'package:research_mantra_official/ui/screens/scanners/screens/widgets/scanner_realtime_data.dart';
import 'package:research_mantra_official/ui/screens/scanners/widgets/today/common_scanner.dart';

class ScannerNotificationScreen extends StatefulWidget {
  final dynamic getTodayScannerNotification;
  final Map? firebaseData;

  const ScannerNotificationScreen({
    super.key,
    required this.getTodayScannerNotification,
    this.firebaseData,
  });

  @override
  State<ScannerNotificationScreen> createState() =>
      _ScannerNotificationScreenState();
}

class _ScannerNotificationScreenState extends State<ScannerNotificationScreen> {
  String? _currentlyExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Map<String, List<dynamic>> combinedMap = {};
    List<String> firebaseKeys = [];

    // Step 1: Add all data from getTodayScannerNotification
    widget.getTodayScannerNotification.forEach((key, value) {
      combinedMap[key] = List.from(value ?? []);
    });

    // Step 2: Add firebaseData only for keys already in getTodayScannerNotification
    widget.firebaseData?.forEach((key, value) {
      if (value is List) {
        if (!combinedMap.containsKey(key)) {
          return; // Skip keys not in today's notification
        }
        firebaseKeys.add(key.toString());
        combinedMap[key]?.addAll(value);
      }
    });

    return Container(
      color: theme.primaryColor,
      child: Column(
        children: combinedMap.entries.map<Widget>((entry) {
          final title = entry.key;
          final sectionData = entry.value;
          final isExpanded = _currentlyExpanded == title;
          final isFirebaseKey = firebaseKeys.contains(title);

          final stockDataList = sectionData
              .where((item) => item is Map && item.containsKey('Ltp'))
              .map<StockData>((stock) {
            return StockData(
              name: stock['TradingSymbol'] ?? '---',
              price: double.parse((stock['Ltp'] ?? '0').toString())
                  .toStringAsFixed(2),
              changePercent:
                  double.parse((stock['PercentChange'] ?? '0').toString())
                      .toStringAsFixed(2),
              triggerPrice: stock['Ltp'] ?? "0.00",
              dayHigh: stock['DayHigh'] ?? "0.00",
              viewChart: stock['ViewChart']?.toString() ??
                  'https://in.tradingview.com/chart/?symbol=NSE:${stock['TradingSymbol']}',
            );
          }).toList();

          final childrenWidgets = sectionData
              .where((item) => !(item is Map && item.containsKey('Ltp')))
              .map<Widget>((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
              child: CommonScannerContainer(
                tradingSymbol: item.tradingSymbol,
                price: item.price,
                message: item.message,
                createdOn: item.createdOn,
                viewChartUrl: item.viewChart,
                onChartTap: (url, symbol) {
                  Navigator.pushNamed(
                    context,
                    webviewscreen,
                    arguments: url,
                  );
                },
              ),
            );
          }).toList();

          return ScannerCategory(
            title: title,
            currentDate: isFirebaseKey
                ? (widget.firebaseData?['CurrentDate'] ?? '')
                : '--',
            stocks: isFirebaseKey ? stockDataList : [],
            expanded: isExpanded,
            onExpand: () {
              setState(() {
                _currentlyExpanded = isExpanded ? null : title;
              });
            },
            stockCount: isFirebaseKey
                ? '${stockDataList.length}'
                : '${sectionData.length}',
            children: childrenWidgets,
          );
        }).toList(),
      ),
    );
  }
}
