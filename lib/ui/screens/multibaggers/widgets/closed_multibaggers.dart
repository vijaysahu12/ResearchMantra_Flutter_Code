import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClosedMultibaggersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const ClosedMultibaggersScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Closed Stocks (${data.length})",
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14.sp)),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return 
            
            Container(
              margin: EdgeInsets.all(8.w),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: theme.indicatorColor, width: 0.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Top Row (Stock + Gain)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["stockSymbol"],
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColorDark,
                            ),
                          ),
                          Text(
                            item["companyName"],
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: theme.focusColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Net gain ${item["netGain"]}",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),

                  // ✅ Entry & Exit Details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(
                              color: theme.indicatorColor, width: 0.2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Entry Price: ₹${item["entryPrice"]}",
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(fontSize: 11.sp)),
                            Text("Date: ${item["entryDate"]}",
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(fontSize: 10.sp)),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(
                              color: theme.indicatorColor, width: 0.2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Exit Price: ₹${item["exitPrice"]}",
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(fontSize: 11.sp)),
                            Text("Date: ${item["exitDate"]}",
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(fontSize: 10.sp)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),

                  // ✅ Bottom Action Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Stock Details",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: theme.indicatorColor,
                        ),
                      ),
                      Text(
                        "View Chart",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.indicatorColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
         
         
          },
        ),
      ],
    );
  }
}
