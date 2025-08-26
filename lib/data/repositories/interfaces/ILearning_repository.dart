import 'package:research_mantra_official/data/models/learning_material.dart/indicator_description_data_model.dart';
import 'package:research_mantra_official/data/models/learning_material.dart/learning_material_description.dart';
import 'package:research_mantra_official/data/models/learning_material.dart/learning_material_list.dart';

abstract class ILearningRepository {
  Future<List<LearningMaterialList>> getAllLearningMaterial(
      String endPoint, int id);
  Future<LearningMaterialDescription> individualLearningMaterialDescription(
      int id, String endPoints);
  Future<List<LearningMaterialList>> getAllGraphMaterial(
      String endPoint, int id);
  Future<List<LearningMaterialList>> getAllLearningMateriaList();
  Future<IndicatorBindingDataModel> indicatorDesciption(
      int id, String endPoints);
  Future<bool> likeCount(int id, bool isLiked);
}
