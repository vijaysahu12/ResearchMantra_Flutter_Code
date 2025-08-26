import 'dart:io';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/blogs/blog_api_response_model.dart';
import 'package:research_mantra_official/data/models/community/community_data_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ICommunity_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/community/all_community/all_community_state.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class AllCommunityDataNotifier extends StateNotifier<AllCommunityState> {
  AllCommunityDataNotifier(
    this._communityRepository,
  ) : super(AllCommunityState.initial());

  final ICommunityRepository _communityRepository;

  Future<void> communityData(int pageSize, int pageNumber,
      int communityProductId, int postTypeId) async {
    try {
      state = AllCommunityState.loading(true, false, null, false);

      final community = await _communityRepository.getCommunity(
          pageSize, pageNumber, communityProductId, postTypeId);

      state = AllCommunityState.loaded(community);
    } catch (e) {
      state = AllCommunityState.error(e.toString());
    }
  }

  Future<void> postcommunityData(
      List<File>? image,
      List<String> aspectRatio,
      String? url,
      List<String>? imageurl,
      String productId,
      String title,
      String content) async {
    try {
      state = AllCommunityState.loading(
          false, false, state.getCommunityDataModel, false);

      final response = await _communityRepository.postCommunity(
        image,
        aspectRatio,
        url,
        imageurl,
        productId,
        title,
        content,
      );

      List<ImageDetails>? imagePaths = image?.map((file) {
            // Make sure to get the aspect ratio appropriately
            String aspectRatio =
                file.path; // Get from your ImageDetails class

            return ImageDetails(
              name: file.path, // Or however you get the file path
              aspectRatio: aspectRatio,
            );
          }).toList() ??
          [];

      response.copyWith(imageUrls: imagePaths);

      List<Post> posts = [
        response,
        ...state.getCommunityDataModel?.posts ?? []
      ];

      GetCommunityDataModel communityData = GetCommunityDataModel(
        posts: posts,
        totalCount: state.getCommunityDataModel?.totalCount ?? 0,
        totalPages: state.getCommunityDataModel?.totalPages ?? 0,
        pageNumber: state.getCommunityDataModel?.pageNumber ?? 0,
        pageSize: state.getCommunityDataModel?.pageSize ?? 0,
        hasPurchasedProduct:
            state.getCommunityDataModel?.hasPurchasedProduct ?? false,
        hasAccessToPremiumContent:
            state.getCommunityDataModel?.hasAccessToPremiumContent ?? false,
        canPost: state.getCommunityDataModel?.canPost ?? false,
        communityId: state.getCommunityDataModel?.communityId,
      );

      state = AllCommunityState.loaded(communityData);
    
      // state = AllCommunityState.loaded(communityData);
    } catch (e) {
      state = AllCommunityState.error(e.toString());
    }
  }

  Future<void> editcommunityData(
    String productId,
    String content,
    String blogId,
  ) async {
    try {
      state = AllCommunityState.loading(
          false, false, state.getCommunityDataModel, false);

      final response =
          await _communityRepository.editCommunity(productId, content, blogId);

      final updatedPost = response;
      final currentPosts = state.getCommunityDataModel?.posts ?? [];

      final updatedPosts = currentPosts.map((post) {
        return post.id == updatedPost.id ? updatedPost : post;
      }).toList();

      GetCommunityDataModel communityData = GetCommunityDataModel(
        posts: updatedPosts,
        totalCount: state.getCommunityDataModel?.totalCount ?? 0,
        totalPages: state.getCommunityDataModel?.totalPages ?? 0,
        pageNumber: state.getCommunityDataModel?.pageNumber ?? 0,
        pageSize: state.getCommunityDataModel?.pageSize ?? 0,
        hasPurchasedProduct:
            state.getCommunityDataModel?.hasPurchasedProduct ?? false,
        hasAccessToPremiumContent:
            state.getCommunityDataModel?.hasAccessToPremiumContent ?? false,
        canPost: state.getCommunityDataModel?.canPost ?? false,
        communityId: state.getCommunityDataModel?.communityId,
      );
      state = AllCommunityState.loaded(communityData);
        } catch (e) {
      state = AllCommunityState.error(e.toString());
    }
  }

  Future<void> loadMoreCommunityData(int pageSize, int pageNumber,
      int communityProductId, int postTypeId) async {
    try {
      state = AllCommunityState.loading(
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
        communityId: state.getCommunityDataModel?.communityId,
      );

      state = AllCommunityState.loaded(communityData);
    } catch (e) {
      state = AllCommunityState.error(e.toString());
    }
  }

  Future<void> enableorDisableComment(
      String id, String userId, bool enableDisabelComment) async {
    try {
      state = AllCommunityState.loading(
          false, true, state.getCommunityDataModel, true);

      final community = await _communityRepository.enableorDisableComment(
        id,
        userId,
      );

      GetCommunityDataModel communityData =
          state.getCommunityDataModel ?? GetCommunityDataModel(canPost: true);

      if (community == 200) {
        final updatedPosts = communityData.posts?.map((Post post) {
          if (post.id == id) {
            return post.copyWith(enableComments: enableDisabelComment);
          }
          return post;
        }).toList();
        communityData = GetCommunityDataModel(
          posts: updatedPosts,
          totalCount: communityData.totalCount,
          totalPages: communityData.totalPages,
          pageNumber: communityData.pageNumber,
          pageSize: communityData.pageSize,
          hasPurchasedProduct: communityData.hasPurchasedProduct,
          hasAccessToPremiumContent: communityData.hasAccessToPremiumContent,
          canPost: communityData.canPost,
          communityId: state.getCommunityDataModel?.communityId,
        );
      }
      state = AllCommunityState.loaded(communityData);
    } catch (e) {
      state = AllCommunityState.error(e.toString());
    }
  }

  Future<void> deleteCommunityPost(String productId, String blogId) async {
    try {
      state = AllCommunityState.loading(
          false, false, state.getCommunityDataModel, true);

      final removeCommunity =
          await _communityRepository.deleteCommunityPost(productId, blogId);
      if (removeCommunity == 200) {
        state = AllCommunityState.loaded(
            removePost(blogId) ?? GetCommunityDataModel());
      } else {
        state = AllCommunityState.loaded(
            state.getCommunityDataModel ?? GetCommunityDataModel());
        ToastUtils.showToast(
            "We are encountring issue while delete the post", "error");
      }
    } catch (e) {
      state = AllCommunityState.error(e.toString());
    }
  }

  Future<void> reportCommunityPost(
      String id, String userObejctId, String reasonId) async {
    try {
      state = AllCommunityState.loading(
          false, false, state.getCommunityDataModel, true);

      final removeCommunity = await _communityRepository
          .postCommunityReportBlog(id, userObejctId, reasonId);
      if (removeCommunity == 200) {
        state =
            AllCommunityState.loaded(removePost(id) ?? GetCommunityDataModel());
      } else {
        state = AllCommunityState.loaded(
            state.getCommunityDataModel ?? GetCommunityDataModel());
        ToastUtils.showToast(
            "We are encountring issue while we report the post", "error");
      }
    } catch (e) {
      state = AllCommunityState.error(e.toString());
    }
  }

  Future<void> blockCommunityUser(
      String mobileUserPublicKey, String blockedId, String type) async {
    try {
      state = AllCommunityState.loading(
          false, true, state.getCommunityDataModel, true);
      final response = await _communityRepository.blockUser(
          mobileUserPublicKey, blockedId, type);

      if (response == 200) {
        GetCommunityDataModel communityData =
            state.getCommunityDataModel ?? GetCommunityDataModel();
        final updatedPosts = communityData.posts
            ?.where((post) => post.userObjectId != blockedId)
            .toList();

        communityData = communityData.copyWith(
          posts: updatedPosts,
        );

        state = AllCommunityState.loaded(communityData);
      } else {
        state = AllCommunityState.loaded(
            state.getCommunityDataModel ?? GetCommunityDataModel());
        ToastUtils.showToast(
            "We are encountring issue while block the user", "error");
      }
    } catch (e) {
      state = AllCommunityState.error(e.toString());
    }
  }

  Future<void> manageLikeUnLikeCommunityPostById(
      String userObjectId, String blogId, bool isLiked) async {
    try {
      List<Post> posts = state.getCommunityDataModel?.posts ?? [];

      final List<Post> updateBlog = posts.map((post) {
        if (post.id == blogId) {
          return post.copyWith(
            userHasLiked: isLiked == true,
            likecount: max(
                0, isLiked == true ? post.likecount + 1 : post.likecount - 1),
          );
        }
        return post;
      }).toList();

      GetCommunityDataModel communityData = GetCommunityDataModel(
        posts: updateBlog,
        totalCount: state.getCommunityDataModel?.totalCount,
        totalPages: state.getCommunityDataModel?.totalPages,
        pageNumber: state.getCommunityDataModel?.pageNumber,
        pageSize: state.getCommunityDataModel?.pageSize,
        hasPurchasedProduct: state.getCommunityDataModel?.hasPurchasedProduct,
        hasAccessToPremiumContent:
            state.getCommunityDataModel?.hasAccessToPremiumContent,
        canPost: state.getCommunityDataModel?.canPost,
        communityId: state.getCommunityDataModel?.communityId,
      );
      state = AllCommunityState.loaded(communityData);
      await _communityRepository.manageLikeUnliByCommunityPostId(
          userObjectId, blogId, isLiked);
    } catch (error) {
      state = AllCommunityState.loaded(
          state.getCommunityDataModel ?? GetCommunityDataModel());
      ToastUtils.showToast(
          "We are encountring issue while like the post", "error");
    }
  }

  GetCommunityDataModel? removePost(String id) {
    GetCommunityDataModel communityData =
        state.getCommunityDataModel ?? GetCommunityDataModel();
    final updatedPosts =
        communityData.posts?.where((post) => post.id != id).toList();

    communityData = communityData.copyWith(
      posts: updatedPosts,
    );
    return communityData;
  }

  Future<void> updateCommentsCount(
      String blogId, String action, int replyCount) async {
    try {
      List<Post> posts = state.getCommunityDataModel?.posts ?? [];
      final List<Post> updateBlog = posts.map((post) {
        if (post.id == blogId) {
          if (action == "add") {
            return post.copyWith(
              commentsCount: post.commentsCount + 1,
            );
          } else if (action == "remove") {
            return post.copyWith(
                commentsCount: max(0, post.commentsCount - (replyCount + 1)));
          }
        }
        return post;
      }).toList();

      GetCommunityDataModel communityData = GetCommunityDataModel(
        posts: updateBlog,
        totalCount: state.getCommunityDataModel?.totalCount,
        totalPages: state.getCommunityDataModel?.totalPages,
        pageNumber: state.getCommunityDataModel?.pageNumber,
        pageSize: state.getCommunityDataModel?.pageSize,
        hasPurchasedProduct: state.getCommunityDataModel?.hasPurchasedProduct,
        hasAccessToPremiumContent:
            state.getCommunityDataModel?.hasAccessToPremiumContent,
        canPost: state.getCommunityDataModel?.canPost,
        communityId: state.getCommunityDataModel?.communityId,
      );
      state = AllCommunityState.loaded(communityData);
    } catch (error) {
      state = AllCommunityState.error(state.getCommunityDataModel);
      ToastUtils.showToast(
          "We are encountring issue while $action the comment", "error");
    }
  }
}

final allCommunityDataNotifierProvider =
    StateNotifierProvider<AllCommunityDataNotifier, AllCommunityState>(((ref) {
  final ICommunityRepository communityRepository =
      getIt<ICommunityRepository>();
  return AllCommunityDataNotifier(
    communityRepository,
  );
}));

// final allCommunityDataNotifierFamilyProvider =
//     StateNotifierProvider.family<AllCommunityDataNotifier, AllCommunityState, ({int? productId, int? postTypeId})?>(
//         (ref, ids) {
//   final communityRepository = getIt<ICommunityRepository>();
//   return AllCommunityDataNotifier(
//     communityRepository,
//     ids?.productId ?? 0,
//     ids?.postTypeId ?? 0,
//   );
// });
