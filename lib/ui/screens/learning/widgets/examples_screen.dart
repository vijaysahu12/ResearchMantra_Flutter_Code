import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';

import 'package:research_mantra_official/providers/learning/graph/graph_provider.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/indicator_candlestcik_cache_images/indicator_cadnlestick_cache.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/profile/widgets/full_screen_image_dialog.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class ExampleScreen extends ConsumerStatefulWidget {
  final int id;
  final String endPoints;

  const ExampleScreen({super.key, required this.id, required this.endPoints});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends ConsumerState<ExampleScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _checkAndFetch();
    });
  }

  Future<void> _checkAndFetch() async {
    bool checkConnection =
        await CheckInternetConnection().checkInternetConnection();
    ref
        .read(connectivityProvider.notifier)
        .updateConnectionStatus(checkConnection);

    if (checkConnection) {
      await getGraphDataList(); // Ensure this method is properly awaiting
    }
  }

  Future<void> getGraphDataList() async {
    await ref
        .read(getGraphProvider.notifier)
        .getGraphList(widget.endPoints, widget.id);
  }

//Function to open image in another screen
  void showFullScreenImage(BuildContext context, ImageProvider imageProvider) {
    Navigator.of(context).push(MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return FullScreenImageDialog(
            imageProvider: imageProvider,
            imageUrl: '',
          );
        },
        fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = ref.watch(connectivityProvider);
    final getGraphProviderData = ref.watch(getGraphProvider);
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    if (!hasConnection) {
      return const NoContentWidget(
        message: noContentScreenText,
      );
    }
    return Scaffold(
      appBar: CommonAppBarWithBackButton(
        appBarText: examples,
        handleBackButton: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: theme.primaryColor,
      body: getGraphProviderData.isLoading == true
          ? const CommonLoaderGif()
          : RefreshIndicator(
              onRefresh: _checkAndFetch,
              child: getGraphProviderData.error != null ||
                      getGraphProviderData.getAllGraphListData?.length == 0 ||
                      getGraphProviderData.getAllGraphListData == null
                  ? const NoContentWidget(
                      message: noContentScreenText,
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  getGraphProviderData
                                          .getAllGraphListData?.length ??
                                      10,
                                  (index) => getGraphProviderData
                                              .getAllGraphListData?[index]
                                              .imageUrl ==
                                          null
                                      ? const SizedBox.shrink()
                                      : GestureDetector(
                                          onTap: () {
                                            print(
                                                "$getGetLandscapeImage?imageName=${getGraphProviderData.getAllGraphListData?[index].imageUrl}");
                                            showFullScreenImage(
                                              context,
                                              NetworkImage(
                                                  "$getGetLandscapeImage?imageName=${getGraphProviderData.getAllGraphListData?[index].imageUrl}"),
                                            );
                                          },
                                          child: AnimationConfiguration
                                              .staggeredList(
                                            position: index,
                                            duration: const Duration(
                                                milliseconds: 250),
                                            child: SlideAnimation(
                                                verticalOffset: 100.0,
                                                child: FadeInAnimation(
                                                    child: Container(
                                                  margin:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: theme.primaryColor,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: theme.focusColor
                                                            .withOpacity(0.4),
                                                        spreadRadius: 1,
                                                        blurRadius: 1,
                                                        offset:
                                                            const Offset(0, 1),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CacheNetworkImagesForLearningScreen(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        url:
                                                            getGetLandscapeImage,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                        height: width * 0.5,
                                                        imageURL:
                                                            getGraphProviderData
                                                                    .getAllGraphListData?[
                                                                        index]
                                                                    .imageUrl ??
                                                                "",
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          getGraphProviderData
                                                                  .getAllGraphListData?[
                                                                      index]
                                                                  .name ??
                                                              "",
                                                          style:
                                                              textH5.copyWith(
                                                                  fontSize: 12),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ))),
                                          ))))),
                    ),
            ),
    );
  }
}
// 