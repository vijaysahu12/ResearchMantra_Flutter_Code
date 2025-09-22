import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/common_buttons/common_button.dart';
import 'package:research_mantra_official/ui/screens/market/screens/results/screens/declared_results.dart';
import 'package:research_mantra_official/ui/screens/market/screens/results/screens/upcoming_results.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _mainTabs = ["Upcoming", "Declared"];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _mainTabs.length, vsync: this);
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
          appBarText: "Results",
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
                  UpcomingResults(),

                  // 👉 Institutional / FIIs Tab Content
                  DeclaredResultScreen(),
                ],
              ),
            ),
          ],
        ));
  }
}
