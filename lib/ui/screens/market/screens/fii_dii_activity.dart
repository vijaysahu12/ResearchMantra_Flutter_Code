import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

// ---------------------
// Model
// ---------------------
class FiiDiiData {
  final String date;
  final String fii; // coming as String
  final String dii; // coming as String
  final bool isMonthly;

  const FiiDiiData({
    required this.date,
    required this.fii,
    required this.dii,
    this.isMonthly = false,
  });

  // ✅ Parsed values for calculations
  double get fiiValue => double.tryParse(fii) ?? 0;
  double get diiValue => double.tryParse(dii) ?? 0;
}

// ---------------------
// Main Widget
// ---------------------
class FiiDiiActivityWidget extends StatelessWidget {
  const FiiDiiActivityWidget({super.key});

  final List<FiiDiiData> dataList = const [
    FiiDiiData(date: "09 Sep 2025", fii: "-2050.46", dii: "83.08"),
    FiiDiiData(
        date: "Sep 2025", fii: "8000.25", dii: "2500.50", isMonthly: true),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: dataList.length,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final item = dataList[index];

        return Container(
          width: 250.w,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.focusColor, width: 0.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header
              Text(
                item.date,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.primaryColorDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5.sp),

              // FII Row
              FiiDiiRow(
                label: "FII",
                value: item.fii,
                ratio: _calculateRatio(item.fiiValue),
                color: item.fii.contains("-")
                    ? theme.disabledColor
                    : theme.secondaryHeaderColor,
              ),

              // DII Row
              FiiDiiRow(
                label: "DII",
                value: item.dii,
                ratio: _calculateRatio(item.diiValue),
                color: item.dii.contains("-")
                    ? theme.disabledColor
                    : theme.secondaryHeaderColor,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Normalizes value out of 100000 Cr
  double _calculateRatio(double value) {
    if (value <= 0) return 0;
    return (value / (value + value)).clamp(0, 1);
  }

  /// Formats Indian numbers with commas (e.g. 1,24,990)
  static String formatAmount(String amount) {
    final parsed = double.tryParse(amount) ?? 0;
    final formatter = NumberFormat.decimalPattern('en_IN');
    return formatter.format(parsed.round());
  }
}

// ---------------------
// Reusable Row Widget
// ---------------------
class FiiDiiRow extends StatelessWidget {
  final String label;
  final String value;
  final double ratio;
  final Color color;

  const FiiDiiRow({
    super.key,
    required this.label,
    required this.value,
    required this.ratio,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // Label
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.primaryColorDark,
            // fontWeight: FontWeight.w600
          ),
        ),
        SizedBox(width: 6.w),

        // Progress Bar
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),

        SizedBox(width: 6.w),

        // Amount
        Text(
          '₹${FiiDiiActivityWidget.formatAmount(value)} Cr',
          style: theme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
