

import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/screens/scanners/screens/widgets/scanner_realtime_data.dart';

class ScannerCategory extends StatelessWidget {
  final String title;
  final List<StockData> stocks;
  final List<Widget> children;
  final String currentDate;
  final bool expanded;
  final VoidCallback onExpand;
  final String stockCount;

  const ScannerCategory({
    super.key,
    required this.title,
    this.stocks = const [],
    this.children = const [],
    required this.currentDate,
    required this.expanded,
    required this.onExpand,
    required this.stockCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        borderRadius: expanded
            ? BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              )
            : null,
        border: Border.all(color: theme.shadowColor.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStockCount(stockCount, theme, fontSize),
          if (expanded && stocks.isNotEmpty)
            _buildForTimeCard(
              theme,
              fontSize,
            ),
          if (expanded && stocks.isNotEmpty)
            ...stocks.map((stock) => StockCard(stock: stock)),
          if (expanded && children.isNotEmpty) ...children,
          if (expanded && stocks.isEmpty && children.isEmpty)
            _buildForNoStocks(theme, fontSize),
        ],
      ),
    );
  }

//Widget for displaying stock count
  Widget _buildStockCount(String stockCount, ThemeData theme, double fontSize) {
    return GestureDetector(
      onTap: onExpand,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: expanded
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(2),
                  bottomRight: Radius.circular(2))
              : null,
          color: theme.shadowColor,
        ),
        child: Row(
          children: [
            // Title (flexible space)
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: fontSize * 0.032,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColorDark,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Stock count text, aligned closer to title
            if (stockCount != "0")
              Text(
                '$stockCount ${stockCount == "1" ? "Stock" : "Stocks"}',
                style: TextStyle(
                  fontSize: fontSize * 0.025,
                  fontWeight: FontWeight.w600,
                  color: theme.primaryColorDark.withOpacity(0.7),
                ),
              ),

            // Spacer to push the icon to the end
            const Spacer(),
            const Spacer(),

            // Arrow icon
            Icon(
              expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: theme.primaryColorDark,
              size: fontSize * 0.05,
            ),
          ],
        ),
      ),
    );
  }

//Widget for displaying stock card
  Widget _buildForTimeCard(
    ThemeData theme,
    double fontSize,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12.0,
            runSpacing: 4.0,
            children: [
              Text('TP: Triggered Price',
                  style: TextStyle(
                    color: theme.focusColor,
                    fontSize: fontSize * 0.025,
                    fontWeight: FontWeight.w600,
                  )),
              Text('DH: Day High',
                  style: TextStyle(
                    color: theme.focusColor,
                    fontSize: fontSize * 0.025,
                    fontWeight: FontWeight.w600,
                  )),
              Text('Triggered On: $currentDate',
                  style: TextStyle(
                    color: theme.focusColor,
                    fontSize: fontSize * 0.025,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            'The price may not reflect real-time market update due to delays.',
            style: TextStyle(
              color: theme.focusColor,
              fontSize: fontSize * 0.025,
            ),
          ),
        ],
      ),
    );
  }

  //Widget for no stocks available
  Widget _buildForNoStocks(theme, fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.primaryColor.withOpacity(0.1),
              theme.primaryColor.withOpacity(0.3)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4), // Shadow position
            ),
          ],
          border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              color: theme.hintColor,
              size: fontSize * 0.045,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                "No stocks available under this scanner right now.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.primaryColorDark,
                  fontSize: fontSize * 0.027,
                  fontWeight: FontWeight.w600, // Slightly bolder for emphasis
                  letterSpacing: 0.5, // Slightly increase letter spacing
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
