import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IProduct_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/products/getimage/get_product_image_state.dart';

class ProductImageStateNotifier extends StateNotifier<GetProductImageState> {
  ProductImageStateNotifier(this._productRepository)
      : super(GetProductImageState.inital());
  final IProductRepository _productRepository;

  Future<void> getProductImage(String productImageEndpoint) async {
    state = GetProductImageState.isLoading();
    try {
      await _productRepository.getProductImage(productImageEndpoint);
      state = GetProductImageState.loaded(
          productImageEndpoint); // Update state with the image data
    } catch (error) {
      state = GetProductImageState.error(error);
    }
  }
}

final productImageStateNotifierProvider =
    StateNotifierProvider<ProductImageStateNotifier, GetProductImageState>(
        (ref) {
  final IProductRepository getproductImageRepository =
      getIt<IProductRepository>();
  return ProductImageStateNotifier(getproductImageRepository);
});
