import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/learning_material.dart/learning_material_list.dart';

import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/learning/indicator/indicator_provider.dart';
import 'package:research_mantra_official/providers/learning/indicator_description/indicator_description_provider.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/ui/components/animation/animation_slideup.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';

import 'package:research_mantra_official/ui/components/cacher_network_images/indicator_candlestcik_cache_images/indicator_cadnlestick_cache.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';

import 'package:research_mantra_official/ui/screens/learning/screen/indicator_screens/widgets/description_page_indicator.dart';
import 'package:like_button/like_button.dart';

//import 'package:research_mantra_official/providers/learning/indicator_description/indicator_description_state.dart';

class IndicatorScreen extends ConsumerStatefulWidget {
  final int id;
  const IndicatorScreen({super.key, required this.id});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _IndicatorScreenState();
}

class _IndicatorScreenState extends ConsumerState<IndicatorScreen> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkAndFetch(false);
    });
  }

  Future<void> _checkAndFetch(isRefresh) async {
    bool checkConnection =
        await CheckInternetConnection().checkInternetConnection();
    ref
        .read(connectivityProvider.notifier)
        .updateConnectionStatus(checkConnection);

    if (checkConnection) {
      await getExampleData(isRefresh);
      // await getIndicatorDescriptionData();

      // Ensure this method is properly awaiting
    }
  }

  Future<void> getIndicatorDescriptionData() async {
    await ref
        .read(indicatorDescriptionProvider.notifier)
        .getIndicatorDescription(widget.id, getLearningContentById);
  }

  Future<void> getExampleData(isRefresh) async {
    if (isRefresh) {
      setState(() {
        isLoading = true;
      });
    }
    await ref
        .read(getIndicatorProvider.notifier)
        .getIndicatorListData(widget.id, isRefresh);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> handleLikeCount(int id, bool isLiked) async {
    await ref.read(getIndicatorProvider.notifier).likeCount(id, isLiked);
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = ref.watch(connectivityProvider);
    final getIndicatorData = ref.watch(getIndicatorProvider);

    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    if (!hasConnection) {
      return NoInternet(
        handleRefresh: () => _checkAndFetch(true),
      );
    }
    return Scaffold(
        appBar: CommonAppBarWithBackButton(
          appBarText: indicatorPattern,
          handleBackButton: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: theme.primaryColor,
        body: _buildIndicators(getIndicatorData, theme, width));
  }

  //widget for Indicators
  Widget _buildIndicators(getIndicatorData, theme, width) {
    if (getIndicatorData.isLoading && isLoading) {
      return const CommonLoaderGif();
    } else if (getIndicatorData.getAllLearningMaterial == null) {
      return const NoContentWidget(
        message: noContentScreenText,
      );
    } else if (getIndicatorData.error != null) {
      return const ErrorScreenWidget();
    }

    return RefreshIndicator(
      onRefresh: () => _checkAndFetch(true),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  getIndicatorData.getAllLearningMaterial?.length ?? 10,
                  (index) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DescriptionPageIndicator(
                              id: getIndicatorData
                                      .getAllLearningMaterial?[index].id ??
                                  0,
                              endPoint: getLearningContentById,
                            ),
                          ),
                        );
                      },
                      child: AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 250),
                        child: SlideAnimation(
                            verticalOffset: 100.0,
                            child: FadeInAnimation(
                                child: _indicatorTile(
                                    theme,
                                    width,
                                    getIndicatorData
                                        .getAllLearningMaterial?[index]))),
                      ))),
            )),
      ),
    );
  }

  Widget _indicatorTile(
      theme, double width, LearningMaterialList learningMaterialList) {
    return Container(
      margin: const EdgeInsets.all(10),
      // padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
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
      child: Stack(
        alignment: const Alignment(0.9, -0.9),
        children: [
          CacheNetworkImagesForLearningScreen(
            url: getGetLandscapeImage,
            borderRadius: BorderRadius.circular(10),
            width: width * 0.9,
            height: width * 0.5,
            imageURL: learningMaterialList.imageUrl ?? "",
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSlideUp(
                child: Text(
                  learningMaterialList.likeCount == null
                      ? '0'
                      : learningMaterialList.likeCount.toString(),
                  key: ValueKey(learningMaterialList.likeCount ?? 0),
                  style: TextStyle(color: theme.focusColor, fontSize: 10),
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              LikeButton(
                size: 25,
                isLiked: learningMaterialList.isLiked ?? false,
                likeBuilder: (bool isLiked) {
                  return Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? theme.disabledColor : theme.focusColor,
                    size: 20,
                  );
                },
                onTap: (bool isLiked) async {
                  // Handle the like/unlike action

                  handleLikeCount(learningMaterialList.id ?? 0,
                      !(learningMaterialList.isLiked ?? false));

                  return !isLiked;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
