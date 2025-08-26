import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/bottom_sheet/failed_payment.dart';
import 'package:research_mantra_official/data/network/http_client.dart';

import 'package:research_mantra_official/utils/toast_utils.dart';

HttpClient httpClient = getIt<HttpClient>();

class InstaMojoPaymentUtils {
  final UserSecureStorageService _commonDetails = UserSecureStorageService();

  //create Instamojo payment request ///[Instamojo payment gateway]
  /// This function creates a payment request with Instamojo and returns the payment URL.
  Future<Map<String, dynamic>> createInstamojoPaymentRequest(mobileUserKey,
      productPrice, productName, productId, mappingId, couponCode) async {
    final token = await getAccessToken();

    Map<String, dynamic> userDetails = await _commonDetails.getUserDetails();

    String userFullName = await userDetails['fullName'] ?? 'Hello User';
    String userPhoneNumber = await userDetails['mobileNumber'] ?? "";
    String userEmail = await userDetails['emailId'] ?? '';
    String instamojoPaymentUrl = dotenv.env['INSTAMOJO_PAYMENT_URL'] ??
        "https://api.instamojo.com/v2/payment_requests/";

    final response = await http.post(
      Uri.parse(instamojoPaymentUrl),
      headers: {"Authorization": "Bearer $token"},
      body: {
        "amount": productPrice,
        "purpose": productName,
        "buyer_name": userFullName,
        "email": userEmail,
        "phone": userPhoneNumber,
        "redirect_url": "",
        "webhook": instamojoWebhookUrl,
        "send_email": "false",
        "send_sms": "false",
        "allow_repeated_payments": "false",
      },
    );

    bool isConnected =
        await CheckInternetConnection().checkInternetConnection();
    if (!isConnected) {
      ToastUtils.showToast(noInternetConnectionText, "");
    }
    if (response.statusCode == 201) {
      final data = json.decode(response.body);

      // Return both longurl and id
      return {
        "longurl": data['longurl'],
        "id": data['id'],
      };
    } else {
      throw Exception("Failed to create payment request: ${response.body}");
    }
  }

// Get access token for Instamojo API ///[Instamojo payment gateway]
  Future<String?> getAccessToken() async {
    final grantType = dotenv.env['INSTAMOJO_GRANT_TYPE'];
    final instamojoClientId = dotenv.env['INSTAMOJO_CLIENT_ID'];
    final instamojoClientSecret = dotenv.env['INSTAMOJO_CLIENT_SECRET'];

    final instamojoGetAcessTokenUrl =
        dotenv.env['INSTAMOJO_GET_ACESS_TOKEN_URL'] ??
            "https://api.instamojo.com/oauth2/token/";

    final url = Uri.parse(instamojoGetAcessTokenUrl);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': grantType,
        'client_id': instamojoClientId,
        'client_secret': instamojoClientSecret,
      },
    );
    bool isConnected =
        await CheckInternetConnection().checkInternetConnection();
    if (!isConnected) {
      ToastUtils.showToast(noInternetConnectionText, "");
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final accessToken = data['access_token'];
      print('Access Token: $accessToken');
      return accessToken;
    } else {
      print('Failed to get access token: ${response.body}');
      return null;
    }
  }

  void showTransactionError(String message, context) {
    if (!context.mounted) return;
    BottomSheetHelper.showCustomBottomSheet(
      context: context,
      title: 'Transaction Failed',
      message: message,
    );
  }

  void handleTransactionFailure(dynamic error, String errorType, context) {
    logTransactionIssue(error, errorType);
    showTransactionError(
        'There was an issue processing your payment. Please try again.',
        context);
  }
}

void logTransactionIssue(dynamic issue, String errorType) {
  httpClient.postOthers(
      "$other?message=$userDetails __$issue  -----INSTAMOJO / $errorType");
}
