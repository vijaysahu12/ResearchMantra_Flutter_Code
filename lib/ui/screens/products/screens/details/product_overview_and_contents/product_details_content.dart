import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/products/detailscontent/product_details_content_provider.dart';
import 'package:research_mantra_official/providers/products/single/single_product_state.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import '../../../widget/productdetails/product_content.dart';

class ProductDetailsItemContentScreen extends ConsumerStatefulWidget {
  final int productItemId;
  final SingleProductState getSingleProductDetails;
  final bool? isFromResearch;
  final String isFree;
  const ProductDetailsItemContentScreen({
    required this.productItemId,
    this.isFromResearch,
    super.key,
    required this.getSingleProductDetails,
    required this.isFree,
  });

  @override
  ConsumerState<ProductDetailsItemContentScreen> createState() =>
      _ProductDetailsItemContentScreenState();
}

class _ProductDetailsItemContentScreenState
    extends ConsumerState<ProductDetailsItemContentScreen> {
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
 
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //Todo: Need to add internet checker
      final String mobileUserPublicKey = await _commonDetails.getPublicKey();
      ref
          .read(productDetailsItemProvider.notifier)
          .getSingleProductContentDetails(
              widget.productItemId, mobileUserPublicKey);
    });
  }

  handleToRefresh() async {
    final String mobileUserPublicKey = await _commonDetails.getPublicKey();

    ref
        .read(productDetailsItemProvider.notifier)
        .getSingleProductContentDetails(
            widget.productItemId, mobileUserPublicKey);
  }

  @override
  Widget build(BuildContext context) {
    final getProductItemContent = ref.watch(productDetailsItemProvider);

    if (getProductItemContent.isLoading) {
      return const CommonLoaderGif();
    }
    if (getProductItemContent.productItemContentApiResponseModel.isEmpty) {
      return const NoContentWidget(
        message: noContentScreenText,
      );
    }

    return RefreshIndicator(
        onRefresh: () => handleToRefresh(),
        child: ListView.builder(
          itemCount:
              getProductItemContent.productItemContentApiResponseModel.length,
          itemBuilder: (context, index) {
            final productItemContent =
                getProductItemContent.productItemContentApiResponseModel[index];

            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 100.0,
                child: FadeInAnimation(
                  child: ProductDetailsContentWidget(
                    productId: widget.productItemId,
                    isFree:widget.isFree,
                      isFromResearch: widget.isFromResearch,
                      getProductItemContent: productItemContent,
                      isInMyBucketString: widget.getSingleProductDetails
                          .singleProductApiResponseModel!.isInMyBucket,
                      isInValidity: widget.getSingleProductDetails
                          .singleProductApiResponseModel!.isInValidity),
                ),
              ),
            );
          },
        ));
  }
}
