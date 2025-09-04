import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/ui/common_components/common_ontap_button.dart';

import 'package:research_mantra_official/ui/screens/trades/widgets/trade_list.dart';

class McxTradesScreen extends StatefulWidget {
  const McxTradesScreen({super.key});

  @override
  State<McxTradesScreen> createState() => _McxTradesScreenState();
}

class _McxTradesScreenState extends State<McxTradesScreen> {
  int selectedTabIndex = 0;

  final List<String> tabLabels = ['Open Trades', 'Closed Trades'];
  final List<Widget> tabScreens = [
    TradesIdeasListWidget(tradeType: "MCX Open"),
    TradesIdeasListWidget(tradeType: "MCX Closed Trades"),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTabBarOnTapButton(
              fontSize: 10.sp,
              isBorderEnabled: true,
              buttonTextColor: theme.primaryColorDark,
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
