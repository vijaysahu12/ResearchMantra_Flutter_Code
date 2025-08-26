import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/playlist_model/video_playlist_response_model.dart';
import 'package:research_mantra_official/providers/video_playlist_provider/chapter_name_provider.dart';
import 'package:research_mantra_official/providers/video_playlist_provider/video_playlist_subchapter_selection_provider.dart';
import 'package:research_mantra_official/ui/components/common_widgets/icon_text.dart';
import 'package:research_mantra_official/utils/utils.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlaylistWidget extends ConsumerStatefulWidget {
  final PlaylistDataResponseModel playlistData;
  final Function(SubChapter) onSubChapterClick;
  final YoutubePlayerController controller;
final VoidCallback? onScrollToBottom;
  const PlaylistWidget({
    super.key,
    required this.playlistData,
    required this.onSubChapterClick,
    required this.controller,
      this.onScrollToBottom, 
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlaylistWidgetState();
}

class _PlaylistWidgetState extends ConsumerState<PlaylistWidget> {
  late List<bool> _expandedChapters;

  @override
  void initState() {
    super.initState();

    _expandedChapters =
        List.filled(widget.playlistData.playlists.length, false);
  }



// New method to calculate total chapter duration
  int _calculateChapterTotalDuration(PlaylistItem chapter) {
    return chapter.subChapters.fold(
        0, (total, subChapter) => total + (subChapter.videoDuration ?? 0));
  }

  void _toggleChapterExpansion(int index) {
    setState(() {
      _expandedChapters[index] = !_expandedChapters[index];
    });

  if (_expandedChapters[index]) {
    Future.delayed(Duration(milliseconds: 300), () {
      widget.onScrollToBottom?.call();
    });
  }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children:
          List.generate(widget.playlistData.playlists.length, (chapterIndex) {
        final chapter = widget.playlistData.playlists[chapterIndex];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
          child: ExpansionTile(
            shape: BeveledRectangleBorder(),
            childrenPadding: EdgeInsets.all(0),
            key: ValueKey('chapter_$chapterIndex'),
            initiallyExpanded: _expandedChapters[chapterIndex],
            onExpansionChanged: (isExpanded) =>
                _toggleChapterExpansion(chapterIndex),
            title: _buildChapterTitle(chapter, chapterIndex, theme),
            trailing: _buildExpansionIndicator(chapterIndex, theme),
            children: chapter.subChapters.asMap().entries.map((entry) {
              return _buildSubChapterItem(entry.value, chapterIndex, entry.key,
                  theme, chapter.chapterTitle);
            }).toList(),
          ),
        );
      }),
    );
  }

  Widget _buildChapterTitle(
      PlaylistItem chapter, int chapterIndex, ThemeData theme) {
    final totalChapterDuration = _calculateChapterTotalDuration(chapter);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Prevent unnecessary width
      children: [
        Flexible(
          // Wrap text to prevent overflow
          child: Text(
            chapter.chapterTitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.primaryColorDark,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconText(
              icon: Icons.subscriptions_outlined,
              iconSize: 20,
              text: '${chapter.subChapters.length}',
              style: TextStyle(fontSize: 12),
              decoration: BoxDecoration(),
              padding: EdgeInsets.all(4),
              sizedBox: 2,
              isFirstTextThenIcon: false,
            ),
            IconText(
              icon: Icons.schedule_outlined,
              iconSize: 20,
              text: Utils.durationConverter(totalChapterDuration),
              style: TextStyle(fontSize: 12),
              decoration: BoxDecoration(),
              padding: EdgeInsets.all(4),
              sizedBox: 2,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpansionIndicator(int chapterIndex, ThemeData theme) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Icon(
        _expandedChapters[chapterIndex] ? Icons.expand_less : Icons.expand_more,
        key: ValueKey(_expandedChapters[chapterIndex]),
        color: theme.primaryColorDark,
      ),
    );
  }

  Widget _buildSubChapterItem(SubChapter subChapter, int chapterIndex,
      int subChapterIndex, ThemeData theme, String chaptertitle) {
    final subChapterModel = ref.watch(myModelProvider);
    final isCurrentVideo = subChapterModel == subChapter;
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
            horizontal: BorderSide(
          width: 1,
          color: theme.shadowColor,
        )),
        color: isCurrentVideo
            ? theme.primaryColor.withValues(alpha: 0.1)
            : Colors.transparent,
      ),
      child: ListTile(
        leading: _buildSubChapterLeadingIcon(
          subChapter,
          isCurrentVideo,
          theme,
          chapterIndex,
          subChapterIndex,
        ),
        title: _buildSubChapterTitle(
            subChapter, chapterIndex, subChapterIndex, isCurrentVideo, theme),
        trailing: Text(
          Utils.formatDuration(subChapter.videoDuration ?? 0),
          style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isCurrentVideo
                  ? theme.disabledColor
                  : theme.primaryColorDark),
        ),
        onTap: subChapter.isVisible ?? false
            ? () {
                ref.read(myModelProvider.notifier).updateModel(subChapter);
                ref
                    .read(servicestitleNotifierProvider.notifier)
                    .updateChapterTitle(chaptertitle);
                widget.onSubChapterClick(subChapter);
              }
            : null,
      ),
    );
  }

  Widget _buildSubChapterLeadingIcon(
    SubChapter subChapter,
    bool isCurrentVideo,
    ThemeData theme,
    chapterIndex,
    subChapterIndex,
  ) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: !(subChapter.isVisible ?? true)
          ? Icon(
              Icons.lock_outline,
              key: const ValueKey('locked'),
              color: theme.focusColor,
            )
          : isCurrentVideo
              ? Icon(
                  Icons.play_circle,
                  key: const ValueKey('current'),
                  color: theme.disabledColor,
                )
              : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primaryColorDark,
                  ),
                  child: Text(
                    '  ${subChapterIndex + 1}  ',
                    key: const ValueKey('text'),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
    );
  }

  Widget _buildSubChapterTitle(SubChapter subChapter, int chapterIndex,
      int subChapterIndex, bool isCurrentVideo, ThemeData theme) {
    return Text(
      '${subChapter.title}',
      style: theme.textTheme.bodyMedium?.copyWith(
        fontSize: 14,
        color: subChapter.isVisible ?? true
            ? (isCurrentVideo
                ? theme.disabledColor
                : theme.textTheme.bodyMedium?.color)
            : theme.focusColor,
        fontWeight: isCurrentVideo ? FontWeight.w600 : FontWeight.normal,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
