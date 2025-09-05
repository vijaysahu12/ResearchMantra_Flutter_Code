import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/ui/common_components/common_ontap_button.dart';
import 'package:research_mantra_official/ui/screens/trades/screens/all_trades.dart';
import 'package:research_mantra_official/ui/screens/trades/screens/live_history_trades.dart';
import 'package:research_mantra_official/ui/screens/trades/screens/mcx_trades.dart';

class TradeScreen extends StatefulWidget {
  final int initialSelectedTabIndex;
  const TradeScreen({super.key, this.initialSelectedTabIndex = 0});

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  final List<String> tabLabels = [
    'Home',
    'Live Trades',
    'Closed Trades',
    'MCX'
  ];
  final List<Widget> tabScreens = [
    AllTradesDetailsScreen(),
    LiveClosedTradesScreen(
      title: 'Live',
    ),
    LiveClosedTradesScreen(
      title: 'Closed',
    ),
    McxTradesScreen(),
  ];
  late int selectedTabIndex;
  @override
  void initState() {
    super.initState();
    selectedTabIndex = widget.initialSelectedTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTabBarOnTapButton(
            fontSize: 10.sp,
            buttonTextColor: theme.primaryColorDark,
            buttonBackgroundColor: theme.primaryColor,
            backgroundColor: theme.shadowColor,
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
