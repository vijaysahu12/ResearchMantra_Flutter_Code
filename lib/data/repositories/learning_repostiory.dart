import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/learning_material.dart/indicator_description_data_model.dart';
import 'package:research_mantra_official/data/models/learning_material.dart/learning_material_description.dart';
import 'package:research_mantra_official/data/models/learning_material.dart/learning_material_list.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ILearning_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';

class LearningRepository implements ILearningRepository {
  final HttpClient _httpClient = getIt<HttpClient>();
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  @override
  Future<List<LearningMaterialList>> getAllLearningMaterial(
      String endPoint, int id) async {
    try {
      final String mobileUserPublicKey = await _commonDetails.getPublicKey();
      final response = await _httpClient
          .post(endPoint, {"id": id, "userKey": mobileUserPublicKey});

      if (response.statusCode == 200) {
        final List<dynamic> learningMaterialData = response.data;
        final List<LearningMaterialList> allLearningMaterial =
            learningMaterialData
                .map((data) => LearningMaterialList.fromJson(data))
                .toList();

        return allLearningMaterial;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<LearningMaterialDescription> individualLearningMaterialDescription(
      int id, String endPoints) async {
    try {
      final response = await _httpClient.get("$endPoints/$id");

      if (response.statusCode == 200) {
        final learningMaterialDescription =
            LearningMaterialDescription.fromJson(response.data);

        return learningMaterialDescription;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<LearningMaterialList>> getAllGraphMaterial(
      String endPoint, int id) async {
    try {
      final response = await _httpClient.get("$endPoint/$id");

      if (response.statusCode == 200) {
        final List<dynamic> learnigGrpahlData = response.data;
        final List<LearningMaterialList> allLearningGraph = learnigGrpahlData
            .map((data) => LearningMaterialList.fromJson(data))
            .toList();

        return allLearningGraph;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<LearningMaterialList>> getAllLearningMateriaList() async {
    try {
      final response = await _httpClient.get(getLearningMaterial);

      if (response.statusCode == 200) {
        final List<dynamic> learningMaterialData = response.data;
        final List<LearningMaterialList> allLearningMaterial =
            learningMaterialData
                .map((data) => LearningMaterialList.fromJson(data))
                .toList();

        return allLearningMaterial;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<IndicatorBindingDataModel> indicatorDesciption(
      int id, String endPoints) async {
    try {
      final response = await _httpClient.get("$endPoints/$id");

      if (response.statusCode == 200) {
        final indicatorBindingDataModel =
            IndicatorBindingDataModel.fromJson(response.data);

        return indicatorBindingDataModel;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> likeCount(int id, bool isLiked) async {
    try {
      final String mobileUserPublicKey = await _commonDetails.getPublicKey();
      final response = await _httpClient.post(likeUnlikeLearningApi,
          {"id": id, "isLiked": isLiked, "userKey": mobileUserPublicKey});

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
