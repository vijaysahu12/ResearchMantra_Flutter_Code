import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/community/community_data_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ICommunity_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/community/upcoming_event/upcoming_video_state.dart';


class UpcomingVideoDataNotifier extends StateNotifier<UpcomingVideoState> {

  UpcomingVideoDataNotifier(
    this._communityRepository,
  ) : super(UpcomingVideoState.initial());

  final ICommunityRepository _communityRepository;

  Future<void> communityData(int pageSize, int pageNumber,
      int communityProductId, int postTypeId) async {
    try {
   
      state = UpcomingVideoState.loading(true, false, null, false);

      final community = await _communityRepository.getCommunity(
          pageSize, pageNumber, communityProductId, postTypeId);

      state = UpcomingVideoState.loaded(community);
    } catch (e) {
      state = UpcomingVideoState.error(e.toString());
    }
  }


  Future<void> loadMoreCommunityData(int pageSize, int pageNumber,
      int communityProductId, int postTypeId) async {
    try {
      state = UpcomingVideoState.loading(
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

      state = UpcomingVideoState.loaded(communityData);
    } catch (e) {
      state = UpcomingVideoState.error(e.toString());
    }
  }

}

final upcomingVideoDataNotifierProvider =
    StateNotifierProvider<UpcomingVideoDataNotifier, UpcomingVideoState>(((ref) {
  final ICommunityRepository communityRepository =
      getIt<ICommunityRepository>();
  return UpcomingVideoDataNotifier(
    communityRepository,
 
  );
}));


