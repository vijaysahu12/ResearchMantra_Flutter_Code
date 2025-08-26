import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/generic_message.dart';

///Notification Container
class CommonScannerContainer extends StatelessWidget {
  final String tradingSymbol;
  final dynamic price;
  final String message;
  final String? createdOn;
  final String? viewChartUrl;

  final Function(String url, String symbol) onChartTap;

  const CommonScannerContainer({
    super.key,
    required this.tradingSymbol,
    required this.price,
    required this.message,
    required this.createdOn,
    required this.viewChartUrl,
    required this.onChartTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.8;
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 1),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Row: Symbol & Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tradingSymbol,
                style: TextStyle(
                  fontSize: fontSize * 0.03,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColorDark,
                  letterSpacing: 0.5,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.trending_up,
                      size: 18, color: theme.primaryColorDark),
                  const SizedBox(width: 5),
                  Text(
                    "₹${price?.toStringAsFixed(2) ?? "--"}",
                    style: TextStyle(
                      fontSize: fontSize * 0.03,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColorDark,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          // 🔹 Message Section
          Text(
            message,
            style: TextStyle(
              fontSize: fontSize * 0.03,
              color: theme.focusColor,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          // 🔹 Row: Timestamp & View Chart Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Timestamp
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: theme.focusColor),
                  const SizedBox(width: 4),
                  Text(
                    createdOn ?? "--",
                    style: TextStyle(
                      fontSize: fontSize * 0.03,
                      color: theme.focusColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              // 📊 View Chart Button
              GestureDetector(
                onTap: () {
                  String url = viewChartUrl ?? "";
                  if (url.isEmpty || !url.startsWith("http")) {
                    url =
                        "https://in.tradingview.com/chart/?symbol=NSE:$tradingSymbol";
                  }
                  onChartTap(url, tradingSymbol);
                },
                child: Row(
                  children: [
                    Icon(Icons.bar_chart,
                        size: 18, color: theme.indicatorColor),
                    const SizedBox(width: 6),
                    Text(
                      viewChartText,
                      style: TextStyle(
                        color: theme.indicatorColor,
                        fontSize: fontSize * 0.03,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
        ],
      ),
    );
  }
}
