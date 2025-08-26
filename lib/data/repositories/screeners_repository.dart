import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/screeners/screeners_category_data_model.dart';
import 'package:research_mantra_official/data/models/screeners/stock_data_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IScreeners_repository.dart';
import 'package:research_mantra_official/main.dart';

class ScreenersRespository extends IScreenersRepository {
  final HttpClient _httpClient = getIt<HttpClient>();
  // final SharedPref _sharedPref = SharedPref();
  @override
  Future<List<Category>> getCategoryScreeners() async {
    try {
      final response = await _httpClient.get(getscreener);

      if (response.statusCode == 200) {
        // final categoryData = response.data;

        final List<dynamic> categoryData = response.data;
        final List<Category> categoriesList =
            categoryData.map((data) => Category.fromJson(data)).toList();

        return categoriesList;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Stock>> getStockScreeners(int id, String code) async {
    try {
      final response = await _httpClient
          .get("$getscreenerStockData?code=$code&screenerId=$id");

      if (response.statusCode == 200 && response.data != null) {
        // Access the "data" key in the response if the data is nested
        final jsonResponse = response.data;
        if (jsonResponse is Map<String, dynamic>) {
          final List<dynamic> stockData = jsonResponse['data'] ?? [];

          // Convert the data to a list of Stock objects
          final List<Stock> stockList =
              stockData.map((data) => Stock.fromJson(data)).toList();

          return stockList;
        } else {
          throw Exception('Unexpected response format.');
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching stock screeners: $e');
    }
  }
}
