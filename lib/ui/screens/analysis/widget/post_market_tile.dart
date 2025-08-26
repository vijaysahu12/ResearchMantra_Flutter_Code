import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/market_analysis/all_post_market_analysis.dart';
import 'package:research_mantra_official/ui/screens/analysis/screens/postmarket/post_market_analysis.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/view_buttons.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/utils.dart';

class PostMarketTile extends StatelessWidget {
  final AllPostMarketStockReport data;
  const PostMarketTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
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
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                kingResearchIconWidget(theme),
                const Spacer(),
                Text(
                  data.createdOn != null
                      ? Utils.formatDateTime(
                          dateTimeString: data.createdOn ?? "", format: ddmmyy)
                      : 'N/A',
                  style: TextStyle(
                    color: theme.primaryColorDark,
                    fontFamily: fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const Divider(),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                      child: stockColumn(
                          theme,
                          "Best Perfomer",
                          data.bestPerformer?.name ??
                              "No Leading Performer Today ",
                          context,
                          data.bestPerformer?.close.toString() ?? "",
                          data.bestPerformer?.changePercentage.toString() ??
                              "")),
                  VerticalDivider(
                    color: theme.focusColor.withOpacity(0.4),
                    thickness: 1,
                  ),
                  Expanded(
                    child: stockColumn(
                        theme,
                        "Worst Perfomer",
                        data.worstPerformer?.name ??
                            "No Lagging Performance Today ",
                        context,
                        data.worstPerformer?.close.toString() ?? "",
                        data.worstPerformer?.changePercentage.toString() ?? ""),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: theme.shadowColor,
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                "Volume Shockers",
                style: TextStyle(
                  color: theme.focusColor,
                  fontFamily: fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Row(
              //  mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Expanded(flex: 2, child: SizedBox()),

                // data.volumeShocker?.length ?? 0,

                if (data.volumeShocker != null &&
                    data.volumeShocker?.length != 0)
                  Text("${data.volumeShocker?[0].name ?? ""}.... ",
                      style: TextStyle(
                        color: theme.primaryColorDark,
                        fontFamily: fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      )),

                const Expanded(child: SizedBox()),
                ViewButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PostMarketAnalysis(id: data.id ?? ""),
                      ),
                    );
                  },
                  buttonString: "Read",
                ),
              ],
            ),
          ],
        ));
  }
}

Color changeTextData(BuildContext context, String text, String? changeText) {
  final isNumeric = double.tryParse(text.replaceAll('%', '')) != null;
  final theme = Theme.of(context);

  // Determine text color based on the value
  Color? computedTextColor;
  if (isNumeric && changeText != null) {
    final number = double.parse(changeText.replaceAll('%', ''));
    if (number < 0) {
      computedTextColor = theme.disabledColor; // Negative values
    } else {
      computedTextColor = theme.secondaryHeaderColor;

      // Positive values
    }
  } else {
    computedTextColor = theme.primaryColorDark;
  }

  return computedTextColor;
}

Widget _stockRow(
    BuildContext context, theme, String stockClose, String stockpercent) {
  String stockpercentdata = "($stockpercent %)";
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Flexible(
        child: Text(
          "$stockClose     ${stockpercent == "" ? "" : stockpercentdata}",
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: changeTextData(context, stockpercent, stockpercent),
          ),
        ),
      ),
      stockpercent == ""
          ? SizedBox()
          : Icon(
              changeTextData(context, stockpercent, stockpercent) ==
                      theme.disabledColor
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              size: 16,
              color: changeTextData(context, stockpercent, stockpercent),
            ),
    ],
  );
}

Widget stockColumn(theme, String stockCategory, String stockname,
    BuildContext context, String close, String cahngeText) {
  return Column(
    // crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        stockCategory,
        style: TextStyle(
          color: theme.focusColor,
          fontFamily: fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(stockname,
          style: TextStyle(
            color: theme.primaryColorDark,
            fontFamily: fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          )),
      _stockRow(context, theme, close, cahngeText),
    ],
  );
}

Widget kingResearchIconWidget(theme) {
  return Container(
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 225, 7, 7),
      shape: BoxShape.circle,
      border: Border.all(color: theme.primaryColor),
      gradient: const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xffAD0000),
          Color(0xffFF2929),
        ],
      ),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image.asset(
        kingResearchIcon, // Or any other image
        fit: BoxFit.cover,
        scale: 5,
      ),
    ),
  );
}
