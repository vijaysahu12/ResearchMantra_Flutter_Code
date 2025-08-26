import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/risk_reward_calculator/risk_reward_request_model.dart';
import 'package:research_mantra_official/data/models/risk_reward_calculator/risk_reward_response_model.dart';
import 'package:research_mantra_official/data/models/sip_calculator/sip_request_model.dart';
import 'package:research_mantra_official/data/models/sip_calculator/sip_response_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ISip_calculator_repository.dart';
import 'package:research_mantra_official/main.dart';

class SipCalculatorRepository implements ISipCalculatorRepository {
  final HttpClient _httpClient = getIt<HttpClient>();
  @override
  Future<SipResponseModel> postSipCalculator(SipRequestModel model) async {
    try {
      final response = await _httpClient.post(calculateSipApi, model.toJson());

      if (response.statusCode == 200) {
        final postSip = SipResponseModel.fromJson(response.data);

        return postSip;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

// this POST method for Risk Reward Calculator
  @override
  Future<RiskRewardResponseModel> postRiskRewardCalculator(
      RiskRewardRequestModel model) async {
    try {
      final response =
          await _httpClient.post(calculateRiskRewardApi, model.toJson());

      if (response.statusCode == 200) {
        final postRiskReward = RiskRewardResponseModel.fromJson(response.data);

        return postRiskReward;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
