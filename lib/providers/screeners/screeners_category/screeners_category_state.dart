import 'package:research_mantra_official/data/models/screeners/screeners_category_data_model.dart';

class ScreenerCategoryState {
  final dynamic error;
  final bool isLoading;
  final  List<Category> categoryModel;

  ScreenerCategoryState({
    required this.isLoading,
    this.error,
    required this.categoryModel,
  });

  factory ScreenerCategoryState.initial() => ScreenerCategoryState(
        isLoading: false,
        categoryModel: []
      );
  factory ScreenerCategoryState.loading() => ScreenerCategoryState(
        isLoading: true,
        categoryModel: [],
      );

  factory ScreenerCategoryState.loaded(List<Category> categoryModel) =>
      ScreenerCategoryState(
        isLoading: false,
        categoryModel: categoryModel,
      );
  factory ScreenerCategoryState.error(dynamic error) => ScreenerCategoryState(
        isLoading: false,
        error: error,
        categoryModel: [],
      );
}
