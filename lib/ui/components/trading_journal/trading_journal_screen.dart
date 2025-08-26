import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:research_mantra_official/data/models/trading_journal/trading_journal_model.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/trading_journal/post/trading_journal_provider.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';

import 'package:research_mantra_official/ui/components/trading_journal/screens/trading_jouranl_entries.dart';
import 'screens/trading_journal_viewer.dart';

class TradingJournalScreen extends ConsumerStatefulWidget {
  const TradingJournalScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TradingJournalScreenState();
}

class _TradingJournalScreenState extends ConsumerState<TradingJournalScreen>
    with TickerProviderStateMixin {
  late final TabController controller;
  int length = 2;
  TradingJournalModel? journalToEdit;
  bool isFromEditingScreen = false;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkAndFetch(false);
    });
  }

  void updateIndex(int index, TradingJournalModel journal) {
    setState(() {
      journalToEdit = journal;
      isFromEditingScreen = true;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      controller.index = index;
      setState(() {
        isFromEditingScreen = false;
      });
    });
  }

  Future<void> _checkAndFetch(bool isRefresh) async {
    final connectivityResult = ref.watch(connectivityStreamProvider);
    final result = connectivityResult.value;

    bool hasConnection = result != ConnectivityResult.none;
    ref
        .read(connectivityProvider.notifier)
        .updateConnectionStatus(hasConnection);

    if (hasConnection) {
      await getJournalData();
    }
  }

  Future<void> getJournalData() async {
    const pageNumber = 1;
    ref
        .read(tradingJournalStateNotifierProvider.notifier)
        .getTradingJournalList(pageNumber);
    ref
        .read(paginationStateNotifierProvider.notifier)
        .updatePageNumber(pageNumber);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasConnection = ref.watch(connectivityProvider);

    if (!hasConnection) {
      return Scaffold(
        appBar: CommonAppBarWithBackButton(
          appBarText: "Trading Journal",
          handleBackButton: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: theme.primaryColor,
        body: NoInternet(
          handleRefresh: () => _checkAndFetch(false),
        ),
      );
    }

    return DefaultTabController(
      length: length,
      child: Scaffold(
        backgroundColor: theme.appBarTheme.backgroundColor,
        appBar: CommonAppBarWithBackButton(
          appBarText: "Trading Journal",
          handleBackButton: () {
            Navigator.pop(context);
          },
        ),
        body: Container(
          color: theme.primaryColor,
          child: Column(
            children: [
              TabBar(
                controller: controller,
                indicatorColor: theme.disabledColor,
                labelColor: theme.disabledColor,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w300),
                unselectedLabelColor: theme.focusColor,
                indicatorPadding: EdgeInsets.zero,
                tabs: const [
                  Tab(icon: Icon(Icons.edit_square), text: 'Entries'),
                  Tab(icon: Icon(Icons.table_chart), text: 'View Records'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: controller,
                  children: [
                    TradingJournalEntries(
                      journalToEdit: journalToEdit,
                      isFromEditingScreen: isFromEditingScreen,
                    ),
                    TradingJournalViewer(
                      onTap: updateIndex,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
