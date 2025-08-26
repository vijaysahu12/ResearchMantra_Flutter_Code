import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/invoice/invoices_response_model.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/invoices/invoice_provider.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/common_error/no_connection.dart';
import 'package:research_mantra_official/ui/components/empty_invoices.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/screens/profile/screens/mybuckets/widget/invoice_history_card.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import 'package:research_mantra_official/utils/utils.dart';

class InvoiceHistoryScreen extends ConsumerStatefulWidget {
  const InvoiceHistoryScreen({super.key});

  @override
  ConsumerState<InvoiceHistoryScreen> createState() =>
      _InvoiceHistoryScreenState();
}

class _InvoiceHistoryScreenState extends ConsumerState<InvoiceHistoryScreen> {
  bool isLoading = true;
  final UserSecureStorageService _commonDetails = UserSecureStorageService();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadPaymentData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadPaymentData() async {
    setState(() => isLoading = true);

    try {
      final connectionResult = ref.read(connectivityStreamProvider).value;

      if (connectionResult != ConnectivityResult.none) {
        final mobileUserPublicKey = await _commonDetails.getPublicKey();
        await ref
            .read(invoiceStateProvider.notifier)
            .fetchInvoices(mobileUserPublicKey);
      } else {
        ToastUtils.showToast(noInternetConnectionText, "");
      }
    } catch (e) {
      print('Error loading payment data: $e');
      // Optionally show error to user
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // Scroll listener function to detect reaching the end of the list
  void _scrollListener() {
    final invoiceState = ref.read(invoiceStateProvider);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !invoiceState.isLoadingMore &&
        !invoiceState.hasReachedEnd) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    final mobileUserPublicKey = await _commonDetails.getPublicKey();
    await ref
        .read(invoiceStateProvider.notifier)
        .loadMoreInvoices(mobileUserPublicKey);
    print("calling loadmoree");
  }

  @override
  void dispose() {
    _scrollController
        .dispose(); // Dispose the controller when widget is removed
    super.dispose();
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ToastUtils.showToast(copiedTransactionIdtext, "");
  }

  void _downloadInvoice(String downloadUrl, String productName) {
    if (downloadUrl.isNotEmpty) {
      downloadAndShareFile(
        downloadUrl,
        fileName: '$productName.pdf',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final invoiceState = ref.watch(invoiceStateProvider);
    final bool isDataLoading = invoiceState.isLoading || isLoading;
    final bool isEmpty = invoiceState.invoices.isEmpty;

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: isDataLoading
          ? const CommonLoaderGif()
          : isEmpty
              ? EmptyInvoiceHistoryView()
              : _buildInvoiceList(invoiceState.invoices, invoiceState),
    );
  }

  Widget _buildInvoiceList(List<GetInvoicesModel> invoices, invoiceState) {
    final connectivityResult = ref.watch(connectivityStreamProvider);
    final result = connectivityResult.value;
    if (result == ConnectivityResult.none) {
      return NoInternet(handleRefresh: () => _loadPaymentData());
    }

    return RefreshIndicator(
      onRefresh: _loadPaymentData,
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(4),
          itemCount: invoices.length,
          itemBuilder: (context, index) {
            final payment = invoices[index];

            return InvoicePaymentHistoryCard(
              payment: payment,
              onDownload: _downloadInvoice,
              onCopy: _copyToClipboard,
            );
          },
        ),
      ),
    );
  }
}
