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
import 'package:research_mantra_official/ui/common_components/common_outline_button.dart';
import 'package:research_mantra_official/ui/components/app_video/app_video.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';
import 'package:research_mantra_official/ui/components/common_images_checker/common_image_checker.dart';
import 'package:research_mantra_official/ui/components/images/custom_images.dart';
import 'package:research_mantra_official/ui/components/offer_bottom_sheet/offer_bottom_sheet.dart';
import 'package:research_mantra_official/ui/components/popupscreens/quotepopup/daily_quote_popup.dart';
import 'package:research_mantra_official/ui/components/popupscreens/userregistrationpopup/user_registration_popup.dart';
import 'package:research_mantra_official/ui/components/shimmers/home_shimmer.dart';
import 'package:research_mantra_official/ui/router/app_routes.dart';
import 'package:research_mantra_official/ui/screens/home/screens/ongoing_trades.dart';
import 'package:research_mantra_official/ui/screens/home/widgets/carousel_slider_widget.dart';
import 'package:research_mantra_official/ui/screens/home/widgets/perfomance_segment.dart';
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
          // if (state.quotes?.promotionUrl?.isNotEmpty ?? false)
          //   Positioned(
          //     bottom: 8,
          //     left: 18,
          //     child: buildFloatingActionButton(state, theme),
          //   ),
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
    // final topProducts = ref.watch(topThreeProductsProvider);
    // final dashboardServices = ref.watch(getServicesStateNotifierProvider);

    return RefreshIndicator(
      onRefresh: () async => await checkInternetConnection(isRefreshing: true),
      child: isLoadingAll
          ? HomeScreenShimmerContainer(theme: theme)
          : ListView(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 15),
              children: [
                _buildSinglePromotion(),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                      ),
                      child: Text(
                        "Explore Now",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildTopSection(theme),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildBottomGrid(),
                ),
                // Dashboard image slider
                DashboardCarouselSlider(
                  dashboardImageState: dashboardImages,
                  displayImage: displayImage,
                  dashBoardDefaultImage: dashBoardDefaultImage,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PerformanceCard(),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: _buildLiveTradeSection(),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OngoingTradesSection(
                    onSubscribe: (tab) {
                      print("Subscribe for $tab clicked!");
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildScreenersTextWithNavigation(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildScreenerList(context, theme),
                ),

                // Footer (GIF or dashboard images)
                // DashboardFooterImageWidget(
                //   dashboardImages: dashboardImages,
                //   theme: theme,
                //   displayImage: displayImage,
                // ),
                // const SizedBox(height: 5),
                // Inflation screen card
                // GestureDetector(
                //   onTap: navigateToInflationScreen,
                //   child: const GradientContainer(),
                // ),
                // SizedBox(
                //     height: MediaQuery.of(context).size.height * 0.8,
                //     child: const TradingDashboard()),
                // Dashboard Services (Grid)
                // GridServicesWidget(
                //   theme: theme,
                //   navigateToIndex: widget.navigateToIndex,
                //   getDashBoardServices: dashboardServices,
                //   updateButtonType: updateButtonType,
                // ),
                // Top 3 products
                // TopThreeProductsWidget(getTopProductsImages: topProducts),
                // const SizedBox(height: 5),
                // Top gainers and losers with market index
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.48,
                //   child: TopGainersAndTimeWidget(hasConnection: hasConnection),
                // ),
              ],
            ),
    );
  }

  //Widget For Single Promotion
  Widget _buildSinglePromotion() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {},
        child: CircularCachedNetworkLandScapeImages(
          imageURL:
              "https://www.mikereyfman.com/wp-content/gallery/panoramic-1-to-2-ratio/LF-MRD1E0616-27_Contrast_Crop_1x2_Lofoten-Archipelago.jpg",
          baseUrl: "nobase",
          defaultImagePath: "",
          aspectRatio: 2,
        ),
      ),
    );
  }

  Widget _buildTopSection(theme) {
    return Row(
      children: [
        // PRO Trades Section
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColorDark.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PRO Trades',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColorDark,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Stocks + F&O',
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.focusColor,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonOutlineButton(
                      text: 'View All',
                      onPressed: () => print('Pressed!'),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.blue[700]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.workspace_premium,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Open Demat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColorDark,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'No hidden Brokerage',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.focusColor,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonOutlineButton(
                      text: 'Start now',
                      onPressed: () => print('Pressed!'),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.blue[700]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.brightness_low_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

//Bottom Grid Multibaggers,commodity,screeners
  Widget _buildBottomGrid() {
    const List<Map<String, dynamic>> gridItems = [
      {
        'title': 'Multibagger',
        'icon': Icons.trending_up,
        'color': Colors.blue,
      },
      {
        'title': 'Up to 100%',
        'icon': Icons.insights,
        'color': Colors.blue,
      },
      {
        'title': 'Commodity',
        'icon': Icons.search,
        'color': Colors.blue,
      },
      {
        'title': 'Screeners',
        'icon': Icons.medical_services,
        'color': Colors.blue,
      },
    ];

    return GridView.count(
      shrinkWrap: true, // Important if inside a Column
      physics: NeverScrollableScrollPhysics(), // Disable scrolling
      crossAxisCount: 4, // 4 items per row
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.2,
      children: gridItems.map((item) => _buildGridItem(item)).toList(),
    );
  }

  Widget _buildGridItem(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Centered Icon
                Container(
                  width: 60,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item['icon'],
                    color: item['color'],
                    size: 22,
                  ),
                ),
                const SizedBox(height: 8),
                // Title at the bottom
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Widget for Screener Text
  Widget _buildScreenersTextWithNavigation() {
    return Row(
      children: [
        Icon(
          Icons.medical_services,
          color: Colors.red,
          size: 20,
        ),
        SizedBox(width: 4),
        Text(
          'Screeners',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Spacer(),
        CommonOutlineButton(text: "View All", onPressed: () {})
      ],
    );
  }

  Widget _buildLiveTradeSection() {
    return Row(
      children: [
        Icon(
          Icons.track_changes_rounded,
          color: Colors.red,
          size: 20,
        ),
        SizedBox(width: 4),
        Text(
          'Ongoing Trades',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  final List<Map<String, dynamic>> screenerData = [
    {
      "icon": "daily.png",
      "title": "Daily Fresh Breakouts",
      "description": "Stocks breaking daily resistance",
      "iconColor": Colors.blue,
      "bgColor": Colors.blue.shade50,
    },
    {
      "icon": "weekly.png",
      "title": "Weekly Breakouts",
      "description": "Strong weekly price moves",
      "iconColor": Colors.green,
      "bgColor": Colors.green.shade50,
    },
    {
      "icon": "oversold.png",
      "title": "Oversold Stocks",
      "description": "Potential reversal zones",
      "iconColor": Colors.red,
      "bgColor": Colors.red.shade50,
    },
    {
      "icon": "fii.png",
      "title": "FII Change",
      "description": "Institutional inflow/outflow",
      "iconColor": Colors.orange,
      "bgColor": Colors.orange.shade50,
    },
    {
      "icon": "golden.png",
      "title": "Golden Cross Over",
      "description": "50 EMA crossed 200 EMA",
      "iconColor": Colors.purple,
      "bgColor": Colors.purple.shade50,
    },
    {
      "icon": "dividend.png",
      "title": "Upcoming Dividends",
      "description": "Dividend-paying stocks",
      "iconColor": Colors.teal,
      "bgColor": Colors.teal.shade50,
    },
  ];

  Widget _buildScreenerList(BuildContext context, ThemeData theme) {
    return SizedBox(
      height: 130, // adjust based on your design
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: screenerData.length,
        itemBuilder: (context, index) {
          final screener = screenerData[index];

          return Padding(
            padding: const EdgeInsets.only(right: 12), // spacing between cards
            child: _buildScreenerCard(
              icon: screener["icon"] ?? "",
              title: screener["title"] ?? "",
              iconColor: Colors.white, // optional
              bgColor: screener["bgColor"] as Color,
              description: screener["description"] ?? "",
              theme: theme,
            ),
          );
        },
      ),
    );
  }

//Widget for _buildScreenerCard
  Widget _buildScreenerCard({
    required String icon,
    required String title,
    required Color iconColor,
    required Color bgColor,
    required String description,
    required ThemeData theme,
  }) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.primaryColor,
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                //  height: 20,
                width: MediaQuery.of(context).size.width * 0.08,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: (icon.isEmpty || icon == '')
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          screenersButtonCommoIcon,
                        ),
                      )
                    : CustomImages(
                        imageURL: "$screenerImages?imageName=$icon",
                        fit: BoxFit.cover,
                        aspectRatio: 1,
                      ),
              ),
              const SizedBox(height: 8),
              Text(
                title.length > 40 ? "${title.substring(0, 40)}..." : title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
