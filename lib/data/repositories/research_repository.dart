
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/research/get_basket_data_model.dart';
import 'package:research_mantra_official/data/models/research/get_companies_data_model.dart';
import 'package:research_mantra_official/data/models/research/get_reserach_comments.dart';
import 'package:research_mantra_official/data/models/research/research_detail_data_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IResearch_repository.dart';
import 'package:research_mantra_official/main.dart';

import 'package:research_mantra_official/services/secure_storage.dart';

class ResearchRepository implements IResearchRepository {
  final HttpClient _httpClient = getIt<HttpClient>();
  final SharedPref _sharedPref = SharedPref();

  @override
  Future<ResearchDataModel> getReport(Map<String, dynamic> body) async {
    try {

      final response = await _httpClient.post(getReportapi, body);

      if (response.statusCode == 200) {
        final researchDataModel = ResearchDataModel.fromJson(response.data);

        return researchDataModel;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<BasketDataModel>> getBasket() async {
    try {
      final response = await _httpClient.get(getBaskeapi);

      if (response.statusCode == 200) {
        final List<dynamic> allBasketData = response.data;
        final List<BasketDataModel> allBasketModel = allBasketData
            .map((data) => BasketDataModel.fromJson(data))
            .toList();

        _sharedPref.save(getBasketData, allBasketModel);

        return allBasketModel;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<CompaniesDataModel> getCompanies(Map<String, dynamic> body) async {
    try {

      final response = await _httpClient.post(getComapaniesapi, body);

      if (response.statusCode == 200) {
        final allCompaniesData = response.data;
        final CompaniesDataModel allCompaniesModel =
            CompaniesDataModel.fromJson(allCompaniesData);

        return allCompaniesModel;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<ResearchMessage>> getReserachMessages(num id) async {
    try {
      final response =
          await _httpClient.get("$getCommentResearch?companyId=$id");

      if (response.statusCode == 200) {
        final List<dynamic> allCompaniesData = response.data;
        final List<ResearchMessage> reserchMessage = allCompaniesData
            .map((data) => ResearchMessage.fromJson(data))
            .toList();

        return reserchMessage;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> postReserachMessages(
      Map<String, dynamic> body) async {
    try {
      final response = await _httpClient.post(postCommentReserach, body);

      if (response.statusCode == 200) {
        Map<String, dynamic> messageInfo = {
          "messageId": response.data,
          "message": response.message,
        };

        return messageInfo;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
