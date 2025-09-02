import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/screeners/screeners_category/screeners_category_provider.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/components/images/custom_images.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/screeners/screens/screeners_list.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class ScreenersHomeScreen extends ConsumerStatefulWidget {
  const ScreenersHomeScreen({
    super.key,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScreenersHomeScreenState();
}

class _ScreenersHomeScreenState extends ConsumerState<ScreenersHomeScreen> {
  bool isInitLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // screenerCategory = ScreenerCategory(screeners: data);
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
      await getCategoryData(
          isRefresh); // Ensure this method is properly awaiting.
    } else {
      ToastUtils.showToast(noInternetConnectionText, "");
    }
  }

  Future<void> getCategoryData(isRefresh) async {
    if (isRefresh) {
      setState(() {
        isInitLoading = true;
      });
    }
    await ref.read(screenerCategoryProvider.notifier).getCategory();
    setState(() {
      isInitLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final getCategoryData = ref.watch(screenerCategoryProvider);
    final connectivityResult = ref.watch(connectivityStreamProvider);

    //Checking result based on that displaying connection screen
    final connectionResult = connectivityResult.value;

    bool isConnection = connectionResult != ConnectivityResult.none;
    final theme = Theme.of(context);

    return Scaffold(
      // appBar: CommonAppBarWithBackButton(
      //   appBarText: "Screeners",
      //   handleBackButton: () {
      //     Navigator.pop(context);
      //   },
      // ),
      backgroundColor: theme.primaryColor,
      body: _buildScreenersData(getCategoryData, theme, isConnection),
    );
  }

  //Widget for candlestick data
  Widget _buildScreenersData(getCategoryData, theme, isConnection) {
    if (isConnection == false && getCategoryData.categoryModel.isEmpty) {
      return NoInternet(
        handleRefresh: () {
          _checkAndFetch(false);
        },
      );
    }
    if (getCategoryData.isLoading && isInitLoading) {
      return const CommonLoaderGif();
    } else if (getCategoryData.categoryModel == null ||
        getCategoryData.categoryModel.isEmpty) {
      return const NoContentWidget(
        message: "No screeners here yet. Check back soon for something great!",
      );
    } else if (getCategoryData.error != null) {
      return const ErrorScreenWidget();
    } else {
      return RefreshIndicator(
        onRefresh: () => _checkAndFetch(true),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: 
              
              List.generate(
                  getCategoryData.categoryModel.length ?? 0,
                  (categoryindex) => AnimationConfiguration.staggeredList(
                        position: categoryindex,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          horizontalOffset: 200.0,
                          child: FadeInAnimation(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),
                                Text(
                                  getCategoryData.categoryModel[categoryindex]
                                      .categoryName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: ListView.builder(
                                    shrinkWrap:
                                        true, // This makes the ListView take only as much space as needed
                                    // physics: const NeverScrollableScrollPhysics(),
                                    scrollDirection:
                                        Axis.horizontal, // Horizontal scrolling
                                    itemCount: getCategoryData
                                            .categoryModel[categoryindex]
                                            .screeners
                                            .length ??
                                        0,
                                    itemBuilder: (context, screenerindex) =>
                                        GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ScreenersListBaseScreen(
                                              screenerName: getCategoryData
                                                  .categoryModel[categoryindex]
                                                  .categoryName,
                                              index: screenerindex,
                                              screenerCategory: getCategoryData
                                                  .categoryModel[categoryindex]
                                                  .screeners,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 5, 5, 15),
                                        child: _buildScreenerCard(
                                            theme: theme,
                                            description: getCategoryData
                                                    .categoryModel[
                                                        categoryindex]
                                                    .screeners[screenerindex]
                                                    .screenerDescription ??
                                                "",
                                            icon: getCategoryData
                                                    .categoryModel[
                                                        categoryindex]
                                                    .screeners[screenerindex]
                                                    .icon ??
                                                "",
                                            title: getCategoryData
                                                    .categoryModel[
                                                        categoryindex]
                                                    .screeners[screenerindex]
                                                    .name ??
                                                "",
                                            iconColor: Colors.green,
                                            bgColor: theme.shadowColor),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildScreenerCard({
    required String icon,
    required String title,
    required Color iconColor,
    required Color bgColor,
    required String description,
    required ThemeData theme,
  }) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // border: Border.all(color: Colors.grey.shade200),

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
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    //  height: 20,
                    width: MediaQuery.of(context).size.width * 0.08,
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                    ),
                    child: (icon.isEmpty || icon == '')
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              screenersButtonCommoIcon,
                            ),
                          )
                        : CustomImages(
                            imageURL: "$screenerImages?imageName=$icon",
                            fit: BoxFit.cover,
                            aspectRatio: 1,
                          ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title.length > 40 ? "${title.substring(0, 40)}..." : title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
