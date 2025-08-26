import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/common_api_response.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IPaymentByPass_repository.dart';
import 'package:research_mantra_official/main.dart';

class PaymentGateWayRepository implements IPaymentGateWayByPassRepository {
  final HttpClient _httpClient =  getIt<HttpClient>();

  @override
  Future<CommonHelperResponseModel> byPassTheGateWay(String mobileUserKey,
      int productId, String couponCode, String checkStatus) async {
    try {
      final body = {
        "mobileUserKey": mobileUserKey,
        "productId": productId,
        "couponCode": couponCode,
        "actionType": checkStatus
      };

      final response = await _httpClient.post(byPassThePaymentGatewayApi, body);
      final result = CommonHelperResponseModel.fromJson(response);
      return result;
    } catch (error) {
      throw Exception(error);
    }
  }
}
