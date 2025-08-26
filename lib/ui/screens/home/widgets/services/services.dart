import 'package:flutter/material.dart';
import 'package:research_mantra_official/providers/services/services_state.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';
import 'package:research_mantra_official/ui/components/trading_journal/trading_journal_screen.dart';
import 'package:research_mantra_official/ui/screens/analysis/market_analysis_home_page.dart';
import 'package:research_mantra_official/ui/screens/home/home_navigator.dart';
import 'package:research_mantra_official/ui/screens/home/widgets/top_images/top_dashboard_images.dart';

import 'package:research_mantra_official/ui/screens/screeners/screeners_home_screen.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class GridServicesWidget extends StatelessWidget {
  final dynamic theme;
  final Function(int, bool) navigateToIndex;
  final ServicesState getDashBoardServices;
  //final LearningMaterialState getLearningMaterialData;
  final void Function(dynamic value) updateButtonType;

  const GridServicesWidget({
    required this.theme,
    //required this.getLearningMaterialData,
    required this.navigateToIndex,
    super.key,
    required this.getDashBoardServices,
    required this.updateButtonType,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    //If data is not available then show placeholder this is the list of services
    final List<String> servicesList = [
      // "SCANNERS",
      // "STRATEGIES",
      "SCREENER",
      "RESEARCH",
      "MARKET BASICS",
      "MARKET REPORT",
      "Trading Journel"
    ];

    //Function Navigate Screen
    void handleToNavigateSelectedScreens(dynamic index) async {
      Widget targetScreen;
      switch (index) {
        case 0:
          targetScreen = const ScreenersHomeScreen();
          break;
        case 1:
          targetScreen = const HomeNavigatorWidget(
            initialIndex: 1,
            isFromHome: true,
          );
          break;
        case 2:
          targetScreen = const TopDashBoardBottomImages();
          break;
        case 3:
          targetScreen = const MarketAnalysisiHomepage();
          break;
        case 4:
          targetScreen = const TradingJournalScreen();
          break;
        case 5:
          targetScreen = const TradingJournalScreen();

          break;
        default:
          targetScreen = const HomeNavigatorWidget();
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => targetScreen,
        ),
      );

      if (index == 1) {
        updateButtonType(true);
      } else {
        updateButtonType(false);
      }
    }

    if (getDashBoardServices.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // else if (getDashBoardServices.error != null ||
    //     getDashBoardServices.servicesList.isEmpty) {

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: servicesList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.3,
        ),
        itemBuilder: (context, index) {
          final item = servicesList[index];
          return GestureDetector(
              onTap: () {
                handleToNavigateSelectedScreens(index);
              },
              child: _buildServiceItem(
                item,
                height,
                theme,
              ));
        },
      ),
    );
        // }

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: getDashBoardServices.servicesList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.3,
        ),
        itemBuilder: (context, index) {
          final item = getDashBoardServices.servicesList[index];
          return GestureDetector(
              onTap: () {
                handleToNavigateSelectedScreens(index);
              },
              child: _buildServiceItemWithData(
                theme,
                item,
                height,
              ));
        },
      ),
    );
  }

  // Reusable method to build each service item for placeholder
  Widget _buildServiceItem(
    String title,
    double height,
    dynamic theme,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: theme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: theme.focusColor.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            title,
            style: TextStyle(
              color: theme.primaryColorDark,
              fontSize: height * 0.010,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Reusable method to build each service item with actual data
  Widget _buildServiceItemWithData(theme, item, height) {
    return _buildContainer(
        theme,
        item.title,
        item.subtitle ?? "Analyze implied volatility trends effortlessly.",
        item.imageUrl, // Change this if needed
        item.badge,
        height);
  }

  Widget _buildContainer(theme, title, description, imageUrl, badge, height) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
            color: theme.primaryColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.shadowColor, width: 0.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularCachedDashBoardServices(
                imageURL: imageUrl,
                height: 30,
                width: 30,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: height * 0.010,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColorDark,
                          fontFamily: fontFamily,
                          letterSpacing: 0.4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (badge != null &&
            badge.isNotEmpty) //Todo: Need to use common file CustombookMark
          Positioned(
            top: 0.5,
            right: 0.3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              decoration: BoxDecoration(
                color: theme.secondaryHeaderColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(2),
                ),
              ),
              child: Text(
                " $badge ",
                style: TextStyle(
                    color: theme.floatingActionButtonTheme.foregroundColor,
                    fontSize: height * 0.010,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontFamily),
              ),
            ),
          ),
      ],
    );
  }
}
