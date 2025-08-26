import 'package:research_mantra_official/data/models/learning_material.dart/learning_material_description.dart';


class LearningDescriptionState {
  final dynamic error;
  final bool isLoading;

 final  LearningMaterialDescription? learningMaterialDescription;

  LearningDescriptionState({
    required this.isLoading,
    this.error,
    this.learningMaterialDescription,
  });

  factory LearningDescriptionState.initial() => LearningDescriptionState(
        isLoading: false,
        learningMaterialDescription: null,
      );
  factory LearningDescriptionState.loading() => LearningDescriptionState(
        isLoading: true,
      );

  factory LearningDescriptionState.loaded(
          LearningMaterialDescription? learningMaterialDescription) =>
      LearningDescriptionState(
        isLoading: false,
        learningMaterialDescription: learningMaterialDescription,
      );
  factory LearningDescriptionState.error(dynamic error) =>
      LearningDescriptionState(
        isLoading: false,
        error: error,
        learningMaterialDescription: null,
      );
}
