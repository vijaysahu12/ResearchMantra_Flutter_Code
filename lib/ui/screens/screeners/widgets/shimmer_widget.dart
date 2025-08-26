import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerStockTile extends StatelessWidget {
  final Color color;
  const ShimmerStockTile({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Shimmer for the stock logo
                  ShimmerLoadingWidget(color: color, width: 30, height: 30),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shimmer for symbol
                      ShimmerLoadingWidget(
                          color: color, width: 100, height: 12),
                      // Shimmer for stock name
                      ShimmerLoadingWidget(
                          color: color, width: 120, height: 11),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Shimmer for real-time updates
                  ShimmerLoadingWidget(color: color, width: 100, height: 12),
                  // Shimmer for profit percent
                  ShimmerLoadingWidget(color: color, width: 100, height: 11),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.topRight,
            child: ShimmerLoadingWidget(
                color: color,
                width: 80,
                height: 9), // Shimmer for "View Charts"
          ),
        ],
      ),
    );
  }
}

class ShimmerLoadingWidget extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  // Constructor to receive the width and height of the shimmer item
  const ShimmerLoadingWidget(
      {super.key,
      required this.width,
      required this.height,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Shimmer.fromColors(
      baseColor: theme.shadowColor.withOpacity(0.1), // Light shimmer color
      highlightColor: color.withOpacity(0.2), // Darker shimmer color
      child: Container(
        width: width,
        height: height,
        color: theme.primaryColor, // White shimmer placeholder
      ),
    );
  }
}
