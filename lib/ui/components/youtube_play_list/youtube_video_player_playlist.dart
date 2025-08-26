import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/playlist_model/video_playlist_response_model.dart';
import 'package:research_mantra_official/data/models/product_details_content_api_response_model.dart';
import 'package:research_mantra_official/providers/video_playlist_provider/chapter_name_provider.dart';
import 'package:research_mantra_official/services/no_screen_shot.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/common_widgets/icon_text.dart';
import 'package:research_mantra_official/ui/components/youtube_play_list/widgets/playlist_widget.dart';
import 'package:research_mantra_official/ui/components/youtube_play_list/widgets/video_description_widget.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerPlaylistWidget extends ConsumerStatefulWidget {
  final ProductDetailsItemApiResponseModel? getProductItemContent;
  final PlaylistDataResponseModel? playlistDataContent;
  final int productId;
  final List<String>? sreenshotList;

  const YoutubePlayerPlaylistWidget({
    super.key,
    required this.productId,
    required this.playlistDataContent,
    this.getProductItemContent,
    this.sreenshotList,
  });

  @override
  ConsumerState<YoutubePlayerPlaylistWidget> createState() =>
      _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState
    extends ConsumerState<YoutubePlayerPlaylistWidget> {
  late YoutubePlayerController _controller;
  late final firstVideo;
  final bool _isPlayerReady = false;
  final bool _isInitialView = true;
late  final ScrollController _scrollController;
  final noScreenshotUtil = NoScreenshotUtil();

  void disableScreenshots() async {
    await noScreenshotUtil.disableScreenshots();
  }

  void enableScreenshots() async {
    await noScreenshotUtil.enableScreenshots();
  }

  String _currentTitle = "";
  String _currentDescription = "";
  int _videoDuration = 0;
  String _language = "N/A";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _videoDuration = widget.getProductItemContent?.allVideoDuration ?? 0;
 
    // Configure orientation support
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _initializeFirstVideo();

    //disabled screen shot when entering screen
    disableScreenshots();
  }

  void _scrollToBottom() {

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
   
  }
  void _initializeFirstVideo() {
    // Robust first video selection with null safety
     firstVideo = _findFirstVisibleVideo();

    if (firstVideo != null) {
      // Use dummy data for initial view
      if (_isInitialView) {
        _currentTitle = firstVideo.title ?? "";
        _currentDescription = firstVideo.description ?? "";
        // Keep dummy duration until user clicks
        _videoDuration = _videoDuration ?? 0;
        _language = firstVideo.language ?? "N/A";
      } else {
        _updateVideoMetadata(firstVideo);
      }
      _initializeController(firstVideo);
    } else {
      // Fallback initialization with empty controller
      _controller = YoutubePlayerController(
        initialVideoId: '',
        flags: const YoutubePlayerFlags(autoPlay: false),
      );
    }
  }

  SubChapter? _findFirstVisibleVideo() {
    List<PlaylistItem> playlists = widget.playlistDataContent?.playlists ?? [];

    if (playlists.isEmpty) return null;

    for (var chapter in playlists) {
      for (var subChapter in chapter.subChapters) {
        if (subChapter.isVisible ?? true) return subChapter;
      }
    }
    return null;
  }

  void _initializeController(SubChapter video) {
    final videoId = YoutubePlayer.convertUrlToId(video.link ?? "") ?? '';

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
          autoPlay: false, hideControls: false, forceHD: false),
    );
  }

  void _updateVideoMetadata(SubChapter video) {
    setState(() {
      _currentTitle = video.title ?? "";
      _currentDescription = video.description ?? "";
      _videoDuration = video.videoDuration ?? 0;
      _language = video.language ?? "N/A";
    });
  }

  void _onSubChapterClick(SubChapter subChapter) {
     
    final videoId = YoutubePlayer.convertUrlToId(subChapter.link ?? "");
    setState(() {
      if (videoId != null) {
        _controller.load(videoId);
        _updateVideoMetadata(subChapter);
      }
    });

  }

  @override
  void dispose() {
    _controller.dispose();
        _scrollController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // enabled screenshot while closing
    enableScreenshots();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValidPlaylist =
        widget.playlistDataContent?.playlists.isNotEmpty ?? false;
    return YoutubePlayerBuilder(
      onEnterFullScreen: () {},
      onExitFullScreen: () {},
      player: YoutubePlayer(
        controller: _controller,
        aspectRatio: 16 / 9,
        onReady: () {
          
          final videoId = YoutubePlayer.convertUrlToId(firstVideo.link ?? "") ?? '';
          _controller.load(videoId);
        }
      ),
      builder: (context, player) => Scaffold(
        backgroundColor: theme.primaryColor,
        appBar: CommonAppBarWithBackButton(
          appBarText: kingresearchacademyscreentext,
          handleBackButton: () {
            Navigator.pop(context);

            ref.read(servicestitleNotifierProvider.notifier).updateChapterTitle(
                '${(widget.getProductItemContent?.totalChapters ?? 0)} ${(widget.getProductItemContent?.totalChapters ?? 0) == 1 ? "Chapter" : "Chapters"}');
          },
        ),
        body: hasValidPlaylist
            ? _buildPlaylistContent(context, player, theme)
            : _buildEmptyStateWidget(),
      ),
    );
  }

  Widget _buildPlaylistContent(
      BuildContext context, Widget player, ThemeData theme) {
    return SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Player Widget
          widget.playlistDataContent?.playlists[0].subChapters[0].link
                      ?.startsWith("https://") ==
                  true
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.shadowColor, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: player,
                  ),
                )
              : const SizedBox.shrink(),
          SizedBox(
            height: 2,
          ),
          // Video Description
          VideoDescriptionWidget(
            wantTitle: true,
            title: _currentTitle,
            description: _currentDescription,
            duration: _videoDuration,
            language: _language,
          ),
          SizedBox(
            height: 6,
          ),

          IconText(
            icon: Icons.playlist_add,
            text: 'Playlist',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.025,
              color: theme.primaryColorDark,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 6,
          ),

          // Playlist Section
          if (widget.playlistDataContent != null)
            PlaylistWidget(
              controller: _controller,
              playlistData: widget.playlistDataContent!,
              onSubChapterClick: _onSubChapterClick,
              onScrollToBottom: _scrollToBottom,
            ),
        ],
      ),
    ));
  }

  Widget _buildEmptyStateWidget() {
    return const Center(
      child: Text(
        "No playlist available",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
