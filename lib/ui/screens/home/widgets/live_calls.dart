import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/constants/assets_storage.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/ui/common_components/common_outline_button.dart';

//Live Call Trades Screen Widget
// This widget displays a grid of live call trade options.
// Each grid item is tappable and triggers navigation based on the provided callback.
//Added keys for testing purposes.
class LiveCallTradesScreen extends ConsumerStatefulWidget {
  final void Function(dynamic subIndex, dynamic mainIndex) handleToNavigate;
  const LiveCallTradesScreen({super.key, required this.handleToNavigate});

  @override
  ConsumerState<LiveCallTradesScreen> createState() =>
      _LiveCallTradesScreenState();
}

class _LiveCallTradesScreenState extends ConsumerState<LiveCallTradesScreen> {
  // Example tab data (replace with your real content)
  final List<Map<String, dynamic>> _tabs = [
    {
      "title": "Intraday Nifty",
      "subtitle": "Options",
      "button": "View All",
      "icon": bullMarketIconPath,
      "tabIndex": 1,
      "subIndex": 0,
    },
    {
      "title": "Nifty Positional",
      "subtitle": "Swing Trades",
      "button": "Learn",
      "icon": candlestickIconPath,
      "tabIndex": 1,
      "subIndex": 1,
    },
    {
      "title": "MCX Positional",
      "subtitle": "Commodity Trading",
      "button": "Start Now",
      "icon": mcxIconPath,
      "tabIndex": 1,
      "subIndex": 2,
    },
    {
      "title": "Crypto AI Trading",
      "subtitle": "Smart Algo",
      "button": "Explore",
      "icon": bitCoinImagePath,
      "tabIndex": 1,
      "subIndex": 3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.appBarTheme.backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tradesBySusmithaText,
                    key: const Key('live_call_trades_title'),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.primaryColorDark,
                    ),
                  ),
                  Text(
                    'SEBI Reg.',
                    key: const Key('live_call_trades_sebi_label'),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.primaryColorDark,
                    ),
                  ),
                ],
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _tabs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 👉 2 per row
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 1.5, // Adjust for card height
              ),
              itemBuilder: (context, index) {
                final tab = _tabs[index];
                // 🔑 Create a unique key for each grid item
                final itemKey = Key('grid_item_${tab["title"]}');
                final buttonKey = Key('grid_item_button_${tab["title"]}');
                final iconKey = Key('grid_item_icon_${tab["title"]}');
                return GestureDetector(
                  key: itemKey,
                  onTap: () {
                    final tabIndex = tab["tabIndex"];
                    final subIndex = tab["subIndex"];
                    widget.handleToNavigate(subIndex, tabIndex);
                  },
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColorDark.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tab["title"],
                          key: Key('grid_title_${tab["title"]}'),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.primaryColorDark,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          tab["subtitle"],
                          key: Key('grid_subtitle_${tab["title"]}'),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 10.sp,
                            color: theme.focusColor,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonOutlineButton(
                              key: buttonKey,
                              borderColor: theme.shadowColor,
                              borderRadius: 20,
                              textStyle: theme.textTheme.titleSmall?.copyWith(
                                color: theme.primaryColorDark,
                                fontSize: 10.sp,
                              ),
                              text: tab["button"],
                              onPressed: tab["onTap"],
                            ),
                            Container(
                              key: iconKey,
                              width: 40.w,
                              height: 40.w,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Image.asset(
                                tab["icon"],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
