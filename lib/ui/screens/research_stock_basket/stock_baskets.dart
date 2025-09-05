import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:research_mantra_official/ui/common_components/common_outline_button.dart';
import 'package:research_mantra_official/ui/common_components/shimmer_button.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';

class StockBasketsScreen extends StatefulWidget {
  const StockBasketsScreen({super.key});

  @override
  State<StockBasketsScreen> createState() => _MyStockBasketsScreenState();
}

class _MyStockBasketsScreenState extends State<StockBasketsScreen> {
  final List<Map<String, dynamic>> stockBasketsData = [
    {
      "id": 33,
      "title": "Wealth Multiplies",
      "timeFrame": "3y",
      "cagr": "23.10",
      "volatility": "Low volatility",
      "imageUrl":
          "https://m.economictimes.com/thumb/msid-109215691,width-1200,height-1200,resizemode-4,imgsize-28128/mf-query-i-have-rs-7-8-lakh-surplus-funds-but-dont-want-to-invest-in-stock-markets.jpg",
    },
    {
      "id": 34,
      "title": "Steady Growth",
      "timeFrame": "5y CAGR",
      "cagr": "18.45",
      "volatility": "Medium volatility",
      "imageUrl":
          "https://m.economictimes.com/thumb/msid-109215691,width-1200,height-1200,resizemode-4,imgsize-28128/mf-query-i-have-rs-7-8-lakh-surplus-funds-but-dont-want-to-invest-in-stock-markets.jpg",
    },
    {
      "id": 35,
      "title": "High Momentum",
      "timeFrame": "1y",
      "cagr": "30.25",
      "volatility": "High volatility",
      "imageUrl":
          "https://m.economictimes.com/thumb/msid-109215691,width-1200,height-1200,resizemode-4,imgsize-28128/mf-query-i-have-rs-7-8-lakh-surplus-funds-but-dont-want-to-invest-in-stock-markets.jpg"
    }
  ];

  final List<Map<String, String>> basketData = [
    {
      "title": "Curated Investments",
      "imagePath": "https://example.com/images/curated.png",
    },
    {
      "title": "Transparency & Control",
      "imagePath": "https://example.com/images/transparency.png",
    },
    {
      "title": "Expert Insights",
      "imagePath": "https://example.com/images/insights.png",
    },
    {
      "title": "Smart Tracking",
      "imagePath": "https://example.com/images/tracking.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: "Exclusive Baskets",
        handleBackButton: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBasketsList(theme),
            SizedBox(height: 12.sp),
            _buildBottomGrid(theme),
            SizedBox(height: 12.sp),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildRequestCall(theme),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 25, left: 18, right: 18, top: 5),
        child: ShimmerButton(
          borderRadius: 4,
          text: "Subscribe Now",
          backgroundColor: theme.primaryColorDark,
          textColor: theme.primaryColor,
          onPressed: () => print("Shimmer button pressed!"),
        ),
      ),
    );
  }

  Widget exclusiveStocksMessage(ThemeData theme, String message) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: theme.primaryColorDark,
        ),
      ),
    );
  }

  Widget _buildBasketsList(ThemeData theme) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true, // ✅ prevents unbounded height
      physics:
          const NeverScrollableScrollPhysics(), // ✅ avoids nested scroll conflict
      itemCount: stockBasketsData.length + 1,
      itemBuilder: (context, index) {
        if (index == 0)
          return exclusiveStocksMessage(theme, "Expert curated picks");
        return buildStockBasketCard(context, stockBasketsData[index - 1]);
      },
    );
  }

  Widget buildStockBasketCard(
      BuildContext context, Map<String, dynamic> basket) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: theme.shadowColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼️ Basket Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              basket['imageUrl'],
              height: 80.sp,
              width: 80.sp,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          // 📊 Basket Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + Volatility
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        basket['title'],
                        style: TextStyle(
                          color: theme.primaryColorDark,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      basket['volatility'],
                      style: TextStyle(
                        color: theme.focusColor,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.sp),

                // Timeframe + CAGR + View button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          basket['timeFrame'],
                          style: TextStyle(
                            color: theme.primaryColorDark,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "+${basket['cagr']}%",
                          style: TextStyle(
                            color: theme.secondaryHeaderColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    CommonOutlineButton(
                      borderColor: theme.shadowColor,
                      textColor: theme.focusColor,
                      text: "View",
                      onPressed: () {
                        // TODO: Navigate to detail screen
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// 📌 Bottom grid
  Widget _buildBottomGrid(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        exclusiveStocksMessage(theme, "Benefits with Exclusive Baskets"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
            children:
                basketData.map((item) => _buildGridItem(item, theme)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildGridItem(item, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.shadowColor)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => item.screen),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(item.icon, scale: 20),
            // const SizedBox(height: 8),
            Text(
              item['title'],
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: theme.primaryColorDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

// 📌 Request call widget
  Widget _buildRequestCall(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.shadowColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "NEW TO BASKETS?",
                  style: TextStyle(
                    color: theme.indicatorColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5.sp),
                Text(
                  "Have a call with our experts and resolve your doubts",
                  style: TextStyle(
                    color: theme.primaryColorDark,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.sp),
                Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: ShimmerButton(
                    isShimmer: false,
                    height: 20,
                    fontSize: 10,
                    text: "Request Callback",
                    backgroundColor: theme.primaryColorDark,
                    textColor: theme.primaryColor,
                  ),
                )
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              "https://img.freepik.com/free-photo/young-joyful-woman-with-dark-curly-hair-khaki-shirt-white-t-shirt-happily-looking-camera-talking-cellphone-city-street_574295-2249.jpg?semt=ais_incoming&w=740&q=80",
              height: 100.sp,
              width: 100.sp,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
