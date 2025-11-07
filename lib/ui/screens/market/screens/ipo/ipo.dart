import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/common_buttons/common_button.dart';
import 'package:research_mantra_official/ui/screens/market/screens/ipo/screen/ipo_details.dart';

class IposScreen extends StatefulWidget {
  final int selectedIndex;
  const IposScreen({super.key, this.selectedIndex = 0});

  @override
  State<IposScreen> createState() => _IposScreenState();
}

class _IposScreenState extends State<IposScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _mainTabs = ["Open", "Closed"];
  late TabController _tabController;

  final Map<String, List<Map<String, dynamic>>> ipoData = {
    "Open": [
      {
        "stockSymbol": "ABCIPO",
        "companyName": "ABC Technologies Ltd",
        "companyType": "MainBoard",
        "openClosedDates": "2025-09-15 - 2025-09-18",
        "minInvestment": "₹15,000",
        "issueSize": "₹1,200 Cr",
        "gmp": "+85",
      },
      {
        "stockSymbol": "XYZSME",
        "companyName": "XYZ Agro Industries",
        "companyType": "SME",
        "openClosedDates": "2025-09-15 - 2025-09-18",
        "minInvestment": "₹1,20,000",
        "issueSize": "₹42 Cr",
        "gmp": "+12",
      },
    ],
    "Closed": [
      {
        "stockSymbol": "LMNIPO",
        "companyName": "LMN Healthcare Pvt Ltd",
        "companyType": "MainBoard",
        "openClosedDates": "2025-09-15 - 2025-09-18",
        "minInvestment": "₹14,000",
        "issueSize": "₹900 Cr",
        "gmp": "+40",
      },
      {
        "stockSymbol": "PQRRSME",
        "companyName": "PQR Retail Solutions",
        "companyType": "SME",
        "openClosedDates": "2025-09-15 - 2025-09-18",
        "minInvestment": "₹1,50,000",
        "issueSize": "₹55 Cr",
        "gmp": "-5",
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _mainTabs.length,
      vsync: this,
      initialIndex: widget.selectedIndex,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: "IPO Dashboard",
        handleBackButton: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // ✅ Custom TabBar
          CustomTabBar(
            tabController: _tabController,
            tabTitles: _mainTabs,
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 👉 Individuals Tab Content
                IpoDetailsScreen(
                  ipoDataList: ipoData["Open"] ?? [],
                ),

                // 👉 Institutional / FIIs Tab Content
                IpoDetailsScreen(
                  ipoDataList: ipoData["Closed"] ?? [],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
