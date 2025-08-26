import 'package:research_mantra_official/data/models/block_user/block_user.dart';

// Define a new state class for managing blog posts
class GetBlockedUserState {
  final List<GetBlocUserResponseModel> blockUserResponseModel;
  final bool isLoading;
  final bool isUnblock;

  final dynamic error;

  GetBlockedUserState({
    required this.blockUserResponseModel,
    required this.isLoading,
    required this.isUnblock,
    required this.error,
  });

  // Helper methods to create different instances of the state
  factory GetBlockedUserState.initial() {
    return GetBlockedUserState(
      blockUserResponseModel: [],
      isLoading: true,
      error: null,
      isUnblock: false,
    );
  }

  factory GetBlockedUserState.loading() {
    return GetBlockedUserState(
      blockUserResponseModel: [],
      isLoading: true,
      isUnblock: false,
      error: null,
    );
  }
  factory GetBlockedUserState.loaded(
    List<GetBlocUserResponseModel> blockUserResponseModel,
  ) {
    return GetBlockedUserState(
      blockUserResponseModel: blockUserResponseModel,
      isLoading: false,
      isUnblock: false,
      error: null,
    );
  }
  factory GetBlockedUserState.error(dynamic error) {
    return GetBlockedUserState(
      blockUserResponseModel: [],
      isLoading: false,
      error: error,
      isUnblock: false,
    );
  }

  factory GetBlockedUserState.isUnblock(
      List<GetBlocUserResponseModel> blockUserResponseModel) {
    return GetBlockedUserState(
      blockUserResponseModel: blockUserResponseModel,
      isLoading: false,
      error: null,
      isUnblock: true,
    );
  }
}
