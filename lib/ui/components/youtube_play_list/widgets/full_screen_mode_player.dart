import 'package:flutter/material.dart';
import 'package:research_mantra_official/services/no_screen_shot.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullScreenVideoPlayerPage extends StatefulWidget {
  final String videoUrl;

  const FullScreenVideoPlayerPage({super.key, required this.videoUrl});

  @override
  FullScreenVideoPlayerPageState createState() =>
      FullScreenVideoPlayerPageState();
}

class FullScreenVideoPlayerPageState extends State<FullScreenVideoPlayerPage> {
  late YoutubePlayerController _controller;


  //NO screen shot enabled
  final noScreenshotUtil = NoScreenshotUtil();

  void disableScreenshots() async {
    await noScreenshotUtil.disableScreenshots();
  }

  void enableScreenshots() async {
    await noScreenshotUtil.enableScreenshots();
  }

  @override
  void initState() {
    super.initState();
        //disabled screen shot when entering screen
    disableScreenshots();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    enableScreenshots();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        bottomActions: [
          CurrentPosition(),
          ProgressBar(isExpanded: true),
          RemainingDuration(),
          FullScreenButton(),
        ],
      ),
      builder: (context, player) => Scaffold(
        backgroundColor: theme.primaryColor,
        appBar: CommonAppBarWithBackButton(
          appBarText: "",
          handleBackButton: () => Navigator.pop(context),
        ),
        body: Center(child: player),
      ),
    );
  }
}
