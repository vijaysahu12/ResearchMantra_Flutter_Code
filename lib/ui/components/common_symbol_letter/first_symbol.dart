import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:shimmer/shimmer.dart';

class CustomImageWidgetWithFirstWord extends StatelessWidget {
  final String imageURL;
  final String tradingSymbol;
  final ThemeData theme;

  const CustomImageWidgetWithFirstWord({
    super.key,
    required this.imageURL,
    required this.tradingSymbol,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: (imageURL.isNotEmpty)
          ? CachedNetworkImage(
              imageUrl: "$screenerImages?imageName=$imageURL",
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: theme.primaryColor.withOpacity(0.9),
                highlightColor: theme.primaryColor.withOpacity(0.9),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: theme.primaryColor,
                ),
              ),
              errorWidget: (context, url, error) =>
                  _fallbackText(tradingSymbol),
            )
          : _fallbackText(tradingSymbol),
    );
  }

  Widget _fallbackText(tradingSymbol) {
    return (tradingSymbol == null || tradingSymbol.isEmpty)
        ? Container()
        : Container(
            decoration: BoxDecoration(
              color: theme.primaryColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              tradingSymbol.isNotEmpty ? tradingSymbol[0] : "",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.primaryColorDark,
              ),
            ),
          );
  }
}
