import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/payment_model/payment_model.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/payment_gateway/payment_gateway_provider.dart';
import 'package:research_mantra_official/providers/products/single/single_product_provider.dart';
import 'package:research_mantra_official/providers/research/baskets/basket_provider.dart';
import 'package:research_mantra_official/providers/research/companies/companies_provider.dart';
import 'package:research_mantra_official/services/common_payment_gateway.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/bottom_sheet/failed_payment.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/mybuckets/my_bucket_list_screen.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

HttpClient httpClient = getIt<HttpClient>();

class PaymentUtils {
  final WidgetRef ref;
  final BuildContext context;

  final String? reasearchbasketId;
  final int? pageNumber;
  DateTime? currentTime;
  String? formattedDate;
  String? merchantTransactionId;
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  PaymentUtils({
    required this.ref,
    required this.context,
    this.reasearchbasketId,
    this.pageNumber,
  });

// initialize the PhonePe payment environment ///[PhonePe payment gateway]
  Future<void> initiatePayment(String mobileUserKey, productPrice, productId,
      mappingId, couponCode, productName) async {
    currentTime = DateTime.now();
    formattedDate = DateFormat('ddMMyyyyHHmmss').format(DateTime.now());
    final String merchantUserId =
        'USER${DateTime.now().millisecondsSinceEpoch}';
    merchantTransactionId = "TRANSACTION$formattedDate";

    // Additional transaction ID for product specific tracking
    String userTransactionId =
        "TRAN${mobileUserKey}_${productId}_$formattedDate";

    final String saltKey = dotenv.env['SALT_KEY'] ?? '';
    final String saltIndex = dotenv.env['SALT_INDEX'] ?? '';
    final String merchantId = dotenv.env['MERCHANT_ID'] ?? '';
    final String environment = dotenv.env['ENVIRONMENT'] ?? '';

    final phonePeUtils = PhonePePaymentUtils(
      environment: environment,
      merchantId: merchantId,
      saltKey: saltKey,
      saltIndex: saltIndex,
      enableLogging: true,
    );

    try {
      // Call the payment request method and handle the response
      await ref.read(paymentStatusNotifier.notifier).recordPaymentRequest(
            productId: productId,
            mobileUserPublicKey: mobileUserKey,
            couponCode: couponCode,
            mercdhantTransactionID: merchantTransactionId!,
            amount: productPrice,
            subscriptionMappingId: mappingId,
          );

      // Check payment status after recording the request
      final paymentStatus = ref.watch(paymentStatusNotifier).paymentStatus;

      if (paymentStatus) {
        await proceedTransaction(
          mobileUserKey: mobileUserKey,
          productPrice: productPrice,
          productId: productId,
          phonePeUtils: phonePeUtils,
          merchantUserId: merchantUserId,
          userTransactionId: userTransactionId,
          merchantTransactionId: merchantTransactionId!,
          subscriptionMappingId: mappingId,
          productName: productName,
        );
      }
    } catch (error) {
      handleTransactionFailure(error, 'initiatePayment issue');
    }
  }

// Proceed with the transaction using ///[PhonePe payment gateway]
  Future<void> proceedTransaction({
    required String mobileUserKey,
    required double productPrice,
    required int productId,
    required PhonePePaymentUtils phonePeUtils,
    required String merchantUserId,
    String? userTransactionId,
    required String merchantTransactionId,
    required String productName,
    required int subscriptionMappingId,
  }) async {
    try {
      if (!await phonePeUtils.initializePhonePe()) {
        showTransactionError('Payment initialization failed. Try again.');
        return;
      }

      final result = phonePeUtils.generateChecksum(
        updatedAmount: productPrice,
        merchantTransactionId: merchantTransactionId,
        merchantUserId: merchantUserId,
        callbackUrl: phonePeWebHook,
      );

      if (result['base64Body'] == null ||
          result['checksum'] == null) {
        showTransactionError('Checksum generation failed. Please retry.');
        return;
      }

      final String packageName = dotenv.env['PACKAGE_NAME'] ?? '';

      await phonePeUtils.startTransaction(
        body: result['base64Body'] ?? '',
        callbackUrl: phonePeWebHook,
        checksum: result['checksum'] ?? '',
        packageName: packageName,
      );

      await Future.delayed(const Duration(milliseconds: 100));
      await verifyPaymentStatus(productId, productName, merchantTransactionId);
    } catch (error) {
      handleTransactionFailure(error, 'proceedTransaction issue');
    }
  }

// Verify the payment status using ///[PhonePe payment gateway]
  Future<void> verifyPaymentStatus(
      int productId, String productName, String merchantTransactionId) async {
    await ref
        .read(paymentStatusNotifier.notifier)
        .getpaymentStatus(merchantTransactionId, 'PHONEPE');
    final paymentStatus = ref.watch(paymentStatusNotifier).paymentStatus;

    if (paymentStatus) {
      handlePurchaseOrder(
        productId,
        productName,
        paymentStatus,
      );
      // Only update the buy button if there's a product screen
      ref.read(singleProductStateNotifierProvider.notifier).updateBuyButton();
        } else {
      Future.delayed(const Duration(seconds: 3), () {
        showTransactionError('Payment failed. Try again or contact support.');
        // Update the loading state
      });
    }
  }

  void showTransactionError(String message) {
    BottomSheetHelper.showCustomBottomSheet(
      context: context,
      title: 'Transaction Failed',
      message: message,
    );
  }

  void handleTransactionFailure(dynamic error, String errorType) {
    logTransactionIssue(error, errorType);
    showTransactionError(
        'There was an issue processing your payment. Please try again.');
  }

  void logTransactionIssue(dynamic issue, String errorType) {
    httpClient.postOthers(
        "$other?message=$userDetails __$issue  -----PhonePe / $errorType");
  }

  void handlePurchaseOrder(
      int productId, String productName, bool isSuccessful) async {
    // Enhanced version (from CommonPaymentScreen)
    final mobileUserKey = await _commonDetails.getPublicKey();

    try {
      if (isSuccessful) {
        if (productName.startsWith("Unlock")) {
          Navigator.pop(context);
          // ref.read(getBasketProvider.notifier).getBasket(false);
          // ref.read(companiesDetailsProvider.notifier).getCompaniesDataModel({
          //   "id": reasearchbasketId,
          //   "primaryKey": "",
          //   "secondaryKey": "",
          //   "pageNumber": pageNumber,
          //   "loggedInUser": mobileUserKey,
          // }, false);
          ToastUtils.showToast("Service extended. Check your product.", "");
        } else {
          Navigator.pop(context);
          final paymentResponseModel =
              ref.watch(paymentStatusNotifier).paymentResponseModel;
          productDetailsPopup(
              paymentResponseModel ?? PaymentResponseModel(productId: 0),
              productName);

          // await ref
          //     .read(singleProductStateNotifierProvider.notifier)
          //     .getSingleProductDetails(productId, mobileUserKey, true);
        }
      }
    } catch (e) {
      logTransactionIssue(e, 'Purchase order API issue');
      showTransactionError('An error occurred while processing the purchase.');
    }
  }

  void productDetailsPopup(
      PaymentResponseModel paymentResponseModel, String productName) {
    // Show the popup when needed (e.g., after successful payment)

    showContentBox(context, paymentResponseModel, productName);
  }
}

void showContentBox(BuildContext context,
    PaymentResponseModel? paymentResponseModel, String? productName) {
  final theme = Theme.of(context);
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          clipBehavior: Clip.none, // Allows the icon to overflow outside
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  16, 50, 16, 16), // Adjust top padding
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    productName ?? "Please Check Into My Bucket",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    paymentResponseModel == null
                        ? "Your service has been successfully activated."
                        : 'Your service is now active for ${paymentResponseModel.productValidity ?? ""} days, from ${paymentResponseModel.startDate ?? ""} to ${paymentResponseModel.endDate ?? ""}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor:
                            theme.floatingActionButtonTheme.foregroundColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: Icon(
                        Icons.check_circle,
                        size: 20,
                        color: theme.primaryColor,
                      ),
                      label: const Text("Checkout My Bucket"),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const MyBucketListScreen(isDirect: false),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Centered Success Icon (Floating at the top)
            Positioned(
              top: -30, // Moves the icon outside the box
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor,
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 50,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
