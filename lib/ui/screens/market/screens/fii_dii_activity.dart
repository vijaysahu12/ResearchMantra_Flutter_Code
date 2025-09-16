import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Models
class FiiDiiData {
  final String date;
  final double fii;
  final double dii;
  final bool isMonthly;

  FiiDiiData({
    required this.date,
    required this.fii,
    required this.dii,
    this.isMonthly = false,
  });
}

class FiiDiiActivityWidget extends StatelessWidget {
  FiiDiiActivityWidget({super.key});

  final List<FiiDiiData> dataList = [
    FiiDiiData(date: "09 Sep 2025", fii: 2050.46, dii: 83.08),
    FiiDiiData(date: "Sep 2025", fii: 8000.25, dii: 2500.50, isMonthly: true),
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
          width: 250.w, // Card width
          padding: const EdgeInsets.all(15),

          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.shadowColor, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.focusColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.date,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.primaryColor),
                ),
              ),
              SizedBox(height: 10.sp),

              // FII & DII
              Row(
                children: [
                  // FII
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.trending_up,
                                color: theme.primaryColorDark, size: 16.sp),
                            SizedBox(width: 4.sp),
                            Text('FII',
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(color: theme.primaryColorDark)),
                          ],
                        ),
                        SizedBox(height: 3.sp),
                        Text('₹${_formatAmount(item.fii)}',
                            style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.primaryColorDark,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),

                  // Divider
                  Container(
                      height: 40, width: 1, color: theme.primaryColorDark),

                  // DII
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.trending_up,
                                  color: theme.primaryColorDark, size: 16.sp),
                              const SizedBox(width: 4),
                              Text('DII',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.primaryColorDark)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('₹${_formatAmount(item.dii)}',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.primaryColorDark,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatAmount(double amount) {
    if (amount.abs() >= 1000) {
      return '${(amount / 1000).toStringAsFixed(2)}K Cr';
    }
    return '${amount.toStringAsFixed(2)} Cr';
  }
}
