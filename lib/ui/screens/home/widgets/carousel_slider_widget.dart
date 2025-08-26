import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:research_mantra_official/services/url_launcher_helper.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';
import 'package:research_mantra_official/ui/components/common_expires/expire.dart';
import 'package:research_mantra_official/ui/components/shimmers/home_shimmer.dart';

class DashboardCarouselSlider extends StatefulWidget {
  final dynamic dashboardImageState;
  final String displayImage;
  final String dashBoardDefaultImage;

  const DashboardCarouselSlider({
    super.key,
    required this.dashboardImageState,
    required this.displayImage,
    required this.dashBoardDefaultImage,
  });

  @override
  State<DashboardCarouselSlider> createState() =>
      _DashboardCarouselSliderState();
}

class _DashboardCarouselSliderState extends State<DashboardCarouselSlider> {
  int _currentIndex = 0;
  final Key carouselKey = UniqueKey();

  List<String> _images = [];
  List<String> _urls = [];
  List<dynamic> _nonExpiredImages = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.dashboardImageState.isLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: buildCarouselImagesShimmers(context, theme),
      );
    }

    _prepareCarouselData(widget.dashboardImageState.dashBoardImages);

    if (_images.isEmpty) {
      return _buildBannerDefaultImage();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
      child: Stack(
        alignment: const Alignment(0, 0.89),
        children: [
          CarouselSlider(
            key: carouselKey,
            items: List.generate(_images.length, (index) {
              return GestureDetector(
                onTap: () => _handleTap(index),
                child: CircularCachedNetworkLandScapeImages(
                  imageURL: _images[index],
                  baseUrl: widget.displayImage,
                  defaultImagePath: widget.dashBoardDefaultImage,
                  aspectRatio: 2,
                ),
              );
            }),
            options: CarouselOptions(
              aspectRatio: 2,
              autoPlay: _images.length > 1,
              initialPage: _currentIndex,
              enableInfiniteScroll: true,
              viewportFraction: 1,
              autoPlayInterval: const Duration(seconds: 10),
              autoPlayAnimationDuration: const Duration(seconds: 2),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() => _currentIndex = index);
              },
            ),
          ),
          if (_images.length > 1) const SizedBox(height: 10),
          if (_images.length > 1) _buildIndicator(theme),
        ],
      ),
    );
  }

  void _prepareCarouselData(dynamic dashBoardImages) {
    final imagesJson = json.encode(dashBoardImages);
    final List<dynamic> imagesList = (json.decode(imagesJson) ?? [])
        .where((img) => img['type'] == 'DASHBOARD')
        .toList();

    _nonExpiredImages = ExpirationUtils.filterExpiredImages(imagesList);

    _images = _nonExpiredImages
        .map<String>((image) => image['name'] ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    _urls = _nonExpiredImages
        .map<String>((image) => image['url'] ?? '')
        .where((url) => url.isNotEmpty)
        .toList();
  }

  Widget _buildIndicator(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_images.length, (index) {
        final isActive = _currentIndex == index;
        return GestureDetector(
          onTap: () => setState(() => _currentIndex = index),
          child: Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? theme.indicatorColor : theme.focusColor,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBannerDefaultImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: AspectRatio(
        aspectRatio: 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.asset(
            widget.dashBoardDefaultImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _handleTap(int index) {
    final url = _urls[index];
    final data = _nonExpiredImages[index];

    UrlLauncherHelper.handleToNavigatePathScreen(
      context,
      url,
      data['productId'],
      data['productName'] ?? '',
      false,
    );
  }
}
