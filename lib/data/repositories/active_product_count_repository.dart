import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/total_products/active_product_count_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IActive_product_count_repository.dart';
import 'package:research_mantra_official/main.dart';

class ActiveProductCountRepository implements IActiveProductCountRepository {
  final HttpClient _httpClient = getIt<HttpClient>();

  @override
  Future<ActiveProductCountModel> getActiveProducts() async {
    try {
      final response = await _httpClient.post(activeActiveProducts, {});

      if (response.statusCode == 200 && response.data != null) {
   
        ActiveProductCountModel products =  ActiveProductCountModel.fromJson( response.data);
        return products;
      } else {
        throw Exception(
            'Failed to fetch active product count. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching active product count: ${e.toString()}');
    }
  }
}
