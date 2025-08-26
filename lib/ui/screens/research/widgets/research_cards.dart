import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/custom_book_mark.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/view_buttons.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class ResearchCards extends StatefulWidget {
  final String buttonTitle;
  final String cardTitle;
  final String cardSubHeading;
  final String cardDescription;
  final bool isFree;

  final void Function()? onTap;

  const ResearchCards({
    super.key,
    required this.buttonTitle,
    required this.onTap,
    required this.isFree,
    required this.cardDescription,
    required this.cardSubHeading,
    required this.cardTitle,
  });

  @override
  State<ResearchCards> createState() => _ResearchCardsState();
}

class _ResearchCardsState extends State<ResearchCards> {
  String isFree = "";

  @override
  void initState() {
    super.initState();
    isFree = widget.isFree == true ? free : "";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.height;
    return Stack(
      alignment: const Alignment(0.98, -0.9),
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
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
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(widget.cardTitle,
                        style: TextStyle(
                          color: theme.primaryColorDark,
                          fontFamily: fontFamily,
                          fontSize: fontSize * 0.016,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  if (isFree == free) const SizedBox(width: 25),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.cardSubHeading,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: fontSize * 0.014,
                        fontFamily: fontFamily,
                      ),
                    ),
                  ),
                  ViewButton(
                    buttonColor: widget.buttonTitle == buy
                        ? theme.indicatorColor
                        : widget.buttonTitle == renew
                            ? theme.disabledColor
                            : null,
                    onTap: widget.onTap,
                    buttonString: widget.buttonTitle,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.cardDescription,
                style: TextStyle(
                    fontSize: fontSize * 0.012,
                    fontFamily: fontFamily,
                    color: theme.focusColor),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
        if (isFree == free)
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: CustombookMark(
              bookMarkName: isFree,
              bookMarkColor: theme.secondaryHeaderColor,
            ),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}
