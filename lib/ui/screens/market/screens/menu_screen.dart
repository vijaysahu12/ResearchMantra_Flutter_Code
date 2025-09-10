import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/constants/assets_storage.dart';
import 'package:research_mantra_official/data/models/blogs/blog_api_response_model.dart';
import 'package:research_mantra_official/ui/Screens/home/home_navigator.dart';
import 'package:research_mantra_official/ui/screens/blogs/blogs_screen.dart';
import 'package:research_mantra_official/ui/screens/market/screens/ipo.dart';
import 'package:research_mantra_official/ui/screens/market/screens/results.dart';
import 'package:research_mantra_official/ui/screens/market/screens/sharks.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/results_cards.dart';

// 📌 Model
class GridItem {
  final String title;
  final String icon;
  final String screen;

  GridItem({required this.title, required this.icon, required this.screen});

  factory GridItem.fromJson(Map<String, dynamic> json) {
    return GridItem(
      title: json['title'],
      icon: json['icon'],
      screen: json['screen'],
    );
  }
}

// 📌 Menu Widget
class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key});

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  late final List<GridItem> gridItems;

  @override
  void initState() {
    super.initState();

    // ✅ Convert static data into GridItem objects
    gridItems = [
      {"title": "Screeners", "icon": arrowIconPath, "screen": "ScreenerScreen"},
      {"title": "IPO", "icon": arrowIconPath, "screen": "IpoScreen"},
      {"title": "Sharks", "icon": arrowIconPath, "screen": "SharksScreen"},
      {"title": "Blogs", "icon": arrowIconPath, "screen": "BlogsScreen"},
      {"title": "Results", "icon": arrowIconPath, "screen": "ResultsScreen"},
    ].map((e) => GridItem.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return gridItems.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : _buildBottomScrollRow(context);
  }

  Widget _buildBottomScrollRow(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: gridItems
            .map((item) => _buildScrollItem(context, item, theme))
            .toList(),
      ),
    );
  }

  Widget _buildScrollItem(
      BuildContext context, GridItem item, ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 50.sp,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.3),
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () => _navigateToScreen(context, item.screen),
            child: Image.asset(item.icon, scale: 18),
          ),
        ),
        const SizedBox(height: 6),
        Text(item.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
                color: theme.primaryColorDark, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // 📌 Centralized navigation mapping
  void _navigateToScreen(BuildContext context, String screenName) {
    final Map<String, Widget> screenMap = {
      "ScreenerScreen": const HomeNavigatorWidget(
        initialIndex: 2,
      ),
      "IpoScreen": const IposScreen(),
      "SharksScreen": const SharksScreen(),
      "BlogsScreen": BlogScreenBaseScreen(),
      "ResultsScreen": const ResultsScreen(),
    };

    final screen = screenMap[screenName];
    if (screen != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    } else {
      print("No screen found for $screenName");
    }
  }
}
