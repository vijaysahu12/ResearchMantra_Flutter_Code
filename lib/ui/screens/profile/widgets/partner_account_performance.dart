import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/ui/components/common_box_buttons/box_shadow_buttons.dart';

//Widget for PartnerAccountWidget
class PartnerAccountAndPerformance extends StatelessWidget {
  final void Function() handleNavigateToPartnerAccount;
  final void Function() handleNavigateToPerformancescreenScreen;

  const PartnerAccountAndPerformance(
      {super.key,
      required this.handleNavigateToPartnerAccount,
      required this.handleNavigateToPerformancescreenScreen});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CommonBoxShadowButtons(
            buttonText: partnerAccountText,
            iconTextName: Icons.account_balance_outlined,
            handleNavigateToScreen: handleNavigateToPartnerAccount),
        const SizedBox(
          width: 8,
        ),
        CommonBoxShadowButtons(
            buttonText: performanceText,
            iconTextName: Icons.speed,
            handleNavigateToScreen: handleNavigateToPerformancescreenScreen),
      ],
    );
  }
}
