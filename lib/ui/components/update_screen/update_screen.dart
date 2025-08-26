import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/services/url_launcher_helper.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PromoManager().tryShowPromo(context, disable: true);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PromoManager().tryShowPromo(context, disable: true); // 👈 disables it here
  }

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
    final storeUrl = Platform.isAndroid
        ? "https://play.google.com/store/apps/details?id=com.kingresearch"
        : Platform.isIOS
            ? "https://apps.apple.com/in/app/king-research/id6503350906"
            : null;

    if (storeUrl != null) {
      await UrlLauncherHelper.launchUrlIfPossible(storeUrl);
    } else {
      print("Unsupported platform");
    }

    navigateToAuthScreen();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: theme.primaryColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primaryColorDark.withOpacity(0.2),
                        blurRadius: 1,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(appLogoPopUp, width: 50, height: 50),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        updatePopupTitleText,
                        style: TextStyle(
                          color: theme.focusColor,
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      HtmlWidget(
                        widget.updateScreenText,
                        textStyle: TextStyle(
                          color: theme.primaryColorDark,
                          fontSize: width * 0.035,
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildUpdateButton(theme),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton(ThemeData theme) {
    return Button(
      text: "Update Now",
      onPressed: _handleUpdateNavigation,
      backgroundColor: theme.indicatorColor,
      textColor: theme.floatingActionButtonTheme.foregroundColor,
    );
  }
}
