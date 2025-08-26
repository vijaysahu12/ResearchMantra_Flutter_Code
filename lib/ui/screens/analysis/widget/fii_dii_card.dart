import 'package:flutter/material.dart';
import 'package:research_mantra_official/data/models/market_analysis/specifc_premarket_analysis.dart';

class FiiDiiCard extends StatelessWidget {
  final Color cardColor;
  final Color titleColor;
  final String tag;
  final List<FiiDiiData> fiiDiiData;

  const FiiDiiCard({
    super.key,
    this.cardColor = Colors.red, // Default color
    this.titleColor = Colors.white, // Default color
    this.tag = 'FII', // Default tag
    required this.fiiDiiData,
  });

  String formatDate(String? inputDate) {
    try {
      // Parse the input date string
      if (inputDate == null) return 'recently';
      // DateTime parsedDate = DateTime.parse(inputDate);
      // // Format the parsed date to the desired format
      // return DateFormat('d MMMM y').format(parsedDate);
     
      return inputDate;
    } catch (e) {
      // Handle any parsing or formatting errors
      return 'recently';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            // FII Card
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _customWidget(context, fiiDiiData[0].netValue ?? "", "FII" ,theme)),
                Expanded(child: _customWidget(context, fiiDiiData[1].netValue ?? "", "DII",theme)),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ));
  }
}

Widget _customWidget(BuildContext context, String value, String fiidii , theme) {
  return Stack(
    alignment: Alignment.centerLeft,
    clipBehavior: Clip.none, // Allows the circle to extend beyond the stack
    children: [
      // Text Container
      Container(
        padding: EdgeInsets.only(
          left: fiidii == "FII" ? 30 : 0.0,
          right: fiidii != "FII" ? 30 : 0.0,
        ), // Space for circular container
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.4,
        height: 40, // Same height as the circular container
        decoration: BoxDecoration(
          color: value[0] != "-"
              ? theme.secondaryHeaderColor
              : theme.disabledColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          ' Rs.${ value==""?'N/A':value} Cr',
          //  Cr on ${formatDate(fiiDii.date)}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),

      // Circular "FII" Container
      Positioned(
        left: fiidii == "FII"
            ? -20
            : null, // Partially overlap the circular container

        right: fiidii == "FII" ? null : -20,
        child: Container(
          alignment: Alignment.center,
          width: 60, // Same height as the text container
          height: 60, // Ensures it remains circular
          decoration: BoxDecoration(
            color: value[0] != "-"
               ? theme.secondaryHeaderColor
              : theme.disabledColor,
            shape: BoxShape.circle,
          ),
          child: Text(
            fiidii,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    ],
  );
}
