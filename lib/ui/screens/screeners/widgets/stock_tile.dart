

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/ui/components/text_crop/text_crop_util.dart';
import 'package:research_mantra_official/ui/router/app_routes.dart';
import 'package:research_mantra_official/ui/themes/light_theme.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:shimmer/shimmer.dart';

class StockTile extends StatelessWidget {
  final String stocksymbol;
  final String stockName;
  final String stockLogo;
  final String chartUrl;
  final String realTimeUpdates;
  final String profitPercent;
  final String netChange;
  //final String profit;
  final String? lastUpdated;
  const StockTile({
    super.key,
    required this.chartUrl,
    required this.profitPercent,
    required this.realTimeUpdates,
    required this.stockLogo,
    required this.stockName,
    required this.stocksymbol,
    this.lastUpdated,
    // required this.profit,
    required this.netChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = ColorCheckUtils().getTextColor(netChange, theme);
    final arrowIcon = ColorCheckUtils().getArrowIcon(netChange);
    final fontSize = MediaQuery.of(context).size.width;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: theme.shadowColor, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: brandingSecondaryColor,
                      shape: BoxShape.circle,
                      border: Border.all()),
                  height: 30,
                  width: 30,
                  child: _customImages(stockLogo, stocksymbol, theme),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 100,
                        child: Text(
                          stocksymbol,
                          style: textH5.copyWith(fontSize: fontSize * 0.025),
                          overflow: TextOverflow.ellipsis,
                        )),
                    SizedBox(
                        width: 120,
                        child: Text(
                          stockName,
                          style: textH5.copyWith(
                              fontSize: fontSize * 0.025,
                              fontWeight: FontWeight.normal),
                          overflow: TextOverflow.ellipsis,
                        )),
                    if (lastUpdated != null)
                      Text(
                        "Last updated on $lastUpdated",
                        style: textH5.copyWith(
                            fontSize: fontSize * 0.02,
                            fontWeight: FontWeight.normal),
                        overflow: TextOverflow.ellipsis,
                      )
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  child: Text(
                    realTimeUpdates,
                    style: textH5.copyWith(
                      fontSize: fontSize * 0.028,
                    ),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                (netChange == '0.0' || profitPercent == '0.0')
                    ? Text(
                        'NA',
                        style: TextStyle(
                          fontSize: fontSize * 0.020,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : Row(children: [
                        SizedBox(
                          child: Text(
                            netChange,
                            style: TextStyle(
                              fontSize: fontSize * 0.020,
                              fontFamily: fontFamily,
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            ' ($profitPercent%)',
                            style: TextStyle(
                                color: textColor,
                                fontSize: fontSize * 0.020,
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          arrowIcon,
                          size: fontSize *
                              0.020, // Adjusted to keep icon proportional
                          color: textColor,
                        ),
                      ]),
                SizedBox(
                  height: 2,
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () async {
                        if (chartUrl.isEmpty ||
                            !chartUrl.startsWith("http")) {
                          Navigator.pushNamed(context, webviewscreen,
                              arguments:
                                  "https://in.tradingview.com/chart/?symbol=NSE:$stocksymbol");
                        } else {
                          Navigator.pushNamed(context, webviewscreen,
                              arguments: chartUrl);
                        }
                      },
                      child: Text(
                        viewChartText,
                        style: TextStyle(
                          color: theme.indicatorColor,
                          fontSize: fontSize * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ))
              ],
            ),
          ],
        ));
  }

  Widget _customImages(String imageURL, String tradingSymbol, theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: (imageURL.isNotEmpty || imageURL != null || imageURL != "")
          ? CachedNetworkImage(
              imageUrl: "$screenerImages?imageName=$imageURL",
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: theme.primaryColor.withOpacity(0.9),
                highlightColor: theme.primaryColor.withOpacity(0.9),
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: theme.primaryColor // Placeholder color
                    ),
              ),
              errorWidget: (context, url, error) =>
                  _fallbackText(tradingSymbol, theme),
            )
          : _fallbackText(tradingSymbol, theme),
    );
  }

  Widget _fallbackText(String tradingSymbol, theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryColor, // Background color
        shape: BoxShape.circle, // Makes the container fully rounded
      ),
      alignment: Alignment.center,
      child: Text(
        tradingSymbol.isNotEmpty ? tradingSymbol[0] : "?",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: theme.primaryColorDark, // Text color
        ),
      ),
    );
  }
}
