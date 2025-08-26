// StateNotifier that will manage MyModel state
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/playlist_model/video_playlist_response_model.dart';

class SubChapterModelNotifier extends StateNotifier<SubChapter> {
  SubChapterModelNotifier() : super(SubChapter());

  // Method to update the model
  void updateModel(SubChapter model) {
    state = model;
  }
}
// Provider for MyModelNotifier
final myModelProvider = StateNotifierProvider<SubChapterModelNotifier, SubChapter>((ref) {
  return SubChapterModelNotifier();
});