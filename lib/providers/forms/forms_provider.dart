import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:research_mantra_official/data/repositories/interfaces/IForms_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/forms/form_state.dart';

class FormsStateNotifier extends StateNotifier<FormsState> {
  FormsStateNotifier(this._formsRepository) : super(FormsState.initial());

  final IFormsRepository _formsRepository;

//to get all the subscriptiontopis list
  Future<void> addQueryForm(
    dynamic id,
    String queryCategory,
    String queryDescription,
    File? image,
  ) async {
    state = FormsState.loading();
    try {
      final response = await _formsRepository.postQueryFormData(
          id, queryCategory, queryDescription, image);

      if (response.status) {
        state = FormsState.success(response);
      }
    } catch (e) {
      print(e);
      state = FormsState.error(e);
    }
  }
}

final getFormsStateNotifierProvider =
    StateNotifierProvider<FormsStateNotifier, FormsState>((ref) {
  final IFormsRepository manageQuery = getIt<IFormsRepository>();
  return FormsStateNotifier(manageQuery);
});
