import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/market_analysis/all_premarket_analysis.dart';
import 'package:research_mantra_official/ui/screens/analysis/screens/premarket/datewise_analysis_page.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/view_buttons.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/utils.dart';

class MarketAnalysisListContainer extends StatelessWidget {
  final AllPreMarketAnalysisDataModel data;
  const MarketAnalysisListContainer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: theme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: theme.focusColor.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _stockRow(context, theme, 'NIFTY :', data.nifty),
                  _stockRow(context, theme, 'DIIS: ', data.diis),
                  _stockRow(context, theme, 'VIX: ', data.vix)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _stockRow(context, theme, 'BNF:', data.bnf),
                  _stockRow(context, theme, 'FIIS : ', data.fiis),
                  _stockRow(context, theme, "OI:", "")
                ],
              ),
            ],
          ),

          // Hot News
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    "Hot News  : ${data.hotNews ?? 'No news available'}.",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // View Button
          Padding(
            padding: const EdgeInsets.only(top: 3.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Displaying the date
                Text(
                  "Date : ${data.createdOn != null ? Utils.formatDateTime(dateTimeString: data.createdOn, format: ddmmyy) : 'recently'}",
                  style: TextStyle(
                    color: theme.primaryColorDark,
                    fontFamily: fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // "Read" Button
                ViewButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MarketAnalysisDateWisePage(id: data.id),
                      ),
                    );
                  },
                  buttonString: "Read",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stockRow(
      BuildContext context, theme, String stockType, String stockValue) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
                fontSize: 18,
                color: stockType == 'OI:'
                    ? theme.primaryColor
                    : theme.primaryColorDark), // default style
            children: <TextSpan>[
              TextSpan(
                text: stockType,
                style: const TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: Utils.formatNumber(Utils.parseNumber(stockValue)),
                style: TextStyle(
                  color: stockType == 'OI:'
                      ? theme.primaryColor
                      : Utils.textColor(Utils.parseNumber(stockValue), context),
                  fontFamily: fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Icon(
            Utils.textColor(Utils.parseNumber(stockValue), context) ==
                    theme.disabledColor
               ? Icons.arrow_downward
            : Icons.arrow_upward,
            size: 15,
            color: 
                    stockType == "OI:"
                ? theme.primaryColor
                : Utils.textColor(Utils.parseNumber(stockValue), context)),
      ],
    );
  }
}
