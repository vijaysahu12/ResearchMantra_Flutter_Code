import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/custom_book_mark.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/view_buttons.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class ResultsCards extends StatefulWidget {
  final String buttonTitle;
  final void Function()? onTap;
  final String cardTitle;
  final String marketCap;
  final String ttem;
  final bool isFree;

  final String cardDescription;
  final String date;
  const ResultsCards({
    super.key,
    required this.buttonTitle,
    required this.onTap,
    required this.cardDescription,
    required this.cardTitle,
    required this.date,
    required this.marketCap,
    required this.isFree,
    required this.ttem,
  });

  @override
  State<ResultsCards> createState() => _ResultsCardsState();
}

class _ResultsCardsState extends State<ResultsCards> {
  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate =
        DateFormat.d().format(dateTime); // Day of the month (e.g., 7)
    String month =
        DateFormat.MMM().format(dateTime); // Full month name (e.g., July)
    String year = DateFormat.y().format(dateTime);
    return '$formattedDate $month $year';
  }

  String isFree = "";

  @override
  void initState() {
    super.initState();
    isFree = widget.isFree == true ? free : "";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      alignment: const Alignment(0.98, -0.9),
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.cardTitle,
                      style: TextStyle(
                        color: theme.primaryColorDark,
                        fontFamily: fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  widget.isFree == true
                      ? const SizedBox(
                          width: 15,
                        )
                      : Text(
                          formatDateTime(widget.date),
                          style: TextStyle(
                            color: theme.primaryColorDark,
                            fontFamily: fontFamily,
                            fontSize: 12,
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
                  Flexible(
                      child: Text(
                    widget.cardDescription,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: fontFamily,
                    ),
                  ))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$ttmpe ${widget.ttem}",
                        style: TextStyle(
                          color: theme.primaryColorDark,
                          fontFamily: fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "$marketCapInCr ${widget.marketCap}",
                        style: TextStyle(
                          color: theme.primaryColorDark,
                          fontFamily: fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ViewButton(
                    buttonColor: widget.buttonTitle.toLowerCase() == "unlock"
                        ? theme.indicatorColor
                        : widget.buttonTitle == renew
                            ? theme.disabledColor
                            : null,
                    onTap: widget.onTap,
                    buttonString: widget.buttonTitle,
                  ),
                ],
              ),
            ],
          ),
        ),
        isFree == free
            ? Padding(
                padding: const EdgeInsets.only(right: 5),
                child: CustombookMark(
                    bookMarkName: isFree,
                    bookMarkColor: theme.secondaryHeaderColor))
            : const SizedBox.shrink(),
      ],
    );
  }
}
