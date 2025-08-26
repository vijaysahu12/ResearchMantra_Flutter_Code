
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/images/login_images/login_images_provider.dart';
import 'package:research_mantra_official/providers/partneraccount/partner_account_provider.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/partneraccount/screen/partner_account.dart';
import 'package:research_mantra_official/utils/utils.dart';

class PartnerAccountScreen extends ConsumerStatefulWidget {
  const PartnerAccountScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PersonalProfileDetailsScreen();
}

class _PersonalProfileDetailsScreen
    extends ConsumerState<PartnerAccountScreen> {
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  OverlayEntry? partnerNameDropdownOverlayEntry;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDematImages(true);
      getDetails(false);
    });
  }

//handle get partner details
  Future<void> getDetails(isRefresh) async {
    final String mobileUserPublicKey = await _commonDetails.getPublicKey();
    ref
        .read(partnerAccountProvider.notifier)
        .getPartnerAccountDetails(mobileUserPublicKey, isRefresh);
  }

  Future<void> getDematImages(bool isRefresh) async {
    await ref
        .read(loginScreenImagesProvider.notifier)
        .getLoginScreenImagesList(dematEndPoint);
  }

//handle refresh
  Future<void> _refreshData(isRefresh) async {
    getDetails(isRefresh);
    getDematImages(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final partnerAccountState = ref.watch(partnerAccountProvider);
    final dashboardImageState = ref.watch(loginScreenImagesProvider);
    return GestureDetector(
      onTap: () {
        partnerAccountDetailsKey.currentState?.handleRemoveToggle();
      },
      child: Scaffold(
        backgroundColor: theme.primaryColor,
        appBar: CommonAppBarWithBackButton(
          appBarText: partnerAccountNavbarText,
          handleBackButton: () {
            setState(() {
              Navigator.pop(context, true);
            });
          },
        ),
        body: (partnerAccountState.isLoading && isLoading)
            ? const CommonLoaderGif()
            : RefreshIndicator(
                onRefresh: () => _refreshData(true),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: theme.primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.focusColor.withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: PartnerAccountDetails(
                                  key: partnerAccountDetailsKey,
                                  // partnerNameDropdownOverlayEntry:partnerNameDropdownOverlayEntry
                                  partnerAccountState: partnerAccountState,
                                ),
                              ),
                              if (dashboardImageState
                                      .loginScreenImages.isNotEmpty) ...[
                                AspectRatio(
                                  aspectRatio: 4 / 3,
                                  child: Container(
                                    child: Utils.buildAdvertisementSection(
                                        context,
                                        dashboardImageState.loginScreenImages,
                                        dashboardImageState.error,
                                        dashboardImageState.isLoading),
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                )
                              ]
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
