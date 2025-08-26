import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/data/models/blogs/blog_api_response_model.dart';
import 'package:research_mantra_official/data/models/image_model.dart';
import 'package:research_mantra_official/providers/video_playlist_provider/chapter_name_provider.dart';

import 'package:research_mantra_official/ui/components/common_widgets/icon_text.dart';
import 'package:research_mantra_official/ui/components/expanded/expanded_widget.dart';
import 'package:research_mantra_official/ui/components/image_gallery/full_screen_image_viewer.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class VideoDescriptionWidget extends ConsumerStatefulWidget {
  final bool wantTitle;
  final bool showTime;
  final String? title;
  final int? duration;
  final List<ImageDetails>? screenshotList;

  final String? language;
  final String description;
  final int? videos;

  const VideoDescriptionWidget({
    super.key,
    required this.title,
    required this.description,
    required this.duration,
    this.language,
    this.wantTitle = false,
    this.showTime = false,
    this.videos,
    this.screenshotList,
  });

  @override
  ConsumerState<VideoDescriptionWidget> createState() =>
      _VideoDescriptionWidgetState();
}

class _VideoDescriptionWidgetState
    extends ConsumerState<VideoDescriptionWidget> {
  bool readMore = false;
  bool showTitle = true;

  void _openFullScreenViewer(
      BuildContext context, int index, List<ImageItem> imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(
          images: imageUrl,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final videoTitleValue = ref.watch(servicestitleNotifierProvider);

    final fontSize = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.shadowColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.wantTitle == showTitle) ...[
            Text(
              widget.title ?? "",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.018,
                  color: theme.primaryColorDark,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w600),
            ),
            Divider(
              thickness: 0.6,
            ),
          ],
          ExpandableText(
            text: widget.description,
            trimLength: 400,
            textStyle: TextStyle(
              fontSize: fontSize * 0.026,
              fontFamily: fontFamily,
              color: theme.primaryColorDark,
            ),
            linkStyle: TextStyle(
              fontSize: fontSize * 0.03,
              fontWeight: FontWeight.w600,
              fontFamily: fontFamily,
              color: theme.indicatorColor,
            ),
          ),
          Divider(
            thickness: 0.6,
          ),
          if (widget.screenshotList != null &&
              widget.screenshotList!.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        widget.screenshotList!.length,
                        (index) => GestureDetector(
                              onTap: () => _openFullScreenViewer(context, 0, [
                                ImageItem(
                                    name: widget.screenshotList![index].name,
                                    aspectRatio: widget
                                        .screenshotList![index].aspectRatio)
                              ]),
                              child: ImageTypeCachedNetworkImage(
                                  width: 100,
                                  imageURL: widget.screenshotList![index].name),
                            ))),
              ),
            ),
          ],
          if (videoTitleValue.isNotEmpty)
            Align(
              alignment: videoTitleValue[0] == "1"
                  ? Alignment.centerLeft
                  : Alignment.center,
              child: Wrap(direction: Axis.horizontal, children: [
                videoTitleValue[0] == "1"
                    ? SizedBox()
                    : IconText(
                        icon: Icons.video_library_outlined,
                        text: videoTitleValue,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: fontSize * 0.026,
                          fontFamily: fontFamily,
                          color: theme.primaryColorDark,
                        ),
                      ),
                if (videoTitleValue.length > 20) ...[
                  Divider(),
                ],
                Wrap(
                    runAlignment: WrapAlignment.spaceBetween,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      if (widget.videos != null) ...[
                        IconText(
                          icon: Icons.subscriptions_outlined,
                          text: widget.videos! <= 1
                              ? '${widget.videos} Session '
                              : '${widget.videos} Sessions',
                          style: TextStyle(
                            fontSize: fontSize * 0.026,
                            fontFamily: fontFamily,
                            color: theme.primaryColorDark,
                          ),
                        ),
                      ],
                      IconText(
                        icon: Icons.schedule_outlined,
                        text: Utils.durationConverter(widget.duration ?? 1),
                        style: TextStyle(
                          fontSize: fontSize * 0.026,
                          fontFamily: fontFamily,
                          color: theme.primaryColorDark,
                        ),
                      ),
                      if (videoTitleValue.length > 20) ...[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                        )
                      ],
                      if (widget.language != 'N/A') ...[
                        IconText(
                          icon: Icons.translate_outlined,
                          text: widget.language ?? "",
                          style: TextStyle(
                            fontSize: fontSize * 0.026,
                            fontFamily: fontFamily,
                            color: theme.primaryColorDark,
                          ),
                        ),
                      ],
                    ])
              ]),
            ),
        ],
      ),
    );
  }
}

class ImageTypeCachedNetworkImage extends StatelessWidget {
  final String imageURL;
  final double? width;
  final double? height;
  final Decoration? decoration;

  const ImageTypeCachedNetworkImage({
    super.key,
    required this.imageURL,
    this.height,
    this.width,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      width: width,
      height: width,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: imageURL,
          fit: BoxFit.cover,
          placeholder: (context, url) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: width, // Adjust size as per your needs
                height: height,
                color: Colors.white,
              ),
            );
          },
          errorWidget: (context, error, stackTrace) => Image.asset(
            productDefaultmage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
