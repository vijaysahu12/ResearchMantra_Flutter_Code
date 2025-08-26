// this is the provider file
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/playlist_model/video_playlist_response_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IProduct_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/video_playlist_provider/video_playlist_state.dart';

class VideoPlaylistStateNotifier extends StateNotifier<VideoPlaylistState> {
  VideoPlaylistStateNotifier(this._videoPlaylistRepository)
      : super(VideoPlaylistState.initial());  

  final IProductRepository _videoPlaylistRepository;

  Future<void> getVideoPlaylist(int productId) async {
    state = VideoPlaylistState.loading();
    try {
      final PlaylistDataResponseModel videoPlaylist = await _videoPlaylistRepository.getVideoPlaylist(productId);
      state = VideoPlaylistState.loaded(videoPlaylist);
    } catch (e) {
      state = VideoPlaylistState.error(e.toString());
    }
  }
}

final videoPlaylistProvider = StateNotifierProvider<VideoPlaylistStateNotifier, VideoPlaylistState>((ref) {
  final IProductRepository videoPlaylistRepository = getIt<IProductRepository>(); 
  return VideoPlaylistStateNotifier(videoPlaylistRepository);
});

