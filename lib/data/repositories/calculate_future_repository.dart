import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/calculater/caliculate_future_model.dart';
import 'package:research_mantra_official/data/models/calculater/plans_response_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ICalculate_future_repository.dart';
import '../../main.dart';

class CalculateFutureRepository implements ICalculateMyFutureRepository {
  final HttpClient _httpClient = getIt<HttpClient>();

  @override
  Future<CalculateMyFuturePlanModel?> getFuturePlanData(
      int currentAge,
      int retirementAge,
      double currentMonthlyExpense,
      double inflationRate,
      int anyCurrentInvestment,
      double currentInvestmentAmountInterstRate) async {
    try {
      //post request body
      final body = {
        "currentAge": currentAge,
        "retirementAge": retirementAge,
        "currentMonthlyExpense": currentMonthlyExpense,
        "interestRate": inflationRate,
        "anyCurrentInvestment": anyCurrentInvestment
      };

// Make HTTP post request to get all notification list

      final response = await _httpClient.post(calculateMyFutureApi, body);
      if (response.statusCode == 200) {
        final dynamic data = response.data;
        final calculateMyFuturePlanModel =
            CalculateMyFuturePlanModel.fromJson(data);

        return calculateMyFuturePlanModel;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<GetPlansResponseModel>> getPlans() async {
    try {
// Make HTTP post request to get all notification list
      final response = await _httpClient.post(getFuturePlansApi, {});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<GetPlansResponseModel> calculateMyFuturePlanModel =
            data.map((plans) => GetPlansResponseModel.fromJson(plans)).toList();

        return calculateMyFuturePlanModel;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
