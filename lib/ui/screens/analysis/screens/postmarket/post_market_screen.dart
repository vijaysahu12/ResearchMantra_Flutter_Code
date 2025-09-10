import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/market_analysis/post_market_analysis/all_post_market_provider.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/analysis/widget/post_market_tile.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class AllPostMarketAnalysis extends ConsumerStatefulWidget {
  const AllPostMarketAnalysis({super.key});

  @override
  ConsumerState<AllPostMarketAnalysis> createState() =>
      _AllPostMarketAnalysisState();
}

class _AllPostMarketAnalysisState extends ConsumerState<AllPostMarketAnalysis> {
  // bool isLoading = false;
  late ScrollController _scrollController;
  int pageNumber = 1;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _checkAndFetchData(false, 1);
    });

    _scrollController.addListener(_scrollListener);
  }

  Future<void> _checkAndFetchData(isRefresh, int id) async {
    final connectivityResult = ref.watch(connectivityStreamProvider);

    //Checking result based on that displaying connection screen
    final connectionResult = connectivityResult.value;

    bool isConnection = connectionResult != ConnectivityResult.none;
    ref
        .read(connectivityProvider.notifier)
        .updateConnectionStatus(isConnection);
    if (isConnection) {
      await getAllPostMarketAnalysis(
          isRefresh, id); // Ensure this method is properly awaiting.
    } else {
      ToastUtils.showToast(noInternetConnectionText, "");
    }
  }

  Future<void> getAllPostMarketAnalysis(isRefresh, int id) async {
    // if (isRefresh) {
    //   setState(() {
    //     isLoading = true;
    //   });
    // }
    await ref
        .read(allPostMarketAnalysisProvider.notifier)
        .getAllPostMarketAnalysisData(
          id,
        );

    // setState(() {
    //   isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final allAnalysisData = ref.watch(allPostMarketAnalysisProvider);

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: buildListAnalysis(allAnalysisData, theme),
    );
  }

  Widget buildListAnalysis(allAnalysisData, theme) {
    if (allAnalysisData.isLoading) {
      return const CommonLoaderGif();
    } else if (allAnalysisData.allpostmarketStockreport == null ||
        allAnalysisData.allpostmarketStockreport.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          pageNumber = 1;
          await _checkAndFetchData(true, 1);
        },
        child: const NoContentWidget(
          message:
              " Post Market Analysis is on its way. Check back later for fresh insights!",
        ),
      );
    } else if (allAnalysisData.error != null) {
      return const ErrorScreenWidget();
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          pageNumber = 1;
          await _checkAndFetchData(true, 1);
        },
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(8.0),
          itemCount: allAnalysisData.allpostmarketStockreport!.length ?? 0,
          itemBuilder: (context, index) {
            final data = allAnalysisData.allpostmarketStockreport?[index];

            return PostMarketTile(data: data);
          },
        ),
      );
    }
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter == 0) {
      print('PAGINATION LOGIC --$pageNumber');
      _checkAndFetchData(false, ++pageNumber);
    }
  }
}
