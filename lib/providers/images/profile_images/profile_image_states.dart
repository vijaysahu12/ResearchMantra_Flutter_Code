import 'package:research_mantra_official/data/models/dashboard/dashboard_slider_model.dart';

class ProfileScreenImagesState {
  final bool isLoading;
  final List<CommonImagesResponseModel> profileScreenImage;
  final dynamic error;

  ProfileScreenImagesState(
      {required this.profileScreenImage,
      required this.error,
      required this.isLoading});

  factory ProfileScreenImagesState.initail() => ProfileScreenImagesState(
      profileScreenImage: [], error: null, isLoading: false);
  factory ProfileScreenImagesState.loading() => ProfileScreenImagesState(
      profileScreenImage: [], error: null, isLoading: true);

  factory ProfileScreenImagesState.loadedImages(
          List<CommonImagesResponseModel> profileScreenImage) =>
      ProfileScreenImagesState(
          profileScreenImage: profileScreenImage, error: null, isLoading: false);

  factory ProfileScreenImagesState.profileImages(
          List<CommonImagesResponseModel> dashBoardImages) =>
      ProfileScreenImagesState(
          profileScreenImage: dashBoardImages, error: null, isLoading: false);

  factory ProfileScreenImagesState.error(dynamic error) =>
      ProfileScreenImagesState(
          profileScreenImage: [], error: error, isLoading: false);
}
