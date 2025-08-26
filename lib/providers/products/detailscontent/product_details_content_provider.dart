import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/product_details_content_api_response_model.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/products/detailscontent/produtc_details_content_state.dart';

import '../../../data/repositories/interfaces/IProduct_repository.dart';

class ProductDetailsContentStateNotifier
    extends StateNotifier<ProductDetailsContentState> {
  ProductDetailsContentStateNotifier(this._productRepository)
      : super(ProductDetailsContentState.initial());

  final IProductRepository _productRepository;

//get single product details
  Future<void> getSingleProductContentDetails(
      int productId, String mobileUserPublicKey) async {
    state = ProductDetailsContentState.loading();
    try {
      final List<ProductDetailsItemApiResponseModel> getProductItemContentList =
          await _productRepository.getProductContent(
              productId, mobileUserPublicKey);

      state = ProductDetailsContentState.loaded(getProductItemContentList);
    } catch (e) {
      state = ProductDetailsContentState.error(e);
    }
  }
}

final productDetailsItemProvider = StateNotifierProvider<
    ProductDetailsContentStateNotifier, ProductDetailsContentState>((ref) {
  final IProductRepository getProductContentRepository =
      getIt<IProductRepository>();

  return ProductDetailsContentStateNotifier(getProductContentRepository);
});
