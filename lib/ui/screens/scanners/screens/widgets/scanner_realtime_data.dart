import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/generic_message.dart';

import 'package:research_mantra_official/ui/router/app_routes.dart';
import 'package:research_mantra_official/ui/screens/scanners/widgets/today/common_scanner.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class TodayScannersRealtimeWidget extends StatefulWidget {
  final List sections;

  final String currentDate;

  final bool? expanded;

  const TodayScannersRealtimeWidget({
    super.key,
    required this.sections,
    required this.currentDate,
    this.expanded,
  });

  @override
  State<TodayScannersRealtimeWidget> createState() =>
      _TodayScannersRealtimeWidgetState();
}

class _TodayScannersRealtimeWidgetState
    extends State<TodayScannersRealtimeWidget> {
  int selectedIndex = 0; // Default to the first section

  @override
  Widget build(BuildContext context) {
    final selectedSectionData = widget.sections[selectedIndex]['data'];

    return Column(
      children: [
        ScannerCategory(
          expanded: widget.expanded ?? false,
          currentDate: widget.currentDate,
          title: widget.sections[0]['title'],
          stocks: selectedSectionData.map<StockData>((stock) {
            return StockData(
              name: stock['TradingSymbol'] ?? '---',
              price: double.parse((stock['Ltp'] ?? '0').toString())
                  .toStringAsFixed(2),
              changePercent: double.parse(stock['PercentChange'] ?? '0')
                  .toStringAsFixed(2),
              triggerPrice: stock['Ltp'] ?? "0.00",
              dayHigh: stock['DayHigh'] ?? "0.00",
              viewChart: stock['ViewChart']?.toString() ??
                  'https://in.tradingview.com/chart/?symbol=NSE:${stock['TradingSymbol']}',
            );
          }).toList(),
          onExpand: () {},
          stockCount: selectedSectionData.length.toString(),
        ),
      ],
    );
  }
}

//Widget For Firebase Data
class StockCard extends StatelessWidget {
  final StockData stock;

  const StockCard({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color priceColor = stock.changePercent.contains("-")
        ? theme.disabledColor
        : theme.secondaryHeaderColor;
    final fontSize = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(6),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  stock.name,
                  style: TextStyle(
                    fontSize: fontSize * 0.025,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColorDark,
                    letterSpacing: 0.3,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      stock.price,
                      style: TextStyle(
                        fontSize: fontSize * 0.025,
                        fontWeight: FontWeight.bold,
                        color: priceColor,
                      ),
                    ),
                    SizedBox(width: 2),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Row(
                        children: [
                          Text(
                            '(${stock.changePercent}%)',
                            style: TextStyle(
                              fontSize: fontSize * 0.025,
                              color: priceColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(
                            stock.changePercent.contains("-")
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: priceColor,
                            size: fontSize * 0.025,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (stock.viewChart.isEmpty ||
                        !stock.viewChart.startsWith("http")) {
                      Navigator.pushNamed(context, webviewscreen,
                          arguments:
                              "https://in.tradingview.com/chart/?symbol=NSE:${stock.name}");
                    } else {
                      Navigator.pushNamed(context, webviewscreen,
                          arguments: stock.viewChart);
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.bar_chart,
                        size: fontSize * 0.032,
                        color: theme.indicatorColor,
                      ),
                      SizedBox(width: 6),
                      Text(
                        viewChartText,
                        style: TextStyle(
                          color: theme.indicatorColor,
                          fontSize: fontSize * 0.025,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'TP : ${stock.triggerPrice}   DH : ${stock.dayHigh}',
                  style: TextStyle(
                    fontSize: fontSize * 0.025,
                    color: theme.primaryColorDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//Model for Firebase
class StockData {
  final String name;
  final String price;
  final String changePercent;

  final String triggerPrice;
  final String dayHigh;
  final String viewChart;

  StockData({
    required this.name,
    required this.price,
    required this.changePercent,
    required this.triggerPrice,
    required this.dayHigh,
    required this.viewChart,
  });
}
