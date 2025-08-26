import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/dashboard/dashboard_slider_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IDashBoard_respository.dart';
import 'package:research_mantra_official/main.dart';

class DashBoardRepository implements IDashBoardRepository {
  final HttpClient _client =  getIt<HttpClient>();

  @override
  Future<List<CommonImagesResponseModel>> getDashBoardSliderImages(
      String imageType) async {
    try {
      final response = await _client.get("$getDashBoardImages?type=$imageType");
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<CommonImagesResponseModel> dashBoardImages = data
            .map((images) => CommonImagesResponseModel.fromJson(images))
            .toList();

        return dashBoardImages;
      } else {
        return [];
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  //getTopThreeProducts
  @override
  Future<List<DashBoardTopImagesModel>> getTopThreeProducts(
      String mobileUserKey) async {
    try {
      final response = await _client
          .get('$getTopThreeProductsApi?getTopThreeProducts=$mobileUserKey');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<DashBoardTopImagesModel> getTopThreeProducts = data
            .map((images) => DashBoardTopImagesModel.fromJson(images))
            .toList();
        return getTopThreeProducts;
      } else {
        return [];
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
