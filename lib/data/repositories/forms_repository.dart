import 'dart:io';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/common_api_response.dart';
import 'package:research_mantra_official/data/models/query/query_category_response_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IForms_repository.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/main.dart';

class FormsRepository implements IFormsRepository {
  final HttpClient _httpClient = getIt<HttpClient>();
  
  @override
  Future<CommonHelperResponseModel> postQueryFormData(dynamic id,
      String queryCategory, String queryDescription, File? image) async {
    try {
      // Prepare the request body with the provided parameters.
      Map<String, String> body = {
        "ProductId": id.toString(),
        "QueryCategory": queryCategory,
        "QueryDescription": queryDescription
      };

      // Send the HTTP POST request with multipart form data.
      final commonResponse = await _httpClient.postWithMultiPart(
          manageQueryFormApi, body, image, "ScreenshotUrl");

      // Parse the response into UserDetailsApiResponseModel object.
      final result = CommonHelperResponseModel.fromJson(commonResponse);

      // Return the result.
      return result;
    } catch (error) {
      // If an error occurs during the process, throw an exception.
      throw Exception(error);
    }
  }

  @override
  Future<List<QueryCategory>> getQueryCategories(id) async {
    try {
      // Send the HTTP POST request with multipart form data.
      final commonResponse =
          await _httpClient.get("$getGetQueryCategoriesApi/$id");

      if (commonResponse.statusCode == 200) {
        final List<dynamic> responseData = commonResponse.data;
        // final List<QueryCategory> queryCategory =
        //     responseData.map((data) => QueryCategory.fromJson(data)).toList();
        final List<QueryCategory> queryCategory =
            (responseData).map((data) => QueryCategory.fromJson(data)).toList();

        // Return the result.
        return queryCategory;
      } else {
        return [];
      }
    } catch (error) {
      // If an error occurs during the process, throw an exception.
      throw Exception(error);
    }
  }
}
