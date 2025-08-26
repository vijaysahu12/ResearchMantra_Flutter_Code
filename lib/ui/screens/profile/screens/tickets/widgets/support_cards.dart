import 'package:flutter/material.dart';

import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/utils.dart';

class SupportCards extends StatelessWidget {
  final String title;
  final Widget iconButton;
  final String description;
  final String createdOn;
  final String priority;
  const SupportCards({
    super.key,
    required this.title,
    required this.iconButton,
    required this.description,
    required this.createdOn,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    BorderSide borderSide = const BorderSide(
      color: Colors.transparent,
      width: 3.0,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(10),
          border: Border(
            left: borderSide.copyWith(color:Utils.matchPriorityColor(priority)),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.focusColor.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(4),
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
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(DateTime.parse(createdOn).day.toString(),
                        style: textH1.copyWith(
                            color: theme.primaryColorDark, fontSize: 16)),
                    Text(getMonthString(createdOn),
                        style: textH1.copyWith(
                            color: theme.primaryColorDark, fontSize: 12))
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: textH1.copyWith(
                          color: theme.primaryColorDark, fontSize: 18)),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(matchTicket(description),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textH1.copyWith(
                              color: theme.focusColor, fontSize: 12)),
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

  String getMonthString(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);

    // List of month names
    List<String> monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    // Get the month index (1-12)
    int monthIndex = dateTime.month;

    // Return the corresponding month name
    return monthNames[
        monthIndex - 1]; // Adjust index to match month number (1-based)
  }
}

String matchTicket(String ticket) {
  switch (ticket) {
    case "TEC":
      return "Technical";
    case "SAL":
      return "Sales";

    default:
      return "Others";
  }
}

