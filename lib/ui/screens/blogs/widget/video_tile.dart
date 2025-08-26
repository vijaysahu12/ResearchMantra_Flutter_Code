import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/community/community_data_model.dart';

import 'package:research_mantra_official/ui/components/expanded/expanded_widget.dart';
import 'package:research_mantra_official/ui/components/youtube_play_list/widgets/full_screen_mode_player.dart';
import 'package:research_mantra_official/ui/screens/blogs/widget/community_image_viewer.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/utils.dart';

class VideoTile extends StatelessWidget {
  final Post videos;
  const VideoTile({super.key, required this.videos});

  void _navigateToVideoPlayer(BuildContext context) {
    if (videos.url != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenVideoPlayerPage(
            videoUrl: videos.url!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        border: Border.all(color: theme.focusColor.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title & Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  videos.title ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: width * 0.035,
                    fontFamily: fontFamily,
                    color: theme.primaryColorDark,
                  ),
                ),
              ),
              if (videos.createdOn != null)
                Text(
                  Utils.formatDateTime(
                    dateTimeString: videos.createdOn!,
                    format: ddmmyy,
                  ),
                  style: TextStyle(
                    fontSize: width * 0.03,
                    color: theme.focusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          /// Expandable Description
          ExpandableText(
            text: videos.content,
            trimLength: 250,
            textStyle: TextStyle(
              fontSize: width * 0.03,
              fontFamily: fontFamily,
              color: theme.primaryColorDark,
            ),
            linkStyle: TextStyle(
              fontSize: width * 0.03,
              fontWeight: FontWeight.w600,
              fontFamily: fontFamily,
              color: theme.indicatorColor,
            ),
          ),
          const SizedBox(height: 15),
          /// Video Thumbnail (if imageUrl is available)
          if (videos.imageUrl != null)
            GestureDetector(
              onTap: () => _navigateToVideoPlayer(context),
              child: AspectRatio(
                aspectRatio: 2,
                child: CommunityImageViewer(
                  imageURL: videos.imageUrl!,
                ),
              ),
            ),

          const SizedBox(height: 5),

          /// Video Thumbnail (if imageUrl is available
          if (videos.imageUrl == null)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _navigateToVideoPlayer(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: theme.focusColor, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_circle_fill,
                            size: 18,
                            color: theme.primaryColorDark,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Watch Now",
                            style: textStandard.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: fontFamily,
                              color: theme.primaryColorDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
