import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/constants/assets_storage.dart';
import 'package:research_mantra_official/ui/common_components/common_outline_button.dart';
import 'package:research_mantra_official/ui/screens/home/home_navigator.dart';
import 'package:research_mantra_official/ui/screens/trades/trades_screens.dart';

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
                    "Free Live Trades By SUSMITHA",
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.primaryColorDark,
                    ),
                  ),
                  Text(
                    'SEBI Reg.',
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
                return GestureDetector(
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
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.primaryColorDark,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          tab["subtitle"],
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
