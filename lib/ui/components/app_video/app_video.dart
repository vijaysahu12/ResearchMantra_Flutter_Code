import 'package:flutter/material.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AppVideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const AppVideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<AppVideoPlayerScreen> createState() => _AppVideoPlayerScreenState();
}

class _AppVideoPlayerScreenState extends State<AppVideoPlayerScreen> {
  late YoutubePlayerController _controller;
  late final videoId;
  @override
  void initState() {
    super.initState();
     videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        loop: true,
        mute: false,
        enableCaption: false,
        forceHD: true,
        controlsVisibleAtStart: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.pause(); // Pause the video before disposing
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.cancel_outlined,
            color: theme.primaryColorDark,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: theme.primaryColor,
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(controller: _controller,
          onReady: () {
            _controller.load(videoId);
          },
        ),
        builder: (context, player) {
          return Stack(
            children: [
              Positioned.fill(child: player), // Make player full screen
            ],
          );
        },
      ),
    );
  }
}
