import 'package:flutter/material.dart';
import 'package:research_mantra_official/data/models/product_api_response_model.dart';
import 'package:research_mantra_official/ui/Screens/login/login_screen.dart';
import 'package:research_mantra_official/ui/components/sip_calculator/sip_calculator.dart';
import 'package:research_mantra_official/ui/components/trading_web_view.dart';
import 'package:research_mantra_official/ui/components/youtube_play_list/youtube_video_player_playlist.dart';
import 'package:research_mantra_official/ui/router/app_routes.dart';
import 'package:research_mantra_official/ui/router/auth_route_resolver.dart';
import 'package:research_mantra_official/ui/screens/analysis/market_analysis_home_page.dart';
import 'package:research_mantra_official/ui/screens/blogs/blogs_screen.dart';
import 'package:research_mantra_official/ui/screens/home/home_navigator.dart';
import 'package:research_mantra_official/ui/screens/home/home_screen.dart';
import 'package:research_mantra_official/ui/screens/home/screens/inflation_calculator.dart';
import 'package:research_mantra_official/ui/screens/home/widgets/top_images/top_dashboard_images.dart';
import 'package:research_mantra_official/ui/screens/learning/screen/candlestick_screens/candel_screen.dart';
import 'package:research_mantra_official/ui/screens/learning/screen/candlestick_screens/widgets/description_page_candelistic.dart';
import 'package:research_mantra_official/ui/screens/learning/screen/indicator_screens/widgets/description_page_indicator.dart';
import 'package:research_mantra_official/ui/screens/learning/widgets/examples_screen.dart';
import 'package:research_mantra_official/ui/screens/learning/screen/indicator_screens/indicator_screen.dart';
import 'package:research_mantra_official/ui/screens/notification/notification_screen.dart';

import 'package:research_mantra_official/ui/screens/products/product_screen.dart';
import 'package:research_mantra_official/ui/components/splash/splash_screen.dart';
import 'package:research_mantra_official/ui/screens/products/screens/details/product_details_screen.dart';
import 'package:research_mantra_official/ui/screens/profile/profile_screen.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/mybuckets/my_bucket_list_screen.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/notifications/notification_settings_widget.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/partneraccount/partner_account.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/performance/performance.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/personaldetails/personal_profile_screen.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/tickets/tickets_screen.dart';
import 'package:research_mantra_official/ui/screens/research/research_screen.dart';
import 'package:research_mantra_official/ui/screens/research/screen/bucket_details_screen.dart';

import 'package:research_mantra_official/ui/screens/screeners/screeners_home_screen.dart';
import 'package:research_mantra_official/ui/screens/subscription/subsription_screen.dart';
import '../components/youtubevideoplayer/youtube_video_player_screen.dart';

class AppRouter {
  // static bool _isFirstLaunch = true;

  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        // if (_isFirstLaunch) {
        // _isFirstLaunch = false;
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      // } else {
      //   return MaterialPageRoute(
      //     builder: (_) => const AuthRouteResolverWidget(),
      //   );
      // }
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginWidget(),
        );
      case homeNavigator:
        final args = routeSettings.arguments as Map<String, dynamic>;
        final int index =
            args['initialIndex'] ?? 0; // Default to 0 if not provided
        final bool isFromHome = args['isFromHome'] ?? false;
        return MaterialPageRoute(
          builder: (_) => HomeNavigatorWidget(
            initialIndex: index,
            isFromHome: isFromHome,
          ),
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => HomeScreenWidget(
            navigateToIndex: (int, isResetTabSelection) {},
          ),
        );

      case researchScreen:
        //  bool  ?value= routeSettings.arguments as bool;
        return MaterialPageRoute(
          builder: (_) => ResearchScreen(),
        );

      case profileWidget:
        return MaterialPageRoute(
          builder: (_) => const ProfileWidget(),
        );

      case screenerScreen:
        return MaterialPageRoute(
          builder: (_) => const ScreenersHomeScreen(),
        );

      case marketBasicsScreen:
        return MaterialPageRoute(
          builder: (_) => const TopDashBoardBottomImages(),
        );

      case marketAnalysisScreen:
        return MaterialPageRoute(
          builder: (_) => const MarketAnalysisiHomepage(),
        );

      // //MarketAnalysisPage
      // case marketanalysisscreen:
      //   return MaterialPageRoute(
      //     builder: (_) => const AllAnalysisPage(),
      //   );

      // case blogPostScreen:
      //   return MaterialPageRoute(
      //     builder: (_) => PostScreen(
      //       existingContent: '',
      //       existingBlogId: '',
      //       existingImages: const [],
      //       onPostSuccess: () {},
      //     ),
      //   );

      case subscriptonPlanScreen:
        var datavalue = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => Subscription(
            planId: 0,

            productName: datavalue[
                "productName"], // You might want to pass actual product name here
            productId: datavalue[
                'productId'], // You might want to pass actual product ID here

            bonusProductDetails: [], isFromNotification: false,
          ),
        );

      case productDetailsScreenWidget:
        var datavalue = routeSettings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreenWidget(
            product: ProductApiResponseModel(
              groupName: datavalue['groupName'],
              description: datavalue['description'],
              id: datavalue['id'],
              listImage: datavalue['listImage'],
              name: datavalue['name'],
              price: datavalue['price'],
              overAllRating: datavalue['overAllRating'],
              heartsCount: datavalue['heartsCount'],
              userRating: datavalue['userRating'],
              userHasHeart: datavalue['userHasHeart'],
              isInMyBucket: datavalue['isInMyBucket'],
              isInValidity: datavalue['isInValidity'],
              buyButtonText: datavalue['buyButtonText'],
            ),
            isFromNotification: false,
          ),
        );

      case getAllBlogs:
        return MaterialPageRoute(
          builder: (_) => const BlogsScreen(),
        );

      case notifications:
        final int selectedIndex = routeSettings.arguments as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) => NotificationScreen(
            selectedIndex: selectedIndex,
          ),
        );

      case partnerAccountScreen:
        return MaterialPageRoute(
          builder: (_) => const PartnerAccountScreen(),
        );

      case productscreen:
        return MaterialPageRoute(
          builder: (_) => const AllProducts(
            isFromHome: false,
          ),
        );

      // case webviewscreen:
      //   final String viewChartUrl = routeSettings.arguments as String;
      //   return MaterialPageRoute(
      //     builder: (_) => WebViewScreen(
      //       url: viewChartUrl,
      //     ),
      //   );
      case webviewscreen:
        final String viewChartUrl = routeSettings.arguments as String;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              WebViewScreen(url: viewChartUrl),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0); // Right to left
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            final offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        );

      // case researchScreen:
      //   final num id = routeSettings.arguments as num;
      //   final int pageNUmber = routeSettings.arguments as int;
      //   final String screenName = routeSettings.arguments as String;
      //   final String publicKey = routeSettings.arguments as String;

      //   return MaterialPageRoute(
      //     builder: (_) => CompaniesListScreenUi(
      //       publicKey: publicKey,
      //       pageNUmber: pageNUmber,
      //       screennName: screenName,
      //       id: id,
      //     ),
      //   );
      case bucketDetailsScreen:
        final int id = routeSettings.arguments as int;
        final int productId = routeSettings.arguments as int;

        final int basketId = routeSettings.arguments as int;
        final int pageNumber = routeSettings.arguments as int;
        final int totalLength = routeSettings.arguments as int;
        final String marketCap = routeSettings.arguments as String;
        final String ttmpe = routeSettings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => DetailsBucketScreen(
            basketId: basketId,
            totalLength: totalLength,
            pageNumber: pageNumber,
            id: id,
            marketCap: marketCap,
            ttmpe: ttmpe,
            productId: productId,
          ),
        );
      // route for only yt video player
      case youtubeVideoPlayerWidget:
        final dynamic getProductItemContent =
            routeSettings.arguments as dynamic;
        return MaterialPageRoute(
          builder: (_) => YoutubePlayerWidget(
            getProductItemContent: getProductItemContent,
          ),
        );
      // routes for youtube video player with playlist
      case youtubeVideoPlayerPlaylistWidget:
        final dynamic playlistDataContent = routeSettings.arguments as dynamic;
        final int productId = routeSettings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => YoutubePlayerPlaylistWidget(
            productId: productId,
            playlistDataContent: playlistDataContent,
          ),
        );
      case personalProfileDetails:
        return MaterialPageRoute(
          builder: (_) => const PersonalProfileDetailsScreen(),
        );

      case ticketsScreen:
        return MaterialPageRoute(
          builder: (_) => const TicketsScreen(),
        );

      case partneraccount:
        return MaterialPageRoute(
          builder: (_) => const PartnerAccountScreen(),
        );

      case performancescreen:
        return MaterialPageRoute(
            builder: (_) => const PerformanceScreen(
                  perfomanceValueId: 1,
                ));
      case notificationsSettings:
        return MaterialPageRoute(
          builder: (_) => const NotificationSettingsWidget(),
        );

      case myBucketList:
        return MaterialPageRoute(
          builder: (_) => const MyBucketListScreen(
            isDirect: true,
          ),
        );
      // Inside your RouteGenerator or onGenerateRoute
      case scannersScreen:
        return MaterialPageRoute(
          builder: (_) => HomeNavigatorWidget(
            initialIndex: 4,
            topicName: 'BREAKFAST',
          ),
        );

// sip calculator navigator
      case sipCalculatorScreen:
        return MaterialPageRoute(
          builder: (_) => const SipCalculator(),
        );

      case inflationscreen:
        return MaterialPageRoute(
          builder: (_) => const RetirementCalculator(),
        );

      case candleScreen:
        final int id = routeSettings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => CandleScreen(
            id: id,
          ),
        );

      case indicatorScreen:
        final int id = routeSettings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => IndicatorScreen(
            id: id,
          ),
        );
      case detailScreen:
        final int id = routeSettings.arguments as int;
        final String endPoints = routeSettings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => DescriptionPage(
            id: id,
            endPoints: endPoints,
          ),
        );

      case graphScreen:
        final int id = routeSettings.arguments as int;
        final String endPoints = routeSettings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ExampleScreen(endPoints: endPoints, id: id),
        );
      case descriptionPageIndicator:
        final int id = routeSettings.arguments as int;
        final String endPoints = routeSettings.arguments as String;

        return MaterialPageRoute(
          builder: (_) => DescriptionPageIndicator(endPoint: endPoints, id: id),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const AuthRouteResolverWidget(
            userLoggedIn: false,
            // isNewVersion: false,
          ),
        );
    }
  }
}
