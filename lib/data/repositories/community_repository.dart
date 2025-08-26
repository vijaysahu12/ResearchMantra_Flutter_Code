import 'dart:io';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/community/community_data_model.dart';
import 'package:research_mantra_official/data/models/community/community_type_model.dart';
import 'package:research_mantra_official/data/network/http_client.dart';
import 'package:research_mantra_official/data/repositories/interfaces/ICommunity_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class CommunityRepository implements ICommunityRepository {
  final HttpClient _httpClient = getIt<HttpClient>();
  // final SharedPref _sharedPref = SharedPref();

  @override
  Future<CommunityTypeModel> getCommunityDetails() async {
    try {
      final response = await _httpClient.get(getCommunityDetailsendpoint);

      if (response.statusCode == 200) {
        final allCommunityTypeData = response.data;
        final CommunityTypeModel communityData =
            CommunityTypeModel.fromJson(allCommunityTypeData);

        return communityData;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<GetCommunityDataModel> getCommunity(int pageSize, int pageNumber,
      int communityProductId, int postTypeId) async {
    try {
      Map<String, dynamic> body = {
        "pageSize": pageSize,
        "pageNumber": pageNumber,
        "communityProductId": communityProductId,
        // "loggedInUserId": loggedInUserId,
        "postTypeId": postTypeId
      };

      final response = await _httpClient.post(getCommunityendpoint, body);

      if (response.statusCode == 200) {
        final allCommunityeData = response.data;
        final GetCommunityDataModel communityData =
            GetCommunityDataModel.fromJson(allCommunityeData);

        return communityData;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Post> postCommunity(
      List<File>? image,
      List<String> aspectRatio,
      String? url,
      List<String>? imageurl,
      String productId,
      String title,
      String content) async {
    try {
      Map<String, String> body = {
        "productId": productId,
        // "url": url,
        "title": title,
        "content": content
      };

      final response = await _httpClient.postWithMultiPartWithMultipleImages(
        postCommunityendpoint,
        body,
        image,
        'Images',
        aspectRatio,
      );

      if (response.statusCode == 200) {
        final allCommunityeData = response.data;
        final Post communityData = Post.fromJson(allCommunityeData);

        return communityData;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<int> enableorDisableComment(
    String id,
    String userId,
  ) async {
    try {
      Map<String, dynamic> body = {
        "createdByObjectId": userId,
        "blogId": id,
      };

      final response =
          await _httpClient.post(enableDisableCommentCommunityendpoint, body);

      return response.statusCode;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<int> manageLikeUnliByCommunityPostId(
      String userObjectId, String blogId, bool isLiked) async {
    try {
      Map<String, dynamic> body = {
        "userObjectId": userObjectId,
        "blogId": blogId,
        "isLiked": isLiked
      };

      final response = await _httpClient.post(likeCommunityendpoint, body);

      return response.statusCode;

      // if (response.statusCode == 200) {
      //   // final allCommunityeData = response.data;
      //   // final GetCommunityDataModel communityData =
      //   //     GetCommunityDataModel.fromJson(allCommunityeData);

      //   // return communityData;
      // } else {
      //   throw Exception('Error : ${response.statusCode}');
      // }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<int> deleteCommunityPost(String productId, String blogId) async {
    try {
      Map<String, String> body = {
        "id": blogId,
        "productId": productId,
        "content": "",
        "isDelete": "true",
      };

      final response = await _httpClient.postWithMultiPartWithMultipleImages(
        postCommunityendpoint,
        body,
        [],
        'Images',
        [],
      );

      return response.statusCode;
      // if (response.statusCode == 200) {
      //   // final allCommunityeData = response.data;
      //   // final GetCommunityDataModel communityData =
      //   //     GetCommunityDataModel.fromJson(allCommunityeData);

      //   // return communityData;
      // } else {
      //   throw Exception('Error : ${response.statusCode}');
      // }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<int> blockUser(
      String mobileUserPublicKey, String blockedId, String type) async {
    try {
      Map<String, dynamic> body = {
        "userKey": mobileUserPublicKey,
        "blockedId": blockedId,
        "type": type
      };

      final response = await _httpClient.post(blockUserCommunityendpoint, body);
      return response.statusCode;

      // if (response.statusCode == 200) {
      //   // final allCommunityeData = response.data;
      //   // final GetCommunityDataModel communityData =
      //   //     GetCommunityDataModel.fromJson(allCommunityeData);

      //   // return communityData;
      // }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Post> editCommunity(
      String productId, String content, String blogId) async {
    try {
      Map<String, String> body = {
        "id": blogId,
        "productId": productId,
        "content": content,
        "isDelete": "false",
      };

      final response = await _httpClient.postWithMultiPartWithMultipleImages(
        postCommunityendpoint,
        body,
        [],
        'Images',
        [],
      );

      if (response.statusCode == 200) {
        final allCommunityeData = response.data;
        final Post communityData = Post.fromJson(allCommunityeData);

        return communityData;
      } else {
        throw Exception('Error : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<int> postCommunityReportBlog(
      String blogId, String reportedby, String reasonId) async {
    try {
      Map<String, String> body = {
        "blogId": blogId,
        "reportedBy": reportedby,
        "reasonId": reasonId,
      };

      final response =
          await _httpClient.post(reportBlogCommunityendpoint, body);

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
}
