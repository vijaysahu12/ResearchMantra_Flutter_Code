import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/community/community_type_model.dart';
import 'package:research_mantra_official/data/models/payment_model/payment_model.dart';
import 'package:research_mantra_official/data/models/product_api_response_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/payment_gateway/payment_gateway_provider.dart';
import 'package:research_mantra_official/providers/products/single/single_product_provider.dart';
import 'package:research_mantra_official/ui/components/common_buttons/common_button.dart';
import 'package:research_mantra_official/ui/components/button.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/blogs/screens/community/community_base_screen.dart';
import 'package:research_mantra_official/ui/screens/home/home_navigator.dart';
import 'package:research_mantra_official/ui/screens/products/screens/details/product_overview_and_contents/product_details_content.dart';
import 'package:research_mantra_official/ui/screens/products/screens/details/product_overview_and_contents/product_details_overview.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/performance/performance.dart';
import 'package:research_mantra_official/ui/screens/scanners/screens/today_scanners.dart';
import 'package:research_mantra_official/ui/screens/subscription/subsription_screen.dart';

double finalUpdatedPrice = 0.0;
int? daysToGoEnd = 1;
String isFree = "free";

class ProductDetailsScreenWidget extends ConsumerStatefulWidget {
  final ProductApiResponseModel product;
  final bool? isFromResearch;
  final num? basketId;
  final String? buttonName;
  final String? publicKey;
  final int? pageNumber;
  final int? reasearchbasketId;
  final bool isFromNotification;

  const ProductDetailsScreenWidget(
      {super.key,
      required this.product,
      this.isFromResearch,
      this.basketId,
      this.pageNumber,
      this.publicKey,
      this.buttonName,
      this.reasearchbasketId,
      required this.isFromNotification});

  @override
  ConsumerState<ProductDetailsScreenWidget> createState() =>
      _ProductDetailsScreenWidget();
}

class _ProductDetailsScreenWidget
    extends ConsumerState<ProductDetailsScreenWidget> with RouteAware {
  final PageController _pageController = PageController();
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  // final TextEditingController _couponCodeContoller = TextEditingController();
  HttpClient httpClient = getIt<HttpClient>();

  bool isLoading = true;
  late int productItemId;

  String appId = "";
  bool enableLogging = true;
  String checksum = "";

  dynamic result;

  String body = "";
  int isSelectedIndex = 0;
  late DateTime currentTime;
  late String formattedDate;
  late String merchantTransactionId;

//handle to navigate
  handleToNavigateScanners(productCode) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => HomeNavigatorWidget(
          initialIndex: 4,
          topicName: productCode,
        ),
      ),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _checkAndFetch();
    });
  }

  void _checkAndFetch() async {
    final String mobileUserPublicKey = await _commonDetails.getPublicKey();
    await ref
        .read(singleProductStateNotifierProvider.notifier)
        .getSingleProductDetails(widget.product.id, mobileUserPublicKey, false);
    isLoading = false;
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    // Called when returning to this screen

    print("Returned to FirstScreen. Refreshing...");

    PaymentResponseModel? product =
        ref.watch(paymentStatusNotifier).paymentResponseModel;
    if (product?.productId == widget.product.id &&
        product?.paymentStatus?.toLowerCase() == "success") {
      _checkAndFetch();
    }
  }

  void _onButtonTap(int index, List<String> buttonLabels, productcode) {
    setState(() {
      isSelectedIndex = index;
    });
    // Navigate to `PerformanceScreen` when the "Performance" button is tapped
    if (buttonLabels[index] == "Performance") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PerformanceScreen(
                  perfomanceValueId: widget.product.id,
                )),
      ).then((_) {
        // Force reset to 0 even if already on it
        if (_pageController.page?.round() != 0) {
          _pageController.jumpToPage(0);
        }

        //  Always reset button and tab state
        setState(() {
          isSelectedIndex = 0;
        });
        ref.read(singleProductButtonStateNotifier.notifier).setButtonState(0);
      });

      return; // Avoid further execution if navigating
    }

    // Update the state for the button that was tapped
    ref.read(singleProductButtonStateNotifier.notifier).setButtonState(index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

//function for handleNavigateToContentButton
  void handleNavigateToContentButton(
      BuildContext context, WidgetRef ref) async {
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    ref.read(singleProductButtonStateNotifier.notifier).setButtonState(1);
  }

  ///Navigate to Subscription Screen
  void handleToNavigateSubscriptionScreen(
    bonusProductDetails,
    String productName,
    int productId,
  ) async {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Subscription(
          bonusProductDetails: bonusProductDetails,
          basketId: widget.reasearchbasketId ?? 0,
          pageNumber: widget.pageNumber ?? 0,
          productName: productName,
          productId: productId,
          planId: 0,
          isFromNotification: false,
        ),
      ),
    );
  }

  Future<bool> handleBackButtonAction() async {
    //isFromNotification
    if (!widget.isFromNotification) {
      Navigator.pop(context);
      return false; // Prevents exiting the screen
    } else {
      if (_pageController.page == 1.0) {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        ref.read(singleProductButtonStateNotifier.notifier).setButtonState(0);

        return false; // Prevents exiting the screen
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeNavigatorWidget(initialIndex: 1),
          ),
          (route) => false,
        );

        return false; // Prevents further back action since we manually navigated
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // int isSelectedIndex = ref.watch(singleProductButtonStateNotifier);
    final updatedDetails = ref.watch(singleProductStateNotifierProvider);

    if (isLoading || updatedDetails.isLoading) {
      return Scaffold(
        backgroundColor: theme.primaryColor,
        body: const Center(child: CommonLoaderGif()),
      );
    }

    final apiResponseModel = updatedDetails.singleProductApiResponseModel;
    finalUpdatedPrice = apiResponseModel?.price ?? widget.product.price;
    daysToGoEnd = apiResponseModel?.daysToGo ?? 1;

    setState(() {
      isFree = apiResponseModel?.subscriptionData.toLowerCase() ?? "";
    });

    final bool showButtomNavigation =
        apiResponseModel?.buyButtonText.toLowerCase() == "purchased";
    final bottomBuyButtonText =
        apiResponseModel?.buyButtonText ?? widget.product.buyButtonText;

    bool showSecondButton = (apiResponseModel?.contentCount != 0 ||
        apiResponseModel?.videoCount != 0);
// updatedDetails
//              .singleProductApiResponseModel?.scannerBonusProductId ;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // ignore: deprecated_member_use
        return WillPopScope(
          onWillPop: () => handleBackButtonAction(),
          child: Scaffold(
            backgroundColor: theme.primaryColor,
            appBar: AppBar(
              backgroundColor: theme.appBarTheme.backgroundColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: theme.primaryColorDark),
                onPressed: () => handleBackButtonAction(),
              ),
            ),
            body: _buildForDetailsData(
                // isSelectedIndex,
                showSecondButton,
                updatedDetails,
                handleNavigateToContentButton,
                apiResponseModel?.code),
            bottomNavigationBar: (isFree != "free")
                ? (isSelectedIndex != 0)
                    ? null
                    : ((showButtomNavigation &&
                            apiResponseModel?.category?.toLowerCase() !=
                                'scanner' &&
                            apiResponseModel?.category != null)
                        ? null
                        : buildForBottomNavigation(
                            apiResponseModel?.bonusProducts ?? [],
                            apiResponseModel?.id,
                            apiResponseModel?.name,
                            context,
                            bottomBuyButtonText,
                            daysToGoEnd,
                            apiResponseModel?.category,
                            apiResponseModel?.code))
                : null,
          ),
        );
      },
    );
  }

//widget body
  Widget _buildForDetailsData(showSecondButton, updatedDetails,
      handleNavigateToContentButton, productCode) {
    final theme = Theme.of(context);

    if (updatedDetails.error != null) {
      return const ErrorScreenWidget();
    }

    // Dynamically determine button labels based on `showSecondButton`
    List<String> buttonLabels = (updatedDetails
                .singleProductApiResponseModel?.scannerBonusProductId !=
            null)
        ? [
            overviewButtonText,
            if (showSecondButton) contentButtonText,
            if (updatedDetails.singleProductApiResponseModel.communityName !=
                null)
              updatedDetails.singleProductApiResponseModel.communityName,
            "My Scanners"
          ]
        : [
            overviewButtonText,
            if (showSecondButton) contentButtonText,
            if (updatedDetails.singleProductApiResponseModel.communityName !=
                null)
              updatedDetails.singleProductApiResponseModel.communityName,
            "Performance",
          ];

    return Column(
      children: [
        const SizedBox(height: 5),
        ScrollableButtonList(
          showSecondButton: showSecondButton,
          buttonLabels: buttonLabels,
          selectedIndex: isSelectedIndex,
          onButtonTap: (index) =>
              _onButtonTap(index, buttonLabels, productCode),
          theme: theme,
        ),
        Expanded(
            child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            print("Page changed to index: $index");
            setState(() {
              isSelectedIndex = index;
            });

            ref
                .read(singleProductButtonStateNotifier.notifier)
                .setButtonState(index);
            // Navigate to PerformanceScreen when reaching its index
            if (buttonLabels[index] == "Performance") {
              // Assuming index 2 is for Performance
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PerformanceScreen(
                          perfomanceValueId: widget.product.id,
                        )),
              ).then((_) {
                // Optionally reset to a valid index after returning
                _pageController.jumpToPage(0); // Go back to a safe page index
              });
            }
          },
          children: [
            //  Text(widget.product.id.toString()),
            if (!updatedDetails.isLoading &&
                updatedDetails.singleProductApiResponseModel == null)
              const Center(
                  child: NoContentWidget(
                message: noContentScreenText,
              )),
            ProductItemOverviewScreen(
                isFromResearch: widget.isFromResearch,
                handleNavigateToContentButton: handleNavigateToContentButton,
                getSingleProductId: widget.product.id,
                product: widget.product,
                isBuyButtonEnable: widget.product.isIosCouponEnabled,
                getSingleProductDetails: updatedDetails,
                afterDiscountPrice: finalUpdatedPrice),
            if (showSecondButton)
              ProductDetailsItemContentScreen(
                  isFree: isFree,
                  isFromResearch: widget.isFromResearch,
                  getSingleProductDetails: updatedDetails,
                  productItemId: widget.product.id),
            if (updatedDetails.singleProductApiResponseModel.communityName !=
                null)
              CoummnunityBaseScreen(
                  productTypeData: Product(
                      productId: updatedDetails
                          .singleProductApiResponseModel.communityId,
                      productName: widget.product.name),
                  postTypeData: [
                    PostType(id: 1, name: "Post"),
                    PostType(id: 2, name: "RecordedVideo"),
                    PostType(id: 3, name: "UpcomingEvent")
                  ]),
            if (updatedDetails
                    .singleProductApiResponseModel?.scannerBonusProductId !=
                null) ...[
              TodayScannersScreen(
                id: updatedDetails
                    .singleProductApiResponseModel?.scannerBonusProductId,
                handleRefresh: () {},
              ),
            ],
          ],
        ))
      ],
    );
  }

  Widget buildForBottomNavigation(
    List bonusProductDetails,
    productId,
    String? productName,
    BuildContext context,
    String? buyButtonText,
    int? singleProducts,
    String? category,
    String? productCode,
  ) {
    final theme = Theme.of(context);

    final lowerBuyText = (buyButtonText ?? '').toLowerCase();
    final isPurchased = lowerBuyText == 'purchased';
    final isBuy = lowerBuyText == 'buy';
    final isScanner = (category ?? '').toLowerCase() == 'scanner';
    final hasValidSingleProducts = (singleProducts ?? -1) >= 0;

    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: theme.bottomNavigationBarTheme.backgroundColor,
      child: Row(
        children: [
          if (isPurchased) const Spacer(),
          if (!isBuy && isScanner && hasValidSingleProducts)
            Button(
              text: "My Scanners",
              onPressed: () => handleToNavigateScanners(productCode ?? ''),
              backgroundColor: theme.disabledColor,
              textColor: theme.floatingActionButtonTheme.foregroundColor,
            ),
          if (!isPurchased) ...[
            const Spacer(),
            Button(
              text: "Checkout",
              onPressed: () => handleToNavigateSubscriptionScreen(
                bonusProductDetails,
                productName ?? '',
                productId ?? '',
              ),
              backgroundColor: theme.indicatorColor,
              textColor: theme.floatingActionButtonTheme.foregroundColor,
            ),
          ],
        ],
      ),
    );
  }
}
