import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/partneraccount/partner_account_state.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/ui/components/button.dart';

class AccountButtons extends StatelessWidget {
  final VoidCallback handlePartnerAccountDetails;
  final VoidCallback handlePartnerDetailsCancel;

  final void Function() togglePartnerNamesDropdown;

  final bool isData;
  final PartnerAccountState partnerAccountDetails;
  const AccountButtons({
    super.key,
    required this.handlePartnerAccountDetails,
    required this.handlePartnerDetailsCancel,
    required this.togglePartnerNamesDropdown,
    required this.isData,
    required this.partnerAccountDetails,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        const Spacer(),
        Button(
          isLoading: false,
          text:
              (partnerAccountDetails.partnerAccountResponseModel!.api.isEmpty &&
                      partnerAccountDetails
                          .partnerAccountResponseModel!.partnerId.isEmpty &&
                      partnerAccountDetails
                          .partnerAccountResponseModel!.secretKey.isEmpty)
                  ? submitButtonText
                  : updateButtonText,
          onPressed: () async {
            togglePartnerNamesDropdown();
            bool isConnected =
                await CheckInternetConnection().checkInternetConnection();
            if (isConnected) {
              handlePartnerAccountDetails();
            }
          },
          backgroundColor: theme.indicatorColor,
          textColor: theme.floatingActionButtonTheme.foregroundColor,
        ),
        const SizedBox(
          width: 10,
        ),
        // (partnerAccountDetails.partnerAccountResponseModel!.api.isNotEmpty &&
        //         partnerAccountDetails
        //             .partnerAccountResponseModel!.partnerId.isNotEmpty &&
        //         partnerAccountDetails
        //             .partnerAccountResponseModel!.secretKey.isNotEmpty)
        //     ? Container()
        //     : Button(
        //         isLoading: false,
        //         text: resetButtonText,
        //         onPressed: handlePartnerDetailsCancel,
        //         backgroundColor: theme.indicatorColor,
        //         textColor: theme.floatingActionButtonTheme.foregroundColor,
        //       )
      ],
    );
  }
}
