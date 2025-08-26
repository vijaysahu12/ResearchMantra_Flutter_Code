import 'package:flutter/material.dart';

class TradingJournalCard extends StatelessWidget {
  final String? subTitle;
  final String? summary;
  final double? height;
  final Color? textColor;
  final IconData? icon;

  const TradingJournalCard(
      {super.key,
      this.subTitle,
      this.summary,
      this.height = 0,
      this.textColor,
      this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subTitle ?? '',
              style: TextStyle(
                fontFamily: '',
                fontWeight: FontWeight.bold,
                color: theme.hintColor,
                fontSize: 10,
              ),
            ),
            Text(
              summary ?? '',
              style: TextStyle(
                fontFamily: '',
                fontWeight: FontWeight.w700,
                color: textColor ?? theme.primaryColorDark,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 2,
            ),
          ],
        ),
      ),
    );
  }
}
