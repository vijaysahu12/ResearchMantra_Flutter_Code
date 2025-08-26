

import 'package:research_mantra_official/data/models/common_api_response.dart';
import 'package:research_mantra_official/data/models/partneraccount/partner_account_response_model.dart';
import 'package:research_mantra_official/data/models/partneraccount/partner_names_response_model.dart';

abstract class IPartnerAccountRepository {
  Future<CommonHelperResponseModel> managePartnerDetails(
      String partnerName,
      String partnerId,
      String partnerApiKey,
      String partnerSecretKey,
      String mobileUserPublicKey);

  Future<List<PartnerNamesModel>> getPartnerNames();
  Future<PartnerAccountModel?> getPartnerAccountDetails(
      String mobileUserPublicKey);
}
