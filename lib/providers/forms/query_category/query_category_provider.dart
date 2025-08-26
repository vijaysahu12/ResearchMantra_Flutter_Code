import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:research_mantra_official/data/repositories/interfaces/IForms_repository.dart';
import 'package:research_mantra_official/main.dart';

import 'package:research_mantra_official/providers/forms/query_category/query_category_state.dart';

class QueryCategoryProvider extends StateNotifier<QueryCategoryState> {
  QueryCategoryProvider(this._formsRepository)
      : super(QueryCategoryState.initial());

  final IFormsRepository _formsRepository;

//to get all the subscriptiontopis list
  Future<void> getQueryCategory(
    dynamic id,
  ) async {
    state = QueryCategoryState.loading();
    try {
      final response = await _formsRepository.getQueryCategories(id);

      state = QueryCategoryState.success(response);
    } catch (e) {
      print(e);
      state = QueryCategoryState.error(e);
    }
  }
}

final getQueryCategoryProviderProvider =
    StateNotifierProvider<QueryCategoryProvider, QueryCategoryState>((ref) {
  final IFormsRepository getQueryData = getIt<IFormsRepository>();
  return QueryCategoryProvider(getQueryData);
});
