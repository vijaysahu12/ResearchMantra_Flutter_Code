import 'package:research_mantra_official/data/models/dashboard/dashboard_slider_model.dart';

class TopThreeProductsStates {
  final bool isLoading;
  final List<DashBoardTopImagesModel> topThreeImagesList;
  final dynamic error;

  TopThreeProductsStates(
      {required this.topThreeImagesList,
      required this.error,
      required this.isLoading});

  factory TopThreeProductsStates.initail() => TopThreeProductsStates(
      topThreeImagesList: [], error: null, isLoading: false);
  factory TopThreeProductsStates.loading() => TopThreeProductsStates(
      topThreeImagesList: [], error: null, isLoading: true);

  factory TopThreeProductsStates.loadedImages(
          List<DashBoardTopImagesModel> topThreeImagesList) =>
      TopThreeProductsStates(
          topThreeImagesList: topThreeImagesList,
          error: null,
          isLoading: false);

  factory TopThreeProductsStates.profileImages(
          List<DashBoardTopImagesModel> topThreeImagesList) =>
      TopThreeProductsStates(
          topThreeImagesList: topThreeImagesList,
          error: null,
          isLoading: false);

  factory TopThreeProductsStates.error(dynamic error) => TopThreeProductsStates(
      topThreeImagesList: [], error: error, isLoading: false);
}
