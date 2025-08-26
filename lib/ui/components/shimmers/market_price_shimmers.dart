import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

//Shimmers For Market values
Widget buildMarketValuesShimmerContainer({
  required double fontSize,
  required theme,
}) {
  return Shimmer.fromColors(
    baseColor: theme.focusColor,
    highlightColor: theme.shadowColor,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
              border: Border.all(
                color: theme.shadowColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: fontSize * 0.4,
                    height: fontSize * 0.04,
                    color: theme.shadowColor,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Container(
                    width: fontSize * 0.3,
                    height: fontSize * 0.04,
                    color: theme.shadowColor,
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: fontSize * 0.1,
                    height: fontSize * 0.04,
                    color: theme.shadowColor,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
              border: Border.all(
                color: theme.shadowColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: fontSize * 0.4,
                    height: fontSize * 0.04,
                    color: theme.shadowColor,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Container(
                    width: fontSize * 0.3,
                    height: fontSize * 0.04,
                    color: theme.shadowColor,
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: fontSize * 0.1,
                    height: fontSize * 0.04,
                    color: theme.shadowColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
