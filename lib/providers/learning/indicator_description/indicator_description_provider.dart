import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ILearning_repository.dart';

import 'package:research_mantra_official/main.dart';

import 'package:research_mantra_official/providers/learning/indicator_description/indicator_description_state.dart';

class IndicatorDescriptionNotifier
    extends StateNotifier<IndicatorDescriptionState> {
  IndicatorDescriptionNotifier(this._learningRepository)
      : super(IndicatorDescriptionState.initial());

  final ILearningRepository _learningRepository;
  Future<void> getIndicatorDescription(int id, String endPoints) async {
    try {
      state = IndicatorDescriptionState.loading();

      final getIndicatorDescriptionState =
          await _learningRepository.indicatorDesciption(id, endPoints);

      log("$getIndicatorDescriptionState -----value");
      state = IndicatorDescriptionState.loaded(getIndicatorDescriptionState);
    } catch (e) {
      state = IndicatorDescriptionState.error(e.toString());
    }
  }
}

final indicatorDescriptionProvider = StateNotifierProvider<
    IndicatorDescriptionNotifier, IndicatorDescriptionState>(((ref) {
  final ILearningRepository indicatorDescriptionRepository =
      getIt<ILearningRepository>();
  return IndicatorDescriptionNotifier(indicatorDescriptionRepository);
}));
