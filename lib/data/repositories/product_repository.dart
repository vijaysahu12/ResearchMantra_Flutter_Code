import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/common_api_response.dart';
import 'package:research_mantra_official/data/models/playlist_model/video_playlist_response_model.dart';
import 'package:research_mantra_official/data/models/product_api_response_model.dart';
import 'package:research_mantra_official/data/models/product_details_content_api_response_model.dart';
import 'package:research_mantra_official/data/models/single_product_api_response_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IProduct_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

// Product Repository implementation
class ProductRepository implements IProductRepository {
  final HttpClient _httpClient = getIt<HttpClient>();
  final UserSecureStorageService _commonDetails = UserSecureStorageService();

  // Get list of products
  @override
  Future<List<ProductApiResponseModel>> getProductsList(
      String mobileUserPublicKey) async {
    try {
      final commonApiResponse =
          await _httpClient.get("$getProductsListApi/$mobileUserPublicKey");

      if (commonApiResponse.statusCode == 200) {
        final List<dynamic> responseData = commonApiResponse.data;
        final List<ProductApiResponseModel> resultProductsList = responseData
            .map((productList) => ProductApiResponseModel.fromJson(productList))
            .toList();
        return resultProductsList;
      } else {
        throw Exception("Error: ${commonApiResponse.statusCode}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Manage like or unlike product by id
  @override
  Future<void> manageLikeUnlikeProductById(int productId, String action) async {
    final String mobileUserPublicKey = await _commonDetails.getPublicKey();
    try {
      final notificationPostBody = {
        "productId": productId,
        "likeId": 1,
        "createdBy": mobileUserPublicKey,
        "action": action
      };
      final response =
          await _httpClient.post(likeUnlikeProductApi, notificationPostBody);
      if (response.statusCode == 200) {
      } else {
        throw Exception("Error: ${response.message}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Get details of a single product by id
  @override
  Future<SingleProductApiResponseModel> getSingleProductDetails(
      int id, String mobileUserPublicKey) async {
    try {
      final commonResponse = await _httpClient
          .get('$getProductById?id=$id&mobileUserKey=$mobileUserPublicKey');

      if (commonResponse.statusCode == 200) {
        if (commonResponse.data != null) {
          final result =
              SingleProductApiResponseModel.fromJson(commonResponse.data);
          return result;
        } else {
          throw Exception('Failed to fetch single product details');
        }
      } else {
        throw Exception('Failed to fetch single product details');
      }
    } catch (error) {
      throw Exception('Failed to fetch single product details');
    }
  }

  // Manage rating for a product
  @override
  Future<void> manageRateProduct(
      String mobileUserPublicKey, int productId, int rating) async {
    try {
      final body = {
        "userKey": mobileUserPublicKey,
        "productId": productId,
        "rating": rating
      };
      final response = await _httpClient.post(rateProduct, body);
      if (response.statusCode == 200) {
        print("${response.message}:${response.statusCode}");
      } else {
        print("${response.message}:${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Get content of a product
  @override
  Future<List<ProductDetailsItemApiResponseModel>> getProductContent(
      int productId, String mobileUserPublicKey) async {
    final body = {
      "id": productId,
      "userkey": mobileUserPublicKey,
    };
    try {
      final response = await _httpClient.post(getProductContentApiV2, body);

      if (response.statusCode == 200) {
        // print('response data: ${response.data}'); // print(response.data);
        // print('product id: $productId');
        final List<dynamic> responseData = response.data;
        List<ProductDetailsItemApiResponseModel> productList = responseData
            .map<ProductDetailsItemApiResponseModel>(
                (data) => ProductDetailsItemApiResponseModel.fromJson(data))
            .toList();
        return productList;
      } else {
        throw Exception('Failed to load product content');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  // Get Video Player PlayList
  @override
  Future<PlaylistDataResponseModel> getVideoPlaylist(int productId) async {
    try {
      final response =
          await _httpClient.post(getPlayListApi, {"productId": productId});
      if (response.statusCode == 200) {
        final videoPlaylist = PlaylistDataResponseModel.fromJson(response.data);

        return videoPlaylist;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Get image of a product
  @override
  Future<String?> getProductImage(String productImageEndPoint) async {
    try {
      final response = await _httpClient.get(productImageEndPoint);

      if (response.statusCode == 200) {
        return response.data;
      } else {}
    } catch (error) {
      throw Exception(error);
    }
    return null;
  }

  @override
  Future<CommonApiResponse> manageValidateCouponApi(String mobileUserKey,
      String couponCode, int productId, int subscriptionDurationId) async {
    try {
      Map<String, dynamic> body = {
        "mobileUserKey": mobileUserKey,
        "productId": productId,
        "couponCode": couponCode,
        'subscriptionDurationId': subscriptionDurationId
      };
      final response = await _httpClient.post(validateCouponApi, body);
      if (response.statusCode == 200) {
        return response;
      } else {
        ToastUtils.showToast(invalidCuponCode, "");
        // throw Exception('Failed to validate coupon: ${response.statusCode}');
        return response;
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  Future<CommonApiResponse> managePurchaseOrder(
      String mobileUserKey,
      int productId,
      int paidAmount,
      String couponCode,
      int subscriptionMappingId,
      String transactionId,
      String merchantTransactionId) async {
    try {
      Map<String, dynamic> body = {
        "mobileUserKey": mobileUserKey,
        "productId": productId,
        "subscriptionMappingId": subscriptionMappingId,
        "transactionId": transactionId,
        "merchantTransactionId": merchantTransactionId,
        "paidAmount": paidAmount,
        "couponCode": couponCode
      };

      final response = await _httpClient.post(managePurchaseOrderApi, body);
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            'You are unable to purchase the product: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }
}
