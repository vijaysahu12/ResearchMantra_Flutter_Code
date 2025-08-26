import 'package:research_mantra_official/data/models/coupon_code/coupon_code_response_model.dart';

class CouponCodeState {
  final bool isLoading;
  final dynamic error;
  final List<CouponCodeResponseModel> codeResponseModel;

  CouponCodeState(
      {required this.codeResponseModel,
      required this.error,
      required this.isLoading});

  factory CouponCodeState.initail() =>
      CouponCodeState(codeResponseModel: [], error: null, isLoading: false);

  factory CouponCodeState.loading() =>
      CouponCodeState(codeResponseModel: [], error: null, isLoading: true);

  factory CouponCodeState.error(dynamic error) =>
      CouponCodeState(codeResponseModel: [], error: error, isLoading: false);

  factory CouponCodeState.loaded(
          List<CouponCodeResponseModel> codeResponseModel) =>
      CouponCodeState(
          codeResponseModel: codeResponseModel, error: null, isLoading: false);
}
