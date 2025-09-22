import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:research_mantra_official/constants/assets_storage.dart';
import 'package:research_mantra_official/ui/common_components/common_outline_button.dart';
import 'package:research_mantra_official/ui/common_components/image_button.dart';
import 'package:research_mantra_official/ui/router/app_routes.dart';
import 'package:research_mantra_official/ui/screens/analysis/market_analysis_home_page.dart';
import 'package:research_mantra_official/ui/screens/home/home_navigator.dart';
import 'package:research_mantra_official/ui/screens/market/screens/fii_dii_activity.dart';
import 'package:research_mantra_official/ui/screens/market/screens/menu_screen.dart';
import 'package:research_mantra_official/ui/screens/market/widgets/bulk_block_deals.dart';

class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.primaryColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.3,
                child: FiiDiiActivityWidget(),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomeNavigatorWidget(
                          initialIndex: 1,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50
                        .h, // 👈 avoid sp for fixed heights, use responsive only if needed
                    decoration: BoxDecoration(
                      color: theme.shadowColor.withOpacity(0.1),
                      border: Border.all(color: theme.shadowColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // space between text & button
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // ✅ vertically center children
                      children: [
                        // Text Column
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // ✅ center texts vertically
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Research Mantra",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Smart Entry Smart Exit",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ],
                          ),
                        ),

                        // Button
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: CommonOutlineButton(
                            borderColor: theme.shadowColor,
                            text: "Get Trades Free",
                            backgroundColor: theme.primaryColor,
                            borderWidth: 0.5,
                            borderRadius: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.sp,
              ),
              MenuWidget(),
              SizedBox(
                height: 25.sp,
              ),
              _buildPrePostWidget(theme),
              SizedBox(
                height: 10.sp,
              ),
              SizedBox(height: 300, child: DealsScreen())
            ],
          ),
        ));
  }

  //Widget for Pre and post market
  Widget _buildPrePostWidget(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(color: theme.shadowColor.withOpacity(0.2)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Market Report",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.primaryColorDark,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Daily market report at your fingertips.",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.primaryColorDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
          //Container for pre and post
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: ImageButton(
                  assetPath: preMarketImagePath,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      marketAnalysisScreen,
                      arguments: const MarketAnalysisiHomepage(
                        initialTab: 0, // open Post Market tab
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ImageButton(
                  assetPath: postMarketImagePath,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      marketAnalysisScreen,
                      arguments: const MarketAnalysisiHomepage(
                        initialTab: 1, // open Post Market tab
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
