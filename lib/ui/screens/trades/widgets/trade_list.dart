import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/ui/common_components/common_outline_button.dart';
import 'package:research_mantra_official/ui/common_components/trade_action_container.dart';
import 'package:research_mantra_official/ui/screens/trades/widgets/trade_details.dart';

class TradesIdeasListWidget extends StatefulWidget {
  final List<Map<String, dynamic>> tradeIdeasJson;
  final String tradeType;
  const TradesIdeasListWidget(
      {super.key, required this.tradeType, required this.tradeIdeasJson});

  @override
  State<TradesIdeasListWidget> createState() => _TradesIdeasListWidgetState();
}

class _TradesIdeasListWidgetState extends State<TradesIdeasListWidget> {
  late List<TradeIdea> tradeIdeas;

  @override
  void initState() {
    super.initState();

    // ✅ Load from JSON (mock data for now)
    tradeIdeas =
        widget.tradeIdeasJson.map((e) => TradeIdea.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
        itemCount: tradeIdeas.length,
        itemBuilder: (context, index) {
          final idea = tradeIdeas[index];

          return Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: theme.shadowColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Header Row Stock Name and Status
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                              top: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  idea.tradingSymbol,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                      color: theme.primaryColorDark),
                                ),
                                Text(idea.profitOrLoss,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                        color: theme.secondaryHeaderColor)),
                              ],
                            ),
                          ),
                          //Action Date and Price

                          TradeTable(actions: idea.actions),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.secondaryHeaderColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(0),
                                  bottomLeft: Radius.circular(4),
                                  bottomRight: Radius.circular(4)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Adjusted net gain:",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  idea.percentage,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: CommonOutlineButton(
                              backgroundColor: theme.primaryColor,
                              borderRadius: 4,
                              borderWidth: 0.5,
                              text: "Trade Details",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TradeDetailsWidget(
                                      idea: idea.actions,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
        });
  }

//Widget for if user Didnot purchased
  Widget _SubscribeProduct(ThemeData theme) {
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
                height: 150.h,
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.shadowColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ✅ Show "New" only if isNew is true
                    if (idea.isNew)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.secondaryHeaderColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "New",
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
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
                        color: isProfit
                            ? theme.secondaryHeaderColor
                            : theme.disabledColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Potential left",
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 11.sp,
                            ),
                          ),
                          Text(
                            "${idea.profitLoss.toStringAsFixed(1)}%",
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
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
  final String tradingSymbol;
  final String profitOrLoss;
  final String tradeType;
  final double profitLoss;
  final bool isNew;
  final String potentialText;
  final String percentage;
  final List<Map<String, dynamic>> actions;

  TradeIdea({
    required this.tradingSymbol,
    required this.profitOrLoss,
    required this.tradeType,
    required this.profitLoss,
    required this.isNew,
    required this.potentialText,
    required this.percentage,
    required this.actions,
  });

  factory TradeIdea.fromJson(Map<String, dynamic> json) {
    return TradeIdea(
      tradingSymbol: json['tradingSymbol'] ?? '',
      profitOrLoss: json['profitOrLoss'] ?? '',
      tradeType: json['tradeType'] ?? '',
      profitLoss: (json['profitLoss'] as num?)?.toDouble() ?? 0.0,
      isNew: json['isNew'] ?? false,
      potentialText: json['potentialText'] ?? '',
      percentage: json['percentage'] ?? '',
      actions: List<Map<String, dynamic>>.from(json['actions'] ?? []),
    );
  }
}
