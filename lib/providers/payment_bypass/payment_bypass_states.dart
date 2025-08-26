import 'package:research_mantra_official/data/models/common_api_response.dart';
import 'package:research_mantra_official/data/models/payment_model/payment_model.dart';

class PaymentByPassState {
  final bool isLoading;
  final dynamic error;
  final bool applyCouponcode;
  final CommonHelperResponseModel? data;
  final PaymentResponseModel? paymentResponseModel;

  const PaymentByPassState(
      {required this.data,
      required this.error,
      required this.isLoading,
      required this.applyCouponcode,
      this.paymentResponseModel});

  factory PaymentByPassState.init() => const PaymentByPassState(
      data: null, error: null, isLoading: false, applyCouponcode: false);

  factory PaymentByPassState.loading() => const PaymentByPassState(
      data: null, error: null, isLoading: true, applyCouponcode: false);
  factory PaymentByPassState.loaded(CommonHelperResponseModel data,
          bool applyCouponCode, PaymentResponseModel? paymentResponseModel) =>
      PaymentByPassState(
          data: data,
          error: null,
          isLoading: false,
          applyCouponcode: applyCouponCode,
          paymentResponseModel: paymentResponseModel);
  factory PaymentByPassState.error(dynamic error) => PaymentByPassState(
      data: null, error: error, isLoading: false, applyCouponcode: false);
}
