import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/trading_journal/post/trading_journal_provider.dart';
import 'package:research_mantra_official/ui/components/trading_journal/service/generate_excel_file_service.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class TradingJournalDownloader extends ConsumerStatefulWidget {
  const TradingJournalDownloader({super.key});

  @override
  ConsumerState<TradingJournalDownloader> createState() =>
      _TradingJournalDownloaderState();
}

class _TradingJournalDownloaderState
    extends ConsumerState<TradingJournalDownloader> {
  DateTime? startDate;
  DateTime? endDate;

  Future<void> _downloadExcel() async {
    if (isValidDateRange()) {
      try {
        await ref
            .read(tradingJournalStateNotifierProvider.notifier)
            .getDownloadJournalList(
                startDate ?? DateTime.now(), endDate ?? DateTime.now());

        final updatedJournals = ref
                .read(tradingJournalStateNotifierProvider)
                .tradingJournalDownloadResponse ??
            [];

        if (updatedJournals.isNotEmpty) {
          ExcelGenerator.generateExcel(updatedJournals);
        } else {
          ToastUtils.showToast("No data found for selected range", "");
        }
      } catch (error) {
        ToastUtils.showToast("Error occurred: $error", "");
      }
    }
  }

  bool isValidDateRange() {
    // No dates selected yet
    if (startDate == null || endDate == null) return false;

    // End date must be after start date
    if (endDate!.isBefore(startDate!)) return false;

    // Limit to 90 days
    final difference =
        endDate?.difference(startDate ?? DateTime.now()).inDays ?? 0;
    if (difference > 90) return false;

    return true;
  }

  String getDateRangeErrorMessage() {
    if (startDate != null && endDate != null) {
      if (endDate!.isBefore(startDate!)) {
        return "End date must be after start date";
      }

      final difference =
          endDate?.difference(startDate ?? DateTime.now()).inDays ?? 0;
      if (difference > 90) {
        return "Date range cannot exceed 90 days";
      }
    }

    return "Please select both dates";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasInternet = ref.watch(connectivityProvider);


    final tradingJournalState = ref.watch(tradingJournalStateNotifierProvider);

    bool isLoading = tradingJournalState.isdownloadLoading;

    return Container(
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with drag indicator
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: theme.shadowColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title with icon
          Row(
            children: [
              Icon(Icons.output_rounded, color: theme.indicatorColor, size: 24),
              const SizedBox(width: 6),
              Text(
                "Export Trading Journal",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColorDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Date range selection with labels
          Text(
            "Select Date Range",
            style: TextStyle(
              color: theme.primaryColorDark,
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),

          const SizedBox(height: 12),

          // Date selection cards
          Row(
            children: [
              Expanded(
                child: _buildDateCard(
                  context,
                  "Start Date",
                  startDate,
                  () => _selectDate(context, true),
                  Icons.calendar_today,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDateCard(
                  context,
                  "End Date",
                  endDate,
                  () => _selectDate(context, false),
                  Icons.calendar_today,
                ),
              ),
            ],
          ),

          // Show validation message for date range
          if (!isValidDateRange() && (startDate != null || endDate != null))
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                getDateRangeErrorMessage(),
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),

          const SizedBox(height: 32),

          // Download button
          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: (isValidDateRange() && !isLoading && hasInternet)
                  ? () {
                      _downloadExcel();
                      //FocusScope.of(context).unfocus();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.indicatorColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              icon: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(Icons.download_rounded, color: Colors.white),
              label: Text(
                isLoading ? 'Downloading...' : 'Download',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  // fontFamily: ''
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDateCard(
    BuildContext context,
    String label,
    DateTime? date,
    VoidCallback onPressed,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: theme.primaryColorDark.withAlpha(200),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: Colors.blueAccent,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    date != null
                        ? DateFormat('MMM d, yyyy').format(date)
                        : 'Select date',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final initialDate = isStartDate
        ? startDate ?? DateTime.now().subtract(const Duration(days: 30))
        : endDate ?? DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.indicatorColor,
              onPrimary: Colors.white,
              surface: theme.cardColor,
              onSurface: theme.textTheme.bodyLarge?.color ?? Colors.black,
            ),
            dialogBackgroundColor: theme.dialogBackgroundColor,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
            ),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = pickedDate;
        } else {
          endDate = pickedDate;
        }
      });
    }
  }
}