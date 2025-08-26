import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/assets.dart';

import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/accept_free_trial/accept_free_trial_provider.dart';
import 'package:research_mantra_official/providers/get_free_trial/get_free_trial_state.dart';
import 'package:research_mantra_official/providers/payment_bypass/payment_bypass_states.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/ui/components/button.dart';

import 'package:research_mantra_official/ui/themes/text_styles.dart';

class IsFreeSubscriptionPopUp {
  // Function to display the daily quote

  static showFreeTrialPopUp(
    context,
    WidgetRef ref,
    String mobileUserPublicKey,
    final void Function() removeBanner,
    GetFreeTrialState getFreeTrialData,
  ) async {
    final theme = Theme.of(context);

    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: theme.appBarTheme.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.height * 0.004,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.cancel_outlined,
                            color: theme.focusColor,
                            // size: 50,
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: theme.shadowColor,
                                borderRadius: BorderRadius.circular(50)),
                            height: 100,
                            child: Image.asset(
                              giftBoxImage,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Text(
                                  getFreeTrialData
                                          .getFreeTrialDataModel?.trialName ??
                                      " ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: fontFamily,
                                    fontSize: 15,
                                    color: theme.primaryColorDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              getFreeTrialData
                                      .getFreeTrialDataModel?.data.length ??
                                  0,
                              (index) => Text(
                                "${index + 1}. ${getFreeTrialData.getFreeTrialDataModel!.data[index] ?? 0}",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: theme.primaryColorDark,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Button(
                                    text: activateMyTrial,
                                    onPressed: () async {
                                      if (await CheckInternetConnection()
                                          .checkInternetConnection()) {
                                        removeBanner();
                                        await ref
                                            .read(acceptFreeTrialNotifier
                                                .notifier)
                                            .acceptFreeTrialData(
                                                mobileUserPublicKey);
                                      }

                                      Navigator.pop(context);
                                    },
                                    backgroundColor: theme.indicatorColor,
                                    textColor: theme.floatingActionButtonTheme
                                        .foregroundColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class IosSubscriptionPopup extends ConsumerStatefulWidget {
  final String message;
  final String applyButtonText;
  final String getCouponButtonText;
  final String isSupportMobileNumber;
  final PaymentByPassState getCheckStatus;
  final TextEditingController textEditingController;
  final VoidCallback apply;
  final VoidCallback getCoupon;

  const IosSubscriptionPopup({
    super.key,
    required this.message,
    required this.applyButtonText,
    required this.getCouponButtonText,
    required this.textEditingController,
    required this.apply,
    required this.isSupportMobileNumber,
    required this.getCoupon,
    required this.getCheckStatus,
  });

  @override
  ConsumerState<IosSubscriptionPopup> createState() =>
      _IosSubscriptionPopupState();
}

class _IosSubscriptionPopupState extends ConsumerState<IosSubscriptionPopup> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    // Listen for changes in the text field and rebuild the widget on changes
    widget.textEditingController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    // Trigger UI rebuild on text change
    setState(() {});
  }

  @override
  void dispose() {
    widget.textEditingController.removeListener(_onTextChanged);
    super.dispose();
    widget.textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTextValid = widget.textEditingController.text.length >= 5;

    return (widget.getCheckStatus.isLoading)
        ? const Center(
            child: SizedBox(
                height: 20, width: 20, child: CircularProgressIndicator()),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          text: widget.message, // First part of the message
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: theme.primaryColorDark,
                            fontFamily: fontFamily,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  ' ${widget.isSupportMobileNumber}', // Second part
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: theme
                                    .primaryColorDark, // You can customize styles here
                                fontFamily: fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: theme.focusColor, width: 0.5),
                        ),
                        child: TextField(
                          controller: widget.textEditingController,
                          decoration: InputDecoration(
                            hintText: couponCodeText,
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: theme.primaryColorDark,
                              fontFamily: fontFamily,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    // if (widget.getCheckStatus.data!.data != true)
                    //   Button(
                    //     text: widget.applyButtonText,
                    //     onPressed: widget.apply,
                    //     backgroundColor: !isTextValid
                    //         ? theme.focusColor
                    //         : theme.indicatorColor,
                    //     textColor:
                    //         theme.floatingActionButtonTheme.foregroundColor,
                    //   ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // if (widget.getCheckStatus.data!.data == true)
                    Button(
                      text: widget.applyButtonText,
                      onPressed: widget.apply,
                      backgroundColor: !isTextValid
                          ? theme.focusColor
                          : theme.indicatorColor,
                      textColor:
                          theme.floatingActionButtonTheme.foregroundColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    // if (widget.getCheckStatus.data!.data == true)
                    Button(
                      text: widget.getCouponButtonText,
                      onPressed: widget.getCoupon,
                      backgroundColor: theme.indicatorColor,
                      textColor:
                          theme.floatingActionButtonTheme.foregroundColor,
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
