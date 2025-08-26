import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IPayment_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/payment_gateway/payment_gateway_state.dart';

class PaymentGatewayNotifier extends StateNotifier<PaymentGatewayState> {
  PaymentGatewayNotifier(this._paymentGatewayRepository)
      : super(PaymentGatewayState.initial());

  final IPaymentRespoitory _paymentGatewayRepository;
//Old payment status function
// // This function is used to initiate the payment process
//   Future<void> getpaymentStatus(String transactionId) async {
//     try {
//       state = PaymentGatewayState.loading();

//       final getPaymentStatusResponse =
//           await _paymentGatewayRepository.getPaymnetResponse(transactionId);

//       if (getPaymentStatusResponse != null) {
//         state =
//             PaymentGatewayState.loaded(true, getPaymentStatusResponse, true);
//       } else {
//         state =
//             PaymentGatewayState.loaded(false, getPaymentStatusResponse, true);
//       }
//     } catch (e) {
//       state = PaymentGatewayState.error(e.toString(), true);
//     }
//   }


  Future<void> getpaymentStatus(String paymentRequestId,String paymentGatewayName) async {
    try {
      state = PaymentGatewayState.loading();

      final getPaymentStatusResponse =
          await _paymentGatewayRepository.getPaymnetResponse(paymentRequestId,paymentGatewayName);

      state =
          PaymentGatewayState.loaded(true, getPaymentStatusResponse, true);
        } catch (e) {
      state = PaymentGatewayState.error(e.toString(), true);
    }
  }


  Future<void> loadingAfterpayment(String transactionId) async {
    state = PaymentGatewayState.loadingAfterpayment(
        state.paymentStatus, state.paymentResponseModel, true);

    Future.delayed(const Duration(seconds: 2), () {
      state = PaymentGatewayState.loadingAfterpayment(
          state.paymentStatus, state.paymentResponseModel, false);
    });
  }

// This function is used to record the payment request
  Future<void> recordPaymentRequest(
      {required int productId,
      required String mobileUserPublicKey,
      required String couponCode,
      required String mercdhantTransactionID,
      required double amount,
      required int subscriptionMappingId}) async {
    try {
      state = PaymentGatewayState.loading();

      final getPaymentStatus =
          await _paymentGatewayRepository.addPaymentRequest(
        productId,
        mobileUserPublicKey,
        mercdhantTransactionID,
        amount,
        subscriptionMappingId,
        couponCode,
      );

      state = PaymentGatewayState.loaded(getPaymentStatus, null, false);
    } catch (e) {
      state = PaymentGatewayState.error(e.toString(), false);
    }
  }
}

final paymentStatusNotifier =
    StateNotifierProvider<PaymentGatewayNotifier, PaymentGatewayState>(((ref) {
  final IPaymentRespoitory paymentStatusNotifier = getIt<IPaymentRespoitory>();
  return PaymentGatewayNotifier(paymentStatusNotifier);
}));
