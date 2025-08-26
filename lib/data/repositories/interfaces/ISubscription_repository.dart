import 'package:research_mantra_official/data/models/coupon_code/coupon_code_response_model.dart';
import 'package:research_mantra_official/data/models/subscription/subscription_sinlge_product_model.dart';

abstract class ISubscriptionRepository {
  Future<List<SubscriptionSingleProductDataModel>> singleProductsubscription(
      int planId, int productId, String mobileUserKey, String deviceType);
  Future<List<CouponCodeResponseModel>> getAllCouponCodeList(int productId ,int subscriptionDurationId);
}
