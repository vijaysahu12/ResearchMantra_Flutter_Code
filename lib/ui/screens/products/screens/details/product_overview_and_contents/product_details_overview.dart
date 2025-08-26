import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/product_api_response_model.dart';
import 'package:research_mantra_official/providers/products/detailscontent/product_details_content_provider.dart';
import 'package:research_mantra_official/providers/products/single/single_product_provider.dart';
import 'package:research_mantra_official/providers/products/single/single_product_state.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';

import '../../../widget/productdetails/product_overview.dart';

class ProductItemOverviewScreen extends ConsumerStatefulWidget {
  final int getSingleProductId;
  final Function(BuildContext context, WidgetRef ref)
      handleNavigateToContentButton;

  final bool? isFromResearch;
  final String? isBuyButtonEnable;

  final ProductApiResponseModel product;
  final double afterDiscountPrice;
  final SingleProductState getSingleProductDetails;

  const ProductItemOverviewScreen({
    super.key,
    required this.getSingleProductId,
    required this.handleNavigateToContentButton,
    required this.product,
    required this.afterDiscountPrice,
    required this.getSingleProductDetails,
    this.isFromResearch,
    this.isBuyButtonEnable,
  });

  @override
  ConsumerState<ProductItemOverviewScreen> createState() =>
      _ProductItemOverviewScreenState();
}

class _ProductItemOverviewScreenState
    extends ConsumerState<ProductItemOverviewScreen> {
  final UserSecureStorageService _commonDetails = UserSecureStorageService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final String mobileUserPublicKey = await _commonDetails.getPublicKey();

      ref.read(singleProductButtonStateNotifier.notifier).setButtonState(0);
      ref
          .read(productDetailsItemProvider.notifier)
          .getSingleProductContentDetails(
              widget.getSingleProductId, mobileUserPublicKey);
      getUserName();
    });
  }

  String userName = '';
  getUserName() async {
    Map<String, dynamic> userDetails = await _commonDetails.getUserDetails();
    userName = userDetails['fullName'];
  }

  //

  // Pull-to-refresh function
  Future<void> handleToRefresh() async {
    final String mobileUserPublicKey = await _commonDetails.getPublicKey();

    // Refresh the single product details
    await ref
        .read(singleProductStateNotifierProvider.notifier)
        .getSingleProductDetails(
            widget.getSingleProductId, mobileUserPublicKey, false);
  }

  @override
  Widget build(BuildContext context) {
    final getSingleProduct = widget.getSingleProductDetails;

    return RefreshIndicator(
      onRefresh: () => handleToRefresh(),
      child: ListView(
        children: [
     
          ProductDetailsOverviewWidget(
            isBuyButtonEnable: widget.isBuyButtonEnable,
            isFromResearch: widget.isFromResearch,
            afterDiscountPrice: widget.afterDiscountPrice,
            productPrice: widget.product.price,

            handleNavigateToContentButton: () =>
                widget.handleNavigateToContentButton(context, ref),
            userName: userName,
            // handleCouponValidate: widget.handleCouponValidate,
            getSingleProduct: getSingleProduct.singleProductApiResponseModel!,
          ),

          
        ],
      ),
    );
  }
}
