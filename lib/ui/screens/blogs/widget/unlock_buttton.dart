import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';

import 'package:research_mantra_official/ui/screens/subscription/subsription_screen.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import 'package:shimmer/shimmer.dart';



class UnlockItems extends ConsumerStatefulWidget {
    final String productName;
  final int communityProductId;

  const UnlockItems({super.key, required this.productName, required this.communityProductId ,});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UnlockItemsState();
}
class _UnlockItemsState extends ConsumerState<UnlockItems> {

  //Navigate Subscription Screen
  void navigateToSubscriptionScreen() {
    if (widget.communityProductId != 0) {
   Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Subscription(
            planId: 0, //always zero back end team said
            productName: (widget.productName.trim().isEmpty)
                ? 'Community'
                : widget.productName,

            productId: widget.communityProductId,
            bonusProductDetails: [],
            isFromNotification: false, //No need to show bonus product
          ),
        ),
      );

    } else {
      ToastUtils.showToast(somethingWentWrong, "");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.shadowColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColorDark.withOpacity(0.1),
            blurRadius: 2,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Shimmer effect only on the Lock Icon
          Shimmer.fromColors(
            baseColor: Colors.grey[400]!,
            highlightColor: Colors.white,
            child: Icon(
              Icons.lock,
              size: 50,
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 20),

          // Static description text (no shimmer)
          Text(
            'Discover more with exclusive content and features.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: theme.primaryColorDark,
            ),
          ),
          SizedBox(height: 20),

          InkWell(
            onTap: () {
              navigateToSubscriptionScreen();
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: theme.indicatorColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: theme.shadowColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColorDark.withOpacity(0.1),
                    blurRadius: 2,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Unlock Now',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
