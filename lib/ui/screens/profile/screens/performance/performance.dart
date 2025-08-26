import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/perfomance/performance_data/perfomance_provider.dart';
import 'package:research_mantra_official/providers/perfomance/performance_header/performance_header_provider.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/common_buttons/common_button.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/performance/widget/circle_graph.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/performance/widget/perfomance_values.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class PerformanceScreen extends ConsumerStatefulWidget {
  final int perfomanceValueId;
  const PerformanceScreen({super.key, required this.perfomanceValueId});

  @override
  ConsumerState<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends ConsumerState<PerformanceScreen> {
  int selectedIndex = 0;
  bool isLoading = true;
  String? initailCode;

  // late PageController pageController;

  @override
  void initState() {
    super.initState();
    // pageController = PageController(initialPage: selectedIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool checkConnection =
          await CheckInternetConnection().checkInternetConnection();

      ref
          .read(connectivityProvider.notifier)
          .updateConnectionStatus(checkConnection);

      if (checkConnection) {
        await ref
            .read(performanceHeaderStateNotifierProvider.notifier)
            .getPerfomanceHeadersList();

        final getPerfomanceHeadersData =
            ref.read(performanceHeaderStateNotifierProvider);
        if (getPerfomanceHeadersData.getPerformanceHeaders.isNotEmpty) {
          initailCode = getPerfomanceHeadersData.getPerformanceHeaders[0].code;

          await ref
              .read(performanceStateNotifierProvider.notifier)
              .getPerformanceDetail(initailCode!);
        }
      }
    });
  }

  @override
  void dispose() {
    // pageController.dispose();
    super.dispose();
  }

  //Function to handle to refresh
  void handleToRefresh(selectedIndex, connectionResult) async {
    if (connectionResult == ConnectivityResult.none) {
      ToastUtils.showToast(noInternetConnectionText, "");
    } else {
      ref
          .read(performanceStateNotifierProvider.notifier)
          .getPerformanceDetail(selectedIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final connectivityResult = ref.watch(connectivityStreamProvider).value;
    final performanceData = ref.watch(performanceStateNotifierProvider);
    final performanceHeadersData =
        ref.watch(performanceHeaderStateNotifierProvider);

    // Extract button labels and codes
    final headers = performanceHeadersData.getPerformanceHeaders;
    final buttonLabels = headers.map((header) => header.name ?? '--').toList();
    final codes = headers.map((header) => header.code).toList();

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: performanceText,
        handleBackButton: () => Navigator.pop(context),
      ),
      body: _buildBody(connectivityResult, performanceHeadersData,
          performanceData, theme, buttonLabels, codes),
    );
  }

  Widget _buildBody(
      ConnectivityResult? connectionResult,
      performanceHeadersData,
      performanceData,
      ThemeData theme,
      List<String> buttonLabels,
      codes) {
    if (connectionResult == ConnectivityResult.none &&
        performanceData.perfomanceResponseModel == null) {
      return NoInternet(
          handleRefresh: () => handleToRefresh(initailCode, connectionResult));
    }

    return RefreshIndicator(
      onRefresh: () async => handleToRefresh(initailCode, connectionResult),
      child: performanceHeadersData.isLoading
          ? _buildLoading()
          : Column(
              children: [
                const SizedBox(height: 5),
                ScrollableButtonList(
                  buttonLabels: buttonLabels,
                  selectedIndex: selectedIndex,
                  onButtonTap: (index) {
                    setState(() {
                      selectedIndex = index;
                      initailCode = codes[index];
                    });

                    ref
                        .read(performanceStateNotifierProvider.notifier)
                        .getPerformanceDetail(codes[index]);
                  },
                  theme: theme,
                ),
                if (performanceData.isLoading && isLoading)
                  _buildLoading()
                else
                  Expanded(
                      child:
                          _buildPerfomanceInformation(performanceData, theme)),
              ],
            ),
    );
  }

  //Widget For EntireData
  Widget _buildPerfomanceInformation(getPerfomanceData, theme) {
    if (getPerfomanceData.perfomanceResponseModel == null &&
        getPerfomanceData.isLoading == false) {
      return const NoContentWidget(message: noPerformance);
    } else if (getPerfomanceData.error != null) {
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          const ErrorScreenWidget(),
        ],
      );
    } else {
      return Column(
        children: [
          TradeStats(
            balance: getPerfomanceData.perfomanceResponseModel!.balance,
            totalTrades: getPerfomanceData
                    .perfomanceResponseModel!.statistics!.totalTrades ??
                0,
            profitableTrades: getPerfomanceData
                    .perfomanceResponseModel!.statistics!.totalProfitable ??
                0,
            lossTrades: getPerfomanceData
                    .perfomanceResponseModel!.statistics!.totalLoss ??
                0,
            closedTrades: getPerfomanceData
                    .perfomanceResponseModel!.statistics!.tradeClosed ??
                0,
            tradeOpen: getPerfomanceData
                    .perfomanceResponseModel.statistics.tradeOpen ??
                0,
          ),
          Expanded(
            child: Scrollbar(
              child: _buildTradeStocksData(
                  getPerfomanceData.perfomanceResponseModel.trades),
            ),
          )
        ],
      );
    }
  }

  //Widget for Stcoks
  Widget _buildTradeStocksData(trades) {
    return ListView.builder(
        itemCount: trades.length,
        itemBuilder: (context, index) {
          return TradingCard(
            companyName: trades[index].symbol ?? '--',
            duration: trades[index].duration ?? '--',
            investmentMessage: trades[index].investmentMessage ?? '--',
            roi: trades[index].roi ?? '0',
            entryPrice: trades[index].entryPrice ?? '--',
            cmp: trades[index].cmp ?? 0,
            isOpen: trades[index].status,
          );
        });
  }

  //Widget for loading State
  Widget _buildLoading() {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
        ),
        const CommonLoaderGif(),
      ],
    );
  }
}
