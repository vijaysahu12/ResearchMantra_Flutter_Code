import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/scanners/scanners_history/scanner_history_state.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/router/app_routes.dart';
import 'package:research_mantra_official/ui/screens/scanners/screens/widgets/common_scanner_container.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class HistoryFilteredScanners extends StatefulWidget {
  final ScannersHistoryState scannerNotificationList;
  final VoidCallback onReachEnd;
  final bool isLoadingMore;

  const HistoryFilteredScanners({
    super.key,
    required this.scannerNotificationList,
    required this.onReachEnd,
    required this.isLoadingMore,
  });

  @override
  State<HistoryFilteredScanners> createState() =>
      _HistoryFilteredScannersState();
}

class _HistoryFilteredScannersState extends State<HistoryFilteredScanners> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if (widget.scannerNotificationList.scannersResponseModel.isNotEmpty) {
      widget.scannerNotificationList.scannersResponseModel.clear();
    }
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter == 0) {
      widget.onReachEnd();
    }
  }

  String getMessagePreview(String description,
      {int maxLength = 6, int previewLength = 5}) {
    try {
      if (description.length > maxLength) {
        return '${description.substring(0, previewLength)}..';
      } else {
        return description;
      }
    } catch (e) {
      return description;
    }
  }

  //get item cpunt
  int _getItemCount() {
    return widget.scannerNotificationList.scannersResponseModel.length + 1;
  }

  @override
  Widget build(BuildContext context) {


    if (widget.scannerNotificationList.scannersResponseModel.isEmpty) {
      return const NoContentWidget(message: noHistoryDataText);
    }

    return Expanded(
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _getItemCount(),
        itemBuilder: (context, index) {
          if (index <
              widget.scannerNotificationList.scannersResponseModel.length) {
            final allNotificationScanners =
                widget.scannerNotificationList.scannersResponseModel[index];

            return CommonScannerContainer(
              tradingSymbol: allNotificationScanners.tradingSymbol ?? "",
              price: allNotificationScanners.price ?? "--",
              message: allNotificationScanners.message ?? "",
              createdOn: allNotificationScanners.createdOn?.toString() ?? "--",
              viewChartUrl: allNotificationScanners.viewChart,
              onChartTap: (url, symbol) {
                Navigator.pushNamed(
                  context,
                  webviewscreen,
                  arguments: url,
                );
              },
            );

            // _buildListItem(allNotificationScanners, fontSize, theme);
          } else if (widget.isLoadingMore) {
            return _buildLoadMoreIndicator(context);
          } else if (widget.scannerNotificationList.isLoading) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            );
          } else {
            return null;
          }
        },
        controller: _scrollController,
      ),
    );
  }

//Build for load more indicator
  Widget _buildLoadMoreIndicator(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            'Loading...',
            style: TextStyle(
                color: theme.primaryColorDark,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
