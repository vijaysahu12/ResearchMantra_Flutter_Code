
import 'package:research_mantra_official/data/models/risk_reward_calculator/risk_reward_request_model.dart';
import 'package:research_mantra_official/data/models/risk_reward_calculator/risk_reward_response_model.dart';
import 'package:research_mantra_official/data/models/sip_calculator/sip_request_model.dart';
import 'package:research_mantra_official/data/models/sip_calculator/sip_response_model.dart';

abstract class ISipCalculatorRepository {
  //This method to post value for sip calculation
  Future<SipResponseModel> postSipCalculator(SipRequestModel model);
  
  //This method to post value for RiskReward Calculation
  Future<RiskRewardResponseModel> postRiskRewardCalculator(RiskRewardRequestModel model);

}
