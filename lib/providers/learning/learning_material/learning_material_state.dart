import 'package:research_mantra_official/data/models/learning_material.dart/learning_material_list.dart';

class LearningMaterialState {
  final dynamic error;
  final bool isLoading;

  List<LearningMaterialList>? getAllLearningMaterial;
  LearningMaterialState({
    required this.isLoading,
    this.error,
    this.getAllLearningMaterial,
  });

  factory LearningMaterialState.initial() =>
      LearningMaterialState(isLoading: false, getAllLearningMaterial: null);
  factory LearningMaterialState.loading() => LearningMaterialState(
        isLoading: true,
      );

  factory LearningMaterialState.loaded(
          List<LearningMaterialList>? getAllLearningMaterial) =>
      LearningMaterialState(
        isLoading: false,
        getAllLearningMaterial: getAllLearningMaterial,
      );
  factory LearningMaterialState.error(dynamic error) => LearningMaterialState(
        isLoading: false,
        error: error,
        getAllLearningMaterial: null,
      );
}
