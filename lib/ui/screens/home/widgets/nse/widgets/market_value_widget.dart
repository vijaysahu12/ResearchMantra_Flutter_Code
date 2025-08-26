import 'package:flutter/material.dart';

import 'package:research_mantra_official/ui/router/app_routes.dart';

import 'package:research_mantra_official/ui/themes/text_styles.dart';

//widget for BNF values
class MarkerWidget extends StatelessWidget {
  final String formattedValue;
  final String formattedValePercentage;
  final String valueName;

  const MarkerWidget(this.formattedValue, this.formattedValePercentage,
      {super.key, required this.valueName});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.8;
    final theme = Theme.of(context);
    final textColor = formattedValePercentage.startsWith('-')
        ? theme.disabledColor
        : theme.secondaryHeaderColor;

    return GestureDetector(
      onTap: () {
        if (valueName.toLowerCase() == "nifty") {
          Navigator.pushNamed(context, webviewscreen,
              arguments: "https://in.tradingview.com/chart/?symbol=NSE:NIFTY");
        } else {
          Navigator.pushNamed(context, webviewscreen,
              arguments:
                  "https://in.tradingview.com/chart/?symbol=NSE:BANKNIFTY");
        }
      },
      child: Container(
        // width: 115,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(right: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: theme.shadowColor, width: 0.5),
          color: theme.primaryColor,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor,
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  valueName,
                  style: TextStyle(
                    fontSize: fontSize * 0.04,
                    fontFamily: fontFamily,
                    color: theme.primaryColorDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  formattedValue,
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize * 0.04,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '($formattedValePercentage%)',
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize * 0.04,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
