import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/dashboard/dashboard_slider_model.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/learning/learning_material/learning_material_provider.dart';
import 'package:research_mantra_official/providers/learning/learning_material/learning_material_state.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/learning/screen/candlestick_screens/candel_screen.dart';
import 'package:research_mantra_official/ui/screens/learning/screen/indicator_screens/indicator_screen.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class TopDashBoardBottomImages extends ConsumerStatefulWidget {
  const TopDashBoardBottomImages({
    super.key,
  });

  @override
  ConsumerState<TopDashBoardBottomImages> createState() =>
      _TopDashBoardBottomImagesState();
}

class _TopDashBoardBottomImagesState
    extends ConsumerState<TopDashBoardBottomImages> {
  List<DashBoardTopImagesModel> imagemodel = [
    const DashBoardTopImagesModel(
        price: 0.0, buyButtonText: learningMaterial, listImage: candelLogo),
    const DashBoardTopImagesModel(
        price: 0.0, buyButtonText: learningMaterial, listImage: indicatorLogo),
  ];

  void navigateToLearning(int index) {
    index == 2
        ? Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CandleScreen(id: index),
            ),
          )
        : Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IndicatorScreen(id: index),
            ),
          );
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _checkAndFetchData(false);
    });
  }

  Future<void> _checkAndFetchData(bool isRefresh) async {
    final connectivityResult = ref.watch(connectivityStreamProvider);

    // Checking result based on that displaying connection screen
    final connectionResult = connectivityResult.value;

    bool isConnection = connectionResult != ConnectivityResult.none;

    if (isConnection) {
      await getLearningMaterialData(isRefresh);
    } else {
      ToastUtils.showToast(noInternetConnectionText, "");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getLearningMaterialData(bool isRefresh) async {
    if (isRefresh) {
      setState(() {
        isLoading = true;
      });
    }
    ref
        .read(getLearningMaterialProvider.notifier)
        .getLearningMaterialList(isRefresh);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getLearningMaterialData = ref.watch(getLearningMaterialProvider);
    final theme = Theme.of(context);
    final connectivityResult = ref.watch(connectivityStreamProvider);
    final connectionResult = connectivityResult.value;
    bool checkConnection = connectionResult != ConnectivityResult.none;
    final fontSize = MediaQuery.of(context).size.height;
    // Show the loader first if the data is still being fetched
    return PopScope(
      canPop: true,
      child: Scaffold(
          backgroundColor: theme.primaryColor,
          appBar: CommonAppBarWithBackButton(
            appBarText: learningMaterial,
            handleBackButton: () {
              Navigator.pop(context);
            },
          ),
          body: _buildMarketData(
              checkConnection, getLearningMaterialData, theme, fontSize)),
    );
  }

  Widget _buildMarketData(
      checkConnection, getLearningMaterialData, theme, fontSize) {
    if (isLoading || getLearningMaterialData.isLoading) {
      return const CommonLoaderGif();
    }
    if (getLearningMaterialData.error != null) {
      return const ErrorScreenWidget();
    }

    if (getLearningMaterialData.getAllLearningMaterial == null ||
        getLearningMaterialData.getAllLearningMaterial?.isEmpty) {
      return const NoContentWidget(
        message:
            "Learning resources will arrive shortly. Stay patient and stay curious!",
      );
    }

    return RefreshIndicator(
      onRefresh: () => _checkAndFetchData(true), // Trigger refresh
      child: ListView(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkConnection &&
                    getLearningMaterialData.getAllLearningMaterial?.isNotEmpty
                ? buildImageList(
                    imagemodel, theme, getLearningMaterialData, fontSize)
                : _buildOfflineImages(theme),
          ],
        ),
      ]),
    );
  }

  Widget buildImageList(
      List<DashBoardTopImagesModel> imagesList,
      ThemeData theme,
      LearningMaterialState? getLearningMaterialData,
      fontSize) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: getLearningMaterialData?.getAllLearningMaterial?.length ?? 0,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            navigateToLearning(
                getLearningMaterialData?.getAllLearningMaterial?[index].id ??
                    0);
          },
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              child: Row(
                children: [
                  CircularCachedNetworkProduct(
                    width: 100,
                    height: 100,
                    imageURL: getLearningMaterialData
                            ?.getAllLearningMaterial?[index].imageUrl ??
                        "",
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getLearningMaterialData
                                  ?.getAllLearningMaterial?[index].name ??
                              '',
                          style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.primaryColorDark,
                              fontWeight: FontWeight.bold,
                              fontFamily: fontFamily,
                              fontSize: fontSize * 0.018),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          // description
                          getLearningMaterialData
                                  ?.getAllLearningMaterial?[index]
                                  .description ??
                              '',

                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.focusColor,
                              fontSize: fontSize * 0.014),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOfflineImages(ThemeData theme) {
    // List of items with names and descriptions
    final List<Map<String, String>> offlineItems = [
      {
        'title': 'Candlestick',
        'description':
            'Learn candlestick patterns to predict market trends and spot reversals.'
      },
      {
        'title': 'Indicator',
        'description':
            'Use indicators to confirm trends and make informed trading decisions.'
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: offlineItems.length,
      itemBuilder: (context, index) {
        final item = offlineItems[index];
        return GestureDetector(
          onTap: () {},
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.315,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        productDefaultmage, // Use the placeholder image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']!, // Display the title
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: fontFamily,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['description']!, // Display the description
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.focusColor,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
