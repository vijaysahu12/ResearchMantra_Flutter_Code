import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:research_mantra_official/ui/common_components/common_outline_button.dart';

class OngoingTradesSection extends StatelessWidget {
  final void Function(dynamic subIndex, dynamic mainIndex) handleToNavigate;

  const OngoingTradesSection({
    super.key,
    required this.handleToNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Example data: you can fetch this from API later
    final List<Map<String, dynamic>> tradeSections = [
      {
        "title": "Futures",
        "avg": "Avg 12.5%",
        "subIndex": 0,
      },
      {
        "title": "Options",
        "avg": "Avg 9.2%",
        "subIndex": 1,
      },
      {
        "title": "MCX",
        "avg": "Avg 14.8%",
        "subIndex": 2,
      },
    ];

    return Row(
      children: tradeSections.map((section) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              handleToNavigate(section["subIndex"], 1);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    section["title"],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColorDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    section["avg"],
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.focusColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CommonOutlineButton(
                    borderColor: theme.shadowColor,
                    borderRadius: 16.0,
                    textStyle:
                        TextStyle(fontSize: 10.sp, color: theme.indicatorColor),
                    text: "Active",
                    onPressed: () {
                      handleToNavigate(section["subIndex"], 1);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
