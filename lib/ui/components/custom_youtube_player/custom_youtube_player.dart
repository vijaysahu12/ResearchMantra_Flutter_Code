import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CustomYoutubePlayer extends StatefulWidget {
  final String youtubeUrl;

  const CustomYoutubePlayer({
    super.key,
    required this.youtubeUrl,
  });

  @override
  State<CustomYoutubePlayer> createState() => _CustomYoutubePlayerState();
}

class _CustomYoutubePlayerState extends State<CustomYoutubePlayer>
    with WidgetsBindingObserver {
  late YoutubePlayerController _controller;
late final videoId;
  @override
  void initState() {
    super.initState();
  videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl) ?? "";
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        // Keep controls visible
        hideControls: false,
      ),
    );

    // Register as an observer for app lifecycle changes
    WidgetsBinding.instance.addObserver(this);

    // Force portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    // Remove the observer when disposing
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If app returns to foreground, ensure we're still in portrait mode
    // This helps prevent fullscreen if the user tries to rotate device
    if (state == AppLifecycleState.resumed) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              onReady: () {
                _controller.load(videoId);
                // Ensure portrait mode is locked when video is ready
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                ]);
              },
            ),
          ),
          // Transparent overlay in the bottom-right corner to intercept fullscreen button taps
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 40,
                height: 40,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
