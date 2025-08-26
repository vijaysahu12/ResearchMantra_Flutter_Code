import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildTradingContainer({
  required ThemeData theme,
  required double fontSize,
}) {
  return Shimmer.fromColors(
    baseColor: theme.shadowColor,
    highlightColor: theme.shadowColor,
    child: Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.focusColor)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: fontSize * 0.06,
                color: theme.shadowColor,
              ),
              const Spacer(),
              // Placeholder for a dynamic value, e.g., current price
              Container(
                width: 80,
                height: fontSize * 0.04,
                color: theme.shadowColor,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              // Placeholder for net change
              Container(
                width: 100,
                height: fontSize * 0.04,
                color: theme.shadowColor,
              ),
              const SizedBox(width: 4),
              // Placeholder for percent change
              Container(
                width: 20,
                height: fontSize * 0.04,
                color: theme.shadowColor,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


