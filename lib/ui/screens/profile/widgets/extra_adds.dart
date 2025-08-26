import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/data/models/dashboard/dashboard_slider_model.dart';
import 'package:research_mantra_official/services/url_launcher_helper.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';

//Widget for ExtraOffer or Adds
class ExtraAddsWidget extends StatefulWidget {
  final List<CommonImagesResponseModel> getProfileScreenImages;

  const ExtraAddsWidget({
    super.key,
    required this.getProfileScreenImages,
  });

  @override
  State<ExtraAddsWidget> createState() => _ExtraAddsWidgetState();
}

class _ExtraAddsWidgetState extends State<ExtraAddsWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    // Proceed if the list is not empty
    final String url = widget.getProfileScreenImages[0].url!.trim();
    final String? name = widget.getProfileScreenImages[0].name;

    return GestureDetector(
      onTap: () async {
        if (url.isNotEmpty && url != '') {
          await UrlLauncherHelper.launchUrlIfPossible(url);
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: theme.shadowColor,
            width: 0.5,
          ),
        ),
        child: CircularCachedNetworkLandScapeImages(
          imageURL: name ?? '',
          baseUrl: screenerImages,
          defaultImagePath: profileScreenDefaultImage,
          aspectRatio: 4 / 3,
        ),
      ),
    );
  }
}
