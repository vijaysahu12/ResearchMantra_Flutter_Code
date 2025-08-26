import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/trading_journal/trading_journal_model.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/trading_journal/post/trading_journal_provider.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/components/popupscreens/logout_popup/logout_popup.dart';
import 'package:research_mantra_official/ui/components/trading_journal/screens/trading_journal_downloader.dart';

import 'package:research_mantra_official/ui/components/trading_journal/widgets/trading_journal_card.dart';
import 'package:research_mantra_official/utils/utils.dart';

class TradingJournalViewer extends ConsumerStatefulWidget {
  final void Function(int, TradingJournalModel) onTap;
  const TradingJournalViewer({super.key, required this.onTap});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TradingJournalViewerState();
}

class _TradingJournalViewerState extends ConsumerState<TradingJournalViewer> {
  final _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _mounted = true;
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _mounted = false;
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter == 0 && !_isLoadingMore) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore || !_mounted) return;

    if (_mounted) {
      setState(() => _isLoadingMore = true);
    }

    try {
      bool hasConnection =
          await CheckInternetConnection().checkInternetConnection();
      int value = ref.watch(paginationStateNotifierProvider);
      if (!_mounted) return;

      ref
          .read(connectivityProvider.notifier)
          .updateConnectionStatus(hasConnection);

      if (hasConnection) {
        await ref
            .read(tradingJournalStateNotifierProvider.notifier)
            .getTradingJournalList(++value);
        ref
            .read(paginationStateNotifierProvider.notifier)
            .updatePageNumber(value);
      }
    } catch (e) {
      print("Error loading more data: $e");
    } finally {
      if (_mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  Future<void> _refreshData() async {
    try {
      bool hasConnection =
          await CheckInternetConnection().checkInternetConnection();

      if (!_mounted) return;

      ref
          .read(connectivityProvider.notifier)
          .updateConnectionStatus(hasConnection);

      if (hasConnection) {
        await ref
            .read(tradingJournalStateNotifierProvider.notifier)
            .getTradingJournalList(1);
        ref.read(paginationStateNotifierProvider.notifier).updatePageNumber(1);
      }
    } catch (e) {
      print("Error refreshing data: $e");
    }
  }

  void _deleteEntry(int id) {
    showDialog(
      context: context,
      builder: (context) => CustomPopupDialog(
        title: 'Delete Entry',
        message: 'Are you sure you want to delete this journal entry?',
        confirmButtonText: 'Delete',
        cancelButtonText: 'Cancel',
        onConfirm: () {
          Navigator.pop(context);
          _performDelete(id);
        },
        onCancel: () => Navigator.pop(context),
        buttonColor: Colors.red,
      ),
    );
  }

  // Separate method to handle async delete operation
  Future<void> _performDelete(int id) async {
    if (!_mounted) return;

    try {
      await ref
          .read(tradingJournalStateNotifierProvider.notifier)
          .deleteTradingJournalList(id);
    } catch (e) {
      print("Error deleting entry: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tradingJournalState = ref.watch(tradingJournalStateNotifierProvider);
    final journals = tradingJournalState.tradingJournalResponse ?? [];
    int value = ref.watch(paginationStateNotifierProvider);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: tradingJournalState.isLoading && value == 1
          ? const Center(child: CircularProgressIndicator())
          : journals.isEmpty
              ? RefreshIndicator(
                  onRefresh: _refreshData,
                  child: const NoContentWidget(
                      message: 'No entries found in trading journal'))
              : RefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: journals.length + (journals.length >= 5 ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == journals.length) {
                        // This is the last item, show footer text or loading indicator
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 20),
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: theme.shadowColor,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "You have reached the end",
                              style: TextStyle(
                                color: theme.primaryColorDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }

                      final journal = journals[index];
                      return _buildJournalCard(context, journal);
                    },
                  ),
                ),
      floatingActionButton: journals.isEmpty
          ? null
          : FloatingActionButton.small(
              onPressed:  () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => const TradingJournalDownloader(),
              ),
              backgroundColor: theme.primaryColorDark,
              child: Icon(
                Icons.download,
                color: theme.primaryColor,
              ),
            ),
      //_buildFab(context),
    );
            }

  Widget _buildJournalCard(BuildContext context, TradingJournalModel journal) {
    final theme = Theme.of(context);
    final isBuy = journal.buySellButton == true;
    final profitColor =
        journal.profitLoss?.contains('-') == true ? Colors.red : Colors.green;

    return Padding(
      padding: const EdgeInsets.only(
        top: 14.0,
        left: 12.0,
        right: 12.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.primaryColor,
          border: Border.all(color: theme.shadowColor),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isBuy
                          ? Colors.green.withValues(alpha: 0.2)
                          : Colors.red.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isBuy ? 'BUY' : 'SELL',
                      style: TextStyle(
                        color: isBuy ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    journal.symbol ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    Utils.formatDateTime(
                          format: mmddyyyy,
                          dateTimeString: journal.startDate.toString(),
                        ) ??
                        '',
                    style: TextStyle(
                        color: theme.hintColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                  //const SizedBox(width: 8),
                  SizedBox(
                    height: 28,
                    width: 28,
                    child: PopupMenuButton<String>(
                      color: theme.primaryColor,
                      padding: const EdgeInsets.all(0),
                      icon: Icon(Icons.more_vert, color: theme.hintColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: theme.shadowColor),
                      ),
                      elevation: 8,
                      onSelected: (value) {
                        if (value == 'edit') {
                          widget.onTap(0, journal);
                        } else if (value == 'delete') {
                          _deleteEntry(journal.id ?? 0);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: const [
                              Icon(Icons.edit, size: 18, color: Colors.blue),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: const [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TradingJournalCard(
                        subTitle: 'Entry Price',
                        summary: '₹${journal.entryPrice?.toStringAsFixed(0)}',
                      ),
                    ),
                    Expanded(
                      child: TradingJournalCard(
                        subTitle: 'Stop Loss',
                        summary: '₹${journal.stopLoss?.toStringAsFixed(0)}',
                      ),
                    ),
                    Expanded(
                      child: TradingJournalCard(
                        subTitle: 'Exit Price',
                        summary: '₹${journal.actualExit?.toStringAsFixed(0)}',
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TradingJournalCard(
                        subTitle: 'Capital',
                        summary:
                            '₹${journal.capitalAmount?.toStringAsFixed(0)}',
                      ),
                    ),
                    Expanded(
                      child: TradingJournalCard(
                        subTitle: 'Risk Amount',
                        summary: '₹${journal.riskAmount?.toStringAsFixed(0)}',
                      ),
                    ),
                    Expanded(
                        child: TradingJournalCard(
                            subTitle: 'Actual Exit',
                            summary: '${journal.actualExit}')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TradingJournalCard(
                        subTitle: 'Target 1',
                        summary: '₹${journal.target1?.toString()}',
                      ),
                    ),
                    Expanded(
                      child: TradingJournalCard(
                        subTitle: 'Target 2',
                        summary: '₹${journal.target2?.toString()}',
                      ),
                    ),
                    Expanded(
                      child: TradingJournalCard(
                        subTitle: 'Position Size',
                        summary:
                            '${journal.positionSize?.toStringAsFixed(0)} Qty',
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 12.0, right: 12.0),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: theme.shadowColor,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TradingJournalCard(
                            subTitle: 'P/L',
                            summary: '₹${journal.profitLoss?.toString()}',
                            textColor: profitColor,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TradingJournalCard(
                            subTitle: 'R:R Ratio',
                            summary: '${journal.riskReward}',
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TradingJournalCard(
                            subTitle: 'Risk',
                            summary:
                                '${journal.riskPercentage?.toStringAsFixed(1)}%',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (journal.notes != null && journal.notes?.isNotEmpty == true) ...[
              //const Divider(height: 24),
              TradingJournalCard(
                  subTitle: 'Notes', summary: journal.notes ?? ''),
              SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}
