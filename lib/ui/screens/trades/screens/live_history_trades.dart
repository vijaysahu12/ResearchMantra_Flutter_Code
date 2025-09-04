import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/ui/common_components/common_ontap_button.dart';
import 'package:research_mantra_official/ui/screens/trades/widgets/trade_list.dart';

class LiveClosedTradesScreen extends StatefulWidget {
  final String title;
  const LiveClosedTradesScreen({super.key, required this.title});

  @override
  State<LiveClosedTradesScreen> createState() => _LiveClosedTradesScreenState();
}

class _LiveClosedTradesScreenState extends State<LiveClosedTradesScreen> {
  int selectedTabIndex = 0;

  final List<String> tabLabels = ['Short', 'Long', 'Futures', 'Options'];
  final List<Widget> tabScreens = [
    TradesIdeasListWidget(tradeType: "Short"),
    TradesIdeasListWidget(tradeType: "Long"),
    TradesIdeasListWidget(tradeType: "Futures"),
    TradesIdeasListWidget(tradeType: "Options"),
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTabBarOnTapButton(
              fontSize: 10.sp,
              isBorderEnabled: true,
              buttonTextColor: theme.primaryColor,
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
      ),
    );
  }
}
