import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/user_login_response_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ifcm_respository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/accept_free_trial/accept_free_trial_provider.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/images/dashboard/dashboard_provider.dart';
import 'package:research_mantra_official/providers/images/dashboard/top_products/top_three_products_provider.dart';
import 'package:research_mantra_official/providers/daily_quotes/daily_quote_provider.dart';
import 'package:research_mantra_official/providers/products/list/product_list_provider.dart';
import 'package:research_mantra_official/providers/services/services_provider.dart';
import 'package:research_mantra_official/providers/services_buttons_provider.dart';
import 'package:research_mantra_official/providers/userpersonaldetails/user_personal_details_provider.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/services/secure_storage.dart';
import 'package:research_mantra_official/services/url_launcher_helper.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/app_video/app_video.dart';
import 'package:research_mantra_official/ui/components/common_images_checker/common_image_checker.dart';
import 'package:research_mantra_official/ui/components/offer_bottom_sheet/offer_bottom_sheet.dart';
import 'package:research_mantra_official/ui/components/popupscreens/quotepopup/daily_quote_popup.dart';
import 'package:research_mantra_official/ui/components/popupscreens/userregistrationpopup/user_registration_popup.dart';
import 'package:research_mantra_official/ui/components/shimmers/home_shimmer.dart';
import 'package:research_mantra_official/ui/router/app_routes.dart';
import 'package:research_mantra_official/ui/screens/home/widgets/carousel_slider_widget.dart';
import 'package:research_mantra_official/ui/screens/home/widgets/dashboard_footer_image_widget.dart';
import 'package:research_mantra_official/ui/screens/home/widgets/inflation_container.dart';
import 'package:research_mantra_official/ui/screens/home/widgets/services/services.dart';
import 'package:research_mantra_official/ui/screens/home/widgets/top_gainers_and_time_widget.dart';
import 'package:research_mantra_official/ui/screens/home/widgets/top_products/top_three_products.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/mybuckets/my_bucket_list_screen.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class HomeScreenWidget extends ConsumerStatefulWidget {
  final Function(int, bool) navigateToIndex;

  const HomeScreenWidget({
    super.key,
    required this.navigateToIndex,
  });

  @override
  ConsumerState<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends ConsumerState<HomeScreenWidget> {
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  final SecureStorage _secureStorage = getIt<SecureStorage>();

  Key carouselKey = UniqueKey();
  List<String>? images = [];
  List<String>? urls = [];
  String? quoteTitle;
  String? quoteAuthor;
  int index = 0;
  var currentDateAndTime = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  String? latestUpdatedDateTime;
  bool isRefreshTime = false;
  bool hasRefreshed = false;
  bool isHideVideoFloatButton = true;
  bool isLoadingAll = false;
  // scrollController
  late ScrollController _scrollController;
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final isCalled = ref.read(isCalledProvider);
      if (isCalled) return;

      setState(() => isLoadingAll = true); // Show shimmer only on first load

      try {
        await checkInternetConnection();
      } catch (e) {
        print('Error during internet check: $e');
      }

      if (!mounted) return;
      ref.read(isCalledProvider.notifier).setCalled(true); // Mark API as called
    });
  }

  // Function to check internet and fetch data
  Future<void> checkInternetConnection({bool isRefreshing = false}) async {
    if (!mounted) return;

    if (isRefreshing) {
      setState(() => isLoadingAll = true); // Show shimmer on pull-to-refresh
    }

    try {
      final isConnected =
          await CheckInternetConnection().checkInternetConnection();

      if (!isConnected) {
        ToastUtils.showToast(noInternetConnectionText, "");
      }

      final currentVersion = await ref.read(appVersionProvider.future);
      final mobileUserPublicKey = await _commonDetails.getPublicKey();

      if (isConnected) {
        await Future.wait([
          ref
              .read(getDailyQuoteStateNotifierProvider.notifier)
              .manageSubscriptionTopics(mobileUserPublicKey, currentVersion),
          ref
              .read(dashBoardImagesProvider.notifier)
              .getDashBoardImagesList(dashBoardurlEndpoint, false),
          ref
              .read(topThreeProductsProvider.notifier)
              .getTopThreeProducts(mobileUserPublicKey, true),
          ref
              .read(productsStateNotifierProvider.notifier)
              .getProductList(mobileUserPublicKey, false),
          ref.read(getServicesStateNotifierProvider.notifier).getServicesList(),
        ]);
      }

      await handleIfUserIsNotFilledTheRegistrationForm(); // Always execute
    } catch (e) {
      print("Error during data fetch: $e");
      // Optionally log to Crashlytics or analytics
    }
    if (!mounted) return;
    setState(() => isLoadingAll = false);
  }

//Handle to  check user details
  Future<void> handleIfUserIsNotFilledTheRegistrationForm() async {
    final userDetails = await _commonDetails.getUserDetails();

    final userData = UserData.fromJson(userDetails);

    if (userData.fullName.trim().isEmpty) {
      _showUserRegistrationDialog(userData.mobileNumber ?? '');
    } else {
      String? lastDayPopUpExecutionDay =
          await _secureStorage.read(lastDailyOncePopupExecutionDateAndTime);

      String formattedDate = formatter.format(currentDateAndTime);

      if (lastDayPopUpExecutionDay != formattedDate ||
          lastDayPopUpExecutionDay == null) {
        await _secureStorage.write(
            lastDailyOncePopupExecutionDateAndTime, formattedDate);

        final state = ref.watch(getDailyQuoteStateNotifierProvider);

        if (!state.isLoading && state.quotes != null) {
          await handleSubscriptionTopicsInitially(state);

          _updateFcmToken(userDetails['publicKey']);
        }
      }
    }
  }

  //Function To show User Register pop-up
  void _showUserRegistrationDialog(String mobileNumber) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: Center(child: UserRegistrationPopUp(mobile: mobileNumber)),
      ),
    );
  }

//Function To Update Fcm Token
  Future<void> _updateFcmToken(String publicKey) async {
    try {
      await FirebaseMessaging.instance.deleteToken();
      final token = await FirebaseMessaging.instance.getToken();
      await getIt<IUpdateFcmRepository>().updateFcm(publicKey, token ?? "");
    } catch (e) {
      print("Error updating FCM token: $e");
    }
  }

  //Function to display the quote
  Future<void> handleSubscriptionTopicsInitially(dynamic state) async {
    try {
      final quotes = state?.quotes;
      if (quotes == null) {
        print("State or quotes is null: $quotes");
        return;
      }

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Center(
            child: CustomshowDailyQuote(
              quoteTitle: quotes.quote,
              quoteAuthor: quotes.author,
            ),
          ),
        ),
      );

      if (quotes.discountStatus == true) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            handleToOpenCustomBottomSheet(quotes);
          }
        });
      }
    } catch (error) {
      print("Error in handleSubscriptionTopicsInitially: $error");
    }
  }

  Future<void> handleToOpenCustomBottomSheet(dynamic quotes) async {
    final imageUrl = "$getDiscountImageurl?imageName=${quotes.imageUrl}";

    try {
      final imageExists = await CommonImagesChecker()
          .doesImageExist(quotes.imageUrl, getDiscountImageurl);

      if (!mounted) return;

      if (!imageExists) {
        print('Image not found: $imageUrl');
        return;
      }

      showModalBottomSheet(
        context: context,
        builder: (_) => CustomOfferBottomSheet(
          actionType: quotes.actionUrl,
          imagePath: imageUrl,
          buttonText: quotes.buttonText,
          onPressed: () => handleToCallOfferApi(quotes.actionUrl),
        ),
      );
    } catch (e) {
      print("Error in handleToOpenCustomBottomSheet: $e");
    }
  }

  //handle to call activate api
  Future<void> handleToCallOfferApi(String actionType) async {
    if (!mounted) return;
    Navigator.pop(context);

    try {
      final action = actionType.toLowerCase();
      if (action == "click") {
        final publicKey = await _commonDetails.getPublicKey();
        ref
            .read(acceptFreeTrialNotifier.notifier)
            .acceptFreeTrialData(publicKey);
        _secureStorage.delete(discountStatusStorage);

        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const MyBucketListScreen(isDirect: true),
            ),
          );
        }
      } else if (actionType.startsWith("http")) {
        await UrlLauncherHelper.launchUrlIfPossible(actionType);
      } else {
        print("No valid action URL or type provided: $actionType");
      }
    } catch (e) {
      print("Error in handleToCallOfferApi (click): $e");
    }
  }

  void updateButtonType(value) {
    ref.read(servicesButtonNotifierProvider.notifier).updateButtonType(value);
  }

  //Function to navigate inflation calculator screen
  void navigateToInflationScreen() {
    Navigator.pushNamed(context, inflationscreen);
  }

  //scroll controller
  void _scrollListener() {
    if (_scrollController.offset <=
        _scrollController.position.minScrollExtent + 10) {
      // At top
      if (!isVisible) setState(() => isVisible = true);
    } else if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent - 70) {
      // At bottom
      if (isVisible) setState(() => isVisible = false);
    }
  }

//Function redirect AppVideoScreen
  void navigateToAppVideoScreen(String? promotionUrl) {
    final videoUrl = (promotionUrl != null && promotionUrl.startsWith('http'))
        ? promotionUrl
        : defaultAppUseUrl;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppVideoPlayerScreen(videoUrl: videoUrl),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(getDailyQuoteStateNotifierProvider);
    final connectivityResult = ref.watch(connectivityStreamProvider);
    final hasConnection = connectivityResult.value != ConnectivityResult.none;

    if (!hasConnection) {
      ToastUtils.showToast(noInternetConnectionText, "");
      hasRefreshed = false;
    }

    return Scaffold(
      backgroundColor: theme.appBarTheme.backgroundColor,
      body: Stack(
        children: [
          buildDashboardContent(hasConnection, theme),
          if (state.quotes?.promotionUrl?.isNotEmpty ?? false)
            Positioned(
              bottom: 8,
              left: 18,
              child: buildFloatingActionButton(state, theme),
            ),
        ],
      ),
    );
  }

  Widget buildFloatingActionButton(state, ThemeData theme) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: () => navigateToAppVideoScreen(state.quotes?.promotionUrl),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.asset(
            videoFloatIcon,
            scale: 15,
          ),
        ),
      ),
    );
  }

//Modify your RefreshIndicator
  Widget buildDashboardContent(bool hasConnection, ThemeData theme) {
    final dashboardImages = ref.watch(dashBoardImagesProvider);
    final topProducts = ref.watch(topThreeProductsProvider);
    final dashboardServices = ref.watch(getServicesStateNotifierProvider);

    return RefreshIndicator(
      onRefresh: () async => await checkInternetConnection(isRefreshing: true),
      child: isLoadingAll
          ? HomeScreenShimmerContainer(theme: theme)
          : ListView(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 15),
              children: [
                // Dashboard image slider
                DashboardCarouselSlider(
                  dashboardImageState: dashboardImages,
                  displayImage: displayImage,
                  dashBoardDefaultImage: dashBoardDefaultImage,
                ),
                // Footer (GIF or dashboard images)
                DashboardFooterImageWidget(
                  dashboardImages: dashboardImages,
                  theme: theme,
                  displayImage: displayImage,
                ),
                const SizedBox(height: 5),
                // Inflation screen card
                GestureDetector(
                  onTap: navigateToInflationScreen,
                  child: const GradientContainer(),
                ),
                // Dashboard Services (Grid)
                GridServicesWidget(
                  theme: theme,
                  navigateToIndex: widget.navigateToIndex,
                  getDashBoardServices: dashboardServices,
                  updateButtonType: updateButtonType,
                ),
                // Top 3 products
                // TopThreeProductsWidget(getTopProductsImages: topProducts),
                const SizedBox(height: 5),
                // Top gainers and losers with market index
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.48,
                  child: TopGainersAndTimeWidget(hasConnection: hasConnection),
                ),
              ],
            ),
    );
  }
}
