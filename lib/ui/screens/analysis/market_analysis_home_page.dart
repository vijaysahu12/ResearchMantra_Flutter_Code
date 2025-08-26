import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/screens/analysis/screens/postmarket/all_post_market_analysis.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/ui/screens/analysis/screens/premarket/all_analysis_page.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class MarketAnalysisiHomepage extends StatefulWidget {
  const MarketAnalysisiHomepage({
    super.key,
  });
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
    _tabController = TabController(length: 2, vsync: this);

    // _tabController.animateTo(wid);
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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          marketAnalysis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize * 0.02,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.primaryColorDark,
            size: fontSize * 0.03,
          ),
        ),
        bottom: TabBar(
          dividerColor: theme.shadowColor,
          labelColor: theme.disabledColor,
          indicatorColor: theme.disabledColor,
          indicatorSize: TabBarIndicatorSize.tab,

          padding: const EdgeInsets.all(4),
        //  tabAlignment: TabAlignment.start,

          isScrollable: false,
          controller: _tabController,
          tabs: [
            Tab(
                child: Text(
              "Pre Market",
              style: textH5.copyWith(
                  fontSize: fontSize * 0.015, fontWeight: FontWeight.bold),
            )),
            Tab(
                child: Text(
              "Post Market",
              style: textH5.copyWith(
                  fontSize: fontSize * 0.015, fontWeight: FontWeight.bold),
            )),
          ],
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,

        children: const [AllAnalysisPage(), AllPostMarketAnalysis()],

      ),
    );
  }
}
