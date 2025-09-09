import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TradeTable extends StatelessWidget {
  final List<Map<String, dynamic>> actions;

  const TradeTable({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: theme.shadowColor,
          width: 0.3,
        ),
      ),
      child: Column(
        children: [
          // ✅ Header Row
          Container(
            decoration: BoxDecoration(
              color: theme.shadowColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.r),
                topRight: Radius.circular(4.r),
              ),
              border: Border.all(
                color: theme.shadowColor,
                width: 0.2,
              ),
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  children: [
                    _buildHeaderCell("Action", theme),
                    _buildHeaderCell("Date", theme),
                    _buildHeaderCell("Price", theme),
                  ],
                ),
              ],
            ),
          ),

          // ✅ Data Rows
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(3),
              2: FlexColumnWidth(2),
            },
            children: actions.map((action) {
              return TableRow(
                children: [
                  _buildDataCell(action['action'] ?? "", theme),
                  _buildDataCell(action['date'] ?? "", theme),
                  _buildDataCell(action['price'] ?? "", theme),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          color: theme.primaryColorDark,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataCell(String text, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          color: theme.primaryColorDark,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
