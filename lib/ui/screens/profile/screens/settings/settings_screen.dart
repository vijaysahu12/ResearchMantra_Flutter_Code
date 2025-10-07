import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/providers/get_support_mobile/support_mobile_state.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/common_box_buttons/box_shadow_buttons.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/personaldetails/widgets/deactivate_delete_buttons.dart';
import 'package:research_mantra_official/ui/screens/profile/widgets/about_contact.dart';
import 'package:research_mantra_official/ui/screens/profile/widgets/share_and_rate_app.dart';
import 'package:research_mantra_official/ui/screens/profile/widgets/theme_logout.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class SettingsScreen extends StatefulWidget {
  final GetSupportState getMobileNumber;
  final Function handleLogoutPopUp;
  const SettingsScreen(
      {super.key,
      required this.getMobileNumber,
      required this.handleLogoutPopUp});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.appBarTheme.backgroundColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: "Settings",
        handleBackButton: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            AboutAndContactUs(
              getMobileNumber: widget.getMobileNumber,
            ),
            SizedBox(height: 8.h),
            const RateAndShareApp(),
            SizedBox(height: 8.h),
            DarkLightModeWidget(
              handleLogoutPopUp: widget.handleLogoutPopUp,
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                CommonBoxShadowButtons(
                  buttonText: "Delete Account",
                  iconTextName: Icons.delete_outline,
                  handleNavigateToScreen: () {
                    ToastUtils.showToast(
                        "To delete your account, please sent mail to support@researchmantra.com.",
                        "");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
