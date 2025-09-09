import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/ui/common_components/common_ontap_button.dart';
import 'package:research_mantra_official/ui/screens/trades/trades_screens.dart';
import 'package:research_mantra_official/ui/screens/trades/widgets/trade_list.dart';

class LiveClosedTradesScreen extends ConsumerWidget {
  final int mainIndex;
  final Map<String, dynamic> tradesList;

  const LiveClosedTradesScreen({
    super.key,
    required this.mainIndex,
    required this.tradesList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTabIndex = ref.watch(subTabProvider(mainIndex));
    final theme = Theme.of(context);

    final tabScreens = [
      TradesIdeasListWidget(
          key: ValueKey('Short_$mainIndex}'),
          tradeType: "Shorts",
          tradeIdeasJson: tradesList['Shorts']),
      TradesIdeasListWidget(
          key: ValueKey('Medium$mainIndex}'),
          tradeType: "Medium",
          tradeIdeasJson: tradesList['Medium']),
      TradesIdeasListWidget(
          key: ValueKey('Long$mainIndex}'),
          tradeType: "Long",
          tradeIdeasJson: tradesList['Long']),
      TradesIdeasListWidget(
          key: ValueKey('Futures$mainIndex}'),
          tradeType: "Futures",
          tradeIdeasJson: tradesList['Futures']),
      TradesIdeasListWidget(
          key: ValueKey('Options$mainIndex}'),
          tradeType: "Options",
          tradeIdeasJson: tradesList['Options']),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTabBarOnTapButton(
            borderRadius: 12,
            fontSize: 10.sp,
            isBorderEnabled: true,
            buttonTextColor: theme.primaryColor,
            buttonBackgroundColor: theme.primaryColorDark,
            tabLabels: ['Short', 'Medium', 'Long', 'Futures', 'Options'],
            selectedIndex: selectedTabIndex,
            onTabSelected: (index) {
              ref.read(subTabProvider(mainIndex).notifier).state = index;
            },
            isScrollHorizontal: false,
          ),
          Expanded(
            child: tabScreens[selectedTabIndex],
          ),
        ],
      ),
    );
  }
}
