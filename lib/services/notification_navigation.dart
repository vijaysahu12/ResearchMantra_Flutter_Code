import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/product_api_response_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/INotification_repository.dart';
import 'package:research_mantra_official/main.dart';

import 'package:research_mantra_official/ui/router/app_routes.dart';
import 'package:research_mantra_official/ui/screens/home/home_navigator.dart';
import 'package:research_mantra_official/ui/screens/products/screens/details/product_details_screen.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/mybuckets/my_bucket_list_screen.dart';
import 'package:research_mantra_official/ui/screens/subscription/subsription_screen.dart';
import 'package:research_mantra_official/utils/utils.dart';

final INotificationRepository _iNotificationRepository =
    getIt<INotificationRepository>();

// This function will handle the navigation to the notifications screen and other screens
Future<void> navigateToSpecificName(String screenName, dynamic id,
    String productName, navigatorKey, isFromNotification) async {
  // Call the API directly to check product validity
  final inAppReview = InAppReview.instance;
  final isIOS = isGetIOSPlatform();

// If screenName is "store" or "none", navigate to notifications immediately
  if (screenName.isEmpty || screenName == "none") {
    navigatorKey.currentState?.pushNamed(notifications);
    return;
  }

  if (screenName.toLowerCase() == "store") {
    isIOS
        ? await inAppReview.openStoreListing(appStoreId: '6503350906')
        : await inAppReview.openStoreListing();

    return;
  }

//Todo: Need to remove this value from here and need to add in the constants value from the constants file
  const allowedRoutes = {
    myBucketScreen,
    "partnerAccountScreen",
    "screenerScreen",
    "marketBasicsScreen",
    "marketAnalysisScreen",
    "inflationscreen",
    'performancescreen',
    'ticketsScreen'
  };

//Todo: Need to remove this value from here and need to add in the constants value from the constants file
  const routeIndexMap = {
    "productscreen": 1,
    "getAllBlogs": 2,
    "researchScreen": 3,
    "scannersScreen": 4,
  };

  final productId = (id is int)
      ? id
      : int.tryParse(id) ?? 0; //Todo: if i pass 0 im getting all data

  try {
    // Check if ID is available and navigate to product/subscription screens
    final navigationMap = {
      "productDetailsScreenWidget": () => ProductDetailsScreenWidget(
            product: ProductApiResponseModel(
              groupName: '',
              description: "",
              id: productId,
              listImage: "",
              name: productName ?? '',
              price: 0,
              overAllRating: 0.0,
              heartsCount: null,
              userRating: 0.0,
              userHasHeart: false,
              isInMyBucket: true,
              isInValidity: false,
              buyButtonText: "",
            ),
            isFromNotification: isFromNotification,
          ),
      "subscriptonPlanScreen": () => Subscription(
            planId: 0,
            productName: productName ?? '',
            productId: productId,
            bonusProductDetails: [],
            isFromNotification: isFromNotification,
          ),
    };

    // Handle product-specific navigation
    if (navigationMap.containsKey(screenName)) {
      if (screenName == 'productDetailsScreenWidget') {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => navigationMap[screenName]!()),
        );
        return;
      }
      final isValid =
          await _iNotificationRepository.checkProductValidity(productId);
      final destination = isValid
          ? navigationMap[screenName]!()
          : MyBucketListScreen(
              isDirect: false,
            );
      if (productId != 0) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => destination),
        );
        return;
      } else {
        navigatorKey.currentState?.pushNamed(notifications);
        return;
      }
    }

    if (routeIndexMap.containsKey(screenName)) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => HomeNavigatorWidget(
                  initialIndex: routeIndexMap[screenName]!,
                )),
        (route) => false,
      );
      return;
    }

    if (allowedRoutes.contains(screenName)) {
      navigatorKey.currentState?.pushNamed("/$screenName");
      return;
    }

    // Default to notifications if no match
    navigatorKey.currentState?.pushNamed(notifications);
    return;
  } catch (e) {
    // Error handling
    print('Navigation error: $e');
    navigatorKey.currentState?.pushNamed(notifications);
  }
}
