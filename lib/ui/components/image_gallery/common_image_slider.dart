import 'package:flutter/material.dart';
import 'package:research_mantra_official/data/models/image_model.dart';
import 'image_tile.dart';
import 'full_screen_image_viewer.dart';

class ImageGalleryWidget extends StatelessWidget {
  final List<ImageItem> images;
  final String aspectRatio;
  const ImageGalleryWidget({
    super.key,
    required this.images,
    required this.aspectRatio,
  });
  

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox();

    if (images.length == 1) {
      return ImageTile(
        imageItem: images[0],
        onTap: () => _openFullScreenViewer(context, 0),
        aspectRatio: images[0].aspectRatio.startsWith('/')
            ? (double.tryParse(aspectRatio) ?? 1.0)
            : (double.tryParse(images[0].aspectRatio) ?? 1.0),
        borderRadius: BorderRadius.circular(8),
      );
    }

    if (images.length == 2) {
      return Row(children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: ImageTile(
              imageItem: images[0],
              onTap: () => _openFullScreenViewer(context, 0),
              aspectRatio: 1,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                topLeft: Radius.circular(8),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: ImageTile(
              imageItem: images[1],
              onTap: () => _openFullScreenViewer(context, 1),
              aspectRatio: 1,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ),
        ),
      ]);
    }

    if (images.length == 3) {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: ImageTile(
              imageItem: images[0],
              onTap: () => _openFullScreenViewer(context, 0),
              aspectRatio: 1,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                topLeft: Radius.circular(8),
              ),
            ),
          ),
          SizedBox(width: 4),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                ImageTile(
                  imageItem: images[1],
                  onTap: () => _openFullScreenViewer(context, 1),
                  aspectRatio: 1,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                  ),
                ),
                SizedBox(height: 1),
                ImageTile(
                  imageItem: images[2],
                  onTap: () => _openFullScreenViewer(context, 2),
                  aspectRatio: 1,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return const SizedBox();
  }

  void _openFullScreenViewer(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(
          images: images,
          initialIndex: index,
        ),
      ),
    );
  }
}
