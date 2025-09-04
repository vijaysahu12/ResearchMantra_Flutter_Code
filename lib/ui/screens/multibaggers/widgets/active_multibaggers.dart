import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActiveMultibaggerList extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const ActiveMultibaggerList({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Active Stocks (${data.length})",
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14.sp)),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return item['isPurchased']
                ? _buildActiveTradesList(theme, item)
                : Container(
                    margin: EdgeInsets.all(8.w),
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: theme.focusColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(15.w),
                      decoration: BoxDecoration(
                        color: theme.focusColor,
                        borderRadius: BorderRadius.circular(8.r),
                        border:
                            Border.all(color: theme.primaryColor, width: 0.2),
                      ),
                      child: Column(
                        children: [
                          // ✅ Title Badge
                          Container(
                            width: 180.w,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: theme.secondaryHeaderColor,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              item["title"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),

                          // ✅ Button
                          Container(
                            width: 200.w,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              item["buttonText"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: theme.primaryColorDark,
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),

                          // ✅ Note
                          Text(
                            item["note"],
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 10.sp,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ],
    );
  }

  //Widget for Active trades after purchased
  Widget _buildActiveTradesList(ThemeData theme, item) {
    return Container(
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
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8.0.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(color: theme.indicatorColor, width: 0.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
  }
}
