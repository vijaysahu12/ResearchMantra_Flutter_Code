import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/learning_material.dart/learning_material_list.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/learning/candelistic/candelistic_provider.dart';
import 'package:research_mantra_official/ui/components/animation/animation_slideup.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/indicator_candlestcik_cache_images/indicator_cadnlestick_cache.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/learning/screen/candlestick_screens/widgets/description_page_candelistic.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import 'package:like_button/like_button.dart';

class CandleScreen extends ConsumerStatefulWidget {
  final int id;
  const CandleScreen({super.key, required this.id});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CandleScreenState();
}

class _CandleScreenState extends ConsumerState<CandleScreen> {
  bool isInitLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _checkAndFetch(false);
    });
  }

  Future<void> _checkAndFetch(isRefresh) async {
    final connectivityResult = ref.watch(connectivityStreamProvider);

    //Checking result based on that displaying connection screen
    final connectionResult = connectivityResult.value;

    bool isConnection = connectionResult != ConnectivityResult.none;
    ref
        .read(connectivityProvider.notifier)
        .updateConnectionStatus(isConnection);
    if (isConnection) {
      await getCandleListData(
          isRefresh); // Ensure this method is properly awaiting.
    } else {
      ToastUtils.showToast(noInternetConnectionText, "");
    }
  }

  Future<void> getCandleListData(isRefresh) async {
    if (isRefresh) {
      setState(() {
        isInitLoading = true;
      });
    }
    try {
      await ref
          .read(getCandelProvider.notifier)
          .getCandleList(widget.id, isRefresh);
    } catch (e) {
      print("Error fetching candle list: $e");
    }

    if (mounted) {
      setState(() {
        isInitLoading = false;
      });
    }
  }

  Future<void> handleLikeCount(int id, bool isLiked) async {
    await ref.read(getCandelProvider.notifier).likeCount(id, isLiked);
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = ref.watch(connectivityProvider);
    final getCandleData = ref.watch(getCandelProvider);

    final theme = Theme.of(context);

    if (!hasConnection) {
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: theme.primaryColorDark,
                )),
            title: const Text(learningScreenTitleText),
          ),
          backgroundColor: theme.primaryColor,
          body: NoInternet(
            handleRefresh: () => _checkAndFetch(false),
          ));
    }
    return Scaffold(
      appBar: CommonAppBarWithBackButton(
        appBarText: learningScreenTitleText,
        handleBackButton: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: theme.primaryColor,
      body: _buildCandleStickData(getCandleData, theme),
    );
  }

  //Widget for candlestick data
  Widget _buildCandleStickData(getCandleData, theme) {
    if (getCandleData.isLoading && isInitLoading) {
      return const CommonLoaderGif();
    } else if (getCandleData.getAllLearningMaterial == null) {
      return const NoContentWidget(
        message: noContentScreenText,
      );
    } else if (getCandleData.error != null) {
      return const ErrorScreenWidget();
    }

    return RefreshIndicator(
      onRefresh: () => _checkAndFetch(true),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(10),
          child: Align(
            alignment: getCandleData.getAllLearningMaterial?.length == 1
                ? Alignment.centerLeft
                : Alignment.center,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                  getCandleData.getAllLearningMaterial?.length ?? 0, (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DescriptionPage(
                          id: getCandleData.getAllLearningMaterial?[index].id ??
                              0,
                          endPoints: getLearningContentById,
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
                          child: _candelTile(theme,
                              getCandleData.getAllLearningMaterial?[index])),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _candelTile(theme, LearningMaterialList learningMaterialList) {
    return Container(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          alignment: const Alignment(0.9, -0.98),
          children: [
            CacheNetworkImagesForLearningScreen(
              url: getGetLandscapeImage,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              width: MediaQuery.of(context).size.width * 0.45,
              height: MediaQuery.of(context).size.width * 0.50,
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
                  isLiked: learningMaterialList.isLiked,
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? theme.disabledColor : theme.focusColor,
                      size: 20,
                    );
                  },
                  onTap: (bool isLiked) async {
                    final action =
                        (learningMaterialList.isLiked ?? false) ? unlike : like;

                    handleLikeCount(learningMaterialList.id ?? 0,
                        action.toLowerCase() == "like" ? true : false);

                    return !isLiked;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
