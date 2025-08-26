import 'package:research_mantra_official/data/models/blogs/blog_api_response_model.dart';

class GetCommunityDataModel {
  final bool ?canPost;
  List<Post>? posts;
  int? totalCount;
  int? totalPages;
  int? communityId;
  String? communityName;

  int? pageNumber;
  int? pageSize;
  bool? hasPurchasedProduct;
  bool? hasAccessToPremiumContent;

  GetCommunityDataModel({
  this.canPost,
    this.posts,
    this.totalCount,
    this.totalPages,
    this.pageNumber,
    this.communityId,
    this.communityName,
    this.pageSize,
    this.hasPurchasedProduct,
    this.hasAccessToPremiumContent,
  });

  factory GetCommunityDataModel.fromJson(Map<String, dynamic> json) {
    return GetCommunityDataModel(
      posts: (json['posts'] as List?)?.map((e) => Post.fromJson(e)).toList(),
      totalCount: json['totalCount'] as int?,
      totalPages: json['totalPages'] as int?,
      pageNumber: json['pageNumber'] as int?,
      pageSize: json['pageSize'] as int?,
      communityId: json['communityId'] as int?,
      communityName: json['communityName'] ?? '',
      hasPurchasedProduct: json['hasPurchasedProduct'] ?? false,
      hasAccessToPremiumContent: json['hasAccessToPremiumContent'] ?? false,
      canPost: json['canPost'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'posts': posts?.map((e) => e.toJson()).toList(),
      'totalCount': totalCount,
      'totalPages': totalPages,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'hasPurchasedProduct': hasPurchasedProduct,
      'hasAccessToPremiumContent': hasAccessToPremiumContent,
      'communityName': communityName,
      'communityId': communityId,
      'canPost': canPost,
    };
  }
  GetCommunityDataModel copyWith({
    bool? canPost,
    List<Post>? posts,
    int? totalCount,
    int? totalPages,
    int? communityId,
    String? communityName,
    int? pageNumber,
    int? pageSize,
    bool? hasPurchasedProduct,
    bool? hasAccessToPremiumContent,
  }) {
    return GetCommunityDataModel(
      canPost: canPost ?? this.canPost,
      posts: posts ?? this.posts,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      communityId: communityId ?? this.communityId,
      communityName: communityName ?? this.communityName,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      hasPurchasedProduct: hasPurchasedProduct ?? this.hasPurchasedProduct,
      hasAccessToPremiumContent: hasAccessToPremiumContent ?? this.hasAccessToPremiumContent,
    );
  }

}

class Post {
  String? id;
  int? productId;
  int? postTypeId;
  String? title;
  String? content;
  int? createdBy;
  String? createdOn;
  String? url;
  String? imageUrl;
  bool? isQueryFormEnabled;
  bool? isJoinNowEnabled;
  String? upComingEvent;
  List<ImageDetails>? imageUrls;
  String? isApproved;
  String? gender;
  bool? isUserReported;
  bool? enableComments;
  String? userObjectId;
  String? objectId;
  int likecount ;
  int commentsCount;
  bool userHasLiked;
  bool isadminposted;
  


  Post({
    this.id,
    this.productId,
    this.postTypeId,
    this.title,
    this.content,
    this.createdBy,
    this.createdOn,
    this.url,
    this.imageUrl,
    this.isJoinNowEnabled,
    this.upComingEvent,
    this.isQueryFormEnabled,
    this.imageUrls,
    this.isApproved,
    this.gender,
    this.isUserReported,
    this.enableComments,
    this.userObjectId, 
    this.objectId,
    this.likecount = 0,
    this.commentsCount = 0,
    this.userHasLiked = false,
    this.isadminposted = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String?,
      productId: json['productId'] as int?,
      postTypeId: json['postTypeId'] as int?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      createdBy: json['createdBy'] as int?,
      createdOn: json['createdOn'] as String?,
      url: json['url'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isJoinNowEnabled: json['isJoinNowEnabled'] ?? false,
      isQueryFormEnabled: json['isQueryFormEnabled'] ?? false,
      upComingEvent: json['upComingEvent'] ?? '',
      imageUrls: json['imageUrls'] != null && json['imageUrls'] is List
          ? (json['imageUrls'] as List)
              .map((img) => ImageDetails.fromJson(img))
              .toList()
          : null,
      isApproved: json['isApproved'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      isUserReported: json['isUserReported'] as bool? ?? false,
      enableComments: json['enableComments'] as bool? ?? true,
      userObjectId: json['userObjectId'] as String?,
      objectId: json['objectId'] as String?,
      likecount: json['likecount'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? 0,
      userHasLiked: json['userHasLiked'] as bool? ?? false,
      isadminposted: json['isadminposted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'postTypeId': postTypeId,
      'title': title,
      'content': content,
      'createdBy': createdBy,
      'createdOn': createdOn,
      'url': url,
      'imageUrl': imageUrl,
      'isQueryFormEnabled': isQueryFormEnabled,
      'isJoinNowEnabled': isJoinNowEnabled,
      "upComingEvent": upComingEvent,
      'imageUrls': imageUrls,
      'isApproved': isApproved,
      'gender': gender,
      'isUserReported': isUserReported,
      'enableComments': enableComments,
      'userObjectId': userObjectId,
      'objectId': objectId,
      'likecount': likecount,
      'commentsCount': commentsCount,
      'userHasLiked': userHasLiked,
      'isadminposted': isadminposted, 
    };
  }
  Post copyWith({
    String? id,
    int? productId,
    int? postTypeId,
    String? title,
    String? content,
    int? createdBy,
    String? createdOn,
    String? url,
    String? imageUrl,
    bool? isQueryFormEnabled,
    bool? isJoinNowEnabled,
    String? upComingEvent,
    List<ImageDetails>? imageUrls,
    String? isApproved,
    String? gender,
    bool? isUserReported,
    bool? enableComments,
    String? userObjectId,
    String? objectId,
    int? likecount, 
    int? commentsCount,
    bool? userHasLiked,
    bool? isadminposted,

  }) {
    return Post(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      postTypeId: postTypeId ?? this.postTypeId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdBy: createdBy ?? this.createdBy,
      createdOn: createdOn ?? this.createdOn,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      isQueryFormEnabled: isQueryFormEnabled ?? this.isQueryFormEnabled,
      isJoinNowEnabled: isJoinNowEnabled ?? this.isJoinNowEnabled,
      upComingEvent: upComingEvent ?? this.upComingEvent,
      imageUrls: imageUrls ?? this.imageUrls,
      isApproved: isApproved ?? this.isApproved,
      gender: gender ?? this.gender,
      isUserReported: isUserReported ?? this.isUserReported,
      enableComments: enableComments ?? this.enableComments,
      userObjectId: userObjectId ?? this.userObjectId,
      objectId: objectId ?? this.objectId,
      likecount: likecount ?? this.likecount,
      commentsCount: commentsCount ?? this.commentsCount,
      userHasLiked: userHasLiked ?? this.userHasLiked,
      isadminposted: isadminposted ?? this.isadminposted, 
      
    );
  }
}
