import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/my_bucket_list_api_response_model.dart';
import 'package:research_mantra_official/data/models/product_api_response_model.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class MyBucketListWidget extends ConsumerWidget {
  final MyBucketListApiResponseModel myBucketItemDetails;
  final String formattedStartDate;
  final String formattedEndDate;
  final bool isShowReminder;

  final void Function(dynamic isToggleNotification, dynamic productId)
      hanldeToToggleNotifications;

  const MyBucketListWidget({
    super.key,
    required this.formattedStartDate,
    required this.formattedEndDate,
    required this.isShowReminder,
    required this.myBucketItemDetails,
    required this.hanldeToToggleNotifications,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.width;
    final imageUrlEndpoint =
        myBucketItemDetails.listImage; // Remove unnecessary quotes
    final imagePath =
        imageUrlEndpoint.replaceAll(" ", ""); // Remove unnecessary spaces

    void navigateToProductDetailsScreen() async {
      final connectivityResult = ref.watch(connectivityStreamProvider);
      final connectionResult = connectivityResult.value;

      final isConnected = connectionResult != ConnectivityResult.none;
      if (!isConnected) return;

      final item = myBucketItemDetails;

      if (item.buyButtonText.toLowerCase() == 'disabled') {
        ToastUtils.showToast(
          "This product is currently unavailable. Stay tuned for updates!",
          "",
        );
        return;
      }

      final product = ProductApiResponseModel(
        groupName: '',
        description: '',
        id: item.id,
        listImage: item.listImage,
        name: item.name,
        price: item.price,
        overAllRating: 0.0,
        heartsCount: null,
        userRating: 0.0,
        userHasHeart: item.isHeart,
        isInMyBucket: true,
        isInValidity: DateTime.now().isBefore(item.enddate),
        buyButtonText: item.buyButtonText,
      );

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ProductDetailsScreenWidget(
      //       product: product,
      //       buttonName: item.categoryName,
      //       isFromNotification: false,
      //     ),
      //   ),
      // );
    }

    return GestureDetector(
      onTap: () => navigateToProductDetailsScreen(),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: theme.primaryColor,
          boxShadow: [
            BoxShadow(
              color: theme.focusColor.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: SizedBox(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CircularCachedNetworkProduct(
                    width: fontSize * 0.315,
                    height: fontSize * 0.315,
                    imageURL: imagePath,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          myBucketItemDetails.name,
                          style: TextStyle(
                            color: theme.primaryColorDark,
                            fontFamily: fontFamily,
                            fontWeight: FontWeight.w600,
                            fontSize: fontSize * 0.03,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => hanldeToToggleNotifications(
                            !myBucketItemDetails.notificationEnabled,
                            myBucketItemDetails.id),
                        child: Icon(
                          myBucketItemDetails.notificationEnabled
                              ? Icons.notifications_active_rounded
                              : Icons.notifications_off_sharp,
                          color: theme.primaryColorDark,
                          size: fontSize * 0.045,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        myBucketItemDetails.categoryName,
                        style: TextStyle(
                          fontFamily: fontFamily,
                          color: theme.primaryColorDark,
                          fontSize: fontSize * 0.025,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedStartDate,
                        style: TextStyle(
                          fontFamily: fontFamily,
                          color: theme.primaryColorDark,
                          fontSize: fontSize * 0.025,
                        ),
                      ),
                      Text(
                        formattedEndDate,
                        style: TextStyle(
                            fontFamily: fontFamily,
                            color: theme.primaryColorDark,
                            fontSize: fontSize * 0.025),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  (myBucketItemDetails.daysToGo <= 0)
                      ? Row(
                          children: [
                            Flexible(
                                child: Text(
                              renewMessge,
                              style: TextStyle(
                                fontFamily: fontFamily,
                                color: theme.primaryColorDark,
                                fontSize: fontSize * 0.025,
                              ),
                            ))
                          ],
                        )
                      : Container(),
                  const SizedBox(height: 5),
                  if (myBucketItemDetails.buyButtonText
                          .toLowerCase()
                          .toString() !=
                      'disabled')
                    Row(
                      children: [
                        _buildForExpires(
                            myBucketItemDetails.daysToGo, theme, fontSize),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: isShowReminder
                                ? theme.disabledColor
                                : theme.indicatorColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(0),
                              onTap: () => navigateToProductDetailsScreen(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                child: Text(
                                  isShowReminder ? renew : "Open",
                                  style: TextStyle(
                                      color: theme.floatingActionButtonTheme
                                          .foregroundColor,
                                      fontSize: fontSize * 0.025,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Widget for expires
  Widget _buildForExpires(int daysToGo, ThemeData theme, fontSize) {
    // Define the common text style
    final TextStyle textStyle = TextStyle(
      fontFamily: fontFamily,
      color: theme.primaryColorDark,
      fontWeight: FontWeight.w500,
      fontSize: fontSize * 0.025,
    );

    // Determine the expiration status
    String text;

    if (daysToGo == 0) {
      text = myBucketTextExipringText;
    } else if (daysToGo < 0) {
      text = myBucketTextExipredText;
    } else {
      text = "Days left.";
    }

    // Return the text widget with the common style
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: daysToGo > 0 ? "$daysToGo " : "",
            style: textStyle.copyWith(fontWeight: FontWeight.bold)),
        TextSpan(text: text, style: textStyle),
      ]),
    );
  }
}
