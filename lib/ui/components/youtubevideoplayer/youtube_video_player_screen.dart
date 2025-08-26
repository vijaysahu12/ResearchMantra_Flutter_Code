
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/product_details_content_api_response_model.dart';
import 'package:research_mantra_official/services/no_screen_shot.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/expanded/expanded_widget.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  final ProductDetailsItemApiResponseModel? getProductItemContent;

  const YoutubePlayerWidget({super.key, required this.getProductItemContent});

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _controller;
  bool isPlayerReady = false;

  final noScreenshotUtil = NoScreenshotUtil();

  void disableScreenshots() async {
    await noScreenshotUtil.disableScreenshots();
  }

  void enableScreenshots() async {
    await noScreenshotUtil.enableScreenshots();
  }

  double value = 16 / 9;
  bool readMe = false;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
              "${widget.getProductItemContent!.attachment}") ??
          '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        hideControls: false,
        hideThumbnail: true,
      ),
    );
    disableScreenshots();
    _controller.addListener(_videoPlayerListener);
  }

  void _videoPlayerListener() {
    if (_controller.value.playerState == PlayerState.paused) {
      setState(() {
        isPlayerReady = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoPlayerListener);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _controller.dispose();
    enableScreenshots();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final mediaQuery = MediaQuery.of(context);
    // final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final fontSize = MediaQuery.of(context).size.width;
    return YoutubePlayerBuilder(
        onEnterFullScreen: () {},
        onExitFullScreen: () {},
        player: YoutubePlayer(
          aspectRatio: 2.3,
          controller: _controller,
          showVideoProgressIndicator: false,
        ),
        builder: (context, player) {
          return Scaffold(
            backgroundColor: theme.primaryColor,
            appBar: CommonAppBarWithBackButton(
              appBarText: kingresearchacademyscreentext,
              handleBackButton: () => Navigator.pop(context),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.getProductItemContent!.attachment!
                            .startsWith("https://")
                        ? player
                        : const SizedBox.shrink(),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        border: Border(
                          bottom: BorderSide(
                            color: theme.shadowColor,
                            width: 0.6,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.getProductItemContent!.title!,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.015,
                                      color: theme.primaryColorDark,
                                      fontFamily: fontFamily,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          ExpandableText(
                            text: widget.getProductItemContent?.description,
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
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
