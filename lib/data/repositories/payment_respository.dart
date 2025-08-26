import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/payment_model/payment_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IPayment_repository.dart';
import 'package:research_mantra_official/main.dart';

class PaymentRepository extends IPaymentRespoitory {
  final HttpClient _httpClient = getIt<HttpClient>();
  @override
  Future<PaymentResponseModel> getPaymnetResponse(
      String paymentRequestId, String paymentGatewayName) async {
    try {
      final response = await _httpClient.get(
          "$getPaymentStatusApi?paymentRequestId=$paymentRequestId&paymentGatewayName=$paymentGatewayName");

      if (response.statusCode == 200) {
        final dynamic responseData = response.data;
        final result = PaymentResponseModel.fromJson(responseData);
        return result;
      } else {
        return response.data;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> addPaymentRequest(
      int productId,
      String mobileUserPublicKey,
      String mercdhantTransactionID,
      double amount,
      int subscriptionMappingId,
      String couponCode) async {
    try {
      Map<String, dynamic> body = {
        "productId": productId,
        "mobileUserKey": mobileUserPublicKey,
        "merchantTransactionID": mercdhantTransactionID,
        "amount": amount,
        "subscriptionMappingId": subscriptionMappingId,
        "couponCode": couponCode,
      };

      final response = await _httpClient.post(addPaymentRequestApi, body);

      if (response.statusCode == 200) {
        final result = response.data;

        return result;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
