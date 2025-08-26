import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class TradingCard extends StatelessWidget {
  final String companyName;
  final String duration;
  final String investmentMessage;

  final String roi;
  final String entryPrice;
  final int cmp;
  final String isOpen;

  const TradingCard({
    super.key,
    required this.companyName,
    required this.duration,
    required this.investmentMessage,
    required this.entryPrice,
    required this.roi,
    required this.cmp,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            spreadRadius: 1,
            blurRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            // Left side - Company info and investment details
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    companyName,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: fontSize * 0.015,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Duration: $duration',
                    style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: fontSize * 0.013,
                        color: theme.focusColor,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    investmentMessage ,
                    style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: fontSize * 0.013,
                        color: theme.focusColor,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            // Right side - ROI and other metrics
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isOpen.toLowerCase() == "open"
                          ? theme.focusColor
                          : (double.tryParse(roi) != null &&
                                  double.tryParse(roi)! >= 0
                              ? Colors.green
                              : Colors.red),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isOpen.toString().toLowerCase() == "open"
                          ? 'Open'
                          : 'Closed',
                      style: TextStyle(
                          color:
                              theme.floatingActionButtonTheme.foregroundColor,
                          fontSize: fontSize * 0.013,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: (roi.isEmpty)
                              ? "0"
                              : (roi.toLowerCase() == "n/a")
                                  ? roi
                                  : '$roi% ',
                          style: TextStyle(
                              color: (double.tryParse(roi) != null &&
                                      double.tryParse(roi)! >= 1)
                                  ? theme.secondaryHeaderColor
                                  : theme.disabledColor,
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize * 0.013,
                              fontFamily: fontFamily),
                        ),
                        TextSpan(
                          text: ' ROI',
                          style: TextStyle(
                            fontFamily: fontFamily,
                            color: theme.focusColor,
                            fontSize: fontSize * 0.013,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Entry Price: $entryPrice',
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: fontSize * 0.013,
                      color: theme.focusColor,
                    ),
                  ),
                  Text(
                    isOpen.toString().toLowerCase() == "open"
                        ? 'CMP: $cmp'
                        : 'Exit: $cmp',
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: fontSize * 0.012,
                      color: theme.focusColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
