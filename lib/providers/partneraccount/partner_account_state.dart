import 'package:research_mantra_official/data/models/partneraccount/partner_account_response_model.dart';
import 'package:research_mantra_official/data/models/partneraccount/partner_names_response_model.dart';

class PartnerAccountState {
  final bool isLoading;
  final List<PartnerNamesModel> partnerNames;
  final PartnerAccountModel? partnerAccountResponseModel;

  final dynamic error;

  PartnerAccountState(
      {required this.error,
      required this.partnerNames, // Update the constructor to accept partner names
      required this.isLoading,
      required this.partnerAccountResponseModel});

  factory PartnerAccountState.initial() => PartnerAccountState(
      error: [],
      partnerNames: [], // Initialize partner names to an empty list
      isLoading: false,
      partnerAccountResponseModel: null);

  factory PartnerAccountState.loading() => PartnerAccountState(
      error: [],
      partnerNames: [],
      isLoading: true,
      partnerAccountResponseModel: null);

  factory PartnerAccountState.getNameState(
    List<PartnerNamesModel> partnerNames,
  ) =>
      PartnerAccountState(
          error: [],
          partnerNames: partnerNames,
          isLoading: false,
          partnerAccountResponseModel: null);

  factory PartnerAccountState.getAccountState(
          List<PartnerNamesModel> partnerNames,
          PartnerAccountModel partnerAccountResponseModel) =>
      PartnerAccountState(
          error: [],
          partnerNames: partnerNames,
          isLoading: false,
          partnerAccountResponseModel: partnerAccountResponseModel);

  factory PartnerAccountState.error(dynamic error) => PartnerAccountState(
        error: error,
        partnerNames: [],
        isLoading: false,
        partnerAccountResponseModel: null,
      );
}
