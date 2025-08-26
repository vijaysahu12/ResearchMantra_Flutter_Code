import 'package:research_mantra_official/data/models/learning_material.dart/learning_material_list.dart';

class GrapthState {
  final dynamic error;
  final bool isLoading;

  List<LearningMaterialList>? getAllGraphListData;
  GrapthState({
    required this.isLoading,
    this.error,
    this.getAllGraphListData,
  });

  factory GrapthState.initial() =>
      GrapthState(isLoading: false, getAllGraphListData: null);
  factory GrapthState.loading() => GrapthState(
        isLoading: true,
      );

  factory GrapthState.loaded(
          List<LearningMaterialList>? getAllGraphListData) =>
      GrapthState(
        isLoading: false,
        getAllGraphListData: getAllGraphListData,
      );
  factory GrapthState.error(dynamic error) => GrapthState(
        isLoading: false,
        error: error,
        getAllGraphListData: null,
      );
}
