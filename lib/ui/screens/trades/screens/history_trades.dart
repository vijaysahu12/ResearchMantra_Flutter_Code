import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/common_components/common_ontap_button.dart';
import 'package:research_mantra_official/ui/screens/trades/widgets/trade_ideas.dart';

class HistoryTradesScreen extends StatefulWidget {
  const HistoryTradesScreen({super.key});

  @override
  State<HistoryTradesScreen> createState() => _HistoryTradesScreenState();
}

class _HistoryTradesScreenState extends State<HistoryTradesScreen> {
  int selectedTabIndex = 0;

  final List<String> tabLabels = ['Short', 'Long', 'Futures', 'Options'];
  final List<Widget> tabScreens = [
    TradesIdeasWidget(tradeType: "Short"),
    TradesIdeasWidget(tradeType: "Long"),
    TradesIdeasWidget(tradeType: "Futures"),
    TradesIdeasWidget(tradeType: "Options"),
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTabBarOnTapButton(
            isBorderEnabled: true,
            buttonTextColor: theme.primaryColorDark,
            buttonBackgroundColor: theme.primaryColorDark,
            tabLabels: tabLabels,
            selectedIndex: selectedTabIndex,
            onTabSelected: (index) {
              setState(() {
                selectedTabIndex = index;
              });
            },
          ),
          Expanded(
            child: tabScreens[selectedTabIndex],
          ),
        ],
      ),
    );
  }
}
