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

class FiiDiiActivityWidget extends StatefulWidget {
  const FiiDiiActivityWidget({super.key});

  @override
  State<FiiDiiActivityWidget> createState() => _FiiDiiActivityWidgetState();
}

class _FiiDiiActivityWidgetState extends State<FiiDiiActivityWidget> {
  bool _showMonthlyData = false;
  bool _notificationsEnabled = true;

  // Sample data
  final FiiDiiData _todayData = FiiDiiData(
    date: "09 Sep 2025",
    fii: 2050.46,
    dii: 83.08,
  );

  final FiiDiiData _monthlyData = FiiDiiData(
    date: "Sep 2025",
    fii: 8000.25,
    dii: 2500.50,
    isMonthly: true,
  );

  @override
  Widget build(BuildContext context) {
    final currentData = _showMonthlyData ? _monthlyData : _todayData;
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.8),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.focusColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _showMonthlyData ? _monthlyData.date : _todayData.date,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.primaryColor),
                ),
              ),
              const Spacer(),
              Text(
                _showMonthlyData ? 'FII & DII, MONTHLY' : 'FII & DII, TODAY',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.primaryColorDark),
              ),
            ],
          ),

          SizedBox(height: 5.sp),

          // Main Stats
          Row(
            children: [
              // FII Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          currentData.fii >= 0
                              ? Icons.trending_up
                              : Icons.trending_down,
                          color: theme.primaryColorDark,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.sp),
                        Text(
                          'FII',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: theme.primaryColorDark),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.sp),
                    Text(
                      '₹${_formatAmount(currentData.fii)}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.primaryColorDark,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              // Divider
              Container(
                height: 40,
                width: 1,
                color: theme.primaryColorDark,
              ),

              // DII Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            currentData.dii >= 0
                                ? Icons.trending_up
                                : Icons.trending_down,
                            color: theme.primaryColorDark,
                            size: 16.sp,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'DII',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: theme.primaryColorDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${_formatAmount(currentData.dii)}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.primaryColorDark,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.sp),

          // Toggle and Notifications Row
          Row(
            children: [
              // Data Toggle
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showMonthlyData = !_showMonthlyData;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: theme.shadowColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _showMonthlyData ? Icons.calendar_month : Icons.today,
                        color: theme.primaryColorDark,
                        size: 14,
                      ),
                      SizedBox(width: 5.sp),
                      Text(
                        _showMonthlyData
                            ? 'Switch to Daily'
                            : 'Switch to Monthly',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: theme.primaryColorDark),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Notifications Toggle
              Row(
                children: [
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _showMonthlyData = !_showMonthlyData;
                          _notificationsEnabled = value;
                        });
                      },
                      activeColor: theme.indicatorColor,
                      activeTrackColor: theme.shadowColor,
                      inactiveThumbColor: theme.focusColor,
                      inactiveTrackColor: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount.abs() >= 1000) {
      return '${(amount / 1000).toStringAsFixed(2)}K Cr';
    }
    return '${amount.toStringAsFixed(2)} Cr';
  }
}
