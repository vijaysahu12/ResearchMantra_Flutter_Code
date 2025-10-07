import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/ui/common_components/common_ontap_button.dart';
import 'package:research_mantra_official/ui/screens/trades/screens/all_trades.dart';
import 'package:research_mantra_official/ui/screens/trades/screens/live_commentary.dart';
import 'package:research_mantra_official/ui/screens/trades/screens/live_history_trades.dart';

class TradeScreen extends ConsumerStatefulWidget {
  final int initialSelectedTabIndex;
  const TradeScreen({super.key, this.initialSelectedTabIndex = 0});

  @override
  ConsumerState<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends ConsumerState<TradeScreen> {
  final Map<String, dynamic> tradesList = {
    "Open": {
      "Shorts": [
        {
          "tradingSymbol": "TCS",
          "profitOrLoss": "Profit",
          "tradeType": "Equity",
          "profitLoss": 12.5,
          "isNew": true,
          "potentialText": "Potential left",
          "percentage": "12% in 20 Days",
          "actions": [
            {"action": "Buy", "date": "02/01/25 | 02:50 PM", "price": "3,450"},
            {
              "action": "Add 100%",
              "date": "09/01/25 | 11:20 AM",
              "price": "3,600"
            },
            {
              "action": "Exit Full",
              "date": "15/01/25 | 03:30 PM",
              "price": "3,900"
            }
          ]
        },
        {
          "tradingSymbol": "INFY",
          "profitOrLoss": "Loss",
          "tradeType": "Equity",
          "profitLoss": -3.2,
          "isNew": false,
          "potentialText": "Trailing SL hit",
          "percentage": "-3% in 12 Days",
          "actions": [
            {"action": "Buy", "date": "01/01/25 | 09:30 AM", "price": "1,550"},
            {
              "action": "Exit Full",
              "date": "12/01/25 | 01:10 PM",
              "price": "1,500"
            }
          ]
        },
        {
          "tradingSymbol": "HDFCBANK",
          "profitOrLoss": "Profit",
          "tradeType": "Equity",
          "profitLoss": 5.7,
          "isNew": true,
          "potentialText": "Target 1 achieved",
          "percentage": "6% in 7 Days",
          "actions": [
            {"action": "Buy", "date": "05/01/25 | 02:00 PM", "price": "1,600"},
            {
              "action": "Exit Partial",
              "date": "10/01/25 | 10:00 AM",
              "price": "1,700"
            }
          ]
        }
      ],
      "Medium": [
        {
          "tradingSymbol": "RELIANCE",
          "profitOrLoss": "Profit",
          "tradeType": "Equity",
          "profitLoss": 15.3,
          "isNew": true,
          "potentialText": "Strong uptrend",
          "percentage": "15% in 25 Days",
          "actions": [
            {"action": "Buy", "date": "15/12/24 | 12:00 PM", "price": "2,450"},
            {
              "action": "Exit Full",
              "date": "10/01/25 | 11:00 AM",
              "price": "2,825"
            }
          ]
        },
        {
          "tradingSymbol": "ITC",
          "profitOrLoss": "Profit",
          "tradeType": "Equity",
          "profitLoss": 9.1,
          "isNew": false,
          "potentialText": "Steady gains",
          "percentage": "9% in 30 Days",
          "actions": [
            {"action": "Buy", "date": "10/12/24 | 09:45 AM", "price": "350"},
            {
              "action": "Exit Full",
              "date": "08/01/25 | 02:20 PM",
              "price": "382"
            }
          ]
        },
        {
          "tradingSymbol": "SUNPHARMA",
          "profitOrLoss": "Loss",
          "tradeType": "Equity",
          "profitLoss": -4.8,
          "isNew": false,
          "potentialText": "SL hit",
          "percentage": "-5% in 18 Days",
          "actions": [
            {"action": "Buy", "date": "20/12/24 | 01:30 PM", "price": "1,200"},
            {
              "action": "Exit Full",
              "date": "05/01/25 | 11:10 AM",
              "price": "1,140"
            }
          ]
        }
      ],
      "Long": [
        {
          "tradingSymbol": "BAJFINANCE",
          "profitOrLoss": "Profit",
          "tradeType": "Equity",
          "profitLoss": 22.4,
          "isNew": true,
          "potentialText": "Long-term growth",
          "percentage": "22% in 60 Days",
          "actions": [
            {"action": "Buy", "date": "01/11/24 | 10:00 AM", "price": "6,200"},
            {
              "action": "Exit Full",
              "date": "05/01/25 | 01:00 PM",
              "price": "7,600"
            }
          ]
        },
        {
          "tradingSymbol": "WIPRO",
          "profitOrLoss": "Loss",
          "tradeType": "Equity",
          "profitLoss": -7.6,
          "isNew": false,
          "potentialText": "Stopped out",
          "percentage": "-8% in 45 Days",
          "actions": [
            {"action": "Buy", "date": "20/11/24 | 02:10 PM", "price": "420"},
            {
              "action": "Exit Full",
              "date": "02/01/25 | 10:15 AM",
              "price": "385"
            }
          ]
        },
        {
          "tradingSymbol": "ADANIPORTS",
          "profitOrLoss": "Profit",
          "tradeType": "Equity",
          "profitLoss": 30.2,
          "isNew": true,
          "potentialText": "Multi-year breakout",
          "percentage": "30% in 70 Days",
          "actions": [
            {"action": "Buy", "date": "10/11/24 | 12:30 PM", "price": "800"},
            {
              "action": "Exit Full",
              "date": "25/01/25 | 02:45 PM",
              "price": "1,040"
            }
          ]
        }
      ],
      "Futures": [
        {
          "tradingSymbol": "NIFTY-FUT",
          "profitOrLoss": "Profit",
          "tradeType": "Futures",
          "profitLoss": 120.5,
          "isNew": true,
          "potentialText": "Index breakout",
          "percentage": "2% in 3 Days",
          "actions": [
            {"action": "Buy", "date": "10/01/25 | 09:30 AM", "price": "22,000"},
            {
              "action": "Exit Full",
              "date": "13/01/25 | 03:30 PM",
              "price": "22,450"
            }
          ]
        },
        {
          "tradingSymbol": "BANKNIFTY-FUT",
          "profitOrLoss": "Loss",
          "tradeType": "Futures",
          "profitLoss": -200.0,
          "isNew": false,
          "potentialText": "SL triggered",
          "percentage": "-1.5% in 2 Days",
          "actions": [
            {
              "action": "Sell",
              "date": "08/01/25 | 02:15 PM",
              "price": "48,000"
            },
            {
              "action": "Exit Full",
              "date": "09/01/25 | 11:30 AM",
              "price": "48,700"
            }
          ]
        },
        {
          "tradingSymbol": "RELIANCE-FUT",
          "profitOrLoss": "Profit",
          "tradeType": "Futures",
          "profitLoss": 500.0,
          "isNew": true,
          "potentialText": "Strong move",
          "percentage": "4% in 5 Days",
          "actions": [
            {"action": "Buy", "date": "03/01/25 | 10:30 AM", "price": "2,400"},
            {
              "action": "Exit Full",
              "date": "08/01/25 | 01:30 PM",
              "price": "2,500"
            }
          ]
        }
      ],
      "Options": [
        {
          "tradingSymbol": "NIFTY-22500CE",
          "profitOrLoss": "Profit",
          "tradeType": "Options",
          "profitLoss": 60.0,
          "isNew": true,
          "potentialText": "Premium doubled",
          "percentage": "100% in 2 Days",
          "actions": [
            {"action": "Buy", "date": "09/01/25 | 09:45 AM", "price": "60"},
            {
              "action": "Exit Full",
              "date": "11/01/25 | 01:00 PM",
              "price": "120"
            }
          ]
        },
        {
          "tradingSymbol": "BANKNIFTY-49000PE",
          "profitOrLoss": "Loss",
          "tradeType": "Options",
          "profitLoss": -40.0,
          "isNew": false,
          "potentialText": "Expired worthless",
          "percentage": "-100% in 3 Days",
          "actions": [
            {"action": "Buy", "date": "05/01/25 | 11:20 AM", "price": "40"},
            {"action": "Exit Full", "date": "08/01/25 | 03:30 PM", "price": "0"}
          ]
        },
        {
          "tradingSymbol": "RELIANCE-2400CE",
          "profitOrLoss": "Profit",
          "tradeType": "Options",
          "profitLoss": 150.0,
          "isNew": true,
          "potentialText": "In the money",
          "percentage": "75% in 4 Days",
          "actions": [
            {"action": "Buy", "date": "04/01/25 | 01:30 PM", "price": "200"},
            {
              "action": "Exit Full",
              "date": "08/01/25 | 02:00 PM",
              "price": "350"
            }
          ]
        }
      ]
    },
    "Closed": {
      "Shorts": [
        {
          "tradingSymbol": "SBIN",
          "profitOrLoss": "Profit",
          "tradeType": "Equity",
          "profitLoss": 7.5,
          "isNew": false,
          "potentialText": "Closed on target",
          "percentage": "8% in 10 Days",
          "actions": [
            {"action": "Buy", "date": "15/12/24 | 12:15 PM", "price": "500"},
            {
              "action": "Exit Full",
              "date": "25/12/24 | 11:45 AM",
              "price": "540"
            }
          ]
        },
        {
          "tradingSymbol": "AXISBANK",
          "profitOrLoss": "Loss",
          "tradeType": "Equity",
          "profitLoss": -2.0,
          "isNew": false,
          "potentialText": "SL hit",
          "percentage": "-2% in 7 Days",
          "actions": [
            {"action": "Buy", "date": "01/12/24 | 10:10 AM", "price": "970"},
            {
              "action": "Exit Full",
              "date": "08/12/24 | 01:00 PM",
              "price": "950"
            }
          ]
        },
        {
          "tradingSymbol": "HCLTECH",
          "profitOrLoss": "Profit",
          "tradeType": "Equity",
          "profitLoss": 11.0,
          "isNew": false,
          "potentialText": "Closed in profit",
          "percentage": "11% in 20 Days",
          "actions": [
            {"action": "Buy", "date": "10/11/24 | 09:15 AM", "price": "1,150"},
            {
              "action": "Exit Full",
              "date": "30/11/24 | 03:20 PM",
              "price": "1,280"
            }
          ]
        }
      ],
      "Medium": [
        {
          "tradingSymbol": "LT",
          "profitOrLoss": "Profit",
          "tradeType": "Equity",
          "profitLoss": 13.5,
          "isNew": false,
          "potentialText": "Strong close",
          "percentage": "14% in 30 Days",
          "actions": [
            {"action": "Buy", "date": "01/11/24 | 10:30 AM", "price": "2,100"},
            {
              "action": "Exit Full",
              "date": "01/12/24 | 11:00 AM",
              "price": "2,400"
            }
          ]
        },
        {
          "tradingSymbol": "ONGC",
          "profitOrLoss": "Loss",
          "tradeType": "Equity",
          "profitLoss": -6.2,
          "isNew": false,
          "potentialText": "Closed at SL",
          "percentage": "-6% in 20 Days",
          "actions": [
            {"action": "Buy", "date": "05/11/24 | 09:50 AM", "price": "200"},
            {
              "action": "Exit Full",
              "date": "25/11/24 | 01:45 PM",
              "price": "188"
            }
          ]
        },
        {
          "tradingSymbol": "ULTRACEMCO",
          "profitOrLoss": "Profit",
          "tradeType": "Equity",
          "profitLoss": 17.8,
          "isNew": false,
          "potentialText": "Achieved target",
          "percentage": "18% in 40 Days",
          "actions": [
            {"action": "Buy", "date": "01/10/24 | 11:00 AM", "price": "7,000"},
            {
              "action": "Exit Full",
              "date": "10/11/24 | 12:00 PM",
              "price": "8,250"
            }
          ]
        }
      ],
      "Long": [
        {
          "tradingSymbol": "ASIANPAINT",
          "profitOrLoss": "Profit",
          "tradeType": "Equity",
          "profitLoss": 25.0,
          "isNew": false,
          "potentialText": "Multi-month gain",
          "percentage": "25% in 90 Days",
          "actions": [
            {"action": "Buy", "date": "01/09/24 | 09:30 AM", "price": "3,000"},
            {
              "action": "Exit Full",
              "date": "30/11/24 | 03:00 PM",
              "price": "3,750"
            }
          ]
        },
        {
          "tradingSymbol": "HAVELLS",
          "profitOrLoss": "Loss",
          "tradeType": "Equity",
          "profitLoss": -10.0,
          "isNew": false,
          "potentialText": "Trend reversal",
          "percentage": "-10% in 60 Days",
          "actions": [
            {"action": "Buy", "date": "01/10/24 | 01:15 PM", "price": "1,200"},
            {
              "action": "Exit Full",
              "date": "30/11/24 | 02:45 PM",
              "price": "1,080"
            }
          ]
        },
        {
          "tradingSymbol": "MARUTI",
          "profitOrLoss": "Profit",
          "tradeType": "Equity",
          "profitLoss": 35.0,
          "isNew": false,
          "potentialText": "All-time high breakout",
          "percentage": "35% in 120 Days",
          "actions": [
            {"action": "Buy", "date": "01/08/24 | 11:20 AM", "price": "9,000"},
            {
              "action": "Exit Full",
              "date": "30/11/24 | 01:00 PM",
              "price": "12,150"
            }
          ]
        }
      ],
      "Futures": [
        {
          "tradingSymbol": "NIFTY-FUT",
          "profitOrLoss": "Loss",
          "tradeType": "Futures",
          "profitLoss": -150.0,
          "isNew": false,
          "potentialText": "Closed at SL",
          "percentage": "-1% in 2 Days",
          "actions": [
            {"action": "Buy", "date": "10/12/24 | 10:15 AM", "price": "21,800"},
            {
              "action": "Exit Full",
              "date": "12/12/24 | 03:00 PM",
              "price": "21,650"
            }
          ]
        },
        {
          "tradingSymbol": "BANKNIFTY-FUT",
          "profitOrLoss": "Profit",
          "tradeType": "Futures",
          "profitLoss": 350.0,
          "isNew": false,
          "potentialText": "Strong rally",
          "percentage": "2% in 4 Days",
          "actions": [
            {"action": "Buy", "date": "05/12/24 | 11:00 AM", "price": "47,000"},
            {
              "action": "Exit Full",
              "date": "09/12/24 | 02:00 PM",
              "price": "47,900"
            }
          ]
        },
        {
          "tradingSymbol": "HDFC-FUT",
          "profitOrLoss": "Profit",
          "tradeType": "Futures",
          "profitLoss": 200.0,
          "isNew": false,
          "potentialText": "Closed on target",
          "percentage": "5% in 7 Days",
          "actions": [
            {"action": "Sell", "date": "01/12/24 | 01:00 PM", "price": "3,900"},
            {
              "action": "Exit Full",
              "date": "08/12/24 | 12:00 PM",
              "price": "3,700"
            }
          ]
        }
      ],
      "Options": [
        {
          "tradingSymbol": "NIFTY-22000CE",
          "profitOrLoss": "Profit",
          "tradeType": "Options",
          "profitLoss": 80.0,
          "isNew": false,
          "potentialText": "Doubled premium",
          "percentage": "80% in 3 Days",
          "actions": [
            {"action": "Buy", "date": "05/12/24 | 09:50 AM", "price": "100"},
            {
              "action": "Exit Full",
              "date": "08/12/24 | 01:20 PM",
              "price": "180"
            }
          ]
        },
        {
          "tradingSymbol": "BANKNIFTY-47000PE",
          "profitOrLoss": "Loss",
          "tradeType": "Options",
          "profitLoss": -30.0,
          "isNew": false,
          "potentialText": "Expired OTM",
          "percentage": "-100% in 2 Days",
          "actions": [
            {"action": "Buy", "date": "01/12/24 | 10:30 AM", "price": "30"},
            {"action": "Exit Full", "date": "03/12/24 | 03:30 PM", "price": "0"}
          ]
        },
        {
          "tradingSymbol": "RELIANCE-2500PE",
          "profitOrLoss": "Profit",
          "tradeType": "Options",
          "profitLoss": 120.0,
          "isNew": false,
          "potentialText": "Closed ITM",
          "percentage": "60% in 5 Days",
          "actions": [
            {"action": "Buy", "date": "10/11/24 | 12:20 PM", "price": "200"},
            {
              "action": "Exit Full",
              "date": "15/11/24 | 01:15 PM",
              "price": "320"
            }
          ]
        }
      ]
    }
  };

  final List<String> tabLabels = [
    'Home',
    'Live Trades',
    'Closed Trades',
    'Live Commentary'
  ];
  final List<Widget> tabScreens = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedMainIndex = ref.watch(mainTabProvider);

    final tabScreens = [
      AllTradesDetailsScreen(
        onTabSelected: (mainIndex, subiIndex) {
          ref.read(mainTabProvider.notifier).state = mainIndex;
          ref.read(subTabProvider(mainIndex).notifier).state = subiIndex;
        },
      ),
      LiveClosedTradesScreen(
        // title: 'Live',
        tradesList: tradesList['Open'], mainIndex: 1,
      ),
      LiveClosedTradesScreen(
        // title: 'Closed',
        tradesList: tradesList['Closed'], mainIndex: 2,
      ),
      LiveCommentaryScreen(),
    ];

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTabBarOnTapButton(
            isScrollHorizontal: true,
            fontSize: 10.sp,
            buttonTextColor: theme.primaryColorDark,
            buttonBackgroundColor: theme.primaryColor,
            backgroundColor: theme.shadowColor,
            tabLabels: tabLabels,
            selectedIndex: selectedMainIndex,
            onTabSelected: (index) {
              ref.read(mainTabProvider.notifier).state = index;
              ref.read(subTabProvider(index).notifier).state = 0;
            },
          ),
          Expanded(
            child: tabScreens[selectedMainIndex],
          ),
        ],
      ),
    );
  }
}

// Main tab provider
final mainTabProvider = StateProvider<int>((ref) => 0);

// Sub tab provider
final subTabProvider = StateProvider.family<int, int>((ref, mainIndex) => 0);
