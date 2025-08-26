import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/community/community_data_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ICommunity_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/community/recorded_video/recorded_video_state.dart';


class RecordedVideoDataNotifier extends StateNotifier<RecordedVideoState> {

  RecordedVideoDataNotifier(
    this._communityRepository,
  ) : super(RecordedVideoState.initial());

  final ICommunityRepository _communityRepository;

  Future<void> communityData(int pageSize, int pageNumber,
      int communityProductId, int postTypeId) async {
    try {
   
      state = RecordedVideoState.loading(true, false, null, false);

      final community = await _communityRepository.getCommunity(
          pageSize, pageNumber, communityProductId, postTypeId);

      state = RecordedVideoState.loaded(community);
    } catch (e) {
      state = RecordedVideoState.error(e.toString());
    }
  }


  Future<void> loadMoreCommunityData(int pageSize, int pageNumber,
      int communityProductId, int postTypeId) async {
    try {
      state = RecordedVideoState.loading(
          false, true, state.getCommunityDataModel, false);

      final community = await _communityRepository.getCommunity(
          pageSize, pageNumber, communityProductId, postTypeId);
      community.posts;
      GetCommunityDataModel communityData = GetCommunityDataModel(
        posts: [
          ...state.getCommunityDataModel?.posts ?? [],
          ...community.posts ?? []
        ],
        totalCount: community.totalCount,
        totalPages: community.totalPages,
        pageNumber: community.pageNumber,
        pageSize: community.pageSize,
        hasPurchasedProduct: community.hasPurchasedProduct,
        hasAccessToPremiumContent: community.hasAccessToPremiumContent,
        canPost: community.canPost,
          communityId: state.getCommunityDataModel?.communityId ,
      );

      state = RecordedVideoState.loaded(communityData);
    } catch (e) {
      state = RecordedVideoState.error(e.toString());
    }
  }

}

final recordedVideoDataNotifierProvider =
    StateNotifierProvider<RecordedVideoDataNotifier, RecordedVideoState>(((ref) {
  final ICommunityRepository communityRepository =
      getIt<ICommunityRepository>();
  return RecordedVideoDataNotifier(
    communityRepository,
 
  );
}));


