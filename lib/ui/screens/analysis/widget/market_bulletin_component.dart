import 'package:flutter/material.dart';

class MarketBulletin extends StatelessWidget {
  final dynamic marketBulletin;

  const MarketBulletin({
    super.key,
    required this.marketBulletin,
  });

  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
      child: ListView.builder(
        shrinkWrap: true, // Make ListView take only the required space
        physics:
            const NeverScrollableScrollPhysics(), // Disable internal scrolling
        itemCount: marketBulletin.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Number Circle
                Column(
                  children: [
                    const SizedBox(height: 2,),
                    Text(
                      '${index + 1} .',
                      style:  TextStyle(
                        color: theme.primaryColorDark,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8), // Spacing between circle and text
                // Text Content
                Expanded(
                  child: Text(
                    marketBulletin[index],
                    style:  TextStyle(
                      fontSize: 14,
                        color: theme.primaryColorDark,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
