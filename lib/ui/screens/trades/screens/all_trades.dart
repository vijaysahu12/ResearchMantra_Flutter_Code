import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/constants/assets_storage.dart';
import 'package:research_mantra_official/ui/screens/home/widgets/perfomance_segment.dart';
import 'package:research_mantra_official/ui/screens/multibaggers/multibaggers.dart';
import 'package:research_mantra_official/ui/screens/research_stock_basket/stock_baskets.dart';
import 'package:research_mantra_official/ui/screens/research_xclusive/xclusive_screen.dart';

import 'package:research_mantra_official/ui/themes/text_styles.dart';

class AllTradesDetailsScreen extends StatefulWidget {
  final void Function(int, int)? onTabSelected;
  const AllTradesDetailsScreen({super.key, this.onTabSelected});

  @override
  State<AllTradesDetailsScreen> createState() => _AllTradesDetailsScreenState();
}

class _AllTradesDetailsScreenState extends State<AllTradesDetailsScreen> {
  // 🔹 Trading Segments JSON Data
  final List<Map<String, dynamic>> tradingSegments = [
    {
      "title": "Futures",
      "subtitle": "7 Live",
      "icon": bullMarketIconPath,
      "tabIndex": 1,
      "subIndex": 1,
    },
    {
      "title": "Options",
      "subtitle": "5 Live",
      "icon": candlestickIconPath,
      "tabIndex": 1,
      "subIndex": 0,
    },
    {
      "title": "Commodity",
      "subtitle": "7 Live",
      "icon": mcxIconPath,
      "tabIndex": 1,
      "subIndex": 2,
    },
    {
      "title": "Crypto AI",
      "subtitle": "79 Live",
      "icon": bitCoinImagePath,
      "tabIndex": 1,
      "subIndex": 3,
    },
  ];

  // 🔹 Pro Cards JSON Data
  final List<Map<String, dynamic>> proCards = [
    {
      "title": "Stock Baskets",
      "screen": StockBasketsScreen(),
    },
    {
      "title": "Multibaggers",
      "screen": MultibaggersScreen(),
    },
    {
      "title": "Xclusive Ideas",
      "screen": XclusiveScreen(),
    },
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(child: _buildTradeDetailsHome(theme));
  }

  Widget _buildTradeDetailsHome(ThemeData theme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: PerformanceCard(),
        ),
        _buildTradeIdeas(theme),
        const SizedBox(height: 15),
        _buildProBaskets(theme)
      ],
    );
  }

  //Widget for Pro Baskets
  Widget _buildProBaskets(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pro Baskets',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: theme.primaryColorDark,
            ),
          ),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true, // So it doesn’t take infinite height
            physics:
                NeverScrollableScrollPhysics(), // Disable scrolling if inside another scroll
            crossAxisCount: 3, // 3 items per row
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: proCards.map((item) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => item["screen"]),
                  );
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.shadowColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        // Top: Title
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            item["title"],
                            style: textH4.copyWith(
                                color: theme.primaryColorDark, fontSize: 10.sp),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Center: Icon
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Image.asset(
                              bullMarketIconPath,
                              scale: 12,
                            ),
                          ),
                        ),
                        // Bottom: Explore
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            "Explore",
                            style: textH4.copyWith(
                                color: theme.primaryColorDark, fontSize: 10.sp),
                          ),
                        ),
                      ],
                    )),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

//Widget For Trade Ideas
  Widget _buildTradeIdeas(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ideas by Susmitha',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: theme.primaryColorDark,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: tradingSegments.map((item) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.onTabSelected
                          ?.call(item['tabIndex'], item['subIndex'] ?? 0);
                    },
                    child: Container(
                      width: 45.sp,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.shadowColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Image.asset(
                          item["icon"],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item["title"],
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColorDark,
                    ),
                  ),
                  Text(
                    item["subtitle"],
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: theme.focusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
