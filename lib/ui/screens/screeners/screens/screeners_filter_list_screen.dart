import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/screeners/screeners_category_data_model.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/screeners/screeners_stock/screeners_stock_provider.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/screens/screeners/widgets/screeners_description_widget.dart';
import 'package:research_mantra_official/ui/screens/screeners/widgets/shimmer_widget.dart';
import 'package:research_mantra_official/ui/screens/screeners/widgets/stock_heading.dart';
import 'package:research_mantra_official/ui/screens/screeners/widgets/stock_tile.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import 'package:research_mantra_official/utils/utils.dart';

class ScreenerFilterScreen extends ConsumerStatefulWidget {
  final Screener screenerCategory;

  const ScreenerFilterScreen({
    super.key,
    required this.screenerCategory,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScreenerFilterScreenState();
}

class _ScreenerFilterScreenState extends ConsumerState<ScreenerFilterScreen> {
  bool isInitLoading = true;

  // Refresh Function
  Future<void> checkAndFetch(bool isRefresh) async {
    final connectivityResult = ref.watch(connectivityStreamProvider);
    final connectionResult = connectivityResult.value;

    bool isConnection = connectionResult != ConnectivityResult.none;
    ref
        .read(connectivityProvider.notifier)
        .updateConnectionStatus(isConnection);

    if (isConnection) {
      await getScreenerData(
          isRefresh); // Ensure this method is properly awaited.
    } else {
      ToastUtils.showToast(noInternetConnectionText, "");
    }
  }

  Future<void> getScreenerData(bool isRefresh) async {
    if (isRefresh) {
      if (mounted) {
        setState(() {
          isInitLoading = true;
        });
      }
    }

    await ref.read(screenerStockProvider.notifier).getStock(
        widget.screenerCategory.id ?? 0,
        widget.screenerCategory.code ?? "20");
      if (mounted) {
      setState(() {
        isInitLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await checkAndFetch(false); // Initial data fetch
    });
  }

  // Handling Refresh
  Future<void> _handleRefresh() async {
    await checkAndFetch(true); // Trigger refresh
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final getScreenerStockData = ref.watch(screenerStockProvider);
print("fdjfdjfd");
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: RefreshIndicator(
        onRefresh: _handleRefresh, // Connect the refresh functionality
        child: ListView(
          // Using ListView instead of SingleChildScrollView to allow pull-to-refresh from anywhere
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            ScreenDescription(
              image: widget.screenerCategory.icon,
              color: Utils.hexToColor(
                  widget.screenerCategory.backgroundColor ?? "#3a813a"),
              screenerCategory: widget.screenerCategory.name ?? "",
              description: widget.screenerCategory.screenerDescription ?? "",
              numberOfStocks: getScreenerStockData.stockModel.length.toString(),
            ),
            const SizedBox(height: 10),
            const StockHeading(),
            _buildScreenerStock(getScreenerStockData),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenerStock(getScreenerStockData) {
    if (getScreenerStockData.isLoading && isInitLoading) {
      return Column(
          children: List.generate(
        10,
        ((index) => ShimmerStockTile(
              color: Utils.hexToColor(
                  widget.screenerCategory.backgroundColor ?? "#3a813a"),
            )),
      ));
    } else if (getScreenerStockData.stockModel == null ||
        getScreenerStockData.stockModel.isEmpty) {
      return const NoContentWidget(
        message:
            "Stocks are currently unavailable. Thank you for your patience",
      );
    } else if (getScreenerStockData.error != null) {
      return const ErrorScreenWidget();
    }

    return Column(
      children: List.generate(
        getScreenerStockData.stockModel.length ?? 0,
        (index) => StockTile(
          stocksymbol: getScreenerStockData.stockModel[index].symbol ?? "",
          chartUrl: getScreenerStockData.stockModel[index].chartUrl ?? "",
          realTimeUpdates:
              getScreenerStockData.stockModel[index].triggerPrice == null
                  ? ""
                  : getScreenerStockData.stockModel[index].triggerPrice
                      .toString(),
          stockLogo: getScreenerStockData.stockModel[index].logo ?? "",
          netChange: getScreenerStockData.stockModel[index].netChange == null
              ? ""
              : getScreenerStockData.stockModel[index].netChange.toString(),
          profitPercent:
              getScreenerStockData.stockModel[index].percentageChange == null
                  ? ""
                  : getScreenerStockData.stockModel[index].percentageChange
                      .toString(),
          stockName: getScreenerStockData.stockModel[index].name ?? "",
          lastUpdated: getScreenerStockData.stockModel[index].modifiedOn,
        ),
      ),
    );
  }
}
