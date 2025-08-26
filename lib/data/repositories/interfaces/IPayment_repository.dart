import 'package:research_mantra_official/data/models/payment_model/payment_model.dart';

abstract class IPaymentRespoitory {
  //This method for get all reports
  Future<PaymentResponseModel> getPaymnetResponse(
      String paymentRequestId, String paymentGatewayName);
  //This method for get all reports
  Future<bool> addPaymentRequest(
      int productId,
      String mobileUserPublicKey,
      String mercdhantTransactionID,
      double amount,
      int subscriptionMappingId,
      String couponCode);
}
