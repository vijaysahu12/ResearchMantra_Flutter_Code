import 'dart:io';
import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/data/models/image_model.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';

class ImageTile extends StatelessWidget {
  final ImageItem imageItem;
  final VoidCallback onTap;
  final double aspectRatio;
  final BorderRadius borderRadius;

  const ImageTile({
    super.key,
    required this.imageItem,
    required this.onTap,
    required this.aspectRatio,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = imageItem.name;
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.shadowColor, width: 1),
        borderRadius: borderRadius,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: imageUrl.startsWith('/')
              ? ClipRRect(
                  borderRadius: borderRadius,
                  child: Image.file(File(imageUrl), fit: BoxFit.cover))
              : CommonImageSlider(
                  imageURL: imageUrl,
                  defaultImagePath: dashBoardDefaultImage,
                  aspectRatio: aspectRatio,
                  borderRadius: borderRadius,
                ),
        ),
      ),
    );
  }
}
