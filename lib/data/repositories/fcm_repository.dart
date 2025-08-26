import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ifcm_respository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/services/secure_storage.dart';

class UpdateFcmRepository implements IUpdateFcmRepository {
  final HttpClient _httpClient = getIt<HttpClient>();
  final SecureStorage _secureStorage = getIt<SecureStorage>();
  @override
  Future updateFcm(String pubLickey, fcm) async {
    try {
      final response = await _httpClient
          .post(updateFcmapi, {"mobileUserKey": pubLickey, "fcmToken": fcm});

      if (response.statusCode == 200) {
        _secureStorage.write(fcmToken, fcm);

        print("success ${response.message}");
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }
}
