import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/assets.dart';

class CustomImages extends StatefulWidget {
  final String imageURL;
  final BoxFit? fit;
  final double aspectRatio;
  const CustomImages({
    super.key,
    required this.imageURL,
    this.fit,
    required this.aspectRatio,
  });

  @override
  State<CustomImages> createState() => _CustomImagesState();
}

class _CustomImagesState extends State<CustomImages> {
  bool isHorizontal = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: widget.imageURL,
          fit: widget.fit,
          placeholder: (context, url) => widget.fit == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(),
          errorWidget: (context, url, error) => ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: widget.fit == null
                ? Image.asset(
                    dashBoardDefaultImage,
                  )
                : Container(),
          ),
        ),
      ),
    );
  }
}
