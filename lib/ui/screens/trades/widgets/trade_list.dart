import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/ui/common_components/common_outline_button.dart';

class TradesIdeasListWidget extends StatefulWidget {
  final String tradeType;
  const TradesIdeasListWidget({super.key, required this.tradeType});

  @override
  State<TradesIdeasListWidget> createState() => _TradesIdeasListWidgetState();
}

class _TradesIdeasListWidgetState extends State<TradesIdeasListWidget> {
  late List<TradeIdea> tradeIdeas;
  final List<Map<String, dynamic>> tradeIdeasJson = [
    {
      "tradeType": "Equity",
      "profitLoss": 12.5,
      "isNew": true,
      "potentialText": "Potential left",
      "actions": [
        {"action": "Buy", "date": "02/01/25 | 02:50 PM", "price": "3,450"},
        {"action": "Add 100%", "date": "09/06/25 | 02:50 PM", "price": "2,000"},
        {
          "action": "Exit Full",
          "date": "09/06/25 | 02:50 PM",
          "price": "3,900"
        },
      ]
    },
    {
      "tradeType": "F&O",
      "profitLoss": -8.3,
      "isNew": false,
      "potentialText": "Potential risk",
      "actions": [
        {"action": "Buy", "date": "02/01/25 | 02:50 PM", "price": "3,450"},
        {"action": "Add 100%", "date": "09/06/25 | 02:50 PM", "price": "2,000"},
        {
          "action": "Exit Full",
          "date": "09/06/25 | 02:50 PM",
          "price": "3,900"
        },
      ]
    },
    {
      "tradeType": "Commodity",
      "profitLoss": 5.0,
      "isNew": true,
      "potentialText": "Potential gain",
      "actions": [
        {"action": "Buy", "date": "02/01/25 | 02:50 PM", "price": "3,450"},
        {"action": "Add 100%", "date": "09/06/25 | 02:50 PM", "price": "2,000"},
        {
          "action": "Exit Full",
          "date": "09/06/25 | 02:50 PM",
          "price": "3,900"
        },
      ]
    },
    {
      "tradeType": "Currency",
      "profitLoss": -3.7,
      "isNew": false,
      "potentialText": "Potential loss",
      "actions": [
        {"action": "Buy", "date": "02/01/25 | 02:50 PM", "price": "3,450"},
        {"action": "Add 100%", "date": "09/06/25 | 02:50 PM", "price": "2,000"},
        {
          "action": "Exit Full",
          "date": "09/06/25 | 02:50 PM",
          "price": "3,900"
        },
      ]
    },
    {
      "tradeType": "MCX",
      "profitLoss": 10.2,
      "isNew": true,
      "potentialText": "Potential growth",
      "actions": [
        {"action": "Buy", "date": "02/01/25 | 02:50 PM", "price": "3,450"},
        {"action": "Add 100%", "date": "09/06/25 | 02:50 PM", "price": "2,000"},
        {
          "action": "Exit Full",
          "date": "09/06/25 | 02:50 PM",
          "price": "3,900"
        },
      ]
    },
  ];

  @override
  void initState() {
    super.initState();

    // ✅ Load from JSON (mock data for now)
    tradeIdeas = tradeIdeasJson.map((e) => TradeIdea.fromJson(e)).toList();
  }

  final List<Map<String, String>> actions = [
    {"action": "Buy", "date": "02/01/25 | 02:50 PM", "price": "3,450"},
    {"action": "Add 100%", "date": "09/06/25 | 02:50 PM", "price": "2,000"},
    {"action": "Exit Full", "date": "09/06/25 | 02:50 PM", "price": "3,900"},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
        itemCount: tradeIdeas.length,
        itemBuilder: (context, index) {
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
                                  "TCS",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                      color: theme.primaryColorDark),
                                ),
                                Text("Profit Booked",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                        color: theme.secondaryHeaderColor)),
                              ],
                            ),
                          ),
                          //Action Date and Price

                          TradeTable(actions: actions),
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
                                Text("Adjusted net gain:"),
                                SizedBox(width: 4),
                                Text("6.0% in 245 days",
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: theme.primaryColorDark,
                                        fontWeight: FontWeight.bold)),
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
                              borderRadius: 4,
                              text: "Trade Details",
                              onPressed: () {
                                debugPrint("Subscribed to ${widget.tradeType}");
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

    // ListView.builder(
    //   itemCount: tradeIdeas.length,
    //   shrinkWrap: true,
    //   padding: const EdgeInsets.all(12),
    //   itemBuilder: (context, index) {
    //     final idea = tradeIdeas[index];
    //     final bool isProfit = idea.profitLoss >= 0;

    //     return Stack(
    //       children: [
    //         Container(
    //           padding: const EdgeInsets.all(4.0),
    //           margin: const EdgeInsets.symmetric(vertical: 8),
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(8),
    //             border: Border.all(color: theme.primaryColorDark),
    //           ),
    //           child: Container(
    //             height: 150.h,
    //             margin: const EdgeInsets.all(4),
    //             padding: const EdgeInsets.all(12),
    //             decoration: BoxDecoration(
    //               color: theme.shadowColor,
    //               borderRadius: BorderRadius.circular(4),
    //             ),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 // ✅ Show "New" only if isNew is true
    //                 if (idea.isNew)
    //                   Container(
    //                     padding: const EdgeInsets.symmetric(
    //                         horizontal: 12, vertical: 6),
    //                     decoration: BoxDecoration(
    //                       color: theme.secondaryHeaderColor,
    //                       borderRadius: BorderRadius.circular(6),
    //                     ),
    //                     child: Text(
    //                       "New",
    //                       style: TextStyle(
    //                         color: theme.primaryColor,
    //                         fontWeight: FontWeight.bold,
    //                         fontSize: 11.sp,
    //                       ),
    //                     ),
    //                   ),

    //                 const SizedBox(height: 12),

    //                 // ✅ Profit/Loss container
    //                 Container(
    //                   width: double.infinity,
    //                   padding: const EdgeInsets.symmetric(
    //                       horizontal: 12, vertical: 6),
    //                   decoration: BoxDecoration(
    //                     color: isProfit
    //                         ? theme.secondaryHeaderColor
    //                         : theme.disabledColor,
    //                     borderRadius: BorderRadius.circular(6),
    //                   ),
    //                   child: Column(
    //                     children: [
    //                       Text(
    //                         "Potential left",
    //                         style: TextStyle(
    //                           color: theme.primaryColor,
    //                           fontWeight: FontWeight.w600,
    //                           fontSize: 11.sp,
    //                         ),
    //                       ),
    //                       Text(
    //                         "${idea.profitLoss.toStringAsFixed(1)}%",
    //                         style: TextStyle(
    //                           color: theme.primaryColor,
    //                           fontWeight: FontWeight.bold,
    //                           fontSize: 15.sp,
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),

    //                 const SizedBox(height: 12),

    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                   children: [
    //                     CommonOutlineButton(
    //                       text: "Subscribe Now",
    //                       onPressed: () {
    //                         debugPrint("Subscribed to ${idea.tradeType}");
    //                       },
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),

    //         // ✅ Top-right tradeType
    //         Positioned(
    //           right: 12,
    //           top: 4,
    //           child: Container(
    //             padding:
    //                 const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    //             decoration: BoxDecoration(
    //               color: theme.disabledColor,
    //               borderRadius: BorderRadius.circular(6),
    //             ),
    //             child: Text(
    //               widget.tradeType,
    //               style: TextStyle(
    //                 color: theme.primaryColor,
    //                 fontSize: 10,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     );
    //   },
    // );
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

class TradeTable extends StatelessWidget {
  final List<Map<String, String>> actions;

  const TradeTable({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: theme.shadowColor,
          width: 0.3,
        ),
      ),
      child: Column(
        children: [
          // ✅ Header Row
          Container(
            decoration: BoxDecoration(
              color: theme.shadowColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.r),
                topRight: Radius.circular(4.r),
              ),
              border: Border.all(
                color: theme.shadowColor,
                width: 0.2,
              ),
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  children: [
                    _buildHeaderCell("Action", theme),
                    _buildHeaderCell("Date", theme),
                    _buildHeaderCell("Price", theme),
                  ],
                ),
              ],
            ),
          ),

          // ✅ Data Rows
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(3),
              2: FlexColumnWidth(2),
            },
            children: actions.map((action) {
              return TableRow(
                children: [
                  _buildDataCell(action['action'] ?? "", theme),
                  _buildDataCell(action['date'] ?? "", theme),
                  _buildDataCell(action['price'] ?? "", theme),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          color: theme.primaryColorDark,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataCell(String text, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          color: theme.primaryColorDark,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
