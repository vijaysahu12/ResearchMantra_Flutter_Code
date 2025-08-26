import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ICommunity_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/community/community_details/community_state.dart';

class CommunityTypeNotifier extends StateNotifier<CommunityTypeState> {
  CommunityTypeNotifier(
    this._communityRepository,
  ) : super(CommunityTypeState.initial());

  final ICommunityRepository _communityRepository;

  Future<void> communityDetailsType() async {
    try {
      state = CommunityTypeState.loading();

      final communityDetails = await _communityRepository.getCommunityDetails();

      state = CommunityTypeState.loaded(communityDetails);
    } catch (e) {
      state = CommunityTypeState.error(e.toString());
    }
  }
}

final communityTypeNotifierProvider =
    StateNotifierProvider<CommunityTypeNotifier, CommunityTypeState>(((ref) {
  final ICommunityRepository communityRepository =
      getIt<ICommunityRepository>();
  return CommunityTypeNotifier(
    communityRepository,
  );
}));
