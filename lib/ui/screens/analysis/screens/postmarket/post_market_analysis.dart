import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/market_analysis/specifc_postmarket_analysis.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/market_analysis/post_market_analysis/post_market_analysis_provider.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/analysis/widget/custom_tabs.dart';
import 'package:research_mantra_official/ui/screens/analysis/widget/stock_list.dart';
import 'package:research_mantra_official/ui/screens/analysis/widget/volume_shocker_widget.dart';
import 'package:research_mantra_official/ui/screens/analysis/widget/widget_container.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class PostMarketAnalysis extends ConsumerStatefulWidget {
  final String id;
  const PostMarketAnalysis({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostMarketAnalysisState();
}

class _PostMarketAnalysisState extends ConsumerState<PostMarketAnalysis>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _checkAndFetchData(false, widget.id);
    });
  }

  Future<void> _checkAndFetchData(isRefresh, String id) async {
    final connectivityResult = ref.watch(connectivityStreamProvider);

    //Checking result based on that displaying connection screen
    final connectionResult = connectivityResult.value;

    bool isConnection = connectionResult != ConnectivityResult.none;
    ref
        .read(connectivityProvider.notifier)
        .updateConnectionStatus(isConnection);
    if (isConnection) {
      await getPostMarketAnalysisById(
          isRefresh, id); // Ensure this method is properly awaiting.
    } else {
      ToastUtils.showToast(noInternetConnectionText, "");
    }
  }

  Future<void> getPostMarketAnalysisById(isRefresh, String id) async {
    if (isRefresh) {
      setState(() {
        isLoading = true;
      });
    }

    await ref
        .read(postMarketAnalysisProvider.notifier)
        .getPostMarketAnalysisData(id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = ref.watch(connectivityProvider);
    final getPostMarketAnalysisData = ref.watch(postMarketAnalysisProvider);

    final theme = Theme.of(context);

    if (!hasConnection) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: theme.primaryColorDark,
                )),
            title: const Text(" Post Market Analysis"),
          ),
          backgroundColor: theme.primaryColor,
          body: NoInternet(
            handleRefresh: () => _checkAndFetchData(false, widget.id),
          ));
    }

    return Scaffold(
        appBar: CommonAppBarWithBackButton(
          appBarText: "Post Market Analysis",
          handleBackButton: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: theme.primaryColor,
        body: buildpostmarket(getPostMarketAnalysisData, isLoading));
  }

  Widget buildpostmarket(getPostMarketAnalysisData, isLoading) {
    if (getPostMarketAnalysisData.isLoading || isLoading) {
      return const CommonLoaderGif();
    } else if (getPostMarketAnalysisData.postMarketAnalysisStockData == null) {
      return RefreshIndicator(
        onRefresh: () => _checkAndFetchData(false, widget.id),
        child: const NoContentWidget(
          message:
              "Post Market Analysis is on its way. Check back later for fresh insights!",
        ),
      );
    } else if (getPostMarketAnalysisData.error != null) {
      return RefreshIndicator(
          onRefresh: () => _checkAndFetchData(false, widget.id),
          child: const ErrorScreenWidget());
    } else {
      return RefreshIndicator(
        onRefresh: () => _checkAndFetchData(false, widget.id),
        child: ListView(
          children: [
            if (getPostMarketAnalysisData
                        .postMarketAnalysisStockData?.topGainers !=
                    null &&
                getPostMarketAnalysisData
                        .postMarketAnalysisStockData?.topLosers !=
                    null) ...[
              WidgetContainer(
                child: CustomTablet(
                    firstStockValue: getPostMarketAnalysisData
                            .postMarketAnalysisStockData?.topGainers ??
                        [],
                    secondStockValue: getPostMarketAnalysisData
                            .postMarketAnalysisStockData?.topLosers ??
                        [],
                    firstname: "Top Gainers",
                    secondName: "Top Loosers"),
              )
            ],
            if (getPostMarketAnalysisData
                        .postMarketAnalysisStockData?.bestPerformer !=
                    null &&
                getPostMarketAnalysisData
                        .postMarketAnalysisStockData?.worstPerformer !=
                    null) ...[
              WidgetContainer(
                child: CustomTablet(
                    firstStockValue: getPostMarketAnalysisData
                            .postMarketAnalysisStockData?.bestPerformer ??
                        [],
                    secondStockValue: getPostMarketAnalysisData
                            .postMarketAnalysisStockData?.worstPerformer ??
                        [],
                    firstname: "Best Performer",
                    secondName: "Worst Performer"),
              )
            ],
            if (getPostMarketAnalysisData
                    .postMarketAnalysisStockData?.volumeShockerdata !=
                null) ...[
              WidgetContainer(
                  child: VolumeListWidget(
                volumeStocks: getPostMarketAnalysisData
                        .postMarketAnalysisStockData?.volumeShockerdata ??
                    [],
              ))
            ]
          ],
        ),
      );
    }
  }
}

class CustomTablet extends StatefulWidget {
  final List<Stock> firstStockValue;
  final List<Stock> secondStockValue;
  final String firstname;
  final String secondName;
  const CustomTablet({
    super.key,
    required this.firstStockValue,
    required this.secondStockValue,
    required this.firstname,
    required this.secondName,
  });

  @override
  State<CustomTablet> createState() => _CustomTabletState();
}

class _CustomTabletState extends State<CustomTablet> {
  List<bool> selectedButton = [true, false];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
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
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: Container(
              decoration: BoxDecoration(
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
              child: Row(
                children: [
                  Expanded(
                    child: CustomTabs(
                      isSelected: selectedButton[0],
                      text: widget.firstname,
                      onTap: () {
                        setState(() {
                          selectedButton[0] = true;
                          selectedButton[1] = false;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomTabs(
                      isSelected: selectedButton[1],
                      text: widget.secondName,
                      onTap: () {
                        setState(() {
                          selectedButton[1] = true;
                          selectedButton[0] = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
              // topRight: Radius.circular(8),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.focusColor.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8.0),
          child: StockList(
              leadingPerformer: selectedButton[0] ? true : false,
              stocks: selectedButton[0]
                  ? widget.firstStockValue
                  : widget.secondStockValue),
        ),
      ],
    );
  }
}
