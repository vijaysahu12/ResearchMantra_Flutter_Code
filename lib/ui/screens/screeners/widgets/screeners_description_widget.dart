import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class ScreenDescription extends StatelessWidget {
  final Color color;
  final String screenerCategory;
  final String? numberOfStocks;
  final String? lastUpdated;
  final String description;
  final String? image;
  const ScreenDescription({
    super.key,
    required this.color,
    this.numberOfStocks,
    this.lastUpdated,
    required this.screenerCategory,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [color, Colors.white],
              stops: const [0.5, 10],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    screenerCategory,
                    style: textH5.copyWith(fontSize: 14, color: Colors.white),
                  ),
                   Text("${numberOfStocks ?? 0} Stocks "
                   //| Last Updated ${lastUpdated ?? '-'}"
                   ,style: textH5.copyWith(fontSize: 12,color: Colors.white))
                ],
              ),
              _customImages("$screenerImages?imageName=$image"),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          _buildDescription(theme),
        ],
      ),
    );
  }

  Widget _customImages(String imageURl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageURl,
        fit: BoxFit.cover,
        height: 30,
        width: 30,
        placeholder: (context, url) => Container(),
        errorWidget: (context, url, error) => ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(),
        ),
      ),
    );
  }

  //Widget _buildDescription()
  Widget _buildDescription(theme) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: theme.primaryColor, borderRadius: BorderRadius.circular(2)),
      child: Row(
        children: [
          Flexible(
              child: Text(
            description,
            maxLines: 3,
            style: textH5.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.primaryColorDark),
          )),
        ],
      ),
    );
  }
}
