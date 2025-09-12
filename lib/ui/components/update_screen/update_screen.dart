import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/services/url_launcher_helper.dart';
import 'package:research_mantra_official/ui/common_components/common_outline_button.dart';
import 'package:research_mantra_official/ui/components/button.dart';
import 'package:research_mantra_official/ui/components/dynamic_promo_card/service/promo_manager.dart';
import 'package:research_mantra_official/ui/router/auth_route_resolver.dart';

class UpdateScreen extends StatefulWidget {
  final bool userLoggedIn;
  final String updateScreenText;

  const UpdateScreen({
    super.key,
    required this.userLoggedIn,
    required this.updateScreenText,
  });

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   PromoManager().tryShowPromo(context, disable: true);
    // });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   PromoManager().tryShowPromo(context, disable: true); // 👈 disables it here
  // }

  void navigateToAuthScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => AuthRouteResolverWidget(
          userLoggedIn: widget.userLoggedIn,
        ),
      ),
      (route) => false,
    );
  }

  Future<void> _handleUpdateNavigation() async {
    // Map of platform identifiers to store URLs
    const storeUrls = {
      'android':
          "https://play.google.com/store/apps/details?id=com.kingresearch",
      'ios': "https://apps.apple.com/in/app/king-research/id6503350906",
    };

    // Determine current platform key
    final platformKey = Platform.isAndroid
        ? 'android'
        : Platform.isIOS
            ? 'ios'
            : null;

    if (platformKey == null) {
      // Log unsupported platform for monitoring
      print("Unsupported platform: ${Platform.operatingSystem}");
      return;
    }

    final url = storeUrls[platformKey]!;

    try {
      await UrlLauncherHelper.launchUrlIfPossible(url);
    } catch (e, stackTrace) {
      print("Failed to launch store URL: $e\n$stackTrace");
    }
    navigateToAuthScreen();

    ///TODO: For production need to remove navigation
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor.withOpacity(0.5),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColorDark.withOpacity(0.2),
                    blurRadius: 1,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ALERT!', style: theme.textTheme.headlineSmall),
                  SizedBox(height: 10.h),
                  Text(updatePopupTitleText, style: theme.textTheme.bodyMedium),
                  SizedBox(height: 15.h),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: _buildUpdateButton(theme)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateButton(ThemeData theme) {
    return CommonOutlineButton(
      text: "Update",
      onPressed: _handleUpdateNavigation,
      borderColor: Colors.transparent,
      textStyle: TextStyle(fontSize: 14.sp, color: theme.primaryColorDark),
    );
  }
}
