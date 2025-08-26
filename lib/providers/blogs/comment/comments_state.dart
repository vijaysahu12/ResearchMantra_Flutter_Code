import 'package:research_mantra_official/data/models/blogs/blog_api_response_model.dart';
import 'package:research_mantra_official/data/models/blogs/blog_comment_reply_api_response_model.dart';
import 'package:research_mantra_official/data/models/blogs/blog_comments_api_response_model.dart';
import 'package:research_mantra_official/data/models/blogs/get_report_reason_model.dart';

class GetCommentsState {
  final List<BlogCommentReplyModel>? blogCommentReplies;
  final List<BlogCommentsModel> blogCommentsModel;
  final List<GetReportReasonModel>? reportResponseModel;
  dynamic error;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isProgress;

  final List<Blogs> blogs;

  GetCommentsState({
    this.error,
    required this.blogCommentsModel,
    this.blogCommentReplies,
    required this.isLoading,
    required this.isLoadingMore,
    required this.blogs,
    required this.isProgress,
    this.reportResponseModel,
  });

  factory GetCommentsState.initial() => GetCommentsState(
      blogCommentReplies: [],
      blogCommentsModel: [],
      blogs: [],
      isLoading: false,
      isProgress: false,
      isLoadingMore: false);

  factory GetCommentsState.loading(List<BlogCommentsModel> blogCommentsModel) =>
      GetCommentsState(
          blogCommentReplies: [],
          blogCommentsModel: blogCommentsModel,
          isLoading: true,
          isProgress: false,
          blogs: [],
          isLoadingMore: false);

  factory GetCommentsState.loaded(List<BlogCommentsModel> blogCommentsModel) =>
      GetCommentsState(
          blogCommentReplies: [],
          blogs: [],
          isProgress: false,
          blogCommentsModel: blogCommentsModel,
          isLoading: false,
          isLoadingMore: false);

  factory GetCommentsState.afterManageCommentsloadedState(
    List<BlogCommentsModel> blogCommentsModel,
    List<BlogCommentReplyModel>? blogCommentReplies,
  ) =>
      GetCommentsState(
          blogCommentReplies: [],
          // blogCommentReplies: blogCommentReplies,
          blogs: [],
          isProgress: true,
          blogCommentsModel: blogCommentsModel,
          isLoading: false,
          isLoadingMore: false);

  factory GetCommentsState.setCommentReplyLoadingState(
      List<BlogCommentReplyModel>? blogCommentReplies,
      List<BlogCommentsModel> blogCommentsModel,
      commentId,
      [loadingState = false]) {
    // Find the comment with the matching commentId
    BlogCommentsModel? selectedComment;
    for (var comment in blogCommentsModel) {
      if (comment.objectId == commentId) {
        selectedComment = comment;
        break;
      }
    }

    if (selectedComment != null && blogCommentReplies != null) {
      selectedComment.isRepliesLoading = loadingState;
    }

    return GetCommentsState(
      blogCommentReplies: blogCommentReplies,
      blogCommentsModel: blogCommentsModel,
      blogs: [],
      isLoading: false,
      isProgress: false,
      isLoadingMore: false,
    );
  }

  factory GetCommentsState.selectedCommentRepliesLoaded(
    List<BlogCommentReplyModel>? blogCommentReplies,
    List<BlogCommentsModel> blogCommentsModel,
    commentId,
  ) {
    // Find the comment with the matching commentId
    BlogCommentsModel? selectedComment;
    for (var comment in blogCommentsModel) {
      if (comment.objectId == commentId) {
        selectedComment = comment;
        break;
      }
    }

    if (selectedComment != null && blogCommentReplies != null) {
      // Update the commentsReplies field of the selected comment
      selectedComment.commentsReplies = blogCommentReplies;
      selectedComment.replyCount = blogCommentReplies.length;
      selectedComment.isRepliesLoading = false;
    }

    return GetCommentsState(
      blogCommentReplies: blogCommentReplies,
      blogCommentsModel: blogCommentsModel,
      blogs: [],
      isLoading: false,
      isProgress: false,
      isLoadingMore: false,
    );
  }

  factory GetCommentsState.loadMore(
          List<BlogCommentsModel> blogCommentsModel) =>
      GetCommentsState(
          blogCommentsModel: blogCommentsModel,
          blogs: [],
          isProgress: false,
          isLoading: false,
          isLoadingMore: true);

  factory GetCommentsState.error(dynamic error) => GetCommentsState(
      blogCommentsModel: [],
      blogCommentReplies: [],
      isLoading: false,
      isProgress: false,
      isLoadingMore: false,
      blogs: [],
      error: error);




}
