
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/coupon_code/coupon_code_response_model.dart';
import 'package:research_mantra_official/data/models/subscription/subscription_sinlge_product_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ISubscription_repository.dart';
import 'package:research_mantra_official/main.dart';

class SubscriptionRepository extends ISubscriptionRepository {
  final HttpClient _httpClient = getIt<HttpClient>();
  @override
  Future<List<SubscriptionSingleProductDataModel>> singleProductsubscription(
      int planId,
      int productId,
      String mobileUserKey,
      String deviceType) async {
    try {
      Map<String, dynamic> body = {
        "productId": productId,
        "subscriptionPlanId": planId,
        'mobileUserKey': mobileUserKey,
        "deviceType": deviceType
      };

      final response = await _httpClient.post(getSubscriptionById, body);

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> subscriptionData = response.data;
        final List<SubscriptionSingleProductDataModel>
            singleProductSubscription = subscriptionData
                .map(
                    (data) => SubscriptionSingleProductDataModel.fromJson(data))
                .toList();
        return singleProductSubscription;
      } else {
        return [];
      }
    } catch (error) {
      print(error);
      throw Exception(error.toString());
    }
  }

  @override
  Future<List<CouponCodeResponseModel>> getAllCouponCodeList(
      int productId, int subscriptionDurationId) async {
    try {
      final body = {
        "productId": productId,
        "subscriptionDurationId": subscriptionDurationId
      };
      final response = await _httpClient.post(getCoupons, body);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        final List<CouponCodeResponseModel> getAllCoupons = responseData
            .map((data) => CouponCodeResponseModel.fromJson(data))
            .toList();
        return getAllCoupons;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }
}
