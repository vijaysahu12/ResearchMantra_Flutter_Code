import 'dart:async';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:research_mantra_official/providers/newversion/new_version_provider.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/ui/components/update_screen/update_screen.dart';
import 'package:research_mantra_official/ui/router/auth_route_resolver.dart';
import 'package:research_mantra_official/utils/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends ConsumerStatefulWidget {
  final String? sessionDetails;
  const SplashScreen({this.sessionDetails, super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool userLoggedIn = false;
  bool shouldPlaySound = true;
  String? currentVersion;

  bool isLoading = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _hasNavigated = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000), // GIF duration
    )..forward().whenComplete(() {
        if (mounted) {
          setState(() {}); // Safe
        }
      });

    // _playAudio();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await getData();
    } catch (e) {
      log("Error during initialization: $e");
    }

    if (mounted) {
      if (!_hasNavigated) {
        _hasNavigated = true;
        _navigateToAuthRouteResolverWidget();
      }
    }
  }

  void _playAudio() async {
    await _audioPlayer.play(
        AssetSource('mp3/design.wav')); // Ensure the file exists in assets
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose of animation controller
    _audioPlayer.dispose(); // Dispose of audio player
    super.dispose();
  }

  getData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    currentVersion = packageInfo.version;

    bool isIOS = isGetIOSPlatform();
    bool isConnected =
        await CheckInternetConnection().checkInternetConnection();

    if (isConnected) {
      await ref.read(newVersionDetailsProvider.notifier).getAppNewVersionData(
          isIOS ? "iOS" : "Android", currentVersion ?? "");
    }
  }

  Future<void> _navigateToAuthRouteResolverWidget() async {
    // final String? sessionDetails = await _commonDetails.getRefreshToken();

    final isNewVersionAvailable = ref.watch(newVersionDetailsProvider);
    await Future.delayed(Duration(seconds: 2)); // Simulate API completion

    if (isNewVersionAvailable.newVersionResponseModel?.updateRequired ??
        false) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => UpdateScreen(
            updateScreenText: isNewVersionAvailable
                    .newVersionResponseModel?.message ??
                "Experience the latest improvements to enhance your financial journey with King Research.",
// isNewVersion: isNewVersion,

            userLoggedIn: (widget.sessionDetails != null &&
                (widget.sessionDetails?.isNotEmpty == true)),
          ),
        ),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => AuthRouteResolverWidget(
            userLoggedIn: (widget.sessionDetails != null &&
                (widget.sessionDetails?.isNotEmpty == true)),
          ),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFAF1D12), body: UnivestSplashScreen()

        //  LayoutBuilder(
        //   builder: (context, constraints) {
        //     return Stack(
        //       fit: StackFit.expand,
        //       children: [
        //         // GIF animation (only plays once)
        //         AnimatedBuilder(
        //           animation: _animationController,
        //           builder: (context, child) {
        //             return Opacity(
        //               opacity: _animationController.isCompleted
        //                   ? 0
        //                   : 1, // Hide GIF after playing
        //               child: Image.asset(splashGif, fit: BoxFit.cover),
        //             );
        //           },
        //         ),

        //         Positioned(
        //           bottom: 0,
        //           left: 0,
        //           right: 0,
        //           child: SizedBox(
        //             width: constraints.maxWidth,
        //             child: ProgressIndicatorExample(), // Loader widget
        //           ),
        //         ),
        //       ],
        //     );
        //   },
        // ),

        );
  }
}

class UnivestSplashScreen extends StatelessWidget {
  const UnivestSplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Main content area
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App title
                    const Text(
                      'RESEARCH MANTRA',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 64),

                    // Subtitle
                    const Text(
                      'Stock Market Super App',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Feature tags
                    const Text(
                      'Research • Invest • Grow',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom regulatory text
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'SEBI Registration no.: INZ005554717, Stock Broker | BSE TM CODE: 60369 | BSE TM',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Code: 6969 | SEBI Reg. no.: INF- | NSDL DP ID: IN3088818',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
