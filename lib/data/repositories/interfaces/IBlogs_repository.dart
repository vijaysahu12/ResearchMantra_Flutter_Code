import 'dart:io';

import 'package:research_mantra_official/data/models/block_user/block_user.dart';
import 'package:research_mantra_official/data/models/blogs/blog_api_response_model.dart';
import 'package:research_mantra_official/data/models/blogs/blog_comment_reply_api_response_model.dart';
import 'package:research_mantra_official/data/models/blogs/blog_comments_api_response_model.dart';
import 'package:research_mantra_official/data/models/blogs/get_report_reason_model.dart';
import 'package:research_mantra_official/data/models/common_api_response.dart';

abstract class IGetBlogRepository {
// Method to fetch a list of blogs.
  Future<List<Blogs>> getBlogs(
      int pageNumber, int pageSize, String mobileUserPublicKey);

//Method to fetch load More blogs
  Future<List<Blogs>> loadMoreBlogs(
      int pageNumber, int pageSize, String mobileUserPublicKey);

//Method to fetch blogComments
  Future<List<BlogCommentsModel>> getBlogComments(
      String blogId, int pageNumber, int pageSize,String  ?endpoints);

//Method to Fetch blog load more comments
  Future<List<BlogCommentsModel>> getBlogCommentsLoadMore(
      String blogId, int pageNumber, int pageSize ,String  ?endpoints) ;

//Method to manage like unlike by blog by id
  Future<CommonHelperResponseModel?> manageLikeUnlikeBlogById(
      String userObjectId, String blogId, bool isLiked ,String  ?endpoints);
  //manage comments
  Future<BlogCommentsModel?> manageComment(
      String userObjectId, String blogId, dynamic comment ,String  ?endpoints);

  //manage Blog post
  Future<CommonHelperResponseModel?> manageBlogPost(
      String userObjectId,
      String content,
      String hashTag,
      List<File>? image,
      List<String> aspectRatio);

//delete blog post
  Future<NoContentResponse?> deleteBlogPost(String blogId, String userId);
//Method to fetch all reply comments
  Future<List<BlogCommentReplyModel>> getCommentReply(String commentId,String  ?endpoints);

//Method to delete Comment
  Future<NoContentResponse?> deleteCommentOrReply(
      String objectId, String userId, String type,String  ?endpoints);

  //Method to add comment replies
  Future<CommonHelperResponseModel?> manageCommentReply(
      String reply, String userObjectId, String commentid, String mention ,String  ?endpoints);

  //Method to edit blog post
  Future<CommonHelperResponseModel> editBlogPost(
      String blogId, String userObjectId, String newContent);

  //Method to edit blog post
  Future<CommonHelperResponseModel> editBlogCommentOrReply(String objectId,
      String userObjectId, String newContent, String newMention, String type ,String? endpoints);

  //Method to disable and enable comments  by BlogId
  Future<CommonHelperResponseModel> disableAndEnableComments(
      String blogId, String createdByObjectId);

  Future<List<GetReportReasonModel>> getReportReason();
  Future<int> postReportBlog({
    required String blogId,
    required String reportedby,
    required String reasonId,
  });

  //Method to Block user
  Future<CommonHelperResponseModel> blockUser(
      String mobileUserKey, String blockerId, String type);

        Future<CommonHelperResponseModel> unBlockUser(
      String mobileUserKey, String blockerId, String type);
  //Method to Block user
  Future<List<GetBlocUserResponseModel>> getBlockUserList(String mobileUserKey);
}
