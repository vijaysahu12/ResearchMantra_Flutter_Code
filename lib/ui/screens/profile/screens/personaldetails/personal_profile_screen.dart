import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/images/dashboard/dashboard_provider.dart';

import 'package:research_mantra_official/providers/userpersonaldetails/user_personal_details_provider.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/personaldetails/screens/personal_details.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

import '../../../../../providers/check_connection_provider.dart';
import '../../../../../services/user_secure_storage_service.dart';

class PersonalProfileDetailsScreen extends ConsumerStatefulWidget {
  const PersonalProfileDetailsScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PersonalProfileDetailsScreen();
}

class _PersonalProfileDetailsScreen
    extends ConsumerState<PersonalProfileDetailsScreen> {
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  // final SecureStorage _secureStorage = SecureStorage();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      handleToRefresh();
    });
  }

  void handleToRefresh() async {
    final connectivityResult = ref.read(connectivityStreamProvider);

    //Checking result based on that displaying connection screen
    final connectionResult = connectivityResult.value;

    if (connectionResult != ConnectivityResult.none) {
      final String mobileUserPublicKey = await _commonDetails.getPublicKey();
      await ref
          .read(getUserPersonalDetailsStateNotifierProvider.notifier)
          .getUserPersonalDetails(mobileUserPublicKey);
    } else {
      ToastUtils.showToast(noInternetConnectionText, "");
    }
  }

  Future<bool> _onWillPop(context) async {
    Navigator.pop(context, true);
    await ref.read(userProfileProvider.notifier).loadUserProfile();

    return true;
  }

// Delete profile image method
  void onProfileImageDelete() async {
    try {
      // Get mobileUserPublicKey using UserSecureStorageService
      final String mobileUserPublicKey = await _commonDetails.getPublicKey();

      await ref.read(userProfileProvider.notifier).deleteProfileImage();
      // Call delete profile image method
      await ref
          .read(getUserPersonalDetailsStateNotifierProvider.notifier)
          .deleteUserProfileImage(
            mobileUserPublicKey,
          );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final getUserPersonalDetails =
        ref.watch(getUserPersonalDetailsStateNotifierProvider);
    final connectivityResult = ref.read(connectivityStreamProvider);

    //Checking result based on that displaying connection screen
    final connectionResult = connectivityResult.value;

    bool isConnection = (connectionResult == ConnectivityResult.none);

    // ignore: deprecated_member_use
    return WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          backgroundColor: theme.primaryColor,
          appBar: CommonAppBarWithBackButton(
            appBarText: personalDetailsButttonText,
            handleBackButton: () {
              ref.read(userProfileProvider.notifier).loadUserProfile();
              Navigator.pop(context, true);
            },
          ),
          body: _buildProfileDetails(getUserPersonalDetails, isConnection),
        ));
  }

  //Widget profile Details body
  Widget _buildProfileDetails(getUserPersonalDetails, hasConnection) {
    if (getUserPersonalDetails.isLoading) {
      return const Center(
        child: CommonLoaderGif(),
      );
    } else if (hasConnection &&
        getUserPersonalDetails.userPersonalDetails == null) {
      return NoInternet(
        handleRefresh: handleToRefresh,
      );
    } else if (getUserPersonalDetails.error != null &&
        getUserPersonalDetails.userPersonalDetails == null) {
      return const ErrorScreenWidget();
    }

    return PersonalProfileDetailsWidget(
        handleToRefresh: handleToRefresh,
        hasConnection: hasConnection,
        isGenderChange: getUserPersonalDetails.isGenderChange,
        profileImageDeleted: getUserPersonalDetails.isProfileImageDeleted,
        onProfileImageDelete: onProfileImageDelete,
        getPersonalDetails: getUserPersonalDetails.userPersonalDetails);
  }
}
