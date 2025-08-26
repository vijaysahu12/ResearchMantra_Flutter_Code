import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/network/http_client.dart';

import 'package:research_mantra_official/data/models/advertisement/advertisement_response.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IProfile_repository.dart';
import 'package:research_mantra_official/main.dart';

class ProfileRepository implements IProfileRepository {
  final HttpClient _httpClient =  getIt<HttpClient>();

//Method to get advertisement image and url
  @override
  Future<AdvertisementResponseModel?> getAdvertisementList() async {
    try {
      final response = await _httpClient.get(getProfileScreenAdvertisementList);
      if (response.statusCode == 200) {
        final dynamic responseData = response.data;
        final AdvertisementResponseModel result =
            AdvertisementResponseModel.fromJson(responseData);
        return result;
      } else {
        return null;
      }
    } catch (e) {

      throw Exception('Failed to load : $e');
    }
  }
}
