import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PhonePePaymentUtils {
  final String environment;

  final String merchantId;
  final String saltKey;
  final String saltIndex;
  final bool enableLogging;

  PhonePePaymentUtils({
    required this.environment,
    required this.merchantId,
    required this.saltKey,
    required this.saltIndex,
    this.enableLogging = false,
  });

  /// Initializes PhonePe SDK
  /// PhonePePaymentSdk.init(environmentValue, appId, merchantId, enableLogging)
  Future<bool> initializePhonePe() async {
    try {
      return await PhonePePaymentSdk.init(
        environment,
        "",
        merchantId,
        enableLogging,
      );
    } catch (error) {
      throw Exception("PhonePe Initialization Failed: $error");
    }
  }

  /// Generates the checksum for the transaction
  Map<String, String> generateChecksum({
    required double updatedAmount,
    required String merchantTransactionId,
    required String merchantUserId,
    required String callbackUrl,
  }) {
    final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId": merchantTransactionId,
      "merchantUserId": merchantUserId,
      "amount": (updatedAmount * 100).toInt(), // Convert  paise to rs
      "callbackUrl": callbackUrl,

      "paymentInstrument": {"type": "PAY_PAGE"}
    };

    // Encode the requestData to base64
    String base64Body = base64.encode(utf8.encode(json.encode(requestData)));
    String path = dotenv.env['API_ENDPOINT'] ?? "/pg/v1/pay";

    // Create the string to hash
    String stringToHash = base64Body + path + saltKey;

    // Calculate checksum
    String checksum =
        "${sha256.convert(utf8.encode(stringToHash))}###$saltIndex";

    return {
      "base64Body": base64Body,
      "checksum": checksum,
    };
  }

  /// Starts a PhonePe transaction
  Future<dynamic> startTransaction({
    required String body,
    required String callbackUrl,
    required String checksum,
    required String packageName,
  }) async {
    try {
      var response = await PhonePePaymentSdk.startTransaction(
        body,
        callbackUrl,
        checksum,
        packageName,
      );

      if (response != null) {
        String status = response['status'].toString();
        String error = response['error'].toString();

        if (status == 'SUCCESS') {
          return status;
        } else {
          return "Transaction Error: $error";
        }
      } else {
        return 'Transaction Error';
      }
    } catch (error) {
      throw Exception("Transaction Error: $error");
    }
  }
}
