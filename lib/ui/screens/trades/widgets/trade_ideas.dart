import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/common_components/common_outline_button.dart';

class TradesIdeasWidget extends StatefulWidget {
  final String tradeType;
  const TradesIdeasWidget({super.key, required this.tradeType});

  @override
  State<TradesIdeasWidget> createState() => _TradesIdeasWidgetState();
}

class _TradesIdeasWidgetState extends State<TradesIdeasWidget> {
  late List<TradeIdea> tradeIdeas;
  final List<Map<String, dynamic>> tradeIdeasJson = [
    {
      "tradeType": "Equity",
      "profitLoss": 12.5,
      "isNew": true,
      "potentialText": "Potential left"
    },
    {
      "tradeType": "F&O",
      "profitLoss": -8.3,
      "isNew": false,
      "potentialText": "Potential risk"
    },
    {
      "tradeType": "Commodity",
      "profitLoss": 5.0,
      "isNew": true,
      "potentialText": "Potential gain"
    },
    {
      "tradeType": "Currency",
      "profitLoss": -3.7,
      "isNew": false,
      "potentialText": "Potential loss"
    },
    {
      "tradeType": "MCX",
      "profitLoss": 10.2,
      "isNew": true,
      "potentialText": "Potential growth"
    },
  ];

  @override
  void initState() {
    super.initState();

    // ✅ Load from JSON (mock data for now)
    tradeIdeas = tradeIdeasJson.map((e) => TradeIdea.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: tradeIdeas.length,
      shrinkWrap: true,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        final idea = tradeIdeas[index];
        final bool isProfit = idea.profitLoss >= 0;

        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4.0),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.primaryColorDark),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.shadowColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Show "New" only if isNew is true
                    if (idea.isNew)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "New",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    const SizedBox(height: 12),

                    // ✅ Profit/Loss container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isProfit ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Potential left",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${idea.profitLoss.toStringAsFixed(1)}%",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CommonOutlineButton(
                          text: "Subscribe Now",
                          onPressed: () {
                            debugPrint("Subscribed to ${idea.tradeType}");
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ✅ Top-right tradeType
            Positioned(
              right: 12,
              top: 4,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.disabledColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.tradeType,
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class TradeIdea {
  final String tradeType;
  final double profitLoss;
  final bool isNew;
  final String potentialText; // <-- comes from backend

  TradeIdea({
    required this.tradeType,
    required this.profitLoss,
    this.isNew = false,
    required this.potentialText,
  });

  factory TradeIdea.fromJson(Map<String, dynamic> json) {
    return TradeIdea(
      tradeType: json['tradeType'],
      profitLoss: (json['profitLoss'] as num).toDouble(),
      isNew: json['isNew'] ?? false,
      potentialText: json['potentialText'] ?? 'Potential left',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "tradeType": tradeType,
      "profitLoss": profitLoss,
      "isNew": isNew,
      "potentialText": potentialText,
    };
  }
}
