import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:research_mantra_official/constants/assets.dart';

class CacheNetworkImagesForLearningScreen extends StatelessWidget {
  final String imageURL;
  final double? height;
  final double? width;
  final String url;
  final BorderRadiusGeometry? borderRadius;

  const CacheNetworkImagesForLearningScreen({
    super.key,
    required this.imageURL,
    this.height,
    this.width,
    this.borderRadius,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: '$url?imageName=$imageURL',
          fit: BoxFit.cover,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              color: Colors.white,
            ),
          ),
          errorWidget: (context, url, error) => Image.asset(
            productLandScapeImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
