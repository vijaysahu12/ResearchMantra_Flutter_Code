import 'package:flutter/material.dart';

import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/ui/components/common_box_buttons/box_shadow_buttons.dart';

class MyBucketAndTickets extends StatelessWidget {
  final Function handleNavigateToMyBucketScreen;
  final Function handleNavigateToTicketsScreen;

  const MyBucketAndTickets(
      {required this.handleNavigateToMyBucketScreen,
      required this.handleNavigateToTicketsScreen,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CommonBoxShadowButtons(
            buttonText: myBucketListText,
            iconTextName: Icons.shopping_bag_outlined,
            handleNavigateToScreen: handleNavigateToMyBucketScreen),
        const SizedBox(
          width: 8,
        ),
        CommonBoxShadowButtons(
            buttonText: supportScreenText,
            iconTextName: Icons.support_agent,
            handleNavigateToScreen: handleNavigateToTicketsScreen),
      ],
    );
  }
}
