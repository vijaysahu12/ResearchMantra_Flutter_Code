import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ILearning_repository.dart';

import 'package:research_mantra_official/main.dart';

import 'package:research_mantra_official/providers/learning/learning_material/learning_material_state.dart';

class GetLearningMaterialNotifier extends StateNotifier<LearningMaterialState> {
  GetLearningMaterialNotifier(this._learningRepository)
      : super(LearningMaterialState.initial());

  final ILearningRepository _learningRepository;

  Future<void> getLearningMaterialList(bool isRefresh) async {
    try {
      state = LearningMaterialState.loading();

      final getAllLearningMaterial =
          await _learningRepository.getAllLearningMateriaList();

      log("$getAllLearningMaterial -----value");

      state = LearningMaterialState.loaded(getAllLearningMaterial);
    } catch (e) {
      state = LearningMaterialState.error(e.toString());
    }
  }
}

final getLearningMaterialProvider =
    StateNotifierProvider<GetLearningMaterialNotifier, LearningMaterialState>(
        ((ref) {
  final ILearningRepository learningMaterialcRepository =
      getIt<ILearningRepository>();
  return GetLearningMaterialNotifier(learningMaterialcRepository);
}));
