import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/hive_model/product_hive_model.dart';

import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/products/list/product_list_provider.dart';
import 'package:research_mantra_official/services/hive_service.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/products/widget/products_list_widget.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';


class ProductListScreen extends ConsumerStatefulWidget {
  final String typeOfButton;
  const ProductListScreen({
    super.key,
    required this.typeOfButton,
  });

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  final HiveServiceStorage _hiveServiceStorage = HiveServiceStorage();
  List<ProductHiveModel> products = [];
  bool isLoadDataFromLocalDb = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkAndFetchProducts();
    });
  }

  Future<void> _checkAndFetchProducts() async {
    final connectivityResult = ref.watch(connectivityStreamProvider);
    final connectionResult = connectivityResult.value;
    final productsState = ref.read(productsStateNotifierProvider);

    if (productsState.productApiResponseModel.isNotEmpty) {
      // Data is already available, no need to fetch again.
      setState(() {
        isLoadDataFromLocalDb = false;
      });
      return;
    }

    final String mobileUserPublicKey = await _commonDetails.getPublicKey();

    if (connectionResult != ConnectivityResult.none) {
      await ref.read(productsStateNotifierProvider.notifier).getProductList(
            mobileUserPublicKey,
            false,
          );
    } else {
      ToastUtils.showToast(noInternetConnectionText, "");
      if (mounted) {
        setState(() {
          products = _hiveServiceStorage.getAllData();
        });
      }
    }

    if (mounted) {
      setState(() {
        isLoadDataFromLocalDb = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> handleToRefresh() async {
    final connectivityResult = ref.watch(connectivityStreamProvider);
    final connectionResult = connectivityResult.value;

    if (connectionResult != ConnectivityResult.none) {
      final String mobileUserPublicKey = await _commonDetails.getPublicKey();
      await ref.read(productsStateNotifierProvider.notifier).getProductList(
            mobileUserPublicKey,
            true,
          );
    } else {
      ToastUtils.showToast(noInternetConnectionText, "");
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsList = ref.watch(productsStateNotifierProvider);
    final connectivityResult = ref.watch(connectivityStreamProvider);
    final hasConnection = connectivityResult.value;
    if (hasConnection == ConnectivityResult.none) {
      ToastUtils.showToast(noInternetConnectionText, "");
    }

    if (hasConnection != ConnectivityResult.none) {
      if (productsList.isLoading) {
        return const CommonLoaderGif();
      } else if (productsList.productApiResponseModel.isEmpty &&
          productsList.isLoading) {
        return const NoContentWidget(message: productScreenEmptyTitle);
      } else if (productsList.error != null) {
        return const Center(child: ErrorScreenWidget());
      } else {
        return RefreshIndicator(
          onRefresh: () => handleToRefresh(),
          child: ListView.builder(
            itemCount: productsList.productApiResponseModel.length,
            itemBuilder: (context, index) {
              final product = productsList.productApiResponseModel[index];

              String ratingForProducts = product.overAllRating.toString();
              if (ratingForProducts.contains('.') &&
                  ratingForProducts.split('.')[1].length > 1) {
                ratingForProducts = ratingForProducts.substring(
                    0, ratingForProducts.indexOf('.') + 2);
              }

              final productModel = ProductHiveModel(
                id: product.id,
                name: product.name,
                description: product.description,
                listImage: product.listImage,
                heartsCount: product.heartsCount,
                userHasHeart: product.userHasHeart,
                groupName: product.groupName,
                overAllRating: double.parse(ratingForProducts),
              );

              _hiveServiceStorage.addInHive(productModel);

              return _buildForProducts(
                index,
                ratingForProducts,
                product,
              );
            },
          ),
        );
      }
    } else {
      if (productsList.productApiResponseModel.isNotEmpty) {
        return RefreshIndicator(
          onRefresh: () => handleToRefresh(),
          child: ListView.builder(
            itemCount: productsList.productApiResponseModel.length,
            itemBuilder: (context, index) {
              final product = productsList.productApiResponseModel[index];

              String ratingForProducts = product.overAllRating.toString();
              if (ratingForProducts.contains('.') &&
                  ratingForProducts.split('.')[1].length > 1) {
                ratingForProducts = ratingForProducts.substring(
                    0, ratingForProducts.indexOf('.') + 2);
              }

              return _buildForProducts(
                index,
                ratingForProducts,
                product,
              );
            },
          ),
        );
      }
      if (products.isEmpty &&
          productsList.productApiResponseModel.isEmpty &&
          !isLoadDataFromLocalDb) {
        return NoInternet(
          handleRefresh: () => _checkAndFetchProducts(),
        );
      } else if (isLoadDataFromLocalDb) {
        return const CommonLoaderGif();
      }
      return RefreshIndicator(
        onRefresh: () => handleToRefresh(),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final hiveProduct = products[index];
            return ProductListWidget(
              handleToRefresh: handleToRefresh,
              typeOfButton: widget.typeOfButton,
              ratingForProducts: hiveProduct.overAllRating.toString(),
              hiveProductList: hiveProduct,
            );
          },
        ),
      );
    }
    // }
  }

  //Widget for  product
  Widget _buildForProducts(
    index,
    ratingForProducts,
    product,
  ) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 250),
      child: SlideAnimation(
        verticalOffset: 100.0,
        child: FadeInAnimation(
          child: ProductListWidget(
            handleToRefresh: handleToRefresh,
            typeOfButton: widget.typeOfButton,
            ratingForProducts: ratingForProducts,
            product: product,
          ),
        ),
      ),
    );
  }
}
