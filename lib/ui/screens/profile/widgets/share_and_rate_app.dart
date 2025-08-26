import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/ui/components/common_box_buttons/box_shadow_buttons.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import 'package:research_mantra_official/utils/utils.dart';
import 'package:share_plus/share_plus.dart';

class RateAndShareApp extends StatefulWidget {
  const RateAndShareApp({super.key});

  @override
  State<RateAndShareApp> createState() => _RateAndShareAppState();
}

class _RateAndShareAppState extends State<RateAndShareApp> {
  final InAppReview inAppReview = InAppReview.instance;
  bool isIos = isGetIOSPlatform();
  bool isShareButtonClicked = true;
  bool isRateButtonClicked = true;

  void handleToShareTheApp() async {
    if (isShareButtonClicked) {
      String appLink = androidAppSharingLink ?? ''; // Ensure it's not null
      if (isIos) {
        appLink = iOSAppSharingLink ?? '';
      }

      if (appLink.isNotEmpty) {
        await Share.share(appLink, subject: "Check out King Research!");
      } else {
        ToastUtils.showToast(somethingWentWrong, "");
      }

      if (mounted) {
        setState(() {
          isShareButtonClicked = false;
        });
      }
    }

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          isShareButtonClicked = true;
        });
      }
    });
  }

  void handleToRateTheApp() async {
    if (isRateButtonClicked) {
      if (!isIos) {
        inAppReview.openStoreListing();
      } else if (isIos) {
        inAppReview.openStoreListing(appStoreId: '6503350906');
      }
      setState(() {
        isRateButtonClicked = false;
      });
    }
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isRateButtonClicked = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CommonBoxShadowButtons(
          buttonText: shareButtonText,
          iconTextName: Icons.share_outlined,
          handleNavigateToScreen: handleToShareTheApp,
        ),
        const SizedBox(
          width: 8,
        ),
        CommonBoxShadowButtons(
          buttonText: rateAppButtonText,
          iconTextName: Icons.star_border,
          handleNavigateToScreen: handleToRateTheApp,
        ),
      ],
    );
  }
}
