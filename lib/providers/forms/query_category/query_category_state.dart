import 'package:research_mantra_official/data/models/query/query_category_response_model.dart';

class QueryCategoryState {
  final bool isLoading;
  final dynamic error;
  final List<QueryCategory> queryCategory;

  QueryCategoryState(
      {required this.isLoading,
      required this.error,
      required this.queryCategory});

  factory QueryCategoryState.initial() =>
      QueryCategoryState(isLoading: false, error: null, queryCategory: []);

  factory QueryCategoryState.loading() =>
      QueryCategoryState(isLoading: true, error: null, queryCategory: []);
  factory QueryCategoryState.success(List<QueryCategory> queryCategory) =>
      QueryCategoryState(
          isLoading: false, error: null, queryCategory: queryCategory);
  factory QueryCategoryState.error(dynamic error) =>
      QueryCategoryState(isLoading: false, error: error, queryCategory: []);
}
