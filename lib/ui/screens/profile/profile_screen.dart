import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/get_support_mobile/support_mobile_provider.dart';
import 'package:research_mantra_official/providers/images/profile_images/profile_image_provider.dart';
import 'package:research_mantra_official/providers/userpersonaldetails/user_personal_details_provider.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/router/app_routes.dart';
import 'package:research_mantra_official/ui/components/popupscreens/logout_popup/logout_popup.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/settings/block_users.dart';
import 'package:research_mantra_official/ui/screens/profile/widgets/about_contact.dart';
import 'package:research_mantra_official/ui/screens/profile/widgets/share_and_rate_app.dart';
import 'package:research_mantra_official/ui/screens/profile/widgets/theme_logout.dart';
import 'package:research_mantra_official/ui/screens/profile/widgets/social_media_links.dart';
import 'package:research_mantra_official/ui/screens/profile/widgets/my_bucket_tickets.dart';
import 'package:research_mantra_official/ui/screens/profile/widgets/partner_account_performance.dart';
import 'package:research_mantra_official/ui/screens/profile/widgets/user_details.dart';

final providerContainer = ProviderContainer();

class ProfileWidget extends ConsumerStatefulWidget {
  const ProfileWidget({super.key});

  @override
  ConsumerState<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends ConsumerState<ProfileWidget> {
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  bool isLoading = true;
  String currentVersion = "1.0.0";
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return; // Exit if the widget is disposed.

      final String mobileUserPublicKey = await _commonDetails.getPublicKey();

      if (!mounted) return;
      await ref
          .read(getSupportMobileStateProvider.notifier)
          .getSupportMobileData();

      if (!mounted) return;
      // final getAdvertisementDetailsList =
      //     ref.watch(profileScreenImagesProvider);

      // if (getAdvertisementDetailsList.profileScreenImage.isEmpty) {
      if (!mounted) return;
      await ref
          .read(profileScreenImagesProvider.notifier)
          .getProfileImagesList("PROFILESCREEN");
      // }

      if (!mounted) return;
      await ref
          .read(getUserPersonalDetailsStateNotifierProvider.notifier)
          .getUserPersonalDetails(mobileUserPublicKey);
    });
    setState(() {
      isLoading = false;
    });
  }

  void handleNavigateToMyBucketScreen() {
    Navigator.pushNamed(context, myBucketList);
  }

  void handleNavigateToTicketsScreen() {
    Navigator.pushNamed(context, ticketsScreen);
  }

  void handleNavigateToPartnerAccount() {
    Navigator.pushNamed(context, partneraccount);
  }

  void handleNavigateToPerformancescreenScreen() {
    Navigator.pushNamed(context, performancescreen);
  }

  void handleLogoutPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CustomPopupDialog(
            title: logoutButtonText,
            message: areYouSureYouWantTo,
            confirmButtonText: confirmButtonText,
            cancelButtonText: cancelButtonText,
            onConfirm: () {
              setState(() {
                isLoggingout = true;
              });

              _commonDetails.handleLogout(context, ref);
            },
            onCancel: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  //CustomPopupDialog

  void handleNavigateToNotificationSettingsScreen(context) {
    Navigator.pushNamed(context, notificationsSettings);
  }

  void handleNavigateToSettingsScreen(BuildContext context) {
    Navigator.pushNamed(context, settingsScreen);
  }

//handle to navigate blocked screen
  //handle to navigate to blocked user screen
  void handleToNavigateUserBlockedScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const BlockUserScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final getUserPersonalDetails =
        ref.watch(getUserPersonalDetailsStateNotifierProvider);

    final getMobileNumber = ref.watch(getSupportMobileStateProvider);

    return Scaffold(
      backgroundColor: theme.appBarTheme.backgroundColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: profileScreenAppBarText,
        handleBackButton: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UserDetails(
                handleToNavigateUserBlockedScreen:
                    handleToNavigateUserBlockedScreen,
                getUserPersonalDetails:
                    getUserPersonalDetails.userPersonalDetails,
              ),

              // SizedBox(height: 6.h),
              // _buildProfileContainerSection(theme), //New Add
              SizedBox(height: 12.h),
              _buildHelpAndSupportWidget(theme),
              SizedBox(height: 12.h),
              _buildMyBucketWidget(theme),
              SizedBox(height: 12.h),
              _buildDematAccountWidget(theme),
              SizedBox(height: 12.h),

              MyBucketAndTickets(
                handleNavigateToTicketsScreen: handleNavigateToTicketsScreen,
                handleNavigateToMyBucketScreen: handleNavigateToMyBucketScreen,
              ),
              SizedBox(height: 6.h),
              PartnerAccountAndPerformance(
                handleNavigateToPerformancescreenScreen:
                    handleNavigateToPerformancescreenScreen,
                handleNavigateToPartnerAccount: handleNavigateToPartnerAccount,
              ),
              SizedBox(height: 6.h),
              AboutAndContactUs(getMobileNumber: getMobileNumber),
              SizedBox(height: 6.h),
              const RateAndShareApp(),
              SizedBox(height: 6.h),
              DarkLightModeWidget(handleLogoutPopUp: handleLogoutPopUp),
              SizedBox(height: 6.h),
              // AspectRatio(
              //   aspectRatio: 4 / 3,
              //   child: Container(
              //     child: _buildAdvertisementSection(context, theme),
              //   ),
              // ),
              _buildFollowWidget(context, getMobileNumber)
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildAdvertisementSection(BuildContext context, theme) {
  //   final getAdvertisementDetailsList = ref.watch(profileScreenImagesProvider);

  //   // Handle the expiration logic
  //   final expireOnStr =
  //       getAdvertisementDetailsList.profileScreenImage.isNotEmpty
  //           ? getAdvertisementDetailsList.profileScreenImage[0].expireOn
  //           : null;

  //   final DateTime? expireOn =
  //       expireOnStr != null ? DateTime.parse(expireOnStr) : null;

  //   // Show loading indicator only if it's the first load
  //   if (getAdvertisementDetailsList.isLoading && isLoading) {
  //     return Shimmer.fromColors(
  //       baseColor: theme.shadowColor,
  //       highlightColor: theme.shadowColor,
  //       child: Container(
  //         color: theme.appBarTheme.backgroundColor,
  //       ),
  //     );
  //   }

  //   // If the list is empty or expired, show the default image
  //   final bool isExpired =
  //       expireOn != null ? DateTime.now().isAfter(expireOn) : false;
  //   if (getAdvertisementDetailsList.profileScreenImage.isEmpty || isExpired) {
  //     return GestureDetector(
  //       onTap: () {
  //         UrlLauncherHelper.launchUrlIfPossible(youtubeSubUrl);
  //       },
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(5),
  //         child: Image.asset(
  //           profileScreenDefaultImage,
  //           fit: BoxFit.fitHeight,
  //           width: double.infinity,
  //         ),
  //       ),
  //     );
  //   }

  //   // Show the advertisement image if available and not expired
  //   return ExtraAddsWidget(
  //     getProfileScreenImages: getAdvertisementDetailsList.profileScreenImage,
  //   );
  // }

  //Widget to show the social media links
  Widget _buildFollowWidget(BuildContext context, getMobileNumber) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Optimized alignment
        children: [
          _buildTitleRow(theme, followusTitle, 16, theme.primaryColorDark,
              FontWeight.bold),
          SocialMediaLinks(
            getMobileNumber: getMobileNumber,
            isInside: false,
          ),
          _buildTitleRow(theme, unlockTitle, 28, theme.focusColor,
              FontWeight.w700, "montserrat"),
          _buildTitleRow(theme, subUnlockTitle, 13,
              theme.focusColor.withOpacity(0.9), FontWeight.bold),
          _buildVersionRow(theme, "Version", 11,
              theme.focusColor.withOpacity(0.9), FontWeight.bold),
        ],
      ),
    );
  }

  Widget _buildTitleRow(ThemeData theme, String text, double fontSize,
      Color color, FontWeight fontWeight,
      [String? fontFamily]) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyLarge!.copyWith(
              fontSize: fontSize,
              color: color,
              fontWeight: fontWeight,
              fontFamily: fontFamily,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVersionRow(ThemeData theme, String text, double fontSize,
      Color color, FontWeight fontWeight) {
    final currentVersion = ref.watch(appVersionProvider);
    return Row(
      children: [
        Text(
          "$text ${currentVersion.value}",
          style: theme.textTheme.bodyLarge!.copyWith(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
          ),
        ),
      ],
    );
  }

  //Widget for Help and Support
  Widget _buildHelpAndSupportWidget(ThemeData theme) {
    return GestureDetector(
      onTap: handleNavigateToTicketsScreen,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: theme.primaryColor,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF03DAC6)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Help & Support',
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColorDark,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.support_agent,
                  size: 16,
                  color: theme.focusColor,
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: theme.focusColor.withOpacity(0.5),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'For any assistance, please reach out to our support team.',
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontSize: 10.sp,
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//Widget for My bucket
  Widget _buildMyBucketWidget(ThemeData theme) {
    return GestureDetector(
      onTap: handleNavigateToMyBucketScreen,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: theme.primaryColor,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF03DAC6)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'My Bucket',
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColorDark,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 16,
                  color: theme.focusColor,
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: theme.focusColor.withOpacity(0.5),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Easily manage your purchased items and access them anytime.',
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontSize: 10.sp,
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//Widget for Demat Account
  Widget _buildDematAccountWidget(ThemeData theme) {
    return GestureDetector(
      onTap: handleNavigateToPartnerAccount,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: theme.primaryColor,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF03DAC6)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Demat Account',
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColorDark,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.account_balance_wallet,
                  size: 16,
                  color: theme.focusColor,
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: theme.focusColor.withOpacity(0.5),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Manage your Demat account details all in one place.',
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontSize: 10.sp,
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
