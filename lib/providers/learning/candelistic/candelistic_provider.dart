import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/learning_material.dart/learning_material_list.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ILearning_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/learning/candelistic/candelistic_state.dart';

class GetCandelisticNotifier extends StateNotifier<CandelisticState> {
  GetCandelisticNotifier(this._learningRepository)
      : super(CandelisticState.initial());

  final ILearningRepository _learningRepository;

  Future<void> getCandleList(int id, bool isRefresh) async {
    try {
      if (!isRefresh && state.getAllLearningMaterial.isEmpty) {
        state = CandelisticState.loading();
      } else if (isRefresh == true) {
        state = CandelisticState.loading();
      }

      final getAllLearningMaterial = await _learningRepository
          .getAllLearningMaterial(getLearningContentList, id);
    print("$getAllLearningMaterial --get all learnign material");
      state = CandelisticState.loaded(getAllLearningMaterial);
    } catch (e) {
      state = CandelisticState.error(e.toString());
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
          getAllLearningMaterial[index] = getAllLearningMaterial[index]
              .copyWith(
                  isLiked: isLiked,
                  likeCount: isLiked ? ++likeCount : --likeCount);
        }

        state = CandelisticState.loaded(
          getAllLearningMaterial,
        );
      
      await _learningRepository.likeCount(id, isLiked);
    } catch (e) {
      state = CandelisticState.error(e.toString());
    }
  }
}

final getCandelProvider =
    StateNotifierProvider<GetCandelisticNotifier, CandelisticState>(((ref) {
  final ILearningRepository candelisticRepository =
      getIt<ILearningRepository>();
  return GetCandelisticNotifier(candelisticRepository);
}));
