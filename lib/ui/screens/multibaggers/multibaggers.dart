import 'package:flutter/material.dart';

import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/screens/multibaggers/widgets/active_multibaggers.dart';
import 'package:research_mantra_official/ui/screens/multibaggers/widgets/closed_multibaggers.dart';

class MultibaggersScreen extends StatefulWidget {
  const MultibaggersScreen({super.key});

  @override
  State<MultibaggersScreen> createState() => _MultibaggersScreenState();
}

class _MultibaggersScreenState extends State<MultibaggersScreen> {
  final Map<String, dynamic> allMultibaggers = {
    "openTrades": [
      {
        "title": "Potential up to 500%",
        "buttonText": "Subscribe Now",
        "note": "* Valid only with 1 yr & 5 yr plans",
        "stockSymbol": "TCS",
        "companyName": "Tata Consultancy Services",
        "netGain": "+120%",
        "actions": [
          {"action": "Buy", "date": "02/01/25 | 02:50 PM", "price": "3,450"},
          {
            "action": "Add 100%",
            "date": "09/06/25 | 02:50 PM",
            "price": "2,000"
          },
        ],
        "isPurchased": false,
      },
      {
        "title": "Potential up to 300%",
        "buttonText": "Subscribe Now",
        "note": "* Valid only with 1 yr & 5 yr plans",
        "stockSymbol": "TCS",
        "companyName": "Tata Consultancy Services",
        "netGain": "+120%",
        "actions": [
          {"action": "Buy", "date": "02/01/25 | 02:50 PM", "price": "3,450"},
          {
            "action": "Add 100%",
            "date": "09/06/25 | 02:50 PM",
            "price": "2,000"
          },
        ],
        "isPurchased": false,
      },
      {
        "title": "Potential up to 300%",
        "buttonText": "Subscribe Now",
        "note": "* Valid only with 1 yr & 5 yr plans",
        "stockSymbol": "TCS",
        "companyName": "Tata Consultancy Services",
        "netGain": "+120%",
        "actions": [
          {"action": "Buy", "date": "02/01/25 | 02:50 PM", "price": "3,450"},
          {
            "action": "Add 100%",
            "date": "09/06/25 | 02:50 PM",
            "price": "2,000"
          },
        ],
        "isPurchased": true,
      }
    ],
    "closedTrades": [
      {
        "stockSymbol": "TCS",
        "companyName": "Tata Consultancy Services",
        "netGain": "+120%",
        "actions": [
          {"action": "Buy", "date": "02/01/25 | 02:50 PM", "price": "3,450"},
          {
            "action": "Add 100%",
            "date": "09/06/25 | 02:50 PM",
            "price": "2,000"
          },
          {
            "action": "Exit Full",
            "date": "09/06/25 | 02:50 PM",
            "price": "3,900"
          },
        ],
      },
      {
        "stockSymbol": "INFY",
        "companyName": "Infosys Limited",
        "netGain": "+80%",
        "actions": [
          {"action": "Buy", "date": "02/01/25 | 02:50 PM", "price": "3,450"},
          {
            "action": "Add 100%",
            "date": "09/06/25 | 02:50 PM",
            "price": "2,000"
          },
          {
            "action": "Exit Full",
            "date": "09/06/25 | 02:50 PM",
            "price": "3,900"
          },
        ],
      },
      {
        "stockSymbol": "HDFCBANK",
        "companyName": "HDFC Bank Limited",
        "netGain": "+60%",
        "actions": [
          {"action": "Buy", "date": "02/01/25 | 02:50 PM", "price": "3,450"},
          {
            "action": "Add 100%",
            "date": "09/06/25 | 02:50 PM",
            "price": "2,000"
          },
          {
            "action": "Exit Full",
            "date": "09/06/25 | 02:50 PM",
            "price": "3,900"
          },
        ],
      }
    ]
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: 'Multibaggers',
        handleBackButton: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
                aspectRatio: 2.4,
                child: Image.network(
                    "https://www.etmoney.com/learn/wp-content/uploads/2022/10/How-to-Identify-Multibagger-Stocks.jpg")),
            //Active Stocks.
            ActiveMultibaggerList(
                data: List<Map<String, dynamic>>.from(
                    allMultibaggers['openTrades'])),
            //Closed Stocks.
            ClosedMultibaggersScreen(
                data: List<Map<String, dynamic>>.from(
                    allMultibaggers['closedTrades'])),
          ],
        ),
      ),
    );
  }
}
