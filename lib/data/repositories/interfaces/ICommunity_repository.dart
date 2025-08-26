import 'dart:io';

import 'package:research_mantra_official/data/models/community/community_data_model.dart';
import 'package:research_mantra_official/data/models/community/community_type_model.dart';

abstract class ICommunityRepository {
  //This method for uopdate Fcm
  Future<CommunityTypeModel> getCommunityDetails();
  Future<GetCommunityDataModel> getCommunity(
      int pageSize, int pageNumber, int communityProductId, int postTypeId);
  Future<Post> postCommunity(
        List<File>? image,
      List<String>  aspectRatio,
    String ? url,
    List<String>? imageurl,
    String productId,
    String title,
    String content,
  );
  Future<Post> editCommunity(

    String productId,
    // String title,
    String content,
    String blogId
  );

  Future <int> enableorDisableComment( String id, String userId, );
  Future <int>manageLikeUnliByCommunityPostId(
      String userObjectId, String blogId, bool isLiked );
  Future <int> deleteCommunityPost(
      String productId, String blogId, );
  Future <int>blockUser(
  String mobileUserPublicKey, String blockedId, String type);
   Future<int> postCommunityReportBlog(
   String blogId,
     String reportedby,
    String reasonId);
}
