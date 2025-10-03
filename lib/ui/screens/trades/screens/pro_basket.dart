import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/constants/assets_storage.dart';
import 'package:research_mantra_official/ui/screens/multibaggers/multibaggers.dart';
import 'package:research_mantra_official/ui/screens/research_stock_basket/stock_baskets.dart';
import 'package:research_mantra_official/ui/screens/research_xclusive/xclusive_screen.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class ProBasketContainer extends StatefulWidget {
  const ProBasketContainer({super.key});

  @override
  State<ProBasketContainer> createState() => _ProBasketContainerState();
}

class _ProBasketContainerState extends State<ProBasketContainer> {
  final List<Map<String, dynamic>> proCards = [
    {
      "title": "Stock Baskets",
      "screen": StockBasketsScreen(),
    },
    {
      "title": "Multibaggers",
      "screen": MultibaggersScreen(),
    },
    {
      "title": "Xclusive Ideas",
      "screen": XclusiveScreen(),
    },
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pro Baskets',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: theme.primaryColorDark,
            ),
          ),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true, // So it doesn’t take infinite height
            physics:
                NeverScrollableScrollPhysics(), // Disable scrolling if inside another scroll
            crossAxisCount: 3, // 3 items per row
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: proCards.map((item) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => item["screen"]),
                  );
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.shadowColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        // Top: Title
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            item["title"],
                            style: textH4.copyWith(
                                color: theme.primaryColorDark, fontSize: 10.sp),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Center: Icon
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Image.asset(
                              bullMarketIconPath,
                              scale: 12,
                            ),
                          ),
                        ),
                        // Bottom: Explore
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            "Explore",
                            style: textH4.copyWith(
                                color: theme.primaryColorDark, fontSize: 10.sp),
                          ),
                        ),
                      ],
                    )),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
