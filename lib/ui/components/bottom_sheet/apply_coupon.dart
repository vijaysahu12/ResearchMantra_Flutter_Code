import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/product_api_response_model.dart';
import 'package:research_mantra_official/providers/subscription/coupon_code/coupon_code_state.dart';

import 'package:research_mantra_official/ui/themes/text_styles.dart';

class CouponCodeBottomSheet {
  showCustomBottomSheet({
    required BuildContext context,
    required String title,
    required String message,
    required TextEditingController textEditingController,
    required String commonCouponCode,
    required CouponCodeState getCouponsStates,
    required void Function(
            double value, bool isApplied, String appliedCouponCode)
        updateValue,
    required void Function(double value, bool isApplied, String couponCode,
            int subscriptionDurationId)
        ownCouponCode,
    required subscriptionDurationId,
    required void Function() isCouponCancel,
  }) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12))),
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 18,
                      color: theme.primaryColorDark,
                      fontFamily: "poppins",
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16.0),
              //TextEditor
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: theme.focusColor, width: 0.5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(
                              r'[A-Z0-9]')), // Allows only uppercase letters and numbers
                        ],
                        decoration: InputDecoration(
                          hintText: "Enter coupon code",
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: theme.primaryColorDark,
                            fontFamily: fontFamily,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        if (textEditingController.text.isNotEmpty &&
                            textEditingController.text.length >= 3) {
                          ownCouponCode(10, true, textEditingController.text,
                              subscriptionDurationId); // U
                        }
                        textEditingController.clear();
                      },
                      child: Text(
                        applyButtonText,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.indicatorColor,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.primaryColorDark,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              const SizedBox(height: 2.0),
              Expanded(
                  child: _buildOfferList(theme, getCouponsStates, updateValue))
            ],
          ),
        );
      },
    ).then((value) {
      textEditingController.clear();
      isCouponCancel(); // 👈 Call the cancel function
    });
  }

  //Widget Offers list
  Widget _buildOfferList(theme, getCouponsStates, updateValue) {
    if (getCouponsStates.codeResponseModel.length == 0) {
      return Center(
        child: Column(
          children: [
            Image.asset(
              couponEmptyImage,
              scale: 4,
            ),
            Text(
              "Stay with us for exclusive upcoming offers!",
              style: textH5.copyWith(fontSize: 10),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
        itemCount: getCouponsStates.codeResponseModel.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: theme.appBarTheme.backgroundColor,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: theme.shadowColor, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.4),
                  spreadRadius: 0,
                  blurRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Limited Time Only Text and coupon code
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "🏷️  ${getCouponsStates.codeResponseModel[index].description}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColorDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Unlock Deal: ${getCouponsStates.codeResponseModel[index].couponName}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.primaryColorDark,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // couponCodeDiscount = 160.0;

                                  updateValue(
                                      getCouponsStates.codeResponseModel[index]
                                          .discountAmount,
                                      true,
                                      getCouponsStates.codeResponseModel[index]
                                          .couponName); // U
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Apply",
                                  style: TextStyle(
                                      color: theme.indicatorColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class BonusBottomBar extends StatelessWidget {
  final List<BonusProduct> bonusProduct; // Accept the full BonusProduct list

  const BonusBottomBar({
    super.key,
    required this.bonusProduct, // Accept bonusProduct as argument
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.primaryColor,
          border: Border(top: BorderSide(color: theme.focusColor, width: 2)),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Stack(
                clipBehavior:
                    Clip.none, // This ensures overflow content is visible
                children: [
                  // Positioned image to be outside and inside the top of the bottom sheet
                  Positioned(
                    top:
                        -60, // Adjust this value to move the image outside the bottom sheet more
                    left: (MediaQuery.of(context).size.width - 20) /
                        3, // Center the image
                    child: Image.asset(
                      bonusProductImagePath,
                      scale: 4,
                    ),
                  ),
                  // The rest of the content inside the bottom sheet
                  ///ToDo: We have to fix scrolling issue if we have more than two products
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                            height: 70), // Adjust to give space for the image

                        Text(
                          bonusProduct.first.bonusMessgae ?? '',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColorDark,
                            fontFamily: "poppins",
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow
                              .ellipsis, // Adds ellipsis if the text overflows
                          maxLines: 3, // Limits the number of lines displayed
                        ),
                        const SizedBox(height: 10),
                        // Use ListView or Column to display the list of products
                        Column(
                          children: bonusProduct.map((product) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: theme.primaryColor.withOpacity(0.8),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.focusColor.withOpacity(0.4),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: Alignment
                                        .centerLeft, // Align text inside ribbon
                                    children: [
                                      // 🎀 Ribbon Image (Background)
                                      Image.asset(
                                        "assets/images/const/images/ribbon.png",
                                        scale: 20,
                                      ),
                                      // 📌 Overlay Text Container (Inside the Image)
                                      Positioned(
                                        left:
                                            15, // Adjust positioning inside ribbon
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          child: Text(
                                            product.productCategory ?? '',
                                            style: TextStyle(
                                              color: theme
                                                  .floatingActionButtonTheme
                                                  .foregroundColor, // Ensure readability on ribbon
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                      width:
                                          8), // Space between the icon and the text
                                  Expanded(
                                    child: Text(
                                      "${product.bonusProductName ?? ""}  ${product.validity ?? ""} ${product.validity == null ? "" : "Days"}",
                                      style: TextStyle(
                                        color: theme.primaryColorDark,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
