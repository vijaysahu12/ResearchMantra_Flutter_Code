import 'package:research_mantra_official/data/models/community/community_data_model.dart';

class UpcomingVideoState {
  final dynamic error;
  final bool isLoading;
  final GetCommunityDataModel ? getCommunityDataModel;
  final bool ?isLoadMOre;
  final  bool ?  otheractions;

  UpcomingVideoState({this.isLoadMOre, 
    required this.isLoading,
    this.error,
    this.getCommunityDataModel,
    this.otheractions,
  });

  factory UpcomingVideoState.initial() => UpcomingVideoState(
        isLoading: false,
        otheractions: false,
        // getCommunityDataModel: null,
      );
  factory UpcomingVideoState.loading( bool isLoading ,bool isLoadmore,GetCommunityDataModel ? getCommunityDataModel , bool ? otherActions) => UpcomingVideoState(
        isLoading: isLoading,
        isLoadMOre: isLoadmore,
        getCommunityDataModel: getCommunityDataModel,
         otheractions: otherActions,
      );

  factory UpcomingVideoState.loaded(GetCommunityDataModel getCommunityDataModel) =>
      UpcomingVideoState(
        isLoading: false,
        getCommunityDataModel: getCommunityDataModel,
      );
  factory UpcomingVideoState.error(dynamic error) => UpcomingVideoState(
        isLoading: false,
        error: error,
        getCommunityDataModel: null,
      );


}