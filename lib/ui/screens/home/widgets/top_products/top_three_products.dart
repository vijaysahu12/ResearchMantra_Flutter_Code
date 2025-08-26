import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/product_api_response_model.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/images/dashboard/top_products/top_three_products_states.dart';
import 'package:research_mantra_official/providers/services_buttons_provider.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';
import 'package:research_mantra_official/ui/components/shimmers/home_shimmer.dart';
import 'package:research_mantra_official/ui/screens/home/home_navigator.dart';
import 'package:research_mantra_official/ui/screens/products/screens/details/product_details_screen.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class TopThreeProductsWidget extends ConsumerStatefulWidget {
  final TopThreeProductsStates getTopProductsImages;

  const TopThreeProductsWidget({
    super.key,
    required this.getTopProductsImages,
  });

  @override
  ConsumerState<TopThreeProductsWidget> createState() =>
      _TopThreeProductsWidgetState();
}

class _TopThreeProductsWidgetState
    extends ConsumerState<TopThreeProductsWidget> {
  bool isLoading = true;

//Function to navigate to product details screen
  navigateToProductDetailsScreen(
      productId, price, buyButtonText, buttonName, productName) {
    final connectivityResult = ref.watch(connectivityStreamProvider);

    //Checking result based on that displaying connection screen
    final connectionResult = connectivityResult.value;

    bool checkConnection = connectionResult != ConnectivityResult.none;
    ProductApiResponseModel myObject = ProductApiResponseModel(
      groupName: '',
      description: "",
      id: productId,
      listImage: "", //Todo: instead of categoryName change to imagerl
      name: productName,
      price: price,
      overAllRating: 0.0,
      heartsCount: null,
      userRating: 0.0,
      userHasHeart: false,
      isInMyBucket: true,
      isInValidity: false,
      buyButtonText: buyButtonText,
    );
    if (checkConnection) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailsScreenWidget(
            product: myObject,
            buttonName: buttonName,
            isFromNotification: false,
      
          ),
        ),
      );
    }
  }

//Function Navigate To Selected Index
  void handleToNavigateSelectedScreens(isFromHome) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeNavigatorWidget(
          initialIndex: 1,
          isFromHome: isFromHome,
        ),
      ),
    );
    ref
        .read(servicesButtonNotifierProvider.notifier)
        .updateButtonType(isFromHome);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final connectivityResult = ref.watch(connectivityStreamProvider);
    final connectionResult = connectivityResult.value;
    final bool checkConnection = connectionResult != ConnectivityResult.none;
    final double height = MediaQuery.of(context).size.height;

    if (widget.getTopProductsImages.isLoading) {
      return Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            buildBottomImagesShimmers(context, theme),
            buildBottomImagesShimmers(context, theme),
          ],
        ),
      );
    }
    if (widget.getTopProductsImages.error != null) {
      //Todo:
      return Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildImageOfflineSection(theme),
            const SizedBox(
              height: 10,
            ),
            _buildImageOfflineSection(theme),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: topThreeScannerText,
            onViewAll: () => handleToNavigateSelectedScreens(false),
            imageList: widget.getTopProductsImages.topThreeImagesList,
            type: 'scanner',
            theme: theme,
            height: height,
            checkConnection: checkConnection,
          ),
          const SizedBox(height: 20),
          _buildSection(
            title: topThreeStrategyText,
            onViewAll: () => handleToNavigateSelectedScreens(true),
            imageList: widget.getTopProductsImages.topThreeImagesList,
            type: 'strategy',
            theme: theme,
            height: height,
            checkConnection: checkConnection,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required VoidCallback onViewAll,
    required List<dynamic> imageList,
    required String type,
    required ThemeData theme,
    required double height,
    required bool checkConnection,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Row(
            children: [
              Image.asset(
                "assets/images/const/images/market-research.png",
                scale: 20,
              ),
              const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: height * 0.014,
                  fontWeight: FontWeight.bold,
                  fontFamily: fontFamily,
                  color: theme.focusColor,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  viewAllButtonText,
                  style: TextStyle(
                    fontSize: height * 0.012,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontFamily,
                    color: theme.indicatorColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        type == 'scanner'
            ? _buildScannerImagesRow(theme, checkConnection, imageList, type)
            : _buildStratigiesImagesRow(
                theme, checkConnection, imageList, type),
      ],
    );
  }

  // Widget to build the scanner images row
  Widget _buildScannerImagesRow(ThemeData theme, bool hasConnection,
      List<dynamic> product, String buttonName) {
    final productItem = product
        .where((image) => image.type?.trim().toLowerCase() == "scanner")
        .toList();

    if (!hasConnection) {
      return _buildImageOfflineSection(
        theme,
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: productItem.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final item = productItem[index];
        return _buildImageSection(theme, item, buttonName);
      },
    );
  }

  // Widget to build the stratigies images row
  Widget _buildStratigiesImagesRow(ThemeData theme, bool hasConnection,
      List<dynamic> product, String buttonName) {
    final productItem = product
        .where((image) => image.type?.trim().toLowerCase() == "strategies")
        .toList();
    if (!hasConnection) {
      return _buildImageOfflineSection(
        theme,
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: productItem.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final item = productItem[index];
        return _buildImageSection(theme, item, buttonName);
      },
    );
  }

  //onlin images
  Widget _buildImageSection(ThemeData theme, product, buttonName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.3,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (product != null) {
                      navigateToProductDetailsScreen(product.id, product.price,
                          product.buyButtonText, buttonName, product.name);
                    }
                  },
                  child: Stack(
                    children: [
                      (product != null && product.listImage.isNotEmpty)
                          ? CircularCachedNetworkProduct(
                              imageURL: product.listImage,
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 4),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  productDefaultmage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 4, left: 4, right: 4),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              decoration: const BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [
                                      Color(0xFFAD0202), // Red color
                                      Color(0xFF000000), // Black color
                                    ],
                                    radius: 6,
                                  ),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    product.name,
                                    style: TextStyle(
                                      color: theme.floatingActionButtonTheme
                                          .foregroundColor,
                                      fontFamily: fontFamily,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.02,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageOfflineSection(
    ThemeData theme,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            productDefaultmage,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
