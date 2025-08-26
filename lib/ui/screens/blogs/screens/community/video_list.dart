import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/community/community_type_model.dart';
import 'package:research_mantra_official/data/models/payment_model/payment_model.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/community/recorded_video/recorded_video_provider.dart';
import 'package:research_mantra_official/providers/payment_gateway/payment_gateway_provider.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/services/no_screen_shot.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/blogs/widget/circular_progress_indicator.dart';
import 'package:research_mantra_official/ui/screens/blogs/widget/unlock_buttton.dart';
import 'package:research_mantra_official/ui/screens/blogs/widget/video_tile.dart';

class VideoListScreen extends ConsumerStatefulWidget {
  final PostType announcemtPostType;
  final Product productTypeData;
  const VideoListScreen(
      {super.key,
      required this.announcemtPostType,
      required this.productTypeData});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VideoListScreenState();
}

class _VideoListScreenState extends ConsumerState<VideoListScreen>
    with RouteAware {
  bool isLoading = true;
  int pageNumber = 1;
  late final ScrollController scrollController;
  late final ({int productId, int postTypeId}) ids;

  //NO screen shot enabled
  final noScreenshotUtil = NoScreenshotUtil();

  void disableScreenshots() async {
    await noScreenshotUtil.disableScreenshots();
  }

  void enableScreenshots() async {
    await noScreenshotUtil.enableScreenshots();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    enableScreenshots();
    routeObserver.unsubscribe(this);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    PaymentResponseModel? product =
        ref.watch(paymentStatusNotifier).paymentResponseModel;
    // or call your API here
    if (product?.paymentStatus?.toLowerCase() == "success" &&
        widget.productTypeData.productId == product?.productId) {
      _checkAndFetch(false);
    }
  }

  @override
  void initState() {
    super.initState();
    disableScreenshots();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    ids = (
      productId: widget.productTypeData.productId ?? 0,
      postTypeId: widget.announcemtPostType.id ?? 0,
    );
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
      await getCommunityData();
    }
  }

  Future<void> getCommunityData() async {
    pageNumber = 1;

    await ref.read(recordedVideoDataNotifierProvider.notifier).communityData(
        10,
        pageNumber,
        widget.productTypeData.productId ?? 0,
        widget.announcemtPostType.id ?? 0);
    setState(() {
      isLoading = false;
    });
  }

  void _scrollListener() {
    if (scrollController.position.extentAfter == 0) {
      loadMorePost();
    }
  }

  Future<void> loadMorePost() async {
    bool checkConnection =
        await CheckInternetConnection().checkInternetConnection();
    ref
        .read(connectivityProvider.notifier)
        .updateConnectionStatus(checkConnection);

    if (checkConnection) {
      await ref
          .read(recordedVideoDataNotifierProvider.notifier)
          .loadMoreCommunityData(
              10,
              ++pageNumber,
              widget.productTypeData.productId ?? 0,
              widget.announcemtPostType.id ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final getCommunityDataState = ref.watch(recordedVideoDataNotifierProvider);

    final hasConnection = ref.watch(connectivityProvider);

    final width = MediaQuery.of(context).size.width;

    if (!hasConnection) {
      return NoInternet(
        handleRefresh: () => _checkAndFetch(true),
      );
    }
    return RefreshIndicator(
      onRefresh: () => _checkAndFetch(true),
      child: Scaffold(
        backgroundColor: theme.primaryColor,
        body: _buildCommunityVideos(
            getCommunityDataState,
            theme,
            width,
            scrollController,
            context,
            widget.productTypeData,
            _checkAndFetch,
            isLoading),
      ),
    );
  }
}

Widget _buildCommunityVideos(getCommunityDataState, theme, width,
    scrollController, context, productTypeData, checkAndFetc, isLoading) {
  // Handle loading state
  if (getCommunityDataState.isLoading) {
    return const CommonLoaderGif();
  }

  // Handle error state
  if (getCommunityDataState.error != null) {
    return const ErrorScreenWidget();
  }

  final communityModel = getCommunityDataState.getCommunityDataModel;

  // Handle null model
  if (communityModel == null) {
    return const NoContentWidget(message: noContentScreenText);
  }

  // Check if user has access to premium content
  if (communityModel.hasAccessToPremiumContent == false) {
    return Center(
      child: UnlockItems(
        productName: communityModel.communityName,
        communityProductId: communityModel.communityId ?? 0,
      ),
    );
  }

  // Handle null or empty posts
  final posts = communityModel.posts;
  if (posts == null || posts.isEmpty) {
    return const NoContentWidget(message: noContentScreenText);
  }

  return Stack(
    children: [
      ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          // padding: EdgeInsets.all(15),
          controller: scrollController,
          itemCount:
              getCommunityDataState.getCommunityDataModel?.posts.length ?? 0,
          itemBuilder: (context, index) {
            if (index ==
                (getCommunityDataState.getCommunityDataModel?.posts?.length ??
                    0)) {
              return buildLoadMoreIndicator(getCommunityDataState);
            }
            final announcement =
                getCommunityDataState.getCommunityDataModel?.posts?[index];

            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: VideoTile(
                videos: announcement,
              ),
            );
          }),
    ],
  );
}
