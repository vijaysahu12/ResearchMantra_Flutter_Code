//homscreeen
import 'package:flutter/material.dart';
import 'package:research_mantra_official/ui/components/shimmers/market_price_shimmers.dart';
import 'package:research_mantra_official/ui/components/shimmers/topgainers_toplosers_shimmers.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreenShimmerContainer extends StatelessWidget {
  final ThemeData theme;

  const HomeScreenShimmerContainer({
    super.key,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: theme.focusColor,
        highlightColor: theme.shadowColor,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Column(
            children: [
              buildCarouselImagesShimmers(context, theme),
              const SizedBox(height: 8),
              buildDFooterShimmers(context, theme),
              const SizedBox(height: 8),
              buildDFooterShimmers(context, theme),
              const SizedBox(height: 10),
              buildGridServicesShimmers(context, theme),
              const SizedBox(height: 10),
              buildGridServicesShimmers(context, theme),
              const SizedBox(height: 8),
              buildBottomImagesShimmers(context, theme),
              const SizedBox(height: 8),
              buildBottomImagesShimmers(context, theme),
            ],
          ),
        ),
      ),
    );
  }
}

//carousel images
Widget buildCarouselImagesShimmers(context, theme) {
  return Shimmer.fromColors(
    baseColor: theme.focusColor,
    highlightColor: theme.shadowColor,
    child: AspectRatio(
      aspectRatio: 2,
      child: Container(
        decoration: BoxDecoration(
            color: theme.shadowColor, borderRadius: BorderRadius.circular(4)),
      ),
    ),
  );
}

//widget market nse and nifty value
Widget buildIndainMArketValueShimmers(context, theme) {
  final heightValue = MediaQuery.of(context).size.height;
  return Shimmer.fromColors(
    baseColor: theme.focusColor,
    highlightColor: theme.shadowColor,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      decoration: BoxDecoration(
          border: Border.all(width: 0.1, color: theme.focusColor),
          borderRadius: BorderRadius.circular(4)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: heightValue * 0.15,
                height: heightValue * 0.02,
                color: theme.shadowColor,
              ),
              const Spacer(),
              Container(
                width: heightValue * 0.1,
                height: heightValue * 0.02,
                color: theme.shadowColor,
              ),
            ],
          ),
          buildMarketValuesShimmerContainer(
              fontSize: heightValue * 0.35, theme: theme),
        ],
      ),
    ),
  );
}

//topgainers
Widget buildTopGainersShimmers(context, theme) {
  final heightValue = MediaQuery.of(context).size.height;
  return Shimmer.fromColors(
    baseColor: theme.focusColor,
    highlightColor: theme.shadowColor,
    child: Container(
      height: MediaQuery.of(context).size.height * 0.3,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      decoration: BoxDecoration(
          border: Border.all(width: 0.1, color: theme.focusColor),
          borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: heightValue * 0.12,
                height: heightValue * 0.025,
                color: theme.shadowColor,
              ),
              const SizedBox(
                width: 15,
              ),
              Container(
                width: heightValue * 0.12,
                height: heightValue * 0.025,
                color: theme.shadowColor,
              ),
              const Spacer(),
              Container(
                width: heightValue * 0.1,
                height: heightValue * 0.025,
                color: theme.shadowColor,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                return buildTradingContainer(
                    fontSize: heightValue * 0.5, theme: theme);
              },
            ),
          ),
        ],
      ),
    ),
  );
}

//dofooter shimmer
Widget buildDFooterShimmers(context, theme) {
  final heightValue = MediaQuery.of(context).size.height;
  return Shimmer.fromColors(
    baseColor: theme.shadowColor,
    highlightColor: theme.shadowColor,
    child: Container(
      decoration: BoxDecoration(
          color: theme.shadowColor, borderRadius: BorderRadius.circular(4)),
      width: double.infinity,
      height: heightValue * 0.035,
    ),
  );
}

//bottom images shimmer
Widget buildBottomImagesShimmers(context, theme) {
  final heightValue = MediaQuery.of(context).size.height;
  return Shimmer.fromColors(
    baseColor: theme.shadowColor,
    highlightColor: theme.shadowColor,
    child: Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: heightValue * 0.2,
                height: heightValue * 0.025,
                color: theme.shadowColor,
              ),
              const Spacer(),
              Container(
                width: heightValue * 0.05,
                height: heightValue * 0.025,
                color: theme.shadowColor,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: heightValue * 0.1, // Adjust height if needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(
                      right: 5), // Add spacing between items
                  decoration: BoxDecoration(
                      color: theme.shadowColor,
                      borderRadius: BorderRadius.circular(4)),
                  width: heightValue * 0.14,
                  height: heightValue * 0.14,
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

//Grid Servies images shimmer
Widget buildGridServicesShimmers(context, theme) {
  final heightValue = MediaQuery.of(context).size.height;
  return Shimmer.fromColors(
    baseColor: theme.shadowColor,
    highlightColor: theme.shadowColor,
    child: Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          SizedBox(
            height: heightValue * 0.1, // Adjust height if needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(
                      right: 5), // Add spacing between items
                  decoration: BoxDecoration(
                      color: theme.shadowColor,
                      borderRadius: BorderRadius.circular(4)),
                  width: heightValue * 0.14,
                  height: heightValue * 0.14,
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
