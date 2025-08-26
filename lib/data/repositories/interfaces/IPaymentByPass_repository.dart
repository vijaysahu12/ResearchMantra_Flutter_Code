import 'package:research_mantra_official/data/models/common_api_response.dart';

abstract class IPaymentGateWayByPassRepository {
  Future<CommonHelperResponseModel> byPassTheGateWay(String mobileUserKey,int productId,String couponCode,String checkStatus);
}
