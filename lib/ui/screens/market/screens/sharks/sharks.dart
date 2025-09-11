import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/ui/common_components/common_ontap_button.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/common_buttons/common_button.dart';
import 'package:research_mantra_official/ui/screens/market/screens/sharks/screens/key_changes.dart';
import 'package:research_mantra_official/ui/screens/market/screens/sharks/screens/sharks_list.dart';

// ✅ SharksScreen
class SharksScreen extends StatefulWidget {
  const SharksScreen({super.key});

  @override
  State<SharksScreen> createState() => _SharksScreenState();
}

class _SharksScreenState extends State<SharksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _mainTabs = ["Sharks", "Key Changes"];
  int _subTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _mainTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: "Sharks",
        handleBackButton: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // ✅ Custom TabBar
          CustomTabBar(
            tabController: _tabController,
            tabTitles: _mainTabs,
          ),
          CustomTabBarOnTapButton(
            borderRadius: 12,
            fontSize: 10.sp,
            isBorderEnabled: true,
            buttonTextColor: theme.primaryColor,
            buttonBackgroundColor: theme.primaryColorDark,
            tabLabels: ['Individuals', 'Institutional', 'FIIs'],
            selectedIndex: _subTabIndex,
            onTabSelected: (index) {
              setState(() {
                _subTabIndex = index;
              });
            },
            isScrollHorizontal: false,
          ),

          // ✅ TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(), // disables swipe
              children: [
                // 👉 Sharks Tab Content
                SharksListScreen(),

                // 👉 Key Changes Tab Content
                KeyChangesScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
