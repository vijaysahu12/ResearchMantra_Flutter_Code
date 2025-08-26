import 'package:research_mantra_official/data/models/playlist_model/video_playlist_response_model.dart';

// State class for video playlist
class VideoPlaylistState {
  final bool isLoading;
  final PlaylistDataResponseModel? data;
  final String? error;

  const VideoPlaylistState({
    required this.isLoading,
    this.data,
    this.error,
  });

  // Initial state
  factory VideoPlaylistState.initial() => const VideoPlaylistState(isLoading: false);

  // Loading state
  factory VideoPlaylistState.loading() => const VideoPlaylistState(isLoading: true);

  // Loaded state
  factory VideoPlaylistState.loaded(PlaylistDataResponseModel data) => 
      VideoPlaylistState(isLoading: false, data: data);

  // Error state
  factory VideoPlaylistState.error(String error) => 
      VideoPlaylistState(isLoading: false, error: error);
}




