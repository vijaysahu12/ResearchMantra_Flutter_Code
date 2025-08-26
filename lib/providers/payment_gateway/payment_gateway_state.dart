import 'package:research_mantra_official/data/models/payment_model/payment_model.dart';

class PaymentGatewayState {
  final dynamic error;
  final bool isLoading;
  final bool paymentStatus;
  final bool? paymentEnded;
  final PaymentResponseModel? paymentResponseModel;

  PaymentGatewayState(
      {required this.isLoading,
      this.error,
      required this.paymentStatus,
      this.paymentResponseModel,
      this.paymentEnded});

  factory PaymentGatewayState.initial() => PaymentGatewayState(
      isLoading: false, paymentStatus: false, paymentEnded: false);
  factory PaymentGatewayState.loading() => PaymentGatewayState(
      isLoading: true, paymentStatus: false, paymentEnded: false);

  factory PaymentGatewayState.loaded(
          bool paymentStatus,
          PaymentResponseModel? paymentResponseModel,
          bool? frompaymentResponse) =>
      PaymentGatewayState(
          isLoading: false,
          paymentStatus: paymentStatus,
          paymentResponseModel: paymentResponseModel,
          paymentEnded: frompaymentResponse);
  factory PaymentGatewayState.loadingAfterpayment(bool paymentStatus,
          PaymentResponseModel? paymentResponseModel, isloading) =>
      PaymentGatewayState(
        isLoading: isloading,
        paymentStatus: paymentStatus,
        paymentResponseModel: paymentResponseModel,
        // paymentEnded: false
      );
  factory PaymentGatewayState.error(dynamic error, bool? frompaymentResponse) =>
      PaymentGatewayState(
          isLoading: false,
          error: error,
          paymentStatus: false,
          paymentEnded: frompaymentResponse);
}
