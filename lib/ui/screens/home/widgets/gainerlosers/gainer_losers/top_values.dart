import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/components/shimmers/topgainers_toplosers_shimmers.dart';
import 'package:research_mantra_official/ui/components/text_crop/text_crop_util.dart';

import 'package:research_mantra_official/ui/themes/text_styles.dart';

class TopValuesWidget extends StatefulWidget {
  final List<Map<dynamic, dynamic>> topValues;
  final bool isLoading;

  const TopValuesWidget({
    super.key,
    required this.topValues,
    required this.isLoading,
  });

  @override
  State<TopValuesWidget> createState() => _TopValuesWidgetState();
}

class _TopValuesWidgetState extends State<TopValuesWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.8; // Adjusted to a more reasonable value
    final theme = Theme.of(context);

    if (widget.topValues.isEmpty) {
      return ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return buildTradingContainer(fontSize: fontSize, theme: theme);
        },
      );
    }

    return ListView.builder(
      itemCount: widget.topValues.length,
      itemBuilder: (context, index) {
        final item = widget.topValues[index];
        final tradingSymbol = item['tradingSymbol']?.toString() ?? '---';
        final ltp = item['ltp']?.toString() ?? '0.00';
        final netChange = item['netChange']?.toString() ?? '0.00';
        final percentChange = item['percentChange']?.toString() ?? '0.00';

        final textColor = ColorCheckUtils().getTextColor(netChange, theme);
        final arrowIcon = ColorCheckUtils().getArrowIcon(netChange);

        return Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: theme.focusColor)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tradingSymbol,
                    style: TextStyle(
                        fontSize: fontSize * 0.035,
                        fontFamily: fontFamily,
                        color: theme.primaryColorDark,
                        fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    ltp,
                    style: TextStyle(
                        color: theme.primaryColorDark,
                        fontSize: fontSize * 0.035,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    '$netChange ',
                    style: TextStyle(
                        fontSize: fontSize * 0.035,
                        fontFamily: fontFamily,
                        color: textColor,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '($percentChange%)',
                    style: TextStyle(
                        color: textColor,
                        fontSize: fontSize * 0.035,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      arrowIcon,
                      size:
                          fontSize * 0.05, // Adjusted to keep icon proportional
                      color: textColor,
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
