import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/hive_model/blog_hive_model.dart';
import 'package:research_mantra_official/providers/blogs/main/blogs_provider.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/community/community_details/community_provider.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/services/hive_service.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/common_buttons/common_button.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/blogs/screens/bloglist/blog_list.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/screens/blogs/screens/community/community_base_screen.dart';
import 'package:research_mantra_official/ui/screens/blogs/widget/loca_blogs_data.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import '../../components/common_error/no_connection.dart';

// Blogs Screen
class BlogScreenBaseScreen extends ConsumerStatefulWidget {
  const BlogScreenBaseScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BlogScreenBaseScreenState();
}

class _BlogScreenBaseScreenState extends ConsumerState<BlogScreenBaseScreen>
    with TickerProviderStateMixin {
  List<TabData> tabs = [];
  late TabController _tabController;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 1, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkAndFetchData();
    });
  }

  Future<void> _checkAndFetchData() async {
    bool checkConnection =
        await CheckInternetConnection().checkInternetConnection();
    if (!mounted) return; // ⬅️ Prevents access if widget was disposed
    ref
        .read(connectivityProvider.notifier)
        .updateConnectionStatus(checkConnection);

    if (checkConnection) {
      // Wait for both API calls to complete
      final publicKey = await UserSecureStorageService().getPublicKey();

      if (!mounted) return;
      await ref.read(getBlogPostNotifierProvider.notifier).getBlogPosts(
            publicKey,
            1,
            false,
          );
      if (!mounted) return;
      await ref
          .read(communityTypeNotifierProvider.notifier)
          .communityDetailsType();
    }

    // Always add the static blog tab
    tabs.add(TabData(
      index: 0,
      title: const Tab(
        child: Text('Blogs',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      content: const BlogsScreen(),
    ));

    final communityData =
        ref.read(communityTypeNotifierProvider).communityTypeModel;
    if (communityData?.data?.isNotEmpty ?? false) {
      final datamodel = communityData!.data!;
      final postTypeData = communityData.postTypeData ?? [];

      for (int i = 0; i < datamodel.length; i++) {
        tabs.add(TabData(
          index: i + 1,
          title: Tab(
            child: Text('${datamodel[i].productName}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          content: CoummnunityBaseScreen(
            postTypeData: postTypeData,
            productTypeData: datamodel[i],
          ),
        ));
      }

      _tabController = TabController(length: tabs.length, vsync: this);
    }

    setState(() {
      isInitialized = true;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!isInitialized) {
      return Scaffold(
        backgroundColor: theme.primaryColor,
        body: const CommonLoaderGif(),
      );
    }

    return Scaffold(
      appBar: CommonAppBarWithBackButton(
        appBarText: "Market News",
        handleBackButton: () => Navigator.pop(context),
      ),
      backgroundColor: theme.primaryColor,
      body: _buildCommunity(tabs, theme),
    );
  }

  Widget _buildCommunity(List<TabData> tabs, ThemeData theme) {
    return Column(
      children: [
        if (_tabController.length != 1) //Todo:tab
          CustomTabBar(
            tabController: _tabController,
            tabTitles: tabs
                .map((tabData) => (tabData.title.child as Text).data ?? '')
                .toList(),
          ),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(), // 👈 disables swipe

            controller: _tabController,
            children: tabs.map((tabData) => tabData.content).toList(),
          ),
        ),
      ],
    );
  }
}

class BlogsScreen extends ConsumerStatefulWidget {
  const BlogsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlogsScreenState();
}

class _BlogsScreenState extends ConsumerState<BlogsScreen> {
  final UserSecureStorageService _userDetails = UserSecureStorageService();
  final HiveServiceStorage _hiveServiceStorage = HiveServiceStorage();
  List<BlogsHiveModel> locaBlogPosts = [];
  bool isLocalData = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await refreshBlogPosts(false);
    });
  }

  /// Function to handle refreshing the blog list
  Future<void> refreshBlogPosts(isRefresh) async {
    if (!mounted) return; // Prevent further execution if widget is disposed.
    setState(() {
      isLocalData = true;
    });

    final connectivityResult = ref.read(connectivityStreamProvider);
    final connectionResult = connectivityResult.value;
    if (!mounted) return; // Check again after potential delay

    if (connectionResult != ConnectivityResult.none) {
      final String mobileUserPublicKey = await _userDetails.getPublicKey();
      await ref
          .read(getBlogPostNotifierProvider.notifier)
          .getBlogPosts(mobileUserPublicKey, 1, isRefresh);
    } else {
      ToastUtils.showToast(noInternetConnectionText, "");
      if (mounted) {
        setState(() {
          locaBlogPosts = _hiveServiceStorage.getAllBlogsData();
        });
      }
    }
    if (mounted) {
      ref.read(userActivityProvider.notifier).fetchUserData();
    }

    if (mounted) {
      setState(() {
        isLocalData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final hasConnection = ref.watch(connectivityProvider);
    final getBlogState = ref.watch(getBlogPostNotifierProvider);

    final connectivityResult = ref.watch(connectivityStreamProvider);
    final getUserActivity = ref.watch(userActivityProvider);

    //Checking result based on that displaying connection screen
    final connectionResult = connectivityResult.value;

    if (connectionResult == ConnectivityResult.none &&
        locaBlogPosts.isNotEmpty) {
      return Scaffold(
        backgroundColor: theme.appBarTheme.backgroundColor,

        body: RefreshIndicator(
          onRefresh: () => refreshBlogPosts(true),
          child: LocalBlogItemWidget(
            locaPost: locaBlogPosts,
          ),
        ),

        // body: const NoInternet()
      );
    } else if (connectionResult == ConnectivityResult.none &&
        locaBlogPosts.isEmpty &&
        getBlogState.blogApiResponseModel.isEmpty) {
      return NoInternet(
        handleRefresh: () => refreshBlogPosts(true),
      );
    } else if (getBlogState.isLoading && isLocalData) {
      return const CommonLoaderGif();
    } else if (getBlogState.error != null) {
      return const ErrorScreenWidget();
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => refreshBlogPosts(true),
        child: BlogScreenListWidget(
          getUserActivity: getUserActivity,
          progressState: getBlogState.isAddingPost ||
              (getBlogState.isBeingReported ?? false) ||
              getBlogState.isEditPost ||
              getBlogState.isDeletePost ||
              getBlogState.isUserBlock,
          post: getBlogState.blogApiResponseModel,
          onReachEnd: () async {
            final String mobileUserPublicKey =
                await _userDetails.getPublicKey();
            if (connectionResult != ConnectivityResult.none) {
              if (!getBlogState.isLoadingMore) {
                ref
                    .read(getBlogPostNotifierProvider.notifier)
                    .loadMoreBlogs(mobileUserPublicKey);
              }
            }
          },
          isLoadingMore: getBlogState.isLoadingMore,
        ),
      ),
    );
  }
}
