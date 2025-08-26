import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/services/notification_navigation.dart';

import 'package:research_mantra_official/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  static Future<void> launchUrlIfPossible(String url) async {
    final uri = Uri.tryParse(url.trim()); // Safely parse and trim URL

    if (await canLaunchUrl(Uri.parse(uri.toString()))) {
      await launchUrl(
        Uri.parse(uri.toString()),
        mode: LaunchMode.externalApplication,
      );
    } else {
      Uri.parse(uri.toString());
    }
  }

  //Function to handle redirection
  static void handleToNavigatePathScreen(BuildContext context, String routeName,
      dynamic productId, String? productName, bool isFromNotification) async {
    final inAppReview = InAppReview.instance;
    final isIOS = isGetIOSPlatform();

    if (routeName == "store") {
      isIOS
          ? inAppReview.openStoreListing(appStoreId: '6503350906')
          : inAppReview.openStoreListing();
      return;
    }

    if (routeName.startsWith("http")) {
      await UrlLauncherHelper.launchUrlIfPossible(routeName);
      return;
    }

    if (routeName.isEmpty || routeName.toLowerCase() == "none") {
      print("No Redirections");
      return;
    }

    await navigateToSpecificName(
        routeName ,
        productId ?? '',
        productName ?? '',
        navigatorKey, // Pass the navigator key
        isFromNotification);
  }
}
