import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/blogs/blog_comment_reply_api_response_model.dart';
import 'package:research_mantra_official/data/models/blogs/blog_comments_api_response_model.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IBlogs_repository.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ICommunity_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/blogs/comment/comments_state.dart';
import 'package:research_mantra_official/providers/blogs/main/blogs_provider.dart';
import 'package:research_mantra_official/providers/community/all_community/all_community_provider.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class GetCommentsStateNotifier extends StateNotifier<GetCommentsState> {
  GetCommentsStateNotifier(this._blogRepository, this._blogsListNotifier,
      this._allCommunityDataNotifier, this._iCommunityRepository)
      : super(GetCommentsState.initial());

  final IGetBlogRepository _blogRepository;
  // calling BlogsListStateNotifier
  final BlogsListStateNotifier _blogsListNotifier;
  final AllCommunityDataNotifier _allCommunityDataNotifier;
  final ICommunityRepository _iCommunityRepository;

  final UserSecureStorageService userDetails = UserSecureStorageService();

  int pageNumber = 1;
  int pageSize = 10;

  get blogCommentReplies => null;

//get comments initial
  Future<void> getAllComments(String blogId, int page, String? endPoint) async {
    state = GetCommentsState.loading([]);

    pageNumber = page;
    try {
      final List<BlogCommentsModel> allComments = await _blogRepository
          .getBlogComments(blogId, pageNumber, pageSize, endPoint);
      if (allComments.isEmpty) {
        state = GetCommentsState.loaded([]);
      } else {
        state = GetCommentsState.loaded(allComments);
      }
    } catch (error) {
      state = GetCommentsState.error(error);
      ToastUtils.showToast(weEncounteredIssueWhileWeGetComment, errorText);
    }
  }

//get loadmore comments
  Future<void> getLoadMoreComments(String blogId, String? endPoint) async {
    if (state.isLoadingMore) return;

    final int page = pageNumber + 1;
    final List<BlogCommentsModel> currentComments = state.blogCommentsModel;
    try {
      final List<BlogCommentsModel> newComments = await _blogRepository
          .getBlogCommentsLoadMore(blogId, page, pageSize, endPoint);
      final List<BlogCommentsModel> allComments = [
        ...currentComments,
        ...newComments
      ];
      state = GetCommentsState.loadMore(currentComments);

      state = GetCommentsState.loaded(allComments);

      pageNumber++;
    } catch (error) {
      state = GetCommentsState.error(state.blogCommentsModel);
      ToastUtils.showToast(commentsIsue, errorText);
    }
  }

//manage blog comments
  Future<void> manageBlogComments(
      String userObjectId,
      String blogId,
      dynamic comment,
      String userName,
      String? profileImageUrl,
      String? endpoints) async {
    pageNumber = 1;

    // Update state to indicate comments are being managed
    state = GetCommentsState.afterManageCommentsloadedState(
        state.blogCommentsModel, state.blogCommentReplies);

    try {
      // Call the repository to handle the comment
      await _blogRepository.manageComment(
          userObjectId, blogId, comment, endpoints);

      // Check if the comment is not empty

      if (comment.toString().trim().isNotEmpty) {
        // Create a new comment model

        // // Fetch updated comments from the repository
        final List<BlogCommentsModel> updatedComments =
            await _blogRepository.getBlogComments(blogId, pageNumber, pageSize,
                endpoints != null ? getCommentsCommunityendpoint : null);

        if (endpoints == null) {
          await _blogsListNotifier.manageAddCommentCountBlogById(
            userObjectId,
            blogId,
          );
        } else {
          await _allCommunityDataNotifier.updateCommentsCount(blogId, "add",0);
        }
        // // Fetch updated comments from the repository
        // await _blogRepository.getBlogComments(blogId, pageNumber, pageSize);

        // Update the state with the new list of comments
        state = GetCommentsState.loaded(updatedComments);

        // Reset page number
        pageNumber = 1;

        // Update the comment count for the blog post
      } else {
        // Update state to indicate loading if comment is empty
        state = GetCommentsState.loaded(state.blogCommentsModel);
      }
    } catch (e) {
      // Handle any errors that might occur during the process
      state = GetCommentsState.error(state.blogCommentsModel);
    }
  }

  // delete comments and reply
  Future<void> deleteComments(String objectId, String blogId, String createdBy,
      String type, int replyCount, String? endPoints,
      [commentId]) async {
    state = GetCommentsState.loading(state.blogCommentsModel);
    try {
      final response = await _blogRepository.deleteCommentOrReply(
          objectId, createdBy, type, endPoints);

      if (response != null && response.status) {
        if (type == "COMMENT") {
          if (endPoints == null) {
            await _blogsListNotifier.manageCommentDeleteCountBlogById(
                objectId, blogId, createdBy, replyCount);
          } else {
  
            await _allCommunityDataNotifier.updateCommentsCount(
                blogId, "remove" ,replyCount);
          }
        } else if (type == "REPLY") {

            manageCommentDeleteReplyCount(
              objectId,
              blogId,
              createdBy,
              endPoints,
            );
         
        }

        final updateComments = state.blogCommentsModel
            .where((element) => element.objectId != objectId)
            .toList();

        state = GetCommentsState.loaded(updateComments);
        await _blogRepository.getCommentReply(objectId, endPoints);

        if (commentId != objectId) {
          getCommentReply(commentId, 1, 5,
              endPoints != null ? getCommentsReplyCommunityendpoint : null);
        }
      } else {
        state = GetCommentsState.error(state.blogCommentsModel);
        ToastUtils.showToast(weAreUnableToDeleteComment, errorText);
      }
    } catch (e) {
      state = GetCommentsState.error(state.blogCommentsModel);
      ToastUtils.showToast(weAreUnableToDeleteComment, errorText);
    }
  }

//get comment replies
  Future<void> getCommentReply(
      String commentId, int pageNumber, int pageSize, String? endPoints) async {
    state = GetCommentsState.loading(state.blogCommentsModel);
    state = GetCommentsState.setCommentReplyLoadingState(
        state.blogCommentReplies, state.blogCommentsModel, commentId, true);

    try {
      final List<BlogCommentReplyModel> allReplies =
          await _blogRepository.getCommentReply(commentId, endPoints);

      state = GetCommentsState.selectedCommentRepliesLoaded(
          allReplies, state.blogCommentsModel, commentId);
    } catch (e) {
      state = GetCommentsState.setCommentReplyLoadingState(
          state.blogCommentReplies, state.blogCommentsModel, commentId, true);
      state = GetCommentsState.error(e);

      ToastUtils.showToast(weEncounteredIssueWhileWeGetComment, errorText);
    }
  }

//add reply for comments
  Future<void> manageCommentReply(
      String reply,
      String userObjectId,
      String commentid,
      String blogId,
      String userName,
      String profileImageUrl,
      String? endPoints) async {
    try {
      state = GetCommentsState.afterManageCommentsloadedState(
          state.blogCommentsModel, state.blogCommentReplies);

      final response = await _blogRepository.manageCommentReply(
          reply,
          userObjectId,
          commentid,
          "@hello",
          endPoints); // replace @hello with tags
      if (response != null && response.status) {
        if (reply.toString().trim().isNotEmpty) {
          final res = await _blogRepository.getCommentReply(commentid,
              endPoints != null ? getCommentsReplyCommunityendpoint : null);

          state = GetCommentsState.selectedCommentRepliesLoaded(
              res, state.blogCommentsModel, commentid);

          //handling for count increase
          if (endPoints == null) {
            manageCommentAddReplyCount(userObjectId, blogId, commentid);
          } else {
            await _allCommunityDataNotifier.updateCommentsCount(blogId, "add",0);
          }
        }
      } else {
        state = GetCommentsState.error(state.blogCommentsModel);
        ToastUtils.showToast(weAreUnableToAddReply, errorText);
      }
    } catch (e) {
      state = GetCommentsState.selectedCommentRepliesLoaded(
          state.blogCommentReplies, state.blogCommentsModel, commentid);
      ToastUtils.showToast(weAreUnableToAddReply, errorText);
    }
  }

//add reply for manageCommentReplyCount
  Future<void> manageCommentAddReplyCount(
      String userObejctId, String blogId, String commentId) async {
    try {
      await _blogsListNotifier.manageAddCommentCountBlogById(
          userObejctId, blogId);
    } catch (e) {
      state = GetCommentsState.error(state.blogCommentsModel);
    }
  }

  //add reply for manageCommentReplyCount
  Future<void> manageCommentDeleteReplyCount(
    String commentId,
    String blogId,
    String userObejctId,
    String? endPoints,
  ) async {
    try {
      final List<BlogCommentsModel> updatedComment =
          state.blogCommentsModel.map((comment) {
        if (comment.objectId == blogId) {
          return comment.copyWith(replyCount: comment.replyCount! - 1);
        }
        return comment;
      }).toList();

      // TODO: handle removing the comment from list

      if (endPoints == null) {
        await _blogsListNotifier.manageCommentDeleteCountBlogById(
            userObejctId, blogId, commentId, 0);
      } else {
             await _allCommunityDataNotifier.updateCommentsCount(
                blogId, "remove",0);



      }
      state = GetCommentsState.loaded(updatedComment);
    } catch (e) {
      state = GetCommentsState.error(state.blogCommentsModel);
    }
  }

  //Method for edit Comment or reply comment
  Future<void> editBlogCommentOrReply(
      String objectId,
      String userObjectId,
      String newContent,
      String newMention,
      String type,
      String? endPoints) async {
    List<BlogCommentReplyModel>? commentReplies;
    try {
      state = GetCommentsState.loading(state.blogCommentsModel);

      final response = await _blogRepository.editBlogCommentOrReply(
          objectId, userObjectId, newContent, newMention, type, endPoints);

      if (response.status) {
        final List<BlogCommentsModel> updatedComment =
            state.blogCommentsModel.map((comment) {
          if (comment.objectId == objectId) {
            // Preserve existing replies while updating the comment content
            commentReplies = comment.commentsReplies;
            // Update comment content
            return comment.copyWith(content: newContent);
          } else {
            // Check if there are replies and update commentReplies
            if (comment.commentsReplies != null) {
              // Update replies if the objectId matches
              comment.commentsReplies = comment.commentsReplies!.map((reply) {
                if (reply.objectId == objectId) {
                  return reply.copyWith(content: newContent);
                }
                return reply;
              }).toList();
              // Assign commentReplies after updating replies
              commentReplies = comment.commentsReplies;
            }
          }
          return comment;
        }).toList();

        // Handle the case when the objectId matches comment or reply
        if (commentReplies != null) {
          state = GetCommentsState.selectedCommentRepliesLoaded(
              commentReplies, updatedComment, objectId);
        }

        // Update state with the modified comments
        state = GetCommentsState.loaded(updatedComment);
      }
    } catch (e) {
      // Handle errors
      state = GetCommentsState.error(state.blogCommentsModel);
    }
  }
}

final getBlogCommentsListStateNotifierProvider =
    StateNotifierProvider<GetCommentsStateNotifier, GetCommentsState>(
  (ref) {
    final IGetBlogRepository getblogCommentsRepository =
        getIt<IGetBlogRepository>();
    //reading getBlogPostNotifierProvider
    final BlogsListStateNotifier blogsListNotifier =
        ref.read(getBlogPostNotifierProvider.notifier);
    //reading allCommunityDataNotifierProvider
    final AllCommunityDataNotifier allCommunityDataNotifier =
        ref.read(allCommunityDataNotifierProvider.notifier);
    //reading ICommunityRepository
    final ICommunityRepository iCommunityRepository =
        getIt<ICommunityRepository>();
    return GetCommentsStateNotifier(getblogCommentsRepository,
        blogsListNotifier, allCommunityDataNotifier, iCommunityRepository);
  },
);