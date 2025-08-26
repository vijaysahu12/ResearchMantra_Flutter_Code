import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:research_mantra_official/constants/assets.dart';

class CommunityImageViewer extends StatelessWidget {
  final String imageURL;
  final double? height;
  final double? width;
  final String? defaultImage;
  final double? defaultImageHeight;
  final double? defauktImageWidth;
  final BorderRadiusGeometry? borderRadius;

  const CommunityImageViewer(
      {super.key,
      required this.imageURL,
      this.height,
      this.width,
      this.borderRadius,
      this.defaultImage,
      this.defaultImageHeight,
      this.defauktImageWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: imageURL,
          fit: BoxFit.cover,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              color: Colors.white,
            ),
          ),
          errorWidget: (context, url, error) => Image.asset(
            defaultImage ?? productLandScapeImage,
            fit: BoxFit.cover,
            height: defaultImageHeight,
            width: defauktImageWidth,
          ),
        ),
      ),
    );
  }
}
