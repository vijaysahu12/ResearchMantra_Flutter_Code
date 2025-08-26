import 'package:connectivity_plus_platform_interface/src/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/scanners/scanners_history/scanner_history_provider.dart';
import 'package:research_mantra_official/providers/scanners/scanners_strategies/scanners_strategies_state.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/common_error/oops_screen.dart';
import 'package:research_mantra_official/ui/components/dropdown/dropdown.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/scanners/widgets/history/history_filter_data.dart';
import 'package:research_mantra_official/ui/screens/scanners/widgets/history/strategy_dropdown.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class HistoryScannersScreen extends ConsumerStatefulWidget {
  final ScannersStrategiesState allScannersStrategies;

  const HistoryScannersScreen({
    super.key,
    required this.allScannersStrategies,
  });

  @override
  ConsumerState<HistoryScannersScreen> createState() =>
      _HistoryScannersScreenState();
}

class _HistoryScannersScreenState extends ConsumerState<HistoryScannersScreen>
    with WidgetsBindingObserver {
  late final TextEditingController fromDateController;
  late final TextEditingController toDateController;
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  final LayerLink _strategiesLayerLink = LayerLink();
  OverlayEntry? _strategiesListDropDownOverlayEntry;
  final DateFormat dateFormat = DateFormat('dd-MMM-yy');
  DateTime currentDate = DateTime.now();

  bool checkHandleHistory = false;
  String selectedScannerStrategyName = 'All';
  String? selectedScannerStrategyCode = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Set fromDateController to 6 days before yesterday

    fromDateController = TextEditingController(text: _formatDate(7));
    toDateController = TextEditingController(text: _formatDate(1));

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
  }

  String _formatDate(int daysAgo) {
    return dateFormat.format(DateTime.now().subtract(Duration(days: daysAgo)));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        ref
            .read(getScannersHistoryStateNotifierProvider)
            .scannersResponseModel
            .isEmpty) {
      _loadInitialData();
    }
  }

  Future<void> _loadInitialData() async {
    final connectivityResult = ref.watch(connectivityStreamProvider).value;
    final isConnection = connectivityResult != ConnectivityResult.none;
    if (isConnection) {
      await handleHistoryData(selectedScannerStrategyCode,
          fromDateController.text, toDateController.text);
    } else {
      ToastUtils.showToast("No internet connection", '');
    }
  }

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Dynamically create the strategy map from the provided data
  Map<String, String> getStrategyCodeToNameMap() {
    return {
      for (var strategy in widget.allScannersStrategies.getStrategiesResponse)
        strategy.code: strategy.name
    };
  }

  OverlayEntry _strategiesDataListDropdownOverlay() {
    final strategyCodeToNameMap = getStrategyCodeToNameMap();
    return OverlayEntry(builder: (context) {
      final theme = Theme.of(context);
      return Positioned(
        width: MediaQuery.of(context).size.width * 0.4,
        child: CompositedTransformFollower(
          link: _strategiesLayerLink,
          showWhenUnlinked: false,
          offset: const Offset(2, 50),
          child: Material(
            elevation: 4.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
              decoration: BoxDecoration(
                color: theme.shadowColor,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Column(
                children: List.generate(
                    widget.allScannersStrategies.getStrategiesResponse.length,
                    (index) {
                  final strategy =
                      widget.allScannersStrategies.getStrategiesResponse[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownMenuItemWidget(
                        value: widget.allScannersStrategies
                            .getStrategiesResponse[index].code,
                        onSelect: (value) {
                          setState(() {
                            selectedScannerStrategyName =
                                strategyCodeToNameMap[value]!;

                            selectedScannerStrategyCode =
                                value.trim().isEmpty ? null : value;
                          });
                          _strategiesListDropDownOverlayEntry?.remove();
                          _strategiesListDropDownOverlayEntry = null;
                        },
                        displayText: strategyCodeToNameMap[strategy.code] ??
                            strategy.name,
                      ),
                      Divider(
                        height: 1,
                        color: index < strategyCodeToNameMap.length - 1
                            ? Colors.grey // or any visible color
                            : Colors
                                .transparent, // <- ensures same layout for last item
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _selectScannersDropdownValue() {
    if (_strategiesListDropDownOverlayEntry == null) {
      _strategiesListDropDownOverlayEntry =
          _strategiesDataListDropdownOverlay();
      Overlay.of(context).insert(_strategiesListDropDownOverlayEntry!);
    } else {
      handleToRemoveDropDown();
    }
  }

  //handle to remove dropdown
  void handleToRemoveDropDown() {
    _strategiesListDropDownOverlayEntry?.remove();
    _strategiesListDropDownOverlayEntry = null;
  }

  //handle history data
  Future<void> handleHistoryData(
      primaryKey, fromDateController, toDateController) async {
    DateTime fromDate = dateFormat.parse(fromDateController);
    DateTime toDate = dateFormat.parse(toDateController);

    if (fromDate.isAfter(toDate)) {
      // Show an error message or handle it accordingly
      ToastUtils.showToast("Please select a valid date range.", '');
      return;
    }
    String formattedFromDate = DateFormat('yyyy-MM-dd').format(fromDate);
    String formattedToDate = DateFormat('yyyy-MM-dd').format(toDate);
    if (primaryKey == null) {
      ref
          .read(getScannersHistoryStateNotifierProvider.notifier)
          .getScannersHistoryNotification(
              20, 1, null, formattedFromDate, formattedToDate, null);
    } else {
      ref
          .read(getScannersHistoryStateNotifierProvider.notifier)
          .getScannersHistoryNotification(
              20, 1, primaryKey, formattedFromDate, formattedToDate, null);
    }

    if (mounted) {
      setState(() {
        checkHandleHistory = true;
      });
    }
  }

  Future<void> handleRefresh(
      dynamic primaryKey, String fromDate, String toDate) async {
    final String mobileUserPublicKey = await _commonDetails.getPublicKey();
    handleToRemoveDropDown();
    // Parse the date strings to DateTime objects
    DateTime fromDateTime = dateFormat.parse(fromDate);
    DateTime toDateTime = dateFormat.parse(toDate);

    // Format the DateTime objects to the desired format
    String formattedFromDate = DateFormat('yyyy-MM-dd').format(fromDateTime);
    String formattedToDate = DateFormat('yyyy-MM-dd').format(toDateTime);
    if (primaryKey == null) {
      ref
          .read(getScannersHistoryStateNotifierProvider.notifier)
          .getScannersHistoryNotification(20, 1, null, formattedFromDate,
              formattedToDate, mobileUserPublicKey);
    } else {
      ref
          .read(getScannersHistoryStateNotifierProvider.notifier)
          .getScannersHistoryNotification(
            20,
            1,
            primaryKey,
            formattedFromDate,
            formattedToDate,
            mobileUserPublicKey,
          );
    }
  }

  Future<void> onReachScannersEnd(
      String primaryKey, String fromDate, String toDate) async {
    if (!mounted) return;
    final String mobileUserPublicKey = await _commonDetails.getPublicKey();
    // Parse the date strings to DateTime objects
    DateTime fromDateTime = dateFormat.parse(fromDate);
    DateTime toDateTime = dateFormat.parse(toDate);
    // Format the DateTime objects to the desired format
    String formattedFromDate = DateFormat('yyyy-MM-dd').format(fromDateTime);
    String formattedToDate = DateFormat('yyyy-MM-dd').format(toDateTime);
    if (!mounted) return;
    ref
        .read(getScannersHistoryStateNotifierProvider.notifier)
        .getLoadMoreScannersHistoryNotification(
          20,
          1,
          primaryKey,
          formattedFromDate,
          formattedToDate,
          mobileUserPublicKey,
        );
  }

  // Select date
  Future<void> _selectFilterDate(
      BuildContext context, TextEditingController dateController) async {
    final theme = Theme.of(context);
    DateTime lastDate = currentDate.subtract(const Duration(days: 1));

    DateTime initialDate = currentDate;

    try {
      initialDate = dateFormat.parse(dateController.text);
    } catch (e) {
      initialDate = DateTime.now();
    }
    DateTime? pickedDate = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 130),
            padding: const EdgeInsets.symmetric(vertical: 5),
            height: 150,
            width: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: theme.primaryColor,
            ),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: initialDate,
              maximumDate: lastDate,
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  dateController.text = dateFormat.format(newDate);
                });
              },
            ),
          ),
        );
      },
    );

    if (pickedDate != null) {
      dateController.text = dateFormat.format(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectivityResult = ref.watch(connectivityStreamProvider).value;
    final isConnection = connectivityResult != ConnectivityResult.none;
    final theme = Theme.of(context);
    final scannerNotificationList =
        ref.watch(getScannersHistoryStateNotifierProvider);

    return GestureDetector(
      onTap: handleToRemoveDropDown,
      child: Scaffold(
        backgroundColor: theme.primaryColor,
        body: RefreshIndicator(
          onRefresh: () async {
            handleRefresh(
              selectedScannerStrategyCode,
              fromDateController.text,
              toDateController.text,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Column(
              children: [
                SelectScannersStrategiesAndDate(
                  isConnection: isConnection,
                  handleToRemoveDropDown: handleToRemoveDropDown,
                  selectedScannerStrategyName: selectedScannerStrategyName,
                  selectedScannerStrategyCode: selectedScannerStrategyCode,
                  fromDateController: fromDateController,
                  toDateController: toDateController,
                  strategiesLayerLink: _strategiesLayerLink,
                  selectScannersDropdownValue: _selectScannersDropdownValue,
                  selectFilterDate: _selectFilterDate,
                  handleHistoryData: handleHistoryData,
                ),
                const SizedBox(height: 5),
                _buildHistoryScanners(scannerNotificationList, isConnection),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryScanners(scannerNotificationList, bool hasConnection) {
    if (scannerNotificationList.isLoading) {
      return const CommonLoaderGif();
    }

    if (scannerNotificationList.error != null) {
      return const Center(child: ErrorScreenWidget());
    }

    final scanners = scannerNotificationList.scannersResponseModel;
    if (scanners == null || scanners.isEmpty) {
      return const NoContentWidget(message: noHistoryDataText);
    }
    if (!hasConnection && scanners.isEmpty) {
      return Column(
        children: [
          const SizedBox(height: 100),
          NoInternet(
              handleRefresh: () => handleRefresh(
                    selectedScannerStrategyCode,
                    fromDateController.text,
                    toDateController.text,
                  )),
        ],
      );
    }

    return HistoryFilteredScanners(
      isLoadingMore: scannerNotificationList.isLoadmore,
      onReachEnd: () {
        if (hasConnection) {
          onReachScannersEnd(
            selectedScannerStrategyCode ?? '',
            fromDateController.text,
            toDateController.text,
          );
        }
      },
      scannerNotificationList: scannerNotificationList,
    );
  }
}
