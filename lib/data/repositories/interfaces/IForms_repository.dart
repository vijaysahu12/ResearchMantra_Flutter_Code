import 'dart:io';

import 'package:research_mantra_official/data/models/common_api_response.dart';
import 'package:research_mantra_official/data/models/query/query_category_response_model.dart';

abstract class IFormsRepository {
  Future<CommonHelperResponseModel> postQueryFormData(
    dynamic id,
    String queryCategory,
    String queryDescription,
    File? image,
  );

  Future<List<QueryCategory>> getQueryCategories(
    dynamic id,
  );
}
