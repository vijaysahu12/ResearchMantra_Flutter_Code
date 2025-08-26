import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/utils.dart';

class HeadContainer extends StatelessWidget {
  final String createdDate;

  const HeadContainer({
    super.key,
    required this.createdDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String formattedDate = Utils.formatDateTime(
      dateTimeString: createdDate,
      format: ddmmyy,
    );

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        // Black container with two headings

        Container(
          color: theme.primaryColor,
          // Colors.black,
          padding: const EdgeInsets.fromLTRB(14.0, 18.0, 14.0, 14.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pre Market Report",
                        style: TextStyle(
                          color: theme.disabledColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              fontFamily, // Replace with your font family
                        ),
                      ),
                      formattedDate.toLowerCase() != "invalid date"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    color: theme.primaryColorDark,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        fontFamily, // Replace with your font family
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  Container(
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
                          kingResearchIcon,
                          // stockLogo,
                          scale: 2.5,
                          fit: BoxFit.cover,
                        )),
                  ),
                ],
              ),

              const SizedBox(height: 8), // Spacing between headings
            ],
          ),
        ),

        Container(
          height: 2,
          width: double.infinity,
          color: theme.disabledColor,
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
