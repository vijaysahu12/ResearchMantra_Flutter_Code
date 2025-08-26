import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/community/community_type_model.dart';
import 'package:research_mantra_official/data/models/payment_model/payment_model.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/community/all_community/all_community_provider.dart';
import 'package:research_mantra_official/providers/payment_gateway/payment_gateway_provider.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/community/common_floating_button.dart';
import 'package:research_mantra_official/ui/components/community/common_post_screen.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/blogs/widget/circular_progress_indicator.dart';
import 'package:research_mantra_official/ui/screens/blogs/widget/post_tile.dart';
import 'package:research_mantra_official/ui/screens/blogs/widget/unlock_buttton.dart';
import 'package:research_mantra_official/ui/screens/research/widgets/custom_book_mark.dart';

class AnnouncementScreen extends ConsumerStatefulWidget {
  final PostType announcemtPostType;
  final Product productTypeData;
  const AnnouncementScreen(
      {super.key,
      required this.announcemtPostType,
      required this.productTypeData});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AnnouncementScreenState();
}

class _AnnouncementScreenState extends ConsumerState<AnnouncementScreen>
    with RouteAware {
  bool isLoading = true;
  late final ScrollController scrollController;
  int pageNumber = 1;
  late final ({int productId, int postTypeId}) ids;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);

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

  void _scrollListener() {
    if (scrollController.position.extentAfter == 0) {
      loadMorePost();
    }
  }

  void upScrollController() {
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  Future<void> loadMorePost() async {
    bool checkConnection =
        await CheckInternetConnection().checkInternetConnection();
    ref
        .read(connectivityProvider.notifier)
        .updateConnectionStatus(checkConnection);

    if (checkConnection) {
      await ref
          .read(allCommunityDataNotifierProvider.notifier)
          .loadMoreCommunityData(
              10,
              ++pageNumber,
              widget.productTypeData.productId ?? 0,
              widget.announcemtPostType.id ?? 0);
    }
  }

  Future<void> getCommunityData() async {
    pageNumber = 1;
    await ref.read(allCommunityDataNotifierProvider.notifier).communityData(
        10,
        pageNumber,
        widget.productTypeData.productId ?? 0,
        widget.announcemtPostType.id ?? 0);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
    scrollController.removeListener(_scrollListener);
    scrollController.dispose(); // Dispose of ScrollController
  }

  Color postTypeColor(String postType) {
    switch (postType) {
      case "Pending":
        return Colors.orange;
      case "Approved":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.transparent;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    // Called when returning to this screen
    PaymentResponseModel? product =
        ref.watch(paymentStatusNotifier).paymentResponseModel;
    // or call your API here

    if (product?.paymentStatus?.toLowerCase() == "success" &&
        widget.productTypeData.productId == product?.productId) {
      _checkAndFetch(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final communityState = ref.watch(allCommunityDataNotifierProvider);
    final hasConnection = ref.watch(connectivityProvider);

    if (!hasConnection) {
      return NoInternet(
        handleRefresh: () => _checkAndFetch(true),
      );
    }
    if (communityState.isLoading || isLoading) {
      return const CommonLoaderGif();
    }

    // Handle error state
    if (communityState.error != null) {
      return const ErrorScreenWidget();
    }

    final communityModel = communityState.getCommunityDataModel;

    // Handle null model or posts
    if (communityModel == null) {
      return const NoContentWidget(message: noContentScreenText);
    }

    return RefreshIndicator(
      onRefresh: () => _checkAndFetch(true),
      child: Scaffold(
        backgroundColor: theme.primaryColor,
        body: Column(
          children: [
            communityState.otheractions == true
                ? LinearProgressIndicator(
                    color: theme.focusColor.withOpacity(0.4),
                  )
                : SizedBox.shrink(),
            Expanded(
                flex: 2,
                child: _buildCommunityContent(
                    communityModel, theme, communityState)),
          ],
        ),
        floatingActionButton: _buildForFloatButton(theme, communityModel),
      ),
    );
  }

  Widget _buildCommunityContent(
      communityModel, ThemeData theme, communityState) {
    // Handle loading state

    // Check if user purchased the product
    if (communityModel.hasPurchasedProduct == false) {
      return Center(
        child: UnlockItems(
          productName: communityModel.communityName ?? '',
          communityProductId: communityModel.communityId ?? 0,
        ),
      );
    }

    // Handle empty posts
    final posts = communityModel.posts;
    if (posts == null || posts.isEmpty) {
      return const NoContentWidget(message: noContentScreenText);
    }

    // Build list of posts
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(10),
      itemCount: posts.length ?? 0,
      itemBuilder: (context, index) {
        if (index == posts.length) {
          return buildLoadMoreIndicator(communityState);
        }

        final announcement = posts[index];

        return _buildAnnouncementCard(announcement, theme);
      },
    );
  }

  Widget _buildAnnouncementCard(announcement, ThemeData theme) {
    return Stack(
      // alignment: Alignment(1, -0.99),
      children: [
        Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.primaryColor,
            border: Border.all(color: theme.focusColor.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: PostTile(announcement: announcement),
        ),
        if (announcement.isApproved != "Approved")
          Positioned(
            top: 2,
            right: 4,
            child: CustombookMark(
                bookMarkName: announcement.isApproved ?? "No Value",
                bookMarkColor: postTypeColor(announcement.isApproved ?? "")
                // theme.secondaryHeaderColor,
                ),
          ),
      ],
    );
  }

  //Widget for floating button
  Widget _buildForFloatButton(theme, communityModel) {
    return communityModel.canPost
        ? CommonFloatingButton(
            onPressed: () => _navigateToBlogPostScreen(
                (communityModel.communityId ?? 0).toString()),
          )
        : Container();
  }

  //function navigate to blog post screen
  void _navigateToBlogPostScreen(String productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommonPostScreen(
          existingContent: '',
          existingBlogId: '',
          existingImages: [],
          productId: productId,
          onPostSuccess: (aspectRatio) {
            upScrollController();
            // Handle post success
            // Navigator.pop(context);
          },
          isPostType: 'communit',
        ),
      ),
    );
  }
}
