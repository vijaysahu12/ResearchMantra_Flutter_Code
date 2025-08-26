import 'package:research_mantra_official/data/models/common_api_response.dart';
import 'package:research_mantra_official/data/models/payment_model/payment_model.dart';
import 'package:research_mantra_official/data/models/single_product_api_response_model.dart';

class SingleProductState {
  final SingleProductApiResponseModel? singleProductApiResponseModel;
  final CommonApiResponse? commonApiResponse;
  final dynamic error;
  final bool isLoading;
  final bool managePurchaseOrder;
 final PaymentResponseModel ?paymentResponseModel;

  SingleProductState(
      {required this.singleProductApiResponseModel,
      required this.isLoading,
      this.error,
      this.paymentResponseModel,
      required this.managePurchaseOrder,
      required this.commonApiResponse});

  factory SingleProductState.initial() => SingleProductState(
      singleProductApiResponseModel: null,
      isLoading: false,
      managePurchaseOrder: false,
      commonApiResponse: null);
  factory SingleProductState.loading() => SingleProductState(
    managePurchaseOrder: false,
      singleProductApiResponseModel: null,
      isLoading: true,
      commonApiResponse: null);

  factory SingleProductState.loaded(
          SingleProductApiResponseModel singleProductApiResponseModel,bool managePurchaseOrder,PaymentResponseModel ?paymentResponseModel) =>
      SingleProductState(
        managePurchaseOrder: managePurchaseOrder,
          singleProductApiResponseModel: singleProductApiResponseModel,
          isLoading: false,
          paymentResponseModel: paymentResponseModel,
          commonApiResponse: null);
  factory SingleProductState.error(dynamic error) => SingleProductState(
      singleProductApiResponseModel: null,
      isLoading: false,
      managePurchaseOrder: false,
      error: error,
      commonApiResponse: null);

  factory SingleProductState.manageLikeUnlikestate(
    SingleProductApiResponseModel singleProductApiResponseModel,
  ) {
    final updatedProduct = singleProductApiResponseModel.copyWith(
      isHeart: singleProductApiResponseModel.isHeart,
    );

    return SingleProductState(
        singleProductApiResponseModel: updatedProduct,
        isLoading: false,
        managePurchaseOrder: false,
        commonApiResponse: null);
  }

  factory SingleProductState.productRateState(
    SingleProductApiResponseModel singleProductApiResponseModel,
  ) {
    final updatedProduct = singleProductApiResponseModel.copyWith(
      userRating: singleProductApiResponseModel.userRating,
    );

    return SingleProductState(
        singleProductApiResponseModel: updatedProduct,
        isLoading: false,
        managePurchaseOrder: false,
        commonApiResponse: null);
  }

  factory SingleProductState.applyCouponState(
      SingleProductApiResponseModel singleProductApiResponseModel,
      CommonApiResponse commonApiResponse) {
    final updatedProduct = singleProductApiResponseModel.copyWith(
      price: commonApiResponse.data['deductedPrice'],
    );

    return SingleProductState(
        singleProductApiResponseModel: updatedProduct,
        isLoading: false,
        managePurchaseOrder: false,
        commonApiResponse: null);
  }

}
