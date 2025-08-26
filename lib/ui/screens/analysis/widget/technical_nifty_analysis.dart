

import 'package:flutter/material.dart';
import 'package:research_mantra_official/data/models/market_analysis/specifc_premarket_analysis.dart';

class TechnicalNiftyAnalysis extends StatefulWidget {
  // final List<String>? niftyPoints;
  //final List<Map<String, dynamic>>? gridItems;
  final SupportResistance supportResistance;
  const TechnicalNiftyAnalysis({
    super.key,
    // this.niftyPoints,
    //  this.gridItems,
    required this.supportResistance,
  });

  @override
  State<TechnicalNiftyAnalysis> createState() => _TechnicalNiftyAnalysisState();
}

class _TechnicalNiftyAnalysisState extends State<TechnicalNiftyAnalysis> {
  final niftyPoints = [
    'The Nifty 50 formed a long bearish candlestick pattern on the daily '
        'timeframe, falling below the 100-day EMA for the first time since June 4.',
    'Further, there was a lower highs-lower lows formation on the weekly '
        'charts, indicating the continuation of the downtrend for the fourth '
        'consecutive week.',
    'The momentum indicators, RSI and MACD, showed a negative bias on both '
        'the daily and weekly charts.',
  ];

  List<Map<String, dynamic>> gridItems = [];

  @override
  void initState() {
    super.initState();
    gridItems = [
      {
        'title': 'Support Pivot Levels',
        'value': '${widget.supportResistance.support ?? 'N/A'}',
        'color': Colors.green,
      },
      {
        'title': 'Resistance Pivot Levels',
        'value': '${widget.supportResistance.resistance ?? 'N/A'}',
        'color': Colors.red,
      },
      // {
      //   'title': 'Highest Put OI Strike Weekly',
      //   'value': '24000 | 24250 | 24500',
      //   'color': Colors.green,
      // },
      // {
      //   'title': 'Highest Call OI Strike Weekly',
      //   'value': '26000 | 26250 | 26500',
      //   'color': Colors.red,
      // },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: 

          // Grid View
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3,
            ),
            itemCount: gridItems.length,
            itemBuilder: (context, index) {
              final item = gridItems[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        item['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow
                            .ellipsis, // Ensures text does not overflow
                        maxLines: 2, // Restrict to 1 line
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        item['value'],
                        style: TextStyle(
                          color: item['color']== Colors.green
                              ? theme.secondaryHeaderColor
                              : theme.disabledColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow
                            .ellipsis, // Ensures text does not overflow
                        maxLines: 1, // Restrict to 1 line
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        
        
        
     
    );
  }
}
