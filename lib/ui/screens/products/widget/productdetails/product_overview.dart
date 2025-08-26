import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';
import 'package:research_mantra_official/ui/components/common_images_checker/common_image_checker.dart';
import 'package:research_mantra_official/ui/components/custom_youtube_player/custom_youtube_player.dart';
import 'package:research_mantra_official/ui/components/expanded/expanded_widget.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:like_button/like_button.dart';
import '../../../../../data/models/single_product_api_response_model.dart';
import '../../../../../providers/products/single/single_product_provider.dart';

class ProductDetailsOverviewWidget extends ConsumerStatefulWidget {
  final SingleProductApiResponseModel getSingleProduct;
  final Function handleNavigateToContentButton;
  final String userName;

  final double productPrice;
  final double afterDiscountPrice;

  final bool? isFromResearch;
  final String? isBuyButtonEnable;

  const ProductDetailsOverviewWidget(
      {super.key,
      required this.getSingleProduct,
      required this.handleNavigateToContentButton,
      required this.userName,
      required this.productPrice,
      required this.afterDiscountPrice,
      this.isFromResearch,
      this.isBuyButtonEnable});
  @override
  ConsumerState<ProductDetailsOverviewWidget> createState() =>
      _ProductDetailsOverviewWidgetState();
}

class _ProductDetailsOverviewWidgetState
    extends ConsumerState<ProductDetailsOverviewWidget> {
  final UserSecureStorageService _commonDetails = UserSecureStorageService();

  @override
  void initState() {
    super.initState();
    // Lock to portrait only for this screen
  }

  @override
  void dispose() {
    // 🔓 Re-enable all orientations when leaving this screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  /// Function to check if the image exists
  Future<bool> handleToCheckImage() async {
    bool imageExists = await CommonImagesChecker().doesImageExist(
        widget.getSingleProduct.landscapeImage, getGetLandscapeImage);
    return imageExists;
  }

//// Function to handle product like/unlike
  /// This function is called when the user likes or unlikes a product.
  void handleProductLikeUnlike(ref) async {
    if (!mounted) return;

    final String mobileUserPublicKey = await _commonDetails.getPublicKey();
    final action = widget.getSingleProduct.isHeart ? unlike : like;

    ref
        .read(singleProductStateNotifierProvider.notifier)
        .manageLikeUnlikeProductById(
            mobileUserPublicKey, widget.getSingleProduct.id, action);
  }

//// Function to handle product rating
  /// This function is called when the user rates a product.
  void handleProductRating(value) async {
    if (!mounted) return;

    final String mobileUserPublicKey = await _commonDetails.getPublicKey();
    ref.read(singleProductStateNotifierProvider.notifier).manageRateProduct(
        mobileUserPublicKey, widget.getSingleProduct.id, value.toInt());
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    // String applyButtonTextButton = applyButtonText;
    // final couponState = ref.watch(couponCodeStateNotifierProvider);
    final imageUrlEndpoint = widget.getSingleProduct.landscapeImage;
    final imageUrl = imageUrlEndpoint.replaceAll(" ", "");
    final fontSize = MediaQuery.of(context).size.height;

    bool showSecondButton = widget.getSingleProduct.contentCount != 0 ||
        widget.getSingleProduct.videoCount != 0;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: AnimationConfiguration.synchronized(
          duration: const Duration(milliseconds: 500),
          child: SlideAnimation(
            child: Column(
              children: [
                _buildProductNameAndLikeButton(theme, fontSize),
                _buildCategoryAndRating(theme, fontSize),
                const SizedBox(
                  height: 15,
                ),
                //image
                _buildProductImage(context, imageUrl),
                const SizedBox(
                  height: 5,
                ),
                if (widget.getSingleProduct.bonusProducts.isNotEmpty)
                  _buildBonusProduct(theme),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.getSingleProduct.descriptionTitle,
                            style: TextStyle(
                                fontSize: fontSize * 0.016,
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColorDark),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ExpandableText(
                      text: widget.getSingleProduct.description,
                      trimLength: 800,
                      textStyle: TextStyle(
                        fontSize: fontSize * 0.013,
                        fontFamily: fontFamily,
                        color: theme.primaryColorDark,
                      ),
                      linkStyle: TextStyle(
                        fontSize: fontSize * 0.013,
                        fontWeight: FontWeight.w600,
                        fontFamily: fontFamily,
                        color: theme.indicatorColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                //Validity part
                _buildValidityButton(theme, fontSize),
                const SizedBox(
                  height: 20,
                ),
                //Learning Materials Part
                if (widget.getSingleProduct.contentCount >= 1 &&
                    widget.getSingleProduct.videoCount >= 1)
                  _buildNavigateToContentButton(
                      theme, fontSize, showSecondButton),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Widget for Product Name and Like Button
  Widget _buildProductNameAndLikeButton(theme, fontSize) {
    return Row(
      children: [
        Column(
          children: [
            Text(
              widget.getSingleProduct.name,
              style: TextStyle(
                fontSize: fontSize * 0.02,
                color: theme.primaryColorDark,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Spacer(),
        if (widget.isFromResearch != true) ...[
          LikeButton(
            size: 25,
            isLiked: widget.getSingleProduct.isHeart,
            likeBuilder: (bool isLiked) {
              return Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? theme.disabledColor : theme.focusColor,
                size: 20,
              );
            },
            onTap: (bool isLiked) async {
              // Handle the like/unlike action
              handleProductLikeUnlike(ref);
              return !isLiked;
            },
          ),
        ],
      ],
    );
  }

  //Wdigetfor category and rating
  Widget _buildCategoryAndRating(theme, fontSize) {
    return Row(
      children: [
        Column(
          children: [
            Text(
              widget.getSingleProduct.category ?? '',
              style: TextStyle(
                fontSize: fontSize * 0.015,
                color: theme.primaryColorDark.withOpacity(0.8),
                fontFamily: fontFamily,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Spacer(),
        if (widget.isFromResearch != true) ...[
          Column(
            children: [
              RatingBar.builder(
                initialRating:
                    double.parse(widget.getSingleProduct.userRating.toString()),
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                unratedColor: theme.focusColor,
                itemSize: fontSize * 0.025,
                onRatingUpdate: (double value) => handleProductRating(value),
              ),
            ],
          )
        ]
      ],
    );
  }

  //Widget for validity button
  Widget _buildValidityButton(theme, fontSize) {
    return Row(
      children: [
        Column(
          children: [
            Icon(Icons.access_time_rounded,
                size: fontSize * 0.035, color: theme.primaryColorDark)
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "${widget.getSingleProduct.subscriptionData} $validity",
                  style: TextStyle(
                      fontSize: fontSize * 0.012,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColorDark),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "$thisCourseOffersAccessPeriodOf ${widget.getSingleProduct.subscriptionData ?? ''} ",
                  style: TextStyle(
                    color: theme.primaryColorDark,
                    fontSize: fontSize * 0.012,
                    fontFamily: fontFamily,
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }

//Widget for navigate to content
  Widget _buildNavigateToContentButton(theme, fontSize, showSecondButton) {
    return GestureDetector(
      onTap: showSecondButton
          ? () => widget.handleNavigateToContentButton()
          : () {},
      child: Row(
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: theme.shadowColor),
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: fontSize * 0.035,
                  color: theme.primaryColorDark,
                ),
              )
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "${widget.getSingleProduct.contentCount} $learningMaterialCountText", //Todo:We have to add All Material
                    style: TextStyle(
                        fontSize: fontSize * 0.012,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryColorDark),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "${widget.getSingleProduct.videoCount} $videolecturesText",
                    style: TextStyle(
                      color: theme.primaryColorDark,
                      fontSize: fontSize * 0.012,
                      fontFamily: fontFamily,
                    ),
                  )
                ],
              )
            ],
          ),
          const Spacer(),
          Column(
            children: [
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: theme.primaryColorDark,
              )
            ],
          ),
        ],
      ),
    );
  }

//widget for Product Image
  Widget _buildProductImage(BuildContext context, String imageUrl) {
    return (imageUrl.startsWith("http") || handleToCheckImage() == false)
        ? CustomYoutubePlayer(
            youtubeUrl: imageUrl,
          )
        : CircularCachedNetworkLandScapeImages(
            imageURL: imageUrl,
            baseUrl: getGetLandscapeImage,
            defaultImagePath: productLandScapeImage,
            aspectRatio: 2 / 0.8,
          );
  }

//Widget Builder for Bonus Product
  Widget _buildBonusProduct(theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB71C1C), Color(0xFFFF5252)], // Red Gradient
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🎁 Left Side: Bonus Offer Button
          Expanded(
            child: Text(
              bonusProductText,
              style: TextStyle(
                  color: theme.floatingActionButtonTheme.foregroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: fontFamily),
            ),
          ),

          const SizedBox(width: 10), // Space
          Image.asset(
            bonusProductImagePath,
            scale: 15,
          ),
        ],
      ),
    );
  }
}
