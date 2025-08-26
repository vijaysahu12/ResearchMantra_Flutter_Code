import 'package:research_mantra_official/data/models/dashboard/dashboard_slider_model.dart';

class LoginScreenImagesState {
  final bool isLoading;
  final List<CommonImagesResponseModel> loginScreenImages;
  final dynamic error;

  LoginScreenImagesState(
      {required this.loginScreenImages,
      required this.error,
      required this.isLoading});

  factory LoginScreenImagesState.initail() => LoginScreenImagesState(
      loginScreenImages: [], error: null, isLoading: false);
  factory LoginScreenImagesState.loading() => LoginScreenImagesState(
      loginScreenImages: [], error: null, isLoading: true);

  factory LoginScreenImagesState.loadedImages(
          List<CommonImagesResponseModel> loginScreenImages) =>
      LoginScreenImagesState(
          loginScreenImages: loginScreenImages, error: null, isLoading: false);

  factory LoginScreenImagesState.profileImages(
          List<CommonImagesResponseModel> loginScreenImages) =>
      LoginScreenImagesState(
          loginScreenImages: loginScreenImages, error: null, isLoading: false);

  factory LoginScreenImagesState.error(dynamic error) => LoginScreenImagesState(
      loginScreenImages: [], error: error, isLoading: false);
}
