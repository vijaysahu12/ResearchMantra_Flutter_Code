import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/product_api_response_model.dart';
import 'package:research_mantra_official/data/models/subscription/subscription_sinlge_product_model.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/get_support_mobile/support_mobile_provider.dart';
import 'package:research_mantra_official/providers/mybucket/my_bucket_list_provider.dart';
import 'package:research_mantra_official/providers/payment_bypass/payment_bypass_provider.dart';
import 'package:research_mantra_official/providers/payment_gateway/payment_gateway_provider.dart';
import 'package:research_mantra_official/providers/payment_gateway/payment_gateway_state.dart';
import 'package:research_mantra_official/providers/products/single/single_product_provider.dart';
import 'package:research_mantra_official/providers/research/baskets/basket_provider.dart';
import 'package:research_mantra_official/providers/research/companies/companies_provider.dart';
import 'package:research_mantra_official/providers/subscription/coupon_code/coupon_code_provider.dart';
import 'package:research_mantra_official/providers/subscription/single_product_subscription/single_product_subscription_provider.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/bottom_sheet/apply_coupon.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/common_payment_screen/common_payment_screen.dart';
import 'package:research_mantra_official/ui/components/common_payment_screen/instamojo_payment_screen.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/components/payment_screen/instamojo_screen.dart';
import 'package:research_mantra_official/ui/screens/home/home_navigator.dart';

import 'package:research_mantra_official/ui/screens/subscription/widget/pay_button.dart';
import 'package:research_mantra_official/ui/screens/subscription/widget/payment_description_card.dart';
import 'package:research_mantra_official/ui/screens/subscription/widget/subscription_coupon.dart';
import 'package:research_mantra_official/ui/screens/subscription/widget/subscription_duration_list.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import 'package:research_mantra_official/utils/utils.dart';

class Subscription extends ConsumerStatefulWidget {
  final List<BonusProduct> bonusProductDetails;
  final String productName;
  final int productId;
  final int planId;
  final int? pageNumber;
  final num? basketId;
  final bool isFromNotification;

  const Subscription(
      {super.key,
      required this.planId,
      required this.productName,
      required this.productId,
      this.pageNumber,
      this.basketId,
      required this.bonusProductDetails,
      required this.isFromNotification});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SubscriptionState();
}

class _SubscriptionState extends ConsumerState<Subscription> {
  bool isInitLoading = true;
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  TextEditingController couponCodeEditingController = TextEditingController();
  TextEditingController applyDiscountCouponController = TextEditingController();

  int subscriptionPlan = 0;
  int subscriptionDuration = 0;
  double? netAmounttoBePayed;
  bool isCouponActivated = false;
  bool isCouponAppliedFromList = false;
  double afterAppliedCouponDiscount = 0.0;
  int? subscriptionDurationId;
  String appliedCouponCodeName = '';
  bool paymentstatusLoading = false;
  bool isPaymentButtonClicked = false;
  bool isCouponCancelValue = true;
  bool _bottomSheetShown = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    couponCodeEditingController.dispose();
  }

  Future<void> _initializeData() async {
    await _checkAndFetch(false);
    _maybeOpenBottomBar();
  }

//Function to open bonus product popup
  void _maybeOpenBottomBar() {
    if (widget.bonusProductDetails.isNotEmpty) {
      showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        builder: (context) => BonusBottomBar(
          bonusProduct: widget.bonusProductDetails,
        ),
      );
    }
  }

  Future<void> _checkAndFetch(bool isRefresh) async {
    final connectivityResult = ref.watch(connectivityStreamProvider);
    final connectionResult = connectivityResult.value;
    bool isConnection = connectionResult != ConnectivityResult.none;
    final String mobileUserPublicKey = await _commonDetails.getPublicKey();
    ref
        .read(connectivityProvider.notifier)
        .updateConnectionStatus(isConnection);
    if (isConnection) {
      await Future.wait([
        ref.read(paymentByPassStateProvider.notifier).getCouponCodeCheckStatus(
              mobileUserPublicKey,
              widget.productId,
              "GETSTATUS",
              "checkStatus",
            ),
        ref.read(getSupportMobileStateProvider.notifier).getSupportMobileData(),
        getSubscriptionDataData(isRefresh),
      ]);
    } else {
      ToastUtils.showToast(noInternetConnectionText, "");
    }
  }

  ///Method for get Subscription Data
  Future<void> getSubscriptionDataData(bool isRefresh) async {
    final String mobileUserPublicKey = await _commonDetails.getPublicKey();
    bool isIOS = isGetIOSPlatform();
    if (isRefresh) {
      setState(() {
        isInitLoading = true;
        subscriptionPlan = 0;
        subscriptionDuration = 0;
        isCouponActivated = false;
        isCouponAppliedFromList = false;
        afterAppliedCouponDiscount = 0.0;
      });
    }

    await ref
        .read(getSingleProductSubscriptionProvider.notifier)
        .getSingleProductSubscription(isRefresh, widget.planId,
            widget.productId, mobileUserPublicKey, isIOS ? "iOS" : "Android");

    setState(() {
      isInitLoading = false;
    });
  }

  void handleCouponCode(
      {required String couponCode,
      required int subscriptionDurationId,
      required int productId}) {
    setState(() {
      this.subscriptionDurationId = subscriptionDurationId;
    });

    ref
        .read(getAllCouponCodeListProvider.notifier)
        .getAllCouponCodeList(productId, subscriptionDurationId);

    showCouponCodeBottomSheet(couponCode, subscriptionDurationId);
  }

  void _updateValue(double value, bool isApplied, String appliedCouponCode) {
    setState(() {
      isCouponAppliedFromList = isApplied;
      isCouponActivated = true; //Todo:...?
      afterAppliedCouponDiscount = value;
      appliedCouponCodeName =
          appliedCouponCode.replaceAll(RegExp(r'\s+'), '').toUpperCase();
    });
  }

  /// Function to  Enter CouponCode Apply
  void ownCouponCode(double value, bool isApplied, String isOwnCouponCode,
      int subscriptionDurationId) async {
    final String mobileUserKey = await _commonDetails.getPublicKey();

    final updatedDiscountPrice = await ref
        .read(singleProductStateNotifierProvider.notifier)
        .getCouponCodeDiscountPrice(mobileUserKey, isOwnCouponCode,
            widget.productId, subscriptionDurationId);

    if (updatedDiscountPrice != "invalid") {
      setState(() {
        isCouponAppliedFromList = isApplied;
        isCouponActivated = true;
        afterAppliedCouponDiscount = updatedDiscountPrice;
        appliedCouponCodeName = isOwnCouponCode;
      });

      Navigator.pop(context);
    }
    couponCodeEditingController.clear();
  }

  ///Function to apply coupon code
  void applyIosCouponCode(String couponCodeText) async {
    final String mobileUserKey = await _commonDetails.getPublicKey();

    if (couponCodeText.length > 4) {
      final isCorrect =
          await ref.read(paymentByPassStateProvider.notifier).applyCoucponCode(
                mobileUserKey,
                widget.productId,
                couponCodeText,
                "apply",
              );
      if (isCorrect) {
        if (widget.productName.startsWith("Unlock")) {
          ref
              .read(companiesDetailsProvider.notifier)
              .updateCompaniesDataModel();
          ref.read(getBasketProvider.notifier).getBasket(false);
          ref.read(companiesDetailsProvider.notifier).getCompaniesDataModel({
            id: widget.basketId,
            primaryKey: "",
            secondaryKey: "",
            pageNumber: widget.pageNumber,
            loggedInUser: mobileUserKey,
          }, false);
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          await ref
              .read(singleProductStateNotifierProvider.notifier)
              .getSingleProductDetails(widget.productId, mobileUserKey, true);
          Navigator.pop(context);
        }
        await ref
            .read(myBucketListProvider.notifier)
            .getMyBucketListItems(mobileUserKey, true);

        // _pref.setBool(communityPostEnabled, true);

        ToastUtils.showToast(weExtendTheServicePleaseCheckYourProduct, "");
      }
    } else {
      ToastUtils.showToast("Please enter a valid coupon code.", "");
      return; // Exit early if the coupon code is invalid
    }
  }

  ///Function to getCouponCode
  void getWhatsAppCouponCode() async {
    final String mobileUserKey = await _commonDetails.getPublicKey();
    await ref.read(paymentByPassStateProvider.notifier).getCouponCodeLink(
          mobileUserKey,
          widget.productId,
          "ToGetCoupon", // Type
          "get", //check Status
        );
    // Navigator.pop(context);
  }

  int calculateMonthlyPayment({
    required double netPayment,
    required int months,
    bool isCouponActivated = false,
    double afterAppliedCouponDiscount = 0.0,
    double defaultCouponDiscount = 0.0,
  }) {
    // Calculate final payment based on coupon activation
    double finalPayment = isCouponActivated
        ? netPayment
        : netPayment - afterAppliedCouponDiscount;

    // Divide the final payment by the number of months
    return (finalPayment / months).truncate();
  }

  ///Function To Open the CouponCode bottomsheet

  void showCouponCodeBottomSheet(couponCode, subscriptionDurationId) {
    if (_bottomSheetShown) {
      return; // Return early if the bottom sheet is already shown
    }
    _bottomSheetShown = true; // Set the flag
    Future.delayed(const Duration(milliseconds: 500), () {
      final getCouponsStates = ref.watch(getAllCouponCodeListProvider);

      CouponCodeBottomSheet().showCustomBottomSheet(
          context: context,
          title: couponCodeTitle,
          message: couponCodeOfferMessage,
          getCouponsStates: getCouponsStates,
          textEditingController: couponCodeEditingController,
          updateValue: _updateValue,
          ownCouponCode: ownCouponCode,
          isCouponCancel: isCouponCancel,
          commonCouponCode: couponCode,
          subscriptionDurationId: subscriptionDurationId);

      // Reset the flag
      _bottomSheetShown = false;
    });
  }

//Function to change the value for couponCode
  void isCouponCancel() {
    setState(() {
      isCouponCancelValue = false;
    });
  }

  ///Finction update the Price
  void updatedPrice(SubscriptionDuration subscriptionDuration) {
    ref
        .read(getSingleProductSubscriptionProvider.notifier)
        .addSubscription(subscriptionDuration);
  }

  ///Function Calculate The Payment
  /// Calculates the final payment amount after applying coupon logic
  double calculateFinalPayment({
    required double? netPayment,
    required double? defaultCouponDiscount,
    required double afterAppliedCouponDiscount,
    required bool isCouponActivated,
  }) {
    if (netPayment == null || netPayment == 0.0 && isCouponActivated) {
      return 0.0;
    }

    final double discount =
        isCouponActivated ? afterAppliedCouponDiscount : 0.0;
    final double finalAmount = netPayment - discount;

    return finalAmount
        .truncateToDouble(); // safer and cleaner than parsing string
  }

  ///Function to get the Payment Message
  String getPaymentMessage({
    required double? netPayment,
    required double? defaultCouponDiscount,
    required double afterAppliedCouponDiscount,
    required bool isCouponActivated,
  }) {
    if (netPayment == null) return "GET FREE";

    if (netPayment == 0.0 && !isCouponActivated) {
      return "GET FREE";
    }

    double finalPayment = !isCouponActivated
        ? netPayment
        : netPayment - afterAppliedCouponDiscount;
    // If final payment is 0 (even after applying coupon)

    if (finalPayment.truncate() <= 0) {
      return "GET FREE";
    }

    return "Ready to pay ₹${finalPayment.truncate()}";
    // return "Ready to pay ₹${1}";
  }

  ///Function to get The service name
  String handleToGetTheName(String productName) {
    if (productName.startsWith("Unlock")) {
      return 'Discover Your Plans';
    } else {
      return '$productName Plan';
    }
  }

//Function navigate to Home screen
  void handleBackButtonAction() async {
    if (widget.isFromNotification) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeNavigatorWidget(initialIndex: 1),
        ),
        (route) => false,
      );
    } else {
      Navigator.pop(context);
    }
  }

  bool _isProcessingPayment = false;

  Future<void> handleToPay({
    required String isPhonePe,
    required String productName,
    required int productId,
    required double productPrice,
    required int mappingId,
    required BuildContext context,
    required WidgetRef ref,
    required String couponCode,
    required int subscriptionDurationId,
  }) async {
    if (_isProcessingPayment) return;
    _isProcessingPayment = true;
    final String mobileUserKey = await _commonDetails.getPublicKey();
    try {
      // 🎟️ Handle empty coupon case only once
      if (couponCode.isEmpty && isCouponCancelValue) {
        handleCouponCode(
          couponCode: couponCode,
          subscriptionDurationId: subscriptionDurationId,
          productId: productId,
        );
        return; // Exit early after showing popup
      }

      // 🚫 Validate price
      if (productPrice == 0.0) {
        final isSuccess = await ref
            .read(singleProductStateNotifierProvider.notifier)
            .managePurchaseOrder(
              mobileUserKey,
              productId,
              productPrice.toInt(),
              couponCode,
              mappingId,
              "FREE", // TODO: Replace with dynamic value later
              "FREE",
            );

        await Future.delayed(const Duration(seconds: 2));
        if (isSuccess) {
          await ref
              .read(singleProductStateNotifierProvider.notifier)
              .getSingleProductDetails(widget.productId, mobileUserKey, true);

          Navigator.pop(context);

          ToastUtils.showToast(
              "Product added successfully! Enjoy your access 🎉", "");
        } else {
          ToastUtils.showToast(somethingWentWrong, "");
        }

        return;
      }

      if (productPrice < 9.0 && isPhonePe.toLowerCase() != "phonepe") {
        ToastUtils.showToast("Price cannot be less than ₹9.", "");
        return;
      }

      // 🔄 Update company details for "Unlock"
      if (productName.startsWith("Unlock")) {
        ref.read(companiesDetailsProvider.notifier).updateCompaniesDataModel();
      }

      // 🌐 Check internet connection
      final isConnected =
          await CheckInternetConnection().checkInternetConnection();
      if (!isConnected) {
        ToastUtils.showToast(noInternetConnectionText, "");
        return;
      }

      // 🔘 Update UI
      if (context.mounted) {
        setState(() => isPaymentButtonClicked = true);
      }

      // 💳 Payment gateway handling
      final usePhonePe = isPhonePe.toLowerCase() == "phonepe";
      if (usePhonePe) {
        _handlePhonePePayment(
          context: context,
          ref: ref,
          productName: productName,
          productId: productId,
          productPrice: productPrice,
          mappingId: mappingId,
          couponCode: couponCode,
          researchId: widget.basketId,
        );
      } else {
        await _handleInstamojoPayment(
          context: context,
          ref: ref,
          productName: productName,
          productId: productId,
          productPrice: productPrice,
          mappingId: mappingId,
          couponCode: couponCode,
        );
      }
    } catch (e) {
      ToastUtils.showToast(somethingWentWrong, "");
    } finally {
      if (context.mounted) {
        setState(() => isPaymentButtonClicked = false);
      }
      _isProcessingPayment = false;
    }
  }

  /// Handles PhonePe payment
  Future<void> _handlePhonePePayment({
    context,
    required WidgetRef ref,
    required String productName,
    required int productId,
    required double productPrice,
    required int? mappingId,
    required String couponCode,
    num? researchId,
  }) async {
    final mobileUserKey = await _commonDetails.getPublicKey();

    PaymentUtils(
            ref: ref,
            context: context,
            reasearchbasketId: widget.basketId?.toString())
        .initiatePayment(
      mobileUserKey,
      productPrice,
      productId,
      mappingId,
      couponCode,
      productName,
    );
  }

  /// Handles Instamojo payment
  Future<void> _handleInstamojoPayment({
    required BuildContext context,
    required WidgetRef ref,
    required String productName,
    required int productId,
    required double productPrice,
    required int? mappingId,
    required String couponCode,
  }) async {
    final userDetails = await _commonDetails.getUserDetails();
    final mobileUserKey = userDetails['publicKey'] ?? '';

    final isConnected =
        await CheckInternetConnection().checkInternetConnection();
    if (!isConnected) {
      ToastUtils.showToast(noInternetConnectionText, "");
      return;
    }

    try {
      final paymentUtils = InstaMojoPaymentUtils();
      final paymentResult = await paymentUtils.createInstamojoPaymentRequest(
        mobileUserKey,
        productPrice.toString(),
        productName,
        productId,
        mappingId,
        couponCode,
      );

      final paymentUrl = paymentResult['longurl'];
      final paymentRequestId = paymentResult['id'];

      await ref.read(paymentStatusNotifier.notifier).recordPaymentRequest(
            productId: productId,
            mobileUserPublicKey: mobileUserKey,
            couponCode: couponCode,
            mercdhantTransactionID: paymentRequestId,
            amount: productPrice,
            subscriptionMappingId: mappingId ?? 0,
          );

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => InstamojoPaymentScreen(
            paymentUrl: paymentUrl,
            productName: productName,
            paymentRequestId: paymentRequestId,
          ),
        ),
      );
    } catch (e) {
      ToastUtils.showToast("Payment initiation failed", e.toString());
    }
  }

  void _listenToPaymentStatus(WidgetRef ref) {
    ref.listen<PaymentGatewayState>(paymentStatusNotifier, (previous, next) {
      if (next.paymentEnded == true) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() => paymentstatusLoading = false);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasConnection = ref.watch(connectivityProvider);
    final getSubscriptionData = ref.watch(getSingleProductSubscriptionProvider);
    final getCheckStatus = ref.watch(paymentByPassStateProvider);
    final getMobileNumber = ref.watch(getSupportMobileStateProvider);
    bool managePurchaseorder =
        ref.watch(singleProductStateNotifierProvider).isLoading;
    bool bucketListData = ref.read(myBucketListProvider).isLoading;
    bool getBasketResearch = ref.read(companiesDetailsProvider).isLoading;
    _listenToPaymentStatus(ref);

    final isLoading = getSubscriptionData.isLoading &&
        getCheckStatus.isLoading &&
        getMobileNumber.isLoading &&
        isInitLoading;

    final isAnyProcessRunning = isLoading ||
        managePurchaseorder ||
        bucketListData ||
        getBasketResearch ||
        paymentstatusLoading;

    final shouldShowPaymentButton =
        getSubscriptionData.singleproductSubscription.isNotEmpty &&
            hasConnection &&
            !paymentstatusLoading;

    final double finalPrice = calculateFinalPayment(
      netPayment: getSubscriptionData.subscriptionDuration?.netPayment,
      defaultCouponDiscount:
          getSubscriptionData.subscriptionDuration?.defaultCouponDiscount,
      afterAppliedCouponDiscount: afterAppliedCouponDiscount,
      isCouponActivated: isCouponActivated,
    );

    return WillPopScope(
      onWillPop: () async {
        handleBackButtonAction();
        return false; // Ensure a boolean value is always returned
      },
      child: Scaffold(
        appBar: CommonAppBarWithBackButton(
          appBarText: handleToGetTheName(widget.productName),
          handleBackButton: handleBackButtonAction,
        ),
        backgroundColor: theme.primaryColor,
        body: isAnyProcessRunning
            ? const CommonLoaderGif()
            : _buildSubscriptionData(
                subscriptionData: getSubscriptionData,
                theme: theme,
                checkStatus: getCheckStatus,
                supportMobileNumber: getMobileNumber,
                hasConnection: hasConnection,
                isPaymentProcessing: _isProcessingPayment,
              ),
        bottomNavigationBar: shouldShowPaymentButton
            ? PaymentButtonWidget(
                theme: theme,
                buyButtonText: getPaymentMessage(
                  netPayment:
                      getSubscriptionData.subscriptionDuration?.netPayment,
                  defaultCouponDiscount: getSubscriptionData
                      .subscriptionDuration?.defaultCouponDiscount,
                  afterAppliedCouponDiscount: afterAppliedCouponDiscount,
                  isCouponActivated: isCouponActivated,
                ),
                onStartPayment: () {
                  handleToPay(
                      isPhonePe: getSubscriptionData
                              .singleproductSubscription[0]
                              .paymentGatewayName ?? //TODO: In Future we have to remove hardcoded index
                          '', // or false for Instamojo
                      productName: widget.productName,
                      productId: widget.productId,
                      productPrice: finalPrice,
                      mappingId: getSubscriptionData
                              .subscriptionDuration?.subscriptionMappingId ??
                          0,
                      context: context,
                      ref: ref,
                      couponCode: appliedCouponCodeName,
                      subscriptionDurationId: getSubscriptionData
                              .subscriptionDuration?.subscriptionDurationId ??
                          0);
                },
                isLoading: isPaymentButtonClicked,
              )
            : null,
      ),
    );
  }

  Widget _buildSubscriptionData({
    required dynamic subscriptionData,
    required ThemeData theme,
    required dynamic checkStatus,
    required dynamic supportMobileNumber,
    required bool hasConnection,
    required bool isPaymentProcessing,
  }) {
    /// 🔄 Loading state
    if (subscriptionData.isLoading || isInitLoading || isPaymentProcessing) {
      return const CommonLoaderGif();
    }

    /// ❌ No Internet
    if (!hasConnection) {
      return NoInternet(handleRefresh: () => _checkAndFetch(false));
    }

    /// ⚠️ Error
    if (subscriptionData.error != null) {
      return const ErrorScreenWidget();
    }

    /// 📦 Extracted subscription
    final subscriptionList = subscriptionData.singleproductSubscription;
    final isSubscriptionEmpty =
        subscriptionList == null || subscriptionList.isEmpty;

    /// 🧾 No Subscriptions Available
    if (isSubscriptionEmpty) {
      return RefreshIndicator(
        onRefresh: () => _checkAndFetch(true),
        child: ApplyCouponCodeScreen(
          applyCouponCodePopupForIos: applyCouponCodePopupForIos,
          applyCouponCodePopupForIos2: applyCouponCodePopupForIos2,
          couponCodeController: applyDiscountCouponController,
          applyIosCouponCode: () =>
              applyIosCouponCode(applyDiscountCouponController.text.trim()),
          getWhatsAppCouponCode: getWhatsAppCouponCode,
          getCouponText: getCouponText,
          applyButtonText: applyButtonText,
          getMobileNumber: supportMobileNumber.data?.toString(),
          getCheckStatus: checkStatus,
        ),
      );
    }

    /// ✅ Show Subscription Details
    return _buildCouponDescription(subscriptionData, theme);
  }

  ///Widget for Offer Description
  Widget _buildCouponDescription(dynamic getSubscriptionData, ThemeData theme) {
    final subscriptionList = getSubscriptionData.singleproductSubscription;
    final subscriptionDuration = getSubscriptionData.subscriptionDuration;

    return RefreshIndicator(
      onRefresh: () => _checkAndFetch(true),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Subscription List Cards with Animations
            Column(
              children: List.generate(subscriptionList.length, (index) {
                final subscription = subscriptionList[index];

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    horizontalOffset: 200.0,
                    child: FadeInAnimation(
                      child: _buildSubscriptionCard(
                        context: context,
                        theme: theme,
                        subscription: subscription,
                        productSubscriptionIndex: index,
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 5),

            /// 🔹 Payment Summary Card
            PaymentDescriptionCard(
              theme: theme,
              subscriptionDurationName:
                  subscriptionDuration.subscriptionDurationName,
              subscriptionDurationId:
                  subscriptionDuration.subscriptionDurationId,
              discountPrice: subscriptionDuration.discountPrice,
              actualPrice: subscriptionDuration.actualPrice,
              couponCode: subscriptionDuration.couponCode,
              netPayment: subscriptionDuration.netPayment,
              lastDate: Utils.formatDateTime(
                dateTimeString: subscriptionDuration.expireOn,
                format: ddmmyy,
              ),
              defaultCouponDiscount: subscriptionDuration.defaultCouponDiscount,
              months: subscriptionDuration.months,
              isCouponActivated: isCouponActivated,
              afterAppliedCouponDiscount: afterAppliedCouponDiscount,

              /// 🔸 Coupon Apply Callback
              onApplyCoupon: (code, id) {
                handleCouponCode(
                  couponCode: code,
                  subscriptionDurationId: id,
                  productId: widget.productId,
                );
              },

              /// 🔸 Remove Coupon Callback
              onRemoveCoupon: () {
                setState(() {
                  isCouponActivated = false;
                });
              },

              /// 🔸 Monthly Calculation
              calculateMonthlyPayment: ({
                required double netPayment,
                required int months,
                required bool isCouponActivated,
                required double afterAppliedCouponDiscount,
                required double defaultCouponDiscount,
              }) {
                final discounted = isCouponActivated
                    ? netPayment - afterAppliedCouponDiscount
                    : netPayment;
                return discounted / months;
              },
            ),
            const SizedBox(height: 100), //Todo: Adjust as needed
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard({
    required BuildContext context,
    required ThemeData theme,
    required dynamic subscription, // Ideally: SubscriptionModel
    required int productSubscriptionIndex,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(8),
        border: Border(top: BorderSide(color: theme.disabledColor, width: 1)),
        boxShadow: [
          BoxShadow(
            color: theme.disabledColor.withOpacity(0.4),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Title
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 5),
            child: Text(
              subscription.name ?? "Simple Lite",
              style: const TextStyle(
                fontFamily: "poppins",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          /// 🔹 Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              color: theme.shadowColor,
              thickness: 2,
            ),
          ),

          const SizedBox(height: 2),

          /// 🔹 Horizontal subscription duration list
          SubscriptionDurationList(
            context: context,
            theme: theme,
            subscriptionDurations: subscription.subscriptionDurations,
            productSubscriptionIndex: productSubscriptionIndex,
            selectedPlanIndex: subscriptionPlan,
            selectedDurationIndex: subscriptionDuration,
            onTap: (selectedDuration, index) {
              updatedPrice(selectedDuration);
              setState(() {
                subscriptionPlan = productSubscriptionIndex;
                subscriptionDuration = index;
                isCouponActivated = false;
                isCouponAppliedFromList = false;
                afterAppliedCouponDiscount = 0.0;
                appliedCouponCodeName = '';
                isCouponCancelValue = true;
              });
            },
          ),

          const SizedBox(height: 8),

          /// 🔹 Footer note
          Container(
            width: double.infinity,
            color: theme.shadowColor,
            padding: const EdgeInsets.all(8),
            child: const Align(
              alignment: Alignment.center,
              child: Text(
                monthlyCardBottomText,
                style: TextStyle(
                  fontFamily: "poppins",
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
