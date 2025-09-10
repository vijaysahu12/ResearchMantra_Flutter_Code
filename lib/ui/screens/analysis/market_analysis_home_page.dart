import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/ui/screens/analysis/screens/postmarket/post_market_screen.dart';

import 'package:research_mantra_official/ui/screens/analysis/screens/premarket/pre_market_screen.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class MarketAnalysisiHomepage extends StatefulWidget {
  /// The initial tab index: 0 = Pre Market, 1 = Post Market
  final int initialTab;

  const MarketAnalysisiHomepage({super.key, this.initialTab = 0});

  @override
  State<MarketAnalysisiHomepage> createState() =>
      _MarketAnalysisiHomepageState();
}

class _MarketAnalysisiHomepageState extends State<MarketAnalysisiHomepage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    // Initialize TabController
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = widget.initialTab;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Market Analysis",
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.primaryColorDark,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_outlined,
            color: theme.primaryColorDark,
            size: 22.sp,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(fontSize * 0.06),
          child: Material(
            color: theme.appBarTheme.backgroundColor,
            child: TabBar(
              controller: _tabController,
              isScrollable: false, // set true if you want many tabs
              indicatorColor: theme.disabledColor,
              labelColor: theme.disabledColor,
              unselectedLabelColor: theme.hintColor,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  child: Text(
                    "Pre Market",
                    style: textH5.copyWith(
                        fontSize: fontSize * 0.015,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    "Post Market",
                    style: textH5.copyWith(
                        fontSize: fontSize * 0.015,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const BouncingScrollPhysics(), // allows swipe left/right
        children: const [
          PreMarketDataScreen(),
          AllPostMarketAnalysis(),
        ],
      ),
    );
  }
}
