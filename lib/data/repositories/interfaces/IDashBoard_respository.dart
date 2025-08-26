import 'package:research_mantra_official/data/models/dashboard/dashboard_slider_model.dart';

abstract class IDashBoardRepository {
  Future<List<CommonImagesResponseModel>> getDashBoardSliderImages(
      String imageType);

  Future<List<DashBoardTopImagesModel>> getTopThreeProducts(
      String mobileUserKey);
}
