import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:research_mantra_official/data/models/hive_model/promo_hive_model.dart';
import 'package:research_mantra_official/services/url_launcher_helper.dart';
import 'package:research_mantra_official/ui/components/dynamic_promo_card/promo_image_viewer.dart';
import 'package:research_mantra_official/utils/utils.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PromoBottomSheet extends StatefulWidget {
  final PromoHiveModel promo;

  const PromoBottomSheet({super.key, required this.promo});

  @override
  State<PromoBottomSheet> createState() => _PromoBottomSheetState();
}

class _PromoBottomSheetState extends State<PromoBottomSheet> {
  VideoPlayerController? _videoController;
  YoutubePlayerController? _youtubeController;
  final box = Hive.box<PromoHiveModel>('promos');
  bool get isYouTube =>
      widget.promo.mediaItems.isNotEmpty &&
      widget.promo.mediaItems.first.mediaUrl.contains("youtube");

  List<String> get images =>
      widget.promo.mediaItems.map((e) => e.mediaUrl).toList();

  @override
  void initState() {
    super.initState();

    if (widget.promo.mediaType.toLowerCase() == 'video' &&
        widget.promo.mediaItems.isNotEmpty) {
      final currentUrl = widget.promo.mediaItems[currentMediaIndex].mediaUrl;

      if (isYouTube) {
        final videoId = YoutubePlayer.convertUrlToId(currentUrl);
        if (videoId != null) {
          _youtubeController = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(autoPlay: true),
          );
        }
      } else {
        _videoController = VideoPlayerController.network(currentUrl)
          ..initialize().then((_) {
            setState(() {});
            _videoController?.play();
          });
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  int currentMediaIndex = 0;
  @override
  Widget build(BuildContext context) {
    final isVideo = widget.promo.mediaType.toLowerCase() == 'video';
    final currentButtons = (currentMediaIndex < widget.promo.mediaItems.length)
        ? widget.promo.mediaItems[currentMediaIndex].buttons
        : [];

    return GestureDetector(
      onTap: () async {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        if (widget.promo.globalButtonAction) {
          handlePromoTap(
            context: context,
            promo: widget.promo,
            box: box,
            isGlobalAction: widget.promo.globalButtonAction,
          );
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  child: isVideo
                      ? isYouTube
                          ? YoutubePlayer(controller: _youtubeController!)
                          : (_videoController != null &&
                                  _videoController!.value.isInitialized)
                              ? VideoPlayer(_videoController!)
                              : const Center(child: Icon(Icons.replay))
                      : PromoImageViewer(
                          images: images,
                          onPageChanged: (index) {
                            setState(() => currentMediaIndex = index);
                          },
                        ),
                ),
              ),
            ),
            if (!widget.promo.globalButtonAction)
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
                      if (currentButtons.length == 1) ...[
                        _buildFullWidthButton(
                            context,
                            currentButtons[0].buttonName,
                            currentButtons[0].actionUrl,
                            currentButtons[0].productName,
                            currentButtons[0].productId),
                      ] else ...[
                        Row(
                          children:
                              List.generate(currentButtons.length, (index) {
                            final btn = currentButtons[index];
                            return Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: _buildFullWidthButton(
                                    context,
                                    btn.buttonName,
                                    btn.actionUrl,
                                    btn.productName,
                                    btn.productId),
                              ),
                            );
                          }),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullWidthButton(BuildContext context, String text,
      String actionUrl, String productName, int productId) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () async {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        handlePromoTap(
          context: context,
          promo: widget.promo,
          box: box,
          actionText: text,
          actionUrl: actionUrl,
          productId: productId,
          productName: productName,
          isGlobalAction: widget.promo.globalButtonAction,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFAD0202), Color(0xFF000000)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: theme.floatingActionButtonTheme.foregroundColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> handlePromoTap({
    required BuildContext context,
    required PromoHiveModel promo,
    required Box<PromoHiveModel> box,
    String? actionText,
    String? actionUrl,
    bool isGlobalAction = false,
    int? productId,
    String? productName,
  }) async {
    // Handle tap based on the flag
    if (isGlobalAction) {
      UrlLauncherHelper.handleToNavigatePathScreen(
        context,
        promo.target,
        promo.productId,
        promo.productName,
        false,
      );
    } else {
      if (actionText?.toLowerCase() == "download") {
        downloadAndShareFile(actionUrl ?? '', fileName: 'kingResearch.pdf');
      } else {
        UrlLauncherHelper.handleToNavigatePathScreen(
          context,
          actionUrl ?? '',
          productId,
          productName,
          false,
        );
      }
    }
    // Update the promo info before action
    final updatedPromo = promo.copyWith(
      maxDisplayCount: promo.maxDisplayCount - 1,
      lastShownAt: DateTime.now().toIso8601String(),
    );
    await box.put(promo.id, updatedPromo);
  }
}
