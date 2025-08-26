
import 'package:research_mantra_official/data/models/get_free_trial/activate_free_trial_response_model.dart';
import 'package:research_mantra_official/data/models/get_free_trial/get_free_trial_data_model.dart';

abstract class IGetFreeTrialRepository {
  //This method for get all reports
  Future<GetFreeTrialDataModel> getFreeTrialData(String mobileUserPublicKey);
  Future<ActivateFreeTrialResponseModel> acceptFreeTrialData(String mobileUserPublicKey);


}