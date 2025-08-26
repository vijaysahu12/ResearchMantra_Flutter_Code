
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/single_product_api_response_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IProduct_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/mybucket/my_bucket_list_provider.dart';
import 'package:research_mantra_official/providers/products/list/product_list_provider.dart';

import 'package:research_mantra_official/providers/products/single/single_product_state.dart';

//SingleProductStateNotifier managing single product Details
class SingleProductStateNotifier extends StateNotifier<SingleProductState> {
  SingleProductStateNotifier(
    this._productRepository,
    this._productsStateNotifier,
    this._myBucketListStateNotifier,
  ) : super(SingleProductState.initial());

  final IProductRepository _productRepository;
  final ProductsStateNotifier _productsStateNotifier;
  final MyBucketListStateNotifier _myBucketListStateNotifier;
  // final CouponCodeStateNotifier _couponCodeStateNotifier;

//Method to get product details
  Future<void> getSingleProductDetails(
      int id, String mobileUserPublicKey, bool isPurchase) async {
    // if (!isPurchase) {
    state = SingleProductState.loading();
    // }

    try {
      final SingleProductApiResponseModel getSingleProduct =
          await _productRepository.getSingleProductDetails(
              id, mobileUserPublicKey);
      state = SingleProductState.loaded(getSingleProduct, false, null);
    } catch (e) {
      state = SingleProductState.error(e);
    }
  }

//Method to call GetSingle product details
  Future<void> removeCoupon(int id, String mobileUserPublicKey) async {
    final SingleProductApiResponseModel getSingleProduct =
        await _productRepository.getSingleProductDetails(
            id, mobileUserPublicKey);
    state = SingleProductState.loaded(getSingleProduct, false, null);
  }

//Method to manage like and unlike
  Future<void> manageLikeUnlikeProductById(
      String mobileUserPublicKey, int productId, String action) async {
    try {
      final SingleProductApiResponseModel updatedProduct = state
          .singleProductApiResponseModel!
          .copyWith(isHeart: !state.singleProductApiResponseModel!.isHeart);
      state = SingleProductState.manageLikeUnlikestate(updatedProduct);
      await _productRepository.manageLikeUnlikeProductById(productId, action);
      _productsStateNotifier.getProductList(
        mobileUserPublicKey,
        false,
      );
      _myBucketListStateNotifier.getMyBucketListItems(
          mobileUserPublicKey, false);
    } catch (e) {
      state = SingleProductState.error(e.toString());
    }
  }

//Method to manage product rate
  Future<void> manageRateProduct(
      String mobileUserPublicKey, int productId, int rating) async {
    try {
      final SingleProductApiResponseModel updatedProduct =
          state.singleProductApiResponseModel!.copyWith(
              userRating: state.singleProductApiResponseModel!.userRating);

      state = SingleProductState.productRateState(updatedProduct);
      await _productRepository.manageRateProduct(
          mobileUserPublicKey, productId, rating);

      _productsStateNotifier.getProductList(
        mobileUserPublicKey,
        false,
      );
    } catch (e) {
      state = SingleProductState.error(e.toString());
    }
  }

//manage Purchase order
  Future<bool> managePurchaseOrder(
      String mobileUserKey,
      int productId,
      int paidAmount,
      String couponCode,
      int subscriptionMappingId,
      String transactionId,
      String merchantTransactionId) async {
    try {
      state = SingleProductState.loading();

      final response = await _productRepository.managePurchaseOrder(
        mobileUserKey,
        productId,
        paidAmount,
        couponCode,
        subscriptionMappingId,
        transactionId,
        merchantTransactionId,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      state = SingleProductState.loaded(
          state.singleProductApiResponseModel!, false, null);

      return false;
    }
  }

// //manage validate coupon
//   Future<void> manageValidateCoupon(
//       String mobileUserKey, String couponCode, int productId) async {
//     try {
//       final response = await _productRepository.manageValidateCouponApi(
//           mobileUserKey, couponCode, productId,0);

//       if (response.statusCode == 200) {
//         final double updatedPrice = response.data['deductedPrice'];
//         final double priceAfterDiscount = updatedPrice.toDouble() ?? 0.0;
//         final SingleProductApiResponseModel updatedProduct = state
//             .singleProductApiResponseModel!
//             .copyWith(price: priceAfterDiscount);
//         state = SingleProductState.loaded(updatedProduct, false, null);
//         _couponCodeStateNotifier.setValid(true);
//       }

//       // else {
//       //   final SingleProductApiResponseModel updatedProducts = state
//       //       .singleProductApiResponseModel!
//       //       .copyWith(discount: invalidCuponCode);
//       //   state = SingleProductState.loaded(
//       //     updatedProducts,
//       //   );

//       //   _couponCodeStateNotifier.setValid(false);
//       //   throw Exception(invalidCuponCode);
//       // }
//     } catch (e) {
//       state = SingleProductState.loaded(
//           state.singleProductApiResponseModel!, false, null);
//       // ToastUtils.showToast(invalidCuponCode, "");
//       print('$invalidCuponCode: $e');
//     }
//   }

  Future<dynamic> getCouponCodeDiscountPrice(String mobileUserKey,
      String couponCode, int productId, int subscriptionDurationId) async {
    try {
      final response = await _productRepository.manageValidateCouponApi(
          mobileUserKey, couponCode, productId, subscriptionDurationId);

      if (response.statusCode == 200) {
        return response.data["deductedPrice"] ?? 0.0;
      } else {
        return "invalid";
      }
    } catch (e) {
      return 0.0;
    }
  }

  void updateBuyButton() {
    SingleProductApiResponseModel singleProductApiResponseModel =
        state.singleProductApiResponseModel!;

    singleProductApiResponseModel =
        singleProductApiResponseModel.copyWith(buyButtonText: "Purchased");

    state =
        SingleProductState.loaded(singleProductApiResponseModel, false, null);

    return;
  }
}

//Provider for single Product StateNotifier Provider
final singleProductStateNotifierProvider =
    StateNotifierProvider<SingleProductStateNotifier, SingleProductState>(
        (ref) {
  final IProductRepository singleProductRepository =
      getIt<IProductRepository>();
  final ProductsStateNotifier productsStateNotifier =
      ref.read(productsStateNotifierProvider.notifier);
  final MyBucketListStateNotifier myBucketListStateNotifier =
      ref.read(myBucketListProvider.notifier);
  // final CouponCodeStateNotifier couponCodeStateNotifier =
  //     ref.read(couponCodeStateNotifierProvider.notifier);
  return SingleProductStateNotifier(singleProductRepository,
      productsStateNotifier, myBucketListStateNotifier);
});

//Single product list overview and content buttons provider
class SingleProductButtonStateNotifier extends StateNotifier<int> {
  SingleProductButtonStateNotifier() : super(0);

  void setButtonState(int index) {
    state = index;
  }
}

final singleProductButtonStateNotifier =
    StateNotifierProvider<SingleProductButtonStateNotifier, int>((ref) {
  return SingleProductButtonStateNotifier();
});
