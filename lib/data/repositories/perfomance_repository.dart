
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/perfomance/perfomance_header_response_model.dart';
import 'package:research_mantra_official/data/models/perfomance/perfomance_response_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IPerfomance_repository.dart';
import 'package:research_mantra_official/main.dart';

class PerformaceRepository implements IPerformanceRepository {
  final HttpClient _httpClient =  getIt<HttpClient>();

  @override
  Future<PerformanceResponseModel> getPerfomanceData(String code) async {
    try {
      final response = await _httpClient.get("$getPerformanceApi?code=$code");

      if (response.statusCode == 200) {
        final result = PerformanceResponseModel.fromJson(response.data);
        return result;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<GetPerformanceHeaderResponseModel>> getPerformanceHeader() async {
    try {
      final response = await _httpClient.get(getPerformanceHeaderApi);

      if (response.statusCode == 200) {
        final List<dynamic> result = response.data;
        final List<GetPerformanceHeaderResponseModel> getPerformanceHeaderData =
            result
                .map((headersList) =>
                    GetPerformanceHeaderResponseModel.fromJson(headersList))
                .toList();
        return getPerformanceHeaderData;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
