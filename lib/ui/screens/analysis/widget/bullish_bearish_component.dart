import 'package:flutter/material.dart';

class BullishBearishIndicator extends StatelessWidget {
  final double bullish; // Percentage of bullish
  final double bearish; // Percentage of bearish

  const BullishBearishIndicator({
    super.key,
    required this.bullish,
    required this.bearish,
  });

  @override
  Widget build(BuildContext context) {

    final theme=Theme.of(context);
    if (bullish + bearish > 100) {
      throw Exception('Sum of bullish and bearish values should be 100% or less');
    }

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        children: [
          Container(
            height: 30, // Height of the indicator container
            width: double.infinity, // Full width
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.4)),
            ),
            child: (bullish).toInt()==0?
            
             Container(
                    decoration: BoxDecoration(
                      color: theme.disabledColor,
                      borderRadius: BorderRadius.circular(8),),
                    child: Center(
                      child: Text(
                        '${bearish.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ):
                  (bearish).toInt()==0?Container(
                    decoration:BoxDecoration(
                      color: theme.secondaryHeaderColor,
                    borderRadius:   BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${bullish.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ):
            Row(
              children: [
                // Bullish part (Green)
                Expanded(
                  flex: (bullish).toInt(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.secondaryHeaderColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${bullish.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                // Bearish part (Red)
                Expanded(
                  flex: (bearish).toInt(),
                  child: Container(
                    decoration:  BoxDecoration(
                      color: theme.disabledColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${bearish.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4), // Space between the indicator and labels
         Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bullish',
                  style: TextStyle(
                    color: theme.secondaryHeaderColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Bearish',
                  style: TextStyle(
                    color: theme.disabledColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
