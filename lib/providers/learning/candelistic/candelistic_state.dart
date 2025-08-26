import 'package:research_mantra_official/data/models/learning_material.dart/learning_material_list.dart';

class CandelisticState {
  final dynamic error;
  final bool isLoading;

  final List<LearningMaterialList> getAllLearningMaterial;
  CandelisticState({
    required this.isLoading,
    this.error,
    required this.getAllLearningMaterial,
  });

  factory CandelisticState.initial() =>
      CandelisticState(isLoading: false, getAllLearningMaterial: []);
  factory CandelisticState.loading() => CandelisticState(
        isLoading: true,
        getAllLearningMaterial: [],
      );

  factory CandelisticState.loaded(
          List<LearningMaterialList> getAllLearningMaterial) =>
      CandelisticState(
        isLoading: false,
        getAllLearningMaterial: getAllLearningMaterial,
      );
  factory CandelisticState.error(dynamic error) => CandelisticState(
        isLoading: false,
        error: error,
        getAllLearningMaterial: [],
      );
}
