import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/common_api_response.dart';


import 'package:research_mantra_official/data/models/partneraccount/partner_account_response_model.dart';
import 'package:research_mantra_official/data/models/partneraccount/partner_names_response_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IPartneraccount_repository.dart';
import 'package:research_mantra_official/main.dart';

class PartnerAccountRepository implements IPartnerAccountRepository {
  final HttpClient _httpClient =  getIt<HttpClient>();

// Manage Partner Details Http call
  @override
  Future<CommonHelperResponseModel> managePartnerDetails(
      String partnerName,
      String partnerId,
      String partnerApiKey,
      String partnerSecretKey,
      String mobileUserPublicKey) async {
    try {
      final Map<String, dynamic> body = {
        "partnerName": partnerName,
        "partnerId": partnerId,
        "api": partnerApiKey,
        "secretKey": partnerSecretKey,
        "createdBy": mobileUserPublicKey
      };
      final response = await _httpClient.post(partnerAccountApi, body);

      final result = CommonHelperResponseModel.fromJson(response);
      return result;
    } catch (error) {
      throw Exception(error);
    }
  }

//Get PartnerAccountDetails Http call
  @override
  Future<PartnerAccountModel?> getPartnerAccountDetails(
      String mobileUserPublicKey) async {
    try {
      final response = await _httpClient.get(
          '$getPartnerAccountDetailsApi?mobileUserKey=$mobileUserPublicKey');
      final dynamic partnerAccountDetails = response.data;
      if (response.data != null) {
        final PartnerAccountModel partnerAccountResponseModel =
            PartnerAccountModel.fromJson(partnerAccountDetails);
        return partnerAccountResponseModel;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

//Get Partnames Http call
  @override
  Future<List<PartnerNamesModel>> getPartnerNames() async {
    try {
      final response = await _httpClient.get(getPartnerNamesApi);
      if (response.statusCode == 200) {
        // Parse the response data into PartnerNameResponseModel
        final List<dynamic> partnerNames = response.data;

        final List<PartnerNamesModel> listOfPartners = partnerNames
            .map((data) => PartnerNamesModel.fromJson(data))
            .toList();

        return listOfPartners;
      } else {
  
        throw Exception(
            'Failed to fetch partner names: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching partner names: $e');
    }
  }
}
