import 'package:research_mantra_official/data/models/community/community_type_model.dart';

class CommunityTypeState {
  final dynamic error;
  final bool isLoading;
  final CommunityTypeModel ? communityTypeModel;

  CommunityTypeState({
    required this.isLoading,
    this.error,
    this.communityTypeModel,
  });

  factory CommunityTypeState.initial() => CommunityTypeState(
        isLoading: false,
        communityTypeModel: null,
      );
  factory CommunityTypeState.loading() => CommunityTypeState(
        isLoading: true,
      );

  factory CommunityTypeState.loaded(CommunityTypeModel communityTypeModel) =>
      CommunityTypeState(
        isLoading: false,
        communityTypeModel: communityTypeModel,
      );
  factory CommunityTypeState.error(dynamic error) => CommunityTypeState(
        isLoading: false,
        error: error,
        communityTypeModel: null,
      );


}