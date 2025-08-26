import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';
import 'package:research_mantra_official/ui/components/shimmers/home_shimmer.dart';
// Make sure this contains `dashBoardBottomSlider`

class DashboardFooterImageWidget extends StatelessWidget {
  final dashboardImages;
  final ThemeData theme;
  final String displayImage;

  const DashboardFooterImageWidget({
    super.key,
    required this.dashboardImages,
    required this.theme,
    required this.displayImage,
  });

  @override
  Widget build(BuildContext context) {
    if (dashboardImages.isLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: buildDFooterShimmers(context, theme),
      );
    }

    final List<String> gifs = _extractGifList(dashboardImages);

    if (gifs.isEmpty) {
      return _buildOfflineGif();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: theme.shadowColor),
      ),
      child: CircularCachedNetworkDashboardBottomImages(
        imageURL: "$displayImage?imageName=${gifs.first}",
      ),
    );
  }

  List<String> _extractGifList(dashboardImages) {
    try {
      final raw = dashboardImages.valueOrNull;
      if (raw == null) return [];

      final String imagesJson = json.encode(raw.dashBoardImages ?? []);
      final List<dynamic> imagesList = json.decode(imagesJson);

      return imagesList
          .where((image) =>
              image is Map &&
              image['type'] == 'D-FOOTER' &&
              image['name'] != null)
          .map<String>((image) => image['name'].toString())
          .toList();
    } catch (_) {
      return [];
    }
  }

  Widget _buildOfflineGif() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: theme.shadowColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(
          dashBoardBottomSlider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
