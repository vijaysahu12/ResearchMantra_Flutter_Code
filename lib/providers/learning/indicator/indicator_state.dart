import 'package:research_mantra_official/data/models/learning_material.dart/learning_material_list.dart';

class IndicatorState {
  final dynamic error;
  final bool isLoading;

  final List<LearningMaterialList> getAllLearningMaterial;

  IndicatorState({
    required this.isLoading,
    this.error,
    required this.getAllLearningMaterial,
  });

  factory IndicatorState.initial() => IndicatorState(
        isLoading: false,
        getAllLearningMaterial: [],
      );
  factory IndicatorState.loading() => IndicatorState(
        isLoading: true,
        getAllLearningMaterial: [],
      );

  factory IndicatorState.loaded(
          List<LearningMaterialList> getAllLearningMaterial) =>
      IndicatorState(
        isLoading: false,
        getAllLearningMaterial: getAllLearningMaterial,
      );
  factory IndicatorState.error(dynamic error) => IndicatorState(
        isLoading: false,
        error: error,
        getAllLearningMaterial: [],
      );
}
