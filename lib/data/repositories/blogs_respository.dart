import 'dart:io';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/constants/storage.dart';
import 'package:research_mantra_official/data/models/block_user/block_user.dart';
import 'package:research_mantra_official/data/models/blogs/blog_api_response_model.dart';
import 'package:research_mantra_official/data/models/blogs/blog_comment_reply_api_response_model.dart';
import 'package:research_mantra_official/data/models/blogs/blog_comments_api_response_model.dart';
import 'package:research_mantra_official/data/models/blogs/get_report_reason_model.dart';
import 'package:research_mantra_official/data/models/common_api_response.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IBlogs_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/services/secure_storage.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

//GetBlog repository implementation
class GetBlogsRepository implements IGetBlogRepository {
  final HttpClient _httpClient = getIt<HttpClient>();
  final SecureStorage _secureStorage = getIt<SecureStorage>();
  final SharedPref _pref = SharedPref();

//Method for GetBlogs
  @override
  Future<List<Blogs>> getBlogs(
      int pageNumber, int pageSize, String mobileUserPublicKey) async {
    try {
      final response = await _httpClient.get(
          "$getBlogsApi?pageNumber=$pageNumber&pageSize=$pageSize&publicKey=$mobileUserPublicKey");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        // TODO: we need to do the secur
        _secureStorage.write(userObjectId, response.data["userObjectId"]);
        _pref.setBool(
            communityPostEnabled, response.data["communityPostEnabled"]);
        _pref.setBool(commentsEnabledStatus, response.data["isCommentEnabled"]);

        final List<dynamic> blogData = responseData['blogs'];
        final List<Blogs> blogList =
            blogData.map((blogJson) => Blogs.fromJson(blogJson)).toList();
        return blogList;
      } else {
        print("${response.statusCode}:${response.message}");
        throw Exception('Failed to load tickets: ${response.statusCode}');
      }
    } catch (error) {
      print(error);
      throw Exception('Failed to load tickets: $error');
    }
  }

//loadmore blogs
  @override
  Future<List<Blogs>> loadMoreBlogs(
      int pageNumber, int pageSize, String mobileUserPublicKey) async {
    try {
      final response = await _httpClient.get(
          "$getBlogsApi?pageNumber=$pageNumber&pageSize=$pageSize&publicKey=$mobileUserPublicKey");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> blogData = responseData['blogs'];
        final List<Blogs> blogList =
            blogData.map((blogs) => Blogs.fromJson(blogs)).toList();
        return blogList;
      } else {
        print("${response.statusCode}:${response.message}");
        throw Exception('Failed to load tickets: ${response.statusCode}');
      }
    } catch (error) {
      print(error);
      throw Exception('Failed to load tickets: $error');
    }
  }

  //Method for manage the blog post (add the post)
  @override
  Future<CommonHelperResponseModel?> manageBlogPost(
      String userObjectId,
      String content,
      String hashTag,
      List<File>? image,
      List<String> aspectRatio) async {
    try {
      Map<String, String> body = {
        "Content": content,
        "Hashtag": hashTag,
        "UserObjectId": userObjectId,
      };

      final response = await _httpClient.postWithMultiPartWithMultipleImages(
          manageBlogPostApi, body, image, "Images", aspectRatio);

      final result = CommonHelperResponseModel.fromJson(response);
      return result;
    } catch (error) {
      throw Exception("Failed to manage blog post. Please try again later.");
    }
  }

//Todo: We have to do edit blog post
  @override
  Future<CommonHelperResponseModel> editBlogPost(
      String blogId, String userObjectId, String newContent) async {
    try {
      Map<String, String> body = {
        "blogId": blogId,
        "userObjectId": userObjectId,
        "newContent": newContent,
        "newHashtag": "#Stockmarket#HarrySir" //Todo: we need to do
      };
      final response = await _httpClient.post(editBlogPostByIdApi, body);
      final result = CommonHelperResponseModel.fromJson(response);
      return result;
    } catch (e) {
      throw Exception("Failed to Edit blog post,Please try again ..");
    }
  }

  //delete the blog post
  @override
  Future<NoContentResponse?> deleteBlogPost(
      String blogId, String userId) async {
    try {
      final response = await _httpClient
          .delete("$deleteBlogPostApi?blogId=$blogId&userId=$userId");

      final result = NoContentResponse.fromJson(response);
      return result;
    } catch (error) {
      throw Exception(error);
    }
  }

  //Managelikeunlike by Blog Id
  @override
  Future<CommonHelperResponseModel?> manageLikeUnlikeBlogById(
      String userObjectId,
      String blogId,
      bool isLiked,
      String? endPoints) async {
    try {
      final body = {
        "userObjectId": userObjectId,
        "blogId": blogId,
        "isLiked": isLiked,
      };
      final response =
          await _httpClient.post(endPoints ?? manageLikeUnlikeByBlogId, body);

      final result = CommonHelperResponseModel.fromJson(response);
      return result;
    } catch (error) {
      throw Exception(
        "We are unable  to LikeUnlike the post .Please try after some time",
      );
    }
  }

//get Blog Comments
  @override
  Future<List<BlogCommentsModel>> getBlogComments(
      String blogId, int pageNumber, int pageSize, String? endPoints) async {
    try {
      final response = await _httpClient.get(
          "${endPoints ?? getComments}?blogId=$blogId&pageNumber=$pageNumber&pageSize=$pageSize");
      if (response.statusCode == 200) {
        final List<dynamic> responseBlogCommentData = response.data;
        final List<BlogCommentsModel> blogCommentsList = responseBlogCommentData
            .map((blogComments) => BlogCommentsModel.fromJson(blogComments))
            .toList();
        return blogCommentsList;
      } else {
        return [];
      }
    } catch (error) {
      throw Exception("We are unable to get Blogs,Please try again");
    }
  }

//get loadMore comments
  @override
  Future<List<BlogCommentsModel>> getBlogCommentsLoadMore(
      String blogId, int pageNumber, int pageSize, String? endPoints) async {
    try {
      final response = await _httpClient.get(
          "${endPoints ?? getComments}?blogId=$blogId&pageNumber=$pageNumber&pageSize=$pageSize");
      if (response.statusCode == 200) {
        final List<dynamic> responseCommentsdata = response.data;
        final List<BlogCommentsModel> allComments = responseCommentsdata
            .map((allBlogComments) =>
                BlogCommentsModel.fromJson(allBlogComments))
            .toList();
        return allComments;
      } else {
        ToastUtils.showToast(response.message, "error");

        return [];
      }
    } catch (e) {
      ToastUtils.showToast(
          "We are unable to get More Blogs,Please try again", "error");
      throw Exception('Failed to load tickets: $e');
    }
  }

//Method for manage the Comment  (adding)
  @override
  Future<BlogCommentsModel> manageComment(String userObjectId, String blogId,
      dynamic comment, String? endPoints) async {
    Map<String, dynamic> body = {
      "blogId": blogId,
      "mention": "", //Todo:we need to pass mention user name also
      "comment": comment,
      "userObjectId": userObjectId
    };

    try {
      final response =
          await _httpClient.post(endPoints ?? manageComments, body);
      if (response.statusCode == 200) {
        final commentDetails = BlogCommentsModel.fromJson(body);
        return commentDetails;
      } else {
        throw Exception("Failed to add comment: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to add comment: $e");
    }
  }

//Method for get Comment Reply
  @override
  Future<List<BlogCommentReplyModel>> getCommentReply(
      String commentId, String? endPoints) async {
    try {
      final response = await _httpClient
          .get("${endPoints ?? getCommentReplyApi}?commentId=$commentId");
      if (response.statusCode == 200) {
        final List<dynamic> commetReply = response.data;
        final List<BlogCommentReplyModel> commentsAndReplies = commetReply
            .map((replies) => BlogCommentReplyModel.fromJson(replies))
            .toList();
        return commentsAndReplies;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to load tickets: $e');
    }
  }

//Method for get delete Comment
  @override
  Future<NoContentResponse?> deleteCommentOrReply(
      String objectId, String userId, String type, String? endPoints) async {
    try {
      final response = await _httpClient.delete(
          "${endPoints ?? deleteBlogCommentApi}?objectId=$objectId&userId=$userId&type=$type");

      final result = NoContentResponse.fromJson(response);
      return result;
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<CommonHelperResponseModel?> manageCommentReply(
      String reply,
      String userObjectId,
      String commentid,
      String mention,
      String? endPoints) async {
    try {
      Map<String, dynamic> body = {
        "reply": reply,
        "userObjectId": userObjectId,
        "commentId": commentid,
        "mention": mention
      };

      final response =
          await _httpClient.post(endPoints ?? manageCommentReplyApi, body);
      final result = CommonHelperResponseModel.fromJson(response);

      return result;
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<CommonHelperResponseModel> editBlogCommentOrReply(
      String objectId,
      String userObjectId,
      String newContent,
      String newMention,
      String type,
      String? endPoints) async {
    try {
      Map<String, String> body = {
        "objectId": objectId,
        "userObjectId": userObjectId,
        "newContent": newContent,
        "newMention": newMention,
        "type": type
      };

      final response =
          await _httpClient.post(endPoints ?? editCommentOrReplyApi, body);
      final result = CommonHelperResponseModel.fromJson(response);
      return result;
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<CommonHelperResponseModel> disableAndEnableComments(
      String blogId, String createdByObjectId) async {
    try {
      Map<String, String> body = {
        "blogId": blogId,
        "createdByObjectId": createdByObjectId
      };

      final response =
          await _httpClient.post(disableAndEnableBlogComments, body);
      final result = CommonHelperResponseModel.fromJson(response);
      return result;
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<List<GetReportReasonModel>> getReportReason() async {
    try {
      final response = await _httpClient.get(getReportReasonapi);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        print("$responseData --myresponsedata");

        final List<GetReportReasonModel> reportList = responseData
            .map((reports) => GetReportReasonModel.fromJson(reports))
            .toList();

        return reportList;
      } else {
        print("${response.statusCode}:${response.message}");
        throw Exception('Failed to load tickets: ${response.statusCode}');
      }
    } catch (error) {
      print(error);
      throw Exception('Failed to load tickets: $error');
    }
  }

  @override
  Future<int> postReportBlog(
      {required String blogId,
      required String reportedby,
      required String reasonId}) async {
    try {
      Map<String, String> body = {
        "blogId": blogId,
        "reportedBy": reportedby,
        "reasonId": reasonId,
      };

      final response = await _httpClient.post(postReportReasonapi, body);

      if (response.statusCode == 200) {
        ToastUtils.showToast(postReported, "");

        return response.statusCode;
      } else {
        ToastUtils.showToast(somethingWentWrong, "");
        return 0;
      }

      // return result;
    } catch (error) {
      ToastUtils.showToast(somethingWentWrong, "");
      throw Exception(error);
    }
  }

//Method to block user
  @override
  Future<CommonHelperResponseModel> blockUser(
      String mobileUserPublicKey, String blockerId, String type) async {
    try {
      Map<String, String> body = {
        "userKey": mobileUserPublicKey,
        "blockedId": blockerId,
        "type": type
      };

      final response = await _httpClient.post(blockUserApi, body);
      final result = CommonHelperResponseModel.fromJson(response);
      return result;

      // return result;
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Future<List<GetBlocUserResponseModel>> getBlockUserList(
      String mobileUserKey) async {
    try {
      final response = await _httpClient
          .get('$getBlockedUserApi?mobileUserKey=$mobileUserKey');
      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;

        final List<GetBlocUserResponseModel> reportList = responseData
            .map((reports) => GetBlocUserResponseModel.fromJson(reports))
            .toList();

        return reportList;
      } else {
        print("${response.statusCode}:${response.message}");
        throw Exception('Failed to Block user: ${response.statusCode}');
      }
    } catch (error) {
      print(error);
      throw Exception('Failed to load Block user: $error');
    }
  }

  @override
  Future<CommonHelperResponseModel> unBlockUser(
      String mobileUserPublicKey, String blockerId, String type) async {
    try {
      Map<String, String> body = {
        "userKey": mobileUserPublicKey,
        "blockedId": blockerId,
        "type": type
      };

      final response = await _httpClient.post(blockUserApi, body);
      final result = CommonHelperResponseModel.fromJson(response);
      return result;

      // return result;
    } catch (error) {
      throw Exception(error);
    }
  }
}
