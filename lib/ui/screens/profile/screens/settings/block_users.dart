import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/blogs/main/block_user/block_user_provider.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/components/profile_image/common_profile_widget.dart';

class BlockUserScreen extends ConsumerStatefulWidget {
  const BlockUserScreen({super.key});

  @override
  ConsumerState<BlockUserScreen> createState() => _BlockUserScreenWidget();
}

class _BlockUserScreenWidget extends ConsumerState<BlockUserScreen> {
  final UserSecureStorageService userDetails = UserSecureStorageService();
  bool isLoading = true;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      handleToRefresh();
    });

    super.initState();
  }

  void handleToRefresh() async {
    final String mobileUserPublicKey = await userDetails.getPublicKey();

    await ref
        .read(getBlockedUserStateProvider.notifier)
        .getBlockedUserList(mobileUserPublicKey);
    setState(() {
      isLoading = false;
    });
  }

  //handle to unblock user
  void handleToUnblockUser(blockedId) async {
    final String mobileUserPublicKey = await userDetails.getPublicKey();
    ref
        .read(getBlockedUserStateProvider.notifier)
        .unBlockUser(mobileUserPublicKey, blockedId, "unblock");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: 'Blocked Users',
        handleBackButton: () {
          Navigator.pop(context);
        },
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            handleToRefresh();
          },
          child: _buildListOfUser(theme)),
    );
  }

  Widget _buildListOfUser(theme) {
    final connectivityResult = ref.watch(connectivityStreamProvider);

    //Checking result based on that displaying connection screen
    final connectionResult = connectivityResult.value;

    bool isConnection = connectionResult == ConnectivityResult.none;

    final getBlockedUser = ref.watch(getBlockedUserStateProvider);
    if (isConnection) {
      return Center(
        child: NoInternet(handleRefresh: handleToRefresh),
      );
    }

    if (getBlockedUser.isLoading || isLoading) {
      return const Center(
        child: CommonLoaderGif(),
      );
    } else if (getBlockedUser.blockUserResponseModel.isEmpty) {
      return const Center(
          child: NoContentWidget(
        message: "You're Connected with Everyone",
      ));
    } else if (getBlockedUser.error != null) {
      return const Center(
        child: ErrorScreenWidget(),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: getBlockedUser.blockUserResponseModel.length,
          itemBuilder: (context, index) {
            return _buildForBlockedUser(
                theme, getBlockedUser.blockUserResponseModel[index]);
          },
        ),
      );
    }
  }

  // Widget for blocked user list
  Widget _buildForBlockedUser(theme, blockedUser) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: theme.shadowColor, width: 0.5))),
      child: Row(
        children: [
          UserProfileImage(
            gender: blockedUser.gender,
            profileImage: blockedUser.profileImage,
            borderColor: theme.shadowColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              blockedUser.fullName ?? "",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: theme.textTheme.bodyLarge!.color,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: BoxDecoration(
              color: theme.indicatorColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                handleToUnblockUser(blockedUser.id);
              },
              child: Text(
                unblockButtonText,
                style: TextStyle(
                  color: theme.floatingActionButtonTheme.foregroundColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
