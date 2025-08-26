import 'package:research_mantra_official/data/models/community/community_data_model.dart';

class AllCommunityState {
  final dynamic error;
  final bool isLoading;
  final GetCommunityDataModel ? getCommunityDataModel;
  final bool ?isLoadMOre;
  final  bool ?  otheractions;

  AllCommunityState({this.isLoadMOre, 
    required this.isLoading,
    this.error,
    this.getCommunityDataModel,
    this.otheractions,
  });

  factory AllCommunityState.initial() => AllCommunityState(
        isLoading: false,
        otheractions: false,
        // getCommunityDataModel: null,
      );
  factory AllCommunityState.loading( bool isLoading ,bool isLoadmore,GetCommunityDataModel ? getCommunityDataModel , bool ? otherActions) => AllCommunityState(
        isLoading: isLoading,
        isLoadMOre: isLoadmore,
        getCommunityDataModel: getCommunityDataModel,
         otheractions: otherActions,
      );

  factory AllCommunityState.loaded(GetCommunityDataModel getCommunityDataModel) =>
      AllCommunityState(
        isLoading: false,
        getCommunityDataModel: getCommunityDataModel,
      );
  factory AllCommunityState.error(dynamic error) => AllCommunityState(
        isLoading: false,
        error: error,
        getCommunityDataModel: null,
      );


}