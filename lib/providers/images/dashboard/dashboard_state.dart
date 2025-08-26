import 'package:research_mantra_official/data/models/dashboard/dashboard_slider_model.dart';

class DashBoardState {
  final bool isLoading;
  final List<CommonImagesResponseModel> dashBoardImages;
  final dynamic error;

  DashBoardState(
      {required this.dashBoardImages,
      required this.error,
      required this.isLoading});

  factory DashBoardState.initail() =>
      DashBoardState(dashBoardImages: [], error: null, isLoading: false);
  factory DashBoardState.loading() =>
      DashBoardState(dashBoardImages: [], error: null, isLoading: true);

  factory DashBoardState.loadedImages(
          List<CommonImagesResponseModel> dashBoardImages) =>
      DashBoardState(
          dashBoardImages: dashBoardImages, error: null, isLoading: false);

           factory DashBoardState.profileImages(
          List<CommonImagesResponseModel> dashBoardImages) =>
      DashBoardState(
          dashBoardImages: dashBoardImages, error: null, isLoading: false);


    
  factory DashBoardState.error(dynamic error) =>
      DashBoardState(dashBoardImages: [], error: error, isLoading: false);
}
