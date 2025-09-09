import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';

class BasketStockDetailsScreen extends StatefulWidget {
  final String title;
  const BasketStockDetailsScreen({super.key, required this.title});

  @override
  State<BasketStockDetailsScreen> createState() =>
      _BasketStockDetailsScreenState();
}

class _BasketStockDetailsScreenState extends State<BasketStockDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: widget.title,
        handleBackButton: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          AspectRatio(
              aspectRatio: 2.4,
              child: Image.network(
                  "https://romangonzalez.wordpress.com/wp-content/uploads/2011/01/2-4-inception.jpg")),
          _buildRebalance(theme),
          _buildOverView(
              "Take a bold step towards higher returns with the wealth.Take a bold step towards higher returns with the wealth.Take a bold step towards higher returns with the wealth.Take a bold step towards higher returns with the wealth.Take a bold step towards higher returns with the wealth.",
              theme)
        ],
      ),
    );
  }

  //Widget overView
  Widget _buildOverView(overViewText, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: theme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: theme.focusColor.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: EdgeInsets.all(8),
      child: Text(
        overViewText,
        style: TextStyle(fontSize: 10.sp),
      ),
    );
  }

  //Widget Rebalance
  Widget _buildRebalance(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: theme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: theme.focusColor.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                "overViewText",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.primaryColorDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text("overViewText",
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: theme.focusColor,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),

          // ✅ Vertical Divider
          Container(
            height: 40, // adjust height to match content
            width: 1,
            color: theme.dividerColor,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),

          Column(
            children: [
              Text(
                "overViewText",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.primaryColorDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text("overViewText",
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: theme.focusColor,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),

          // ✅ Another Vertical Divider
          Container(
            height: 40,
            width: 1,
            color: theme.dividerColor,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),

          Column(
            children: [
              Text(
                "overViewText",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.primaryColorDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text("overViewText",
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: theme.focusColor,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
