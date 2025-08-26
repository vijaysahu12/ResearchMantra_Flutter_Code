import 'package:research_mantra_official/data/models/calculater/caliculate_future_model.dart';
import 'package:research_mantra_official/data/models/calculater/plans_response_model.dart';

abstract class ICalculateMyFutureRepository {
  Future<CalculateMyFuturePlanModel?> getFuturePlanData(
      int currentAge,
      int retirementAge,
      double currentMonthlyExpense,
      double inflationRate,
      int anyCurrentInvestment,
      double currentInvestmentAmountInterstRate);

  Future<List<GetPlansResponseModel>> getPlans();
}
