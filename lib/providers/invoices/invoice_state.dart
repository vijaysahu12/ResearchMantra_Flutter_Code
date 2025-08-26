import 'package:research_mantra_official/data/models/invoice/invoices_response_model.dart';

class InvoiceState {
  final bool isLoading;
  final dynamic error;
  final bool isLoadingMore;
  final List<GetInvoicesModel> invoices;
  final bool hasReachedEnd;

  const InvoiceState(
      {required this.isLoading,
      required this.error,
      required this.invoices,
      required this.isLoadingMore,
      required this.hasReachedEnd});

  /// Initial default state
  factory InvoiceState.initial() => const InvoiceState(
        isLoading: false,
        error: null,
        invoices: [],
        isLoadingMore: false,
        hasReachedEnd: false,
      );

  /// Loading state
  factory InvoiceState.loading() => const InvoiceState(
        isLoading: true,
        error: null,
        invoices: [],
        isLoadingMore: false,
        hasReachedEnd: false,
      );

  /// Loading state
  factory InvoiceState.loadMore(List<GetInvoicesModel> currentInvoices) =>
      InvoiceState(
        isLoading: false,
        error: null,
        invoices: currentInvoices,
        isLoadingMore: true,
        hasReachedEnd: false,
      );

  /// Error state
  factory InvoiceState.failure(dynamic error) => InvoiceState(
        isLoading: false,
        error: error,
        invoices: [],
        isLoadingMore: false,
        hasReachedEnd: false,
      );

  /// Loaded state with data
  factory InvoiceState.success(
          List<GetInvoicesModel> invoices, bool hasReachedEnd) =>
      InvoiceState(
        isLoading: false,
        error: null,
        invoices: invoices,
        isLoadingMore: false,
        hasReachedEnd: hasReachedEnd,
      );

  /// Optional: copyWith method for easy updates
  InvoiceState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    dynamic error,
    List<GetInvoicesModel>? invoices,
    bool? hasReachedEnd,
  }) {
    return InvoiceState(
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        invoices: invoices ?? this.invoices,
        hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore);
  }
}
