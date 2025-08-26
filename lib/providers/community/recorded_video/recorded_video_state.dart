import 'package:research_mantra_official/data/models/community/community_data_model.dart';

class RecordedVideoState {
  final dynamic error;
  final bool isLoading;
  final GetCommunityDataModel ? getCommunityDataModel;
  final bool ?isLoadMOre;
  final  bool ?  otheractions;

  RecordedVideoState({this.isLoadMOre, 
    required this.isLoading,
    this.error,
    this.getCommunityDataModel,
    this.otheractions,
  });

  factory RecordedVideoState.initial() => RecordedVideoState(
        isLoading: false,
        otheractions: false,
        // getCommunityDataModel: null,
      );
  factory RecordedVideoState.loading( bool isLoading ,bool isLoadmore,GetCommunityDataModel ? getCommunityDataModel , bool ? otherActions) => RecordedVideoState(
        isLoading: isLoading,
        isLoadMOre: isLoadmore,
        getCommunityDataModel: getCommunityDataModel,
         otheractions: otherActions,
      );

  factory RecordedVideoState.loaded(GetCommunityDataModel getCommunityDataModel) =>
      RecordedVideoState(
        isLoading: false,
        getCommunityDataModel: getCommunityDataModel,
      );
  factory RecordedVideoState.error(dynamic error) => RecordedVideoState(
        isLoading: false,
        error: error,
        getCommunityDataModel: null,
      );


}