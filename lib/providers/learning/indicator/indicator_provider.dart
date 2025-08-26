import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/learning_material.dart/learning_material_list.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ILearning_repository.dart';

import 'package:research_mantra_official/main.dart';

import 'package:research_mantra_official/providers/learning/indicator/indicator_state.dart';

class GetIndicatorNotifier extends StateNotifier<IndicatorState> {
  GetIndicatorNotifier(this._learningRepository)
      : super(IndicatorState.initial());

  final ILearningRepository _learningRepository;

  //Method to get All indicator List Data
  Future<void> getIndicatorListData(int id, bool isRefresh) async {
    try {
      if (!isRefresh && state.getAllLearningMaterial.isEmpty) {
        state = IndicatorState.loading();
      } else if (isRefresh == true) {
        state = IndicatorState.loading();
      }
      final getAllLearningMaterial = await _learningRepository
          .getAllLearningMaterial(getLearningContentList, id);

      state = IndicatorState.loaded(getAllLearningMaterial);
    } catch (e) {
      state = IndicatorState.error(e.toString());
    }
  }

  Future<void> likeCount(int id, bool isLiked) async {
    try {
      List<LearningMaterialList> getAllLearningMaterial =
          state.getAllLearningMaterial;

      int index =
          getAllLearningMaterial.indexWhere((element) => element.id == id);

      if (index != -1) {
        int likeCount = getAllLearningMaterial[index].likeCount ?? 0;
        getAllLearningMaterial[index] = getAllLearningMaterial[index].copyWith(
            isLiked: isLiked, likeCount: isLiked ? ++likeCount : --likeCount);
      }

      state = IndicatorState.loaded(
        getAllLearningMaterial,
      );
      await _learningRepository.likeCount(id, isLiked);
    } catch (e) {
      state = IndicatorState.error(e.toString());
    }
  }
}

final getIndicatorProvider =
    StateNotifierProvider<GetIndicatorNotifier, IndicatorState>(((ref) {
  final ILearningRepository indicatorRepository = getIt<ILearningRepository>();
  return GetIndicatorNotifier(indicatorRepository);
}));
