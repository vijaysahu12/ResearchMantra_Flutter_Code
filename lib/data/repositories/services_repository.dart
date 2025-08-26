import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/services/services_response_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IServices_repositry.dart';
import 'package:research_mantra_official/main.dart';

class ServicesRepository implements IServicesReposity {
  final HttpClient _httpClient = getIt<HttpClient>();

  @override
  Future<List<ServicesResponseModel>> getServicesList() async {
    try {
      final response = await _httpClient.get(getServicesApi);
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> servicesData = response.data;
        final List<ServicesResponseModel> servicesList = servicesData
            .map((data) => ServicesResponseModel.fromJson(data))
            .toList();
        return servicesList;
      } else {
        if (response.data == null) {
          return [];
        } else {
          throw Exception(response.message);
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
