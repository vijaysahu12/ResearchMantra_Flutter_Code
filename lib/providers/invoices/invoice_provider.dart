

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IMybucket_list_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/invoices/invoice_state.dart';

class InvoiceProvider extends StateNotifier<InvoiceState> {
  InvoiceProvider(this._mybucketListRepository) : super(InvoiceState.initial());

  final IMybucketListRepository _mybucketListRepository;

  int page = 1;
  final int pageSize = 10;

  /// Initial fetch (page 1)
  Future<void> fetchInvoices(String mobileUserKey) async {
    try {
      page = 1;
      state = InvoiceState.loading();

      final newInvoices =
          await _mybucketListRepository.getInvoicesByMobileUserKey(
        mobileUserKey,
        page,
        pageSize,
      );

      state = InvoiceState.success(newInvoices, false);
    } catch (e) {
      state = InvoiceState.failure(e);
    }
  }

  /// Load more invoices (pagination)
  Future<void> loadMoreInvoices(String mobileUserKey) async {
    if (state.hasReachedEnd || state.isLoadingMore) return;
    try {
      state = InvoiceState.loadMore(state.invoices);

      page += 1; // increment page

      final newInvoices =
          await _mybucketListRepository.getInvoicesByMobileUserKey(
        mobileUserKey,
        page,
        pageSize,
      );

      final updatedInvoices = [...state.invoices, ...newInvoices];
      // ✅ Check if we received less than pageSize items (i.e., end of data)
      final hasReachedEnd = newInvoices.length < pageSize;
      print("Page Number are $page");
      state = InvoiceState.success(updatedInvoices, hasReachedEnd);
    } catch (e) {
      state = InvoiceState.failure(e);
    }
  }
}

final invoiceStateProvider =
    StateNotifierProvider<InvoiceProvider, InvoiceState>((ref) {
  final IMybucketListRepository repository = getIt<IMybucketListRepository>();
  return InvoiceProvider(repository);
});
