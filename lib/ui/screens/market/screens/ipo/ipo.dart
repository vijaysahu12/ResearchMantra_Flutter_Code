import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/common_buttons/common_button.dart';
import 'package:research_mantra_official/ui/screens/market/screens/ipo/screen/ipo_details.dart';

class IposScreen extends StatefulWidget {
  const IposScreen({super.key});

  @override
  State<IposScreen> createState() => _IposScreenState();
}

class _IposScreenState extends State<IposScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _mainTabs = ["Open", "Closed"];
  late TabController _tabController;

  int _subTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _mainTabs.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _subTabIndex = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: "Ipos",
        handleBackButton: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // ✅ Custom TabBar
          CustomTabBar(
            tabController: _tabController,
            tabTitles: _mainTabs,
          ),

          // ✅ TabBarView
          // 👇 Replace TabBarView with simple conditional rendering
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 👉 Individuals Tab Content
                IpoDetailsScreen(
                    // investorSharksDetails:
                    //     investorSharksDetails[investorKeys[_subTabIndex]] ?? [],
                    ),

                // 👉 Institutional / FIIs Tab Content
                IpoDetailsScreen(
                    // investorDetails:
                    //     investorDetails[investorKeys[_subTabIndex]] ?? [],
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
