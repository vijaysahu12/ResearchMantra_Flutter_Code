import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/data/models/playlist_model/video_playlist_response_model.dart';
import 'package:research_mantra_official/data/models/product_details_content_api_response_model.dart';
import 'package:research_mantra_official/providers/video_playlist_provider/chapter_name_provider.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';
import 'package:research_mantra_official/ui/components/custom_youtube_player/custom_youtube_player.dart';

import 'package:research_mantra_official/ui/components/youtube_play_list/widgets/video_description_widget.dart';
import 'package:research_mantra_official/ui/components/youtube_play_list/youtube_video_player_playlist.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:research_mantra_official/providers/video_playlist_provider/video_playlist_provider.dart';

class ProductDetailsContentWidget extends ConsumerStatefulWidget {
  final ProductDetailsItemApiResponseModel? getProductItemContent;
  final bool isInMyBucketString;
  final bool isInValidity;
  final bool? isFromResearch;
  final String isFree;
  final int productId;
  final List<String>? sreenshotList;

  const ProductDetailsContentWidget({
    super.key,
    required this.isInMyBucketString,
    required this.isInValidity,
    this.isFromResearch,
    required this.getProductItemContent,
    required this.isFree,
    required this.productId,
    this.sreenshotList,
  });

  @override
  ConsumerState<ProductDetailsContentWidget> createState() =>
      _ProductDetailsContentWidgetState();
}

class _ProductDetailsContentWidgetState
    extends ConsumerState<ProductDetailsContentWidget> {
  YoutubePlayerController? _controller;
  late int duration = 0;

  bool get canAccessContent =>
      widget.isInMyBucketString && widget.isInValidity ||
      widget.isFree.toLowerCase() == "free";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(servicestitleNotifierProvider.notifier).updateChapterTitle(
          '${(widget.getProductItemContent?.totalChapters ?? 0)} ${(widget.getProductItemContent?.totalChapters ?? 0) == 1 ? "Chapter" : "Chapters"}');
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void handleNavigateToVideoPlayer(BuildContext context) {
    if (canAccessContent) {
      // Fetch the video playlist data before navigation
      ref
          .read(videoPlaylistProvider.notifier)
          .getVideoPlaylist(widget.productId)
          .then((_) {
        final videoPlaylistState = ref.read(videoPlaylistProvider);

        if (videoPlaylistState.data != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => YoutubePlayerPlaylistWidget(
                getProductItemContent: widget.getProductItemContent,
                productId: widget.productId,
                playlistDataContent: videoPlaylistState.data ??
                    PlaylistDataResponseModel(playlists: []),
                sreenshotList: widget.sreenshotList,
              ),
            ),
          );
        } else if (_controller == null) {
          // Handle error, maybe show a snackbar or error message
          ToastUtils.showToast('SomeThing Went Wrong!', '');
        } else if (videoPlaylistState.error != null) {
          // Handle error, maybe show a snackbar or error message
          ToastUtils.showToast('No PlayList Available.', '');
        }
      });
    } else {
      handleNavigateToPayment(context);
    }
  }

  void handleNavigateToPayment(BuildContext context) {
    // TODO: Implement payment navigation
  }

  Widget _buildVideoThumbnail() {
    final thumbnailImage = widget.getProductItemContent?.thumbnailImage;
    final contentVideoUrl = widget.getProductItemContent?.attachment;

    // Check if thumbnail image is available
    if (thumbnailImage != null && thumbnailImage.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularCachedNetworkLandScapeImages(
          imageURL: thumbnailImage,
          baseUrl: 'nobase',
          defaultImagePath: productLandScapeImage,
          aspectRatio: 2 / 0.8,
        ),
      );
    } else {
      // Return video player if no thumbnail image
      if (contentVideoUrl != null && contentVideoUrl.startsWith("http")) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomYoutubePlayer(
            youtubeUrl: contentVideoUrl,
          ),
        );
      } else {
        return Center();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.height * 0.015;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.shadowColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColorDark.withValues(alpha: 0.1),
              blurRadius: 2,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleRow(theme, fontSize),
            _buildVideoThumbnail(),
            VideoDescriptionWidget(
                wantTitle: false,
                title: widget.getProductItemContent?.title ?? "N/A",
                description: widget.getProductItemContent?.description ?? "N/A",
                duration: widget.getProductItemContent?.allVideoDuration ?? 0,
                language: widget.getProductItemContent?.language ?? "N/A",
                videos: widget.getProductItemContent?.totalVideoCount ?? 0,
                screenshotList: widget.getProductItemContent?.screenshotList),
            const Divider(),
            _buildActionButton(context, theme, fontSize),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleRow(ThemeData theme, double fontSize) {
    return Row(
      children: [
        _buildImage(),
        Expanded(
          child: Text(
            widget.getProductItemContent?.title ?? "",
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: fontFamily,
              fontWeight: FontWeight.bold,
              color: theme.primaryColorDark,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      BuildContext context, ThemeData theme, double fontSize) {
    return GestureDetector(
      onTap: () => handleNavigateToVideoPlayer(context),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.primaryColorDark, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'View Content',
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w600,
                color: theme.primaryColorDark,
              ),
            ),
            const SizedBox(width: 20),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: theme.primaryColorDark,
              size: fontSize * 1,
            ),
            _buildAccessIcon(theme, fontSize),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessIcon(ThemeData theme, double fontSize) {
    final isFreeContent = widget.isFree.toLowerCase() == "free";

    if (!widget.isInValidity && !isFreeContent) {
      return Icon(
        Icons.lock_rounded,
        color: theme.disabledColor,
        size: fontSize * 2,
      );
    } else if (widget.isInValidity && isFreeContent) {
      return Icon(
        Icons.lock_open_rounded,
        color: theme.secondaryHeaderColor,
        size: fontSize * 2,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildImage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Image.asset(
        contentProductImage,
        height: 50,
        width: 50,
      ),
    );
  }
}
