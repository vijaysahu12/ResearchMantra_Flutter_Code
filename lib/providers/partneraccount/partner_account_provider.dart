import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/partneraccount/partner_account_response_model.dart';
import 'package:research_mantra_official/data/models/partneraccount/partner_names_response_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IPartneraccount_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/partneraccount/partner_account_state.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class PartnerAccountStateNotifier extends StateNotifier<PartnerAccountState> {
  PartnerAccountStateNotifier(this._iPartnerAccountRepository)
      : super(PartnerAccountState.initial());
  final IPartnerAccountRepository _iPartnerAccountRepository;

//Method to manage partner account details
  Future<void> managePartnerAccountDetailsProvider(
      String partnerName,
      String partnerId,
      String partnerApiKey,
      String partnerSecretKey,
      String mobileUserPublicKey) async {
    try {
      final response = await _iPartnerAccountRepository.managePartnerDetails(
          partnerName,
          partnerId,
          partnerApiKey,
          partnerSecretKey,
          mobileUserPublicKey);

      if (response.status) {
        ToastUtils.showToast(successMessage, "");
      } else {
        ToastUtils.showToast(response.message, '');
      }
    } catch (error) {
      state = PartnerAccountState.error(error);
      ToastUtils.showToast(pleaseTryAfterSomeTime, errorText);
    }
  }

  //Method to get Partner AccountDetails
  Future<void> getPartnerAccountDetails(
      String mobileUserPublicKey, bool isRefresh) async {
    try {
      // if (!isRefresh && state.partnerAccountResponseModel == null) {
      //   state = PartnerAccountState.loading();
      // } else if (isRefresh) {
      state = PartnerAccountState.loading();
      // }

      final List<PartnerNamesModel> listofAccountNames =
          await _iPartnerAccountRepository.getPartnerNames();
      final PartnerAccountModel? accountDetails =
          await _iPartnerAccountRepository
              .getPartnerAccountDetails(mobileUserPublicKey);
      if (accountDetails != null) {
        state = PartnerAccountState.getAccountState(
          listofAccountNames,
          accountDetails,
        );
      } else {
        // If listofAccountDetails is null, pass some default values or handle the situation accordingly
        state = PartnerAccountState.getAccountState(
            listofAccountNames,
            const PartnerAccountModel(
                id: 0,
                partnerId: '',
                api: '',
                partnerName: 'AliceBlue',
                secretKey: ''));
      }
    } catch (error) {
      // Handle other errors
      state = PartnerAccountState.error(error);
    }
  }
}

final partnerAccountProvider =
    StateNotifierProvider<PartnerAccountStateNotifier, PartnerAccountState>(
        (ref) {
  final IPartnerAccountRepository partnerAccountRepository =
      getIt<IPartnerAccountRepository>();
  return PartnerAccountStateNotifier(partnerAccountRepository);
});
