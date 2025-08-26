import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/get_free_trial/activate_free_trial_response_model.dart';
import 'package:research_mantra_official/data/models/get_free_trial/get_free_trial_data_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IGet_Free_trial_respositiry.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/services/secure_storage.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class GetFreeTrialRepository implements IGetFreeTrialRepository {
  final HttpClient _httpClient =  getIt<HttpClient>();

  final SharedPref pref = SharedPref();

  @override
  Future<GetFreeTrialDataModel> getFreeTrialData(
      String mobileUserPublicKey) async {
    try {
      final response = await _httpClient
          .get("$getFreeTrial?mobileUserKey=$mobileUserPublicKey");

      if (response.statusCode == 200) {
        final getFreeTrialDataModel =
            GetFreeTrialDataModel.fromJson(response.data);

        // return researchDataModel;
        return getFreeTrialDataModel;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<ActivateFreeTrialResponseModel> acceptFreeTrialData(
      String mobileUserPublicKey) async {
    try {
      final response = await _httpClient
          .get("$activateFreeTrial?mobileUserKey=$mobileUserPublicKey");

      if (response.statusCode == 200) {
        final activateFreeTrialResponse =
            ActivateFreeTrialResponseModel.fromJson(response.data);

        await pref.save(
            freeTrialStatus, activateFreeTrialResponse.result ?? activated);

        ToastUtils.showToast(
            activateFreeTrialResponse.message ?? weExtendTheFreeTrialService,
            "");

        return activateFreeTrialResponse;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
