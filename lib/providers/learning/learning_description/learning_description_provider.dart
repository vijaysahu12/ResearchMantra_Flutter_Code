

import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ILearning_repository.dart';

import 'package:research_mantra_official/main.dart';

import 'package:research_mantra_official/providers/learning/learning_description/learning_description_state.dart';

class LearningDescriptionNotifier extends StateNotifier<LearningDescriptionState> {
  LearningDescriptionNotifier(this._learningRepository)
      : super(LearningDescriptionState.initial());

  final ILearningRepository _learningRepository;
     Future<void> getLearningDescription(int id, String endPoints) async {
        try {
    state = LearningDescriptionState.loading();

      final learningMaterialDesc =
          await _learningRepository.individualLearningMaterialDescription(id,endPoints);

          log("$learningMaterialDesc -----value");
      state = LearningDescriptionState.loaded(learningMaterialDesc);
    } catch (e) {
      state = LearningDescriptionState.error(e.toString());
    }
  }
}

final getLearningDescProvider =
    StateNotifierProvider<LearningDescriptionNotifier, LearningDescriptionState>(((ref) {
  final ILearningRepository  learningDescRepository = getIt<ILearningRepository>();
  return LearningDescriptionNotifier(learningDescRepository);
}));
