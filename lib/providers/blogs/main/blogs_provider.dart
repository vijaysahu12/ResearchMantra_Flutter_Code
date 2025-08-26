import 'dart:io';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/models/blogs/blog_api_response_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IBlogs_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/blogs/main/blogs_state.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

// State notifier for managing the state of the blogs list
class BlogsListStateNotifier extends StateNotifier<BlogsState> {
  BlogsListStateNotifier(this._blogRepository) : super(BlogsState.initial());

  final IGetBlogRepository _blogRepository;
  int pageNumber = 1;
  final int pageSize = 20;
  final UserSecureStorageService userDetails = UserSecureStorageService();

  // Function for getting all blog posts
  Future<void> getBlogPosts(
      String mobileUserPublicKey, page, bool isRefresh) async {
    pageNumber = page;
    if (state.blogApiResponseModel.isEmpty && !isRefresh) {
      state = BlogsState.loading(state.blogApiResponseModel);
    } else if (isRefresh == true) {
      state = BlogsState.loading(state.blogApiResponseModel);
    }

    try {
      final List<Blogs> getAllBlogs = await _blogRepository.getBlogs(
          pageNumber, pageSize, mobileUserPublicKey);
      if (getAllBlogs.isEmpty) {
        state = BlogsState.success(
          [],
        );
      } else {
        state = BlogsState.success(
          getAllBlogs,
        );
      }
    } catch (error) {
      state = BlogsState.error(error.toString());
    }
  }

  // Function for loading more blogs
  Future<void> loadMoreBlogs(String mobileUserPublicKey) async {
    if (state.isLoadingMore) return;
    final int page = pageNumber + 1;
    final List<Blogs?> currentBlogs = state.blogApiResponseModel;
    state = BlogsState.loadMore(currentBlogs);
    try {
      final List<Blogs?> newBlogs = await _blogRepository.loadMoreBlogs(
          page, pageSize, mobileUserPublicKey);
      final List<Blogs?> allBlogs = [...currentBlogs, ...newBlogs];
      state = BlogsState.success(allBlogs);
      pageNumber++;
    } catch (error) {
      state = BlogsState.error(error);
    }
  }

// Function for managing the blog post
  Future<void> manageBlogPosts(
    String userObjectId,
    String content,
    String hashTag,
    List<File>? image,
    List<String> aspectRatio,
    String userFullName,
    String userProfileImage,
  ) async {
    try {
      final String? gender = await userDetails.getSelectedGender();
      // Set the state to indicate progress

      state = BlogsState.progress(state.blogApiResponseModel);
      final response = await _blogRepository.manageBlogPost(
        userObjectId,
        content,
        hashTag,
        image,
        aspectRatio,
      );
      if (response != null && response.status) {
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

        //after post the new blogpost again we are calling getblogs with updated values
        final newOne = Blogs(
            objectId: response.data.toString(),
            enableComments: true,
            postedAgo: "just now",
            content: content,
            hashtag: "",
            createdBy: userObjectId,
            createdOn: DateTime.now().toString(),
            likesCount: 0,
            commentsCount: 0,
            image: imagePaths,
            gender: gender!,
            userFullName: userFullName,
            userProfileImage: userProfileImage,
            userHasLiked: false,
            isPinned: false);
// Current list of blogs
        final List<Blogs?> getAllBlogs = state.blogApiResponseModel;

// Separate pinned and non-pinned blogs
        final List<Blogs?> pinnedBlogs =
            getAllBlogs.where((blog) => blog?.isPinned == true).toList();
        final List<Blogs?> nonPinnedBlogs =
            getAllBlogs.where((blog) => blog?.isPinned != true).toList();

// Create a new list with the desired order
        final List<Blogs?> newUpdatedList = [
          ...pinnedBlogs,
          // Add the first pinned blog (if any)
          newOne,
          ...nonPinnedBlogs,
        ];

        state = BlogsState.success(newUpdatedList);
      } else {
        state = BlogsState.success(state.blogApiResponseModel);
        ToastUtils.showToast(somethingWentWrong, 'error');
      }
    } catch (e) {
      state = BlogsState.success(state.blogApiResponseModel);
      ToastUtils.showToast(somethingWentWrong, 'error');
    }
  }

  // Function for deleting the blog post
  Future<void> deleteBlogPost(String blogId, String userId) async {
    final String mobileUserPublicKey = await userDetails.getPublicKey();

    try {
      // Perform the deletion
      state = BlogsState.isDelete(state.blogApiResponseModel);
      await _blogRepository.deleteBlogPost(blogId, userId);

      List<Blogs> currentPageBlogs = await _blogRepository.getBlogs(
          pageNumber, pageSize, mobileUserPublicKey);

      state = BlogsState.success(currentPageBlogs);
    } catch (error) {
      state = BlogsState.error(state.blogApiResponseModel);
      ToastUtils.showToast(
          "We are unable to delete the post. Please try again later.", "error");
    }
  }

  //Function for edit the blog
  Future<void> editBlogPost(
      String blogId, String userObjectId, String newContent) async {
    state = BlogsState.loading(state.blogApiResponseModel);
    try {
      state = BlogsState.isEdit(state.blogApiResponseModel);

      // Call the repository to update the blog post
      final response =
          await _blogRepository.editBlogPost(blogId, userObjectId, newContent);

      if (response.status) {
        // Map through the existing blog posts and update the one with matching ID
        final List<Blogs?> updatedPosts =
            state.blogApiResponseModel.map((blog) {
          if (blog!.objectId == blogId) {
            // Return a copy of the blog post with updated content
            return blog.copyWith(content: newContent);
          }
          return blog; // Return other blog posts as is
        }).toList();

        // Update the state with the updated blog posts
        state = BlogsState.success(updatedPosts);
      } else {}
    } catch (e) {
      state = BlogsState.error(state.blogApiResponseModel);
      ToastUtils.showToast(
          "We are unable to Edit the post .Please try after some time",
          "error");
    }
  }

  // Function for managing like/unlike blog by ID
  Future<void> manageLikeUnLikeBlogById(String userObjectId, String blogId,
      bool isLiked, String? endPoint) async {
    try {
      final List<Blogs?> updateBlog = state.blogApiResponseModel.map((blog) {
        if (blog!.objectId == blogId) {
          return blog.copyWith(
            userHasLiked: isLiked == true,
            likesCount:
                isLiked == true ? blog.likesCount + 1 : blog.likesCount - 1,
          );
        }
        return blog;
      }).toList();
      state = BlogsState.success(updateBlog);

      await _blogRepository.manageLikeUnlikeBlogById(
          userObjectId, blogId, isLiked, endPoint);
    } catch (error) {
      state = BlogsState.success(state.blogApiResponseModel);
      ToastUtils.showToast(
          "We are encountring issue while like the post", "error");
    }
  }

  // Function for managing manageCommentCountBlogById
  Future<void> manageAddCommentCountBlogById(
      String userObjectId, String blogId) async {
    try {
      final List<Blogs?> updateBlog = state.blogApiResponseModel.map((blog) {
        if (blog!.objectId == blogId) {
          return blog.copyWith(
            commentsCount: blog.commentsCount + 1,
          );
        }
        return blog;
      }).toList();
      state = BlogsState.success(updateBlog);
    } catch (error) {
      state = BlogsState.error(state.blogApiResponseModel);
      ToastUtils.showToast(
          "We are encountring issue while add the comment", "error");
    }
  }

  // Function for managing manageCommentCountBlogById
  Future<void> manageCommentDeleteCountBlogById(String commentId, String blogId,
      String userObjectId, int replyCount) async {
    try {
      final List<Blogs?> updateBlog = state.blogApiResponseModel.map((blog) {
        if (blog!.objectId == blogId) {
          return blog.copyWith(
            commentsCount: blog.commentsCount - (replyCount + 1),
          );
        }
        return blog;
      }).toList();
      state = BlogsState.success(updateBlog);
    } catch (error) {
      state = BlogsState.error(state.blogApiResponseModel);
      ToastUtils.showToast(
          "We are encountring issue while add the comment", "error");
    }
  }

//Function for managing blogcomments disable and enable
  Future<void> manageCommentsDisableAndEnableByBlogId(
      String blogId, String createdObjectId, bool isComments) async {
    // state = BlogsState.loading(state.blogApiResponseModel);

    try {
      await _blogRepository.disableAndEnableComments(blogId, createdObjectId);

      final List<Blogs?> updatedBlog = state.blogApiResponseModel.map((blog) {
        if (blog!.objectId == blogId) {
          return blog.copyWith(enableComments: !isComments);
        }
        return blog;
      }).toList();
      state = BlogsState.success(
        updatedBlog,
      );
    } catch (error) {
      state = BlogsState.error(error);
      ToastUtils.showToast(somethingWentWrong, "error");
    }
  }

  Future<void> postReportReasonBlog({
    required String blogId,
    required String reportedby,
    required String reasonId,
  }) async {
    try {
      state = BlogsState.postReportLoading(state.blogApiResponseModel, true);
      final updatedBlogList = List<Blogs?>.from(state.blogApiResponseModel);
      final statusCode = await _blogRepository.postReportBlog(
          blogId: blogId, reportedby: reportedby, reasonId: reasonId);

      if (statusCode == 200) {
        int index = state.blogApiResponseModel
            .indexWhere((element) => element?.objectId == blogId);
        updatedBlogList.removeAt(index);
      }

      state = BlogsState.postReport(
        updatedBlogList,
      );
    } catch (e) {
      state = BlogsState.error(e.toString());
    }
  }

  //Block User Method
  Future<void> blockUser(
      String mobileUserPublicKey, String blockedId, String type) async {
    try {
      state = BlogsState.isUserBlock(state.blogApiResponseModel);
      // Call the repository to update the blog post
      final response =
          await _blogRepository.blockUser(mobileUserPublicKey, blockedId, type);

      if (response.status) {
        final respo =
            await _blogRepository.getBlogs(1, 20, mobileUserPublicKey);

        state = BlogsState.success(respo);
        ToastUtils.showToast(blockUserText, "");
      } else {
        ToastUtils.showToast(somethingWentWrongString, "");
      }
    } catch (e) {
      state = BlogsState.error(state.blogApiResponseModel);
    }
  }
}

// Provider for managing the states
final getBlogPostNotifierProvider =
    StateNotifierProvider<BlogsListStateNotifier, BlogsState>((ref) {
  final IGetBlogRepository getBlogListRepository = getIt<IGetBlogRepository>();
  return BlogsListStateNotifier(getBlogListRepository);
});

//UserActivityState //Todo: We have to move this to separate provider
class UserActivityState {
  final String? userObjectId;
  final bool? userActivity;

  UserActivityState({this.userObjectId, this.userActivity});
}

class UserNotifier extends StateNotifier<UserActivityState> {
  UserNotifier() : super(UserActivityState());

  Future<void> fetchUserData() async {
    final userId = await userDetails.getUserObjectId();
    final activity = await userDetails.fetchUserActivity();

    state = UserActivityState(userObjectId: userId, userActivity: activity);
  }
}

final userActivityProvider =
    StateNotifierProvider<UserNotifier, UserActivityState>(
  (ref) => UserNotifier(),
);
