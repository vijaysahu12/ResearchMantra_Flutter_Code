import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/hive_model/product_hive_model.dart';
import 'package:research_mantra_official/data/models/product_api_response_model.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/products/list/product_list_provider.dart';
import 'package:research_mantra_official/providers/products/single/single_product_provider.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/animation/animation_slideup.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/common_images_checker/common_image_checker.dart';
import 'package:research_mantra_official/ui/components/rating_popup/rating_popup.dart';
import 'package:research_mantra_official/ui/screens/products/screens/details/product_details_screen.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/utils.dart';
import 'package:like_button/like_button.dart';

class ProductListWidget extends ConsumerStatefulWidget {
  final String ratingForProducts;
  final ProductApiResponseModel? product;
  final String typeOfButton;
  final ProductHiveModel? hiveProductList;
  final Future<void> Function() handleToRefresh;
  const ProductListWidget({
    required this.ratingForProducts,
    this.product,
    super.key,
    this.hiveProductList,
    required this.typeOfButton,
    required this.handleToRefresh,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductListWidgetState();
}

class _ProductListWidgetState extends ConsumerState<ProductListWidget> {
  bool _isNavigationInProgress = false;

  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  // Function to handle navigation to ProductDetails Screen
  void handleProductDetailsNavigation(
      BuildContext context, WidgetRef ref, String buttonName) async {
    final connectivityResult = ref.watch(connectivityStreamProvider);

    //Checking result based on that displaying connection screen
    final connectionResult = connectivityResult.value;

    // Check if the navigation is already in progress
    if (_isNavigationInProgress) {
      return;
    }
    _isNavigationInProgress = true; // Set the flag to true
    if (connectionResult != ConnectivityResult.none && widget.product != null) {
      // Navigate to Details Screen

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailsScreenWidget(
            product: widget.product!,
            buttonName: buttonName,
            isFromNotification: false,
          ),
        ),
      );
    }

    _isNavigationInProgress = false; // Reset the flag after navigation
  }

  late dynamic getProductData;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      setState(() {
        getProductData = widget.product;
      });
    } else {
      setState(() {
        getProductData = widget.hiveProductList;
      });
    }
  }

  Future<bool> handleToCheckImage() async {
    bool imageExists = await CommonImagesChecker()
        .doesImageExist(widget.product?.listImage ?? '', getProductImageApi);
    return imageExists;
  }

  // Function to handle like/unlike action for the product
  void handleProductLikeUnlike(WidgetRef ref) async {
    final action = widget.product!.userHasHeart ? isHeartUnLike : isHeartLike;
    ref
        .read(productsStateNotifierProvider.notifier)
        .manageLikeUnlikeProductById(getProductData!.id, action);

    if (action.toLowerCase() == 'like') {
      await Future.delayed(Duration(milliseconds: 200));
      handleToShowRatingPopup(context);
    }
  }

  String getButtonType(String typeOfButton) {
    return typeOfButton.toLowerCase() == "course" ? "Strategy" : "Scanner";
  }

  void handleProductRating(value) async {
    if (!mounted) return;

    final String mobileUserPublicKey = await _commonDetails.getPublicKey();
    ref.read(singleProductStateNotifierProvider.notifier).manageRateProduct(
        mobileUserPublicKey, widget.product?.id ?? 0, value.toInt());
  }

  void handleToShowRatingPopup(context) {
    double currentRating =
        double.tryParse(widget.product?.userRating.toString() ?? '0.0') ?? 0.0;

    if (currentRating == 5.0) {
      return;
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) => ProductFeedbackDialog(
          initialRating:
              double.tryParse(widget.product?.userRating.toString() ?? '0.0') ??
                  0.0,
          onSubmit: (newRating) {
            handleProductRating(newRating);
          },
          title: currentRating > 0.0
              ? "Want to update your rating for ${widget.product?.name}.\n Go ahead — we appreciate your feedback!"
              : "We'd love your feedback on ${widget.product?.name} product.",
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final height = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final connectivityResult = ref.watch(connectivityStreamProvider);

    //Checking result based on that displaying connection screen
    final connectionResult = connectivityResult.value;

    if (connectionResult == ConnectivityResult.none && getProductData == null) {
      return NoInternet(
        handleRefresh: () => widget.handleToRefresh(),
      );
    }
    if (getProductData!.groupName.toString().toLowerCase() ==
        widget.typeOfButton.toLowerCase()) {
      return GestureDetector(
        onTap: () => handleProductDetailsNavigation(
          context,
          ref,
          getButtonType(widget.typeOfButton),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (getProductData.listImage.isEmpty ||
                      handleToCheckImage() == false)
                  ? Container(
                      width: height * 0.28,
                      height: height * 0.28,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          productDefaultmage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : CircularCachedNetworkProduct(
                      width: height * 0.28,
                      height: height * 0.28,
                      imageURL: getProductData.listImage,
                    ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    productNameAndLikeButton(height, theme, connectionResult),
                    descriptionWidget(height, theme),
                    ratingAndReadMoreButton(height, theme),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  //widget for product name and like button
  Widget productNameAndLikeButton(double height, theme, connectionResult) {
    return Row(
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  getProductData?.name ?? "",
                  style: textH2.copyWith(
                    color: theme.primaryColorDark,
                    fontSize: height * 0.03,
                  ),
                ),
              ),
            ],
          ),
        ),
        // const Spacer(),
        Row(
          children: [
            AnimatedSlideUp(
              child: Text(
                widget.product != null && widget.product!.heartsCount != null
                    ? formatLikesCount(widget.product!.heartsCount!)
                    : widget.hiveProductList != null &&
                            widget.hiveProductList!.heartsCount != null
                        ? formatLikesCount(widget.hiveProductList!.heartsCount!)
                        : '0',
                key: ValueKey(
                  widget.product != null && widget.product!.heartsCount != null
                      ? formatLikesCount(widget.product!.heartsCount!)
                      : widget.hiveProductList != null &&
                              widget.hiveProductList!.heartsCount != null
                          ? formatLikesCount(
                              widget.hiveProductList!.heartsCount!)
                          : '0',
                ),
                style: TextStyle(
                  color: theme.focusColor,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(
              width: 2,
            ),
            LikeButton(
              size: 25,
              isLiked: (widget.product != null)
                  ? widget.product!.userHasHeart
                  : (widget.hiveProductList != null)
                      ? widget.hiveProductList!.userHasHeart
                      : false,
              likeBuilder: (bool isLiked) {
                return Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? theme.disabledColor : theme.focusColor,
                  size: 20,
                );
              },
              onTap: (bool isLiked) async {
                // Handle the like/unlike action
                if (connectionResult != ConnectivityResult.none) {
                  handleProductLikeUnlike(ref);
                  return !isLiked;
                } else {
                  return null;
                }
              },
            ),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }

  //Widget for Description
  Widget descriptionWidget(double height, theme) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "${getProductData!.description}",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: textStandard.copyWith(
              fontSize: height * 0.028,
              fontFamily: fontFamily,
              color: theme.focusColor,
            ),
          ),
        ),
        const SizedBox(
          width: 30,
        ),
      ],
    );
  }

  //Widget for rating and readmore button
  Widget ratingAndReadMoreButton(double height, theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            RatingBar.builder(
              initialRating: double.parse(widget.ratingForProducts),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              ignoreGestures: true,
              unratedColor: theme.focusColor,
              allowHalfRating: true,
              itemSize: height * 0.04,
              onRatingUpdate: (double value) {},
            ),
          ],
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          widget.ratingForProducts,
          style: textH4.copyWith(
            color: theme.focusColor,
            fontSize: height * 0.025,
          ),
        ),
        const Spacer(),
        TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          onPressed: () => handleProductDetailsNavigation(
            context,
            ref,
            getButtonType(widget.typeOfButton),
          ),
          child: Text(
            readMoreButtonText,
            style: textH4.copyWith(
              color: theme.indicatorColor,
              fontSize: height * 0.025,
            ),
          ),
        ),
      ],
    );
  }
}
