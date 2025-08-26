import 'package:research_mantra_official/data/models/common_api_response.dart';
import 'package:research_mantra_official/data/models/playlist_model/video_playlist_response_model.dart';
import 'package:research_mantra_official/data/models/product_details_content_api_response_model.dart';
import 'package:research_mantra_official/data/models/single_product_api_response_model.dart';

import '../../models/product_api_response_model.dart';

//Interface for ProductList
abstract class IProductRepository {
  //This method for get all products
  Future<List<ProductApiResponseModel>> getProductsList(
      String mobileUserPublicKey);
  //This method manages the like or unlike action for the product identified by [productId].
  Future<void> manageLikeUnlikeProductById(int productId, String action);

  //This method for get SingleProductDetails.
  Future<SingleProductApiResponseModel> getSingleProductDetails(
      int id, String mobileUserPublicKey);

  //This method for manage Rate Product.
  Future<void> manageRateProduct(
      String mobileUserPublicKey, int productId, int rationg);

  //This method for get Product Content.
  Future<List<ProductDetailsItemApiResponseModel>> getProductContent(
      int productId, String mobileUserPublicKey);

  //This method for getting video playlist screen data
  Future<PlaylistDataResponseModel> getVideoPlaylist(int productId);

//This method for getProductImage
  Future<String?> getProductImage(String productImageEndPoint);
  Future<CommonApiResponse> manageValidateCouponApi(String mobileUserKey,
      String couponCode, int productId, int subscriptionDurationId);
  Future<CommonApiResponse> managePurchaseOrder(
      String mobileUserKey,
      int productId,
      int paidAmount,
      String couponCode,
      int subscriptionMappingId,
      String transactionId,
      String merchantTransactionId);
}
