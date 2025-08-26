import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/block_user/block_user.dart';
import 'package:research_mantra_official/providers/blogs/main/block_user/block_user_states.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:research_mantra_official/data/repositories/interfaces/IBlogs_repository.dart';
import 'package:research_mantra_official/main.dart';

import 'package:research_mantra_official/utils/toast_utils.dart';

// State notifier for managing the state of the blogs list
class BlockUserStateNotifier extends StateNotifier<GetBlockedUserState> {
  BlockUserStateNotifier(this._blogRepository)
      : super(GetBlockedUserState.initial());

  final IGetBlogRepository _blogRepository;

  // Function for getting all blog posts
  Future<void> getBlockedUserList(String userObjectId) async {
    state = GetBlockedUserState.loading();

    try {
      final List<GetBlocUserResponseModel> blockUserResponseModel =
          await _blogRepository.getBlockUserList(userObjectId);
      state = GetBlockedUserState.loaded(blockUserResponseModel);
    } catch (error) {
      state = GetBlockedUserState.error(error.toString());
      ToastUtils.showToast("Something went wrong", "error");
    }
  }

  Future<void> unBlockUser(
      String mobileUserPublicKey, String blockedId, String type) async {
    // Set the state to indicate the unblocking process is ongoing.
    state = GetBlockedUserState.isUnblock(state.blockUserResponseModel);

    try {
      final response =
          await _blogRepository.unBlockUser(mobileUserPublicKey, blockedId, type);

      // If the unblocking is successful.
      if (response.status) {
        // Remove the blockedId from blockUserResponseModel's blocked users list.
        final updatedBlockedUsers = state.blockUserResponseModel
            .where((user) => user.id != blockedId)
            .toList();

        // Update the state with the new list of blocked users.
        state = GetBlockedUserState.loaded(updatedBlockedUsers);
        ToastUtils.showToast(ublockUserText, "error");
      }
    } catch (error) {
      // Handle the error and set the state accordingly.
      state = GetBlockedUserState.error(state.blockUserResponseModel);
      ToastUtils.showToast(somethingWentWrong, "error");
    }
  }
}

// Provider for managing the states
final getBlockedUserStateProvider =
    StateNotifierProvider<BlockUserStateNotifier, GetBlockedUserState>((ref) {
  final IGetBlogRepository getBlockedUserDetails = getIt<IGetBlogRepository>();
  return BlockUserStateNotifier(getBlockedUserDetails);
});
