import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/market_analysis/all_post_market_analysis.dart';
import 'package:research_mantra_official/data/models/market_analysis/all_premarket_analysis.dart';
import 'package:research_mantra_official/data/models/market_analysis/specifc_postmarket_analysis.dart';
import 'package:research_mantra_official/data/models/market_analysis/specifc_premarket_analysis.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IAnalysis_repository.dart';
import 'package:research_mantra_official/main.dart';

class MarketAnalysisRepository extends IAnalysisRepository {
  final HttpClient _httpClient = getIt<HttpClient>();
  // final SharedPref _sharedPref = SharedPref();
  @override
  Future<List<AllPreMarketAnalysisDataModel>?> getAllPreMarketAnalysis(int id ) async {
    try {
      final response = await _httpClient.get(
        "$getPreMarketAnalysisApi?pageNumber=$id&pageSize=10",
      );

      if (response.statusCode == 200 && response.data != null) {
        // Ensure data is a List before mapping
        final List<dynamic> responseData = response.data as List<dynamic>;

        final preMarketAnalysisData = responseData
            .map((data) => AllPreMarketAnalysisDataModel.fromJson(
                data as Map<String, dynamic>))
            .toList();

        return preMarketAnalysisData;
      } else {
        print('${response.statusCode}:${response.message}');
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  @override
  Future<PreMarketAnalysisData?> getPreMarketAnalysisById(String id) async {
    try {
      final response =
          await _httpClient.get("$getPreMarketAnalysisApiById?objectId=$id");

      if (response.statusCode == 200) {
        // final categoryData = response.data;

        final preMarketAnalysisData =
            PreMarketAnalysisData.fromJson(response.data);

        return preMarketAnalysisData;
      } else {
        print('${response.statusCode}:${response.message}');
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  @override
  Future<PostMarketAnalysisStockData?> getPostMarketAnalysisById(
      String id) async {
    try {
      final response = await _httpClient
          .get("$getPostMarketAnalysisByIdendPoint?objectId=$id");

      if (response.statusCode == 200 && response.data != null) {
        print('The responsePremarket............................');

        // Ensure data is a List before mapping
        final responseData = response.data;

        final postMarketAnalysisData =
            PostMarketAnalysisStockData.fromJson(responseData);

        return postMarketAnalysisData;
      } else {
        print('${response.statusCode}:${response.message}');
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<AllPostMarketStockReport?>> getAllPostMarketAnalysis(
      int pageNumber) async {
    try {
      final response = await _httpClient.get(
          "$getAlllPostMarketAnalysis?pageNumber=$pageNumber&pageSize=10");

      if (response.statusCode == 200 && response.data != null) {
        // Ensure data is a List before mapping
        final List<dynamic> learningMaterialData = response.data;

        // final postMarketAnalysisData = AllPostMarketStockReport.fromJson(responseData);
        final List<AllPostMarketStockReport> postMarketAnalysisData =
            learningMaterialData
                .map((data) => AllPostMarketStockReport.fromJson(data))
                .toList();

        return postMarketAnalysisData;
      } else {
        print('${response.statusCode}:${response.message}');
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }
}
