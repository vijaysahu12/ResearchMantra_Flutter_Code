import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/product_api_response_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IProduct_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/products/list/product_list_state.dart';

class ProductsStateNotifier extends StateNotifier<ProductListState> {
  ProductsStateNotifier(this._productRepository)
      : super(ProductListState.initial());

  final IProductRepository _productRepository;

  Future<void> getProductList(String mobileUserPublicKey, bool isRate) async {
    if (isRate || state.productApiResponseModel.isEmpty) {
      state = ProductListState.loading();
    }

    try {
      final List<ProductApiResponseModel> getProducts =
          await _productRepository.getProductsList(mobileUserPublicKey);
      state = ProductListState.loaded(getProducts);
    } catch (e) {
      state = ProductListState.error(e.toString());
    }
  }

  Future<void> manageLikeUnlikeProductById(int productId, String action) async {
    try {
      // Update the liked/unliked state locally first
      final List<ProductApiResponseModel> updatedProducts =
          state.productApiResponseModel.map((product) {
        if (product.id == productId) {
          return product.copyWith(
            userHasHeart: action == like,
            heartsCount: action == like
                ? product.heartsCount! + 1
                : product.heartsCount! - 1,
          );
        }
        return product;
      }).toList();

      state = ProductListState.loaded(updatedProducts);

      // Then make the API call to update the server
      await _productRepository.manageLikeUnlikeProductById(productId, action);
    } catch (e) {
      state = ProductListState.error(e.toString());
    }
  }
}

final productsStateNotifierProvider =
    StateNotifierProvider<ProductsStateNotifier, ProductListState>((ref) {
  final IProductRepository notificationRepository = getIt<IProductRepository>();
  return ProductsStateNotifier(notificationRepository);
});

//Product List Screen servicesButton and TradingButton StateNotifier
class AlgoButtonStateNotifier extends StateNotifier<int> {
  AlgoButtonStateNotifier() : super(0);

  void setButtonState(int index) {
    state = index;
  }

  void getButton() {
    state = 1;
  }
}

final algoButtonsStateNotifierProvider =
    StateNotifierProvider.autoDispose<AlgoButtonStateNotifier, int>((ref) {
  return AlgoButtonStateNotifier();
});
