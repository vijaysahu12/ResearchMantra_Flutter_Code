class BlogApiResponseModel {
  final String userObjectId;
  final bool communityPostEnabled;
  final bool isCommentEnabled;
  final List<Blogs> blogs;

  const BlogApiResponseModel(
      {required this.userObjectId,
      required this.communityPostEnabled,
      required this.blogs,
      required this.isCommentEnabled});

  static BlogApiResponseModel fromJson(Map<dynamic, dynamic> json) {
    return BlogApiResponseModel(
        userObjectId: json['userObjectId'],
        communityPostEnabled: json['communityPostEnabled'] ?? true,
        blogs: json['blogs'],
        isCommentEnabled: json['isCommentEnabled'] ?? false);
  }
}

class Blogs {
  final String objectId;
  late final String content;
  final String gender;
  final String hashtag;
  final String createdBy;
  final String createdOn;
  final String postedAgo;
  final bool enableComments;
  final int likesCount;
  final bool? isUserReported;
  late final int commentsCount;
  final List<ImageDetails>? image; // Change the type to List<String>?
  final String? userFullName;
  final String? userProfileImage;
  final bool userHasLiked;
  final bool isPinned;

  Blogs(
      {required this.objectId,
      required this.enableComments,
      required this.postedAgo,
      required this.content,
      required this.hashtag,
      required this.createdBy,
      required this.gender,
      required this.createdOn,
      required this.likesCount,
      required this.commentsCount,
      required this.image, // Update the type here
      this.userFullName,
      this.userProfileImage,
      required this.userHasLiked,
      this.isUserReported,
      required this.isPinned});

  Blogs copyWith(
      {String? objectId,
      String? content,
      String? hashtag,
      String? createdBy,
      String? createdOn,
      String? postedAgo,
      bool? enableComments,
      int? likesCount,
      int? commentsCount,
      String? gender,
      List<ImageDetails>? image,
      String? userFullName,
      String? userProfileImage,
      bool? isUserReported,
      bool? isPinned,
      bool? userHasLiked}) {
    return Blogs(
        objectId: objectId ?? this.objectId,
        enableComments: enableComments ?? this.enableComments,
        content: content ?? this.content,
        hashtag: hashtag ?? this.hashtag,
        createdBy: createdBy ?? this.createdBy,
        gender: gender ?? this.gender,
        createdOn: createdOn ?? this.createdOn,
        postedAgo: postedAgo ?? this.postedAgo,
        likesCount: likesCount ?? this.likesCount,
        commentsCount: commentsCount ?? this.commentsCount,
        image: image ?? this.image,
        userFullName: userFullName ?? this.userFullName,
        userProfileImage: userProfileImage ?? this.userProfileImage,
        isUserReported: isUserReported ?? this.isUserReported,
        isPinned: isPinned ?? this.isPinned,
        userHasLiked: userHasLiked ?? this.userHasLiked);
  }

  factory Blogs.fromJson(Map<String, dynamic> json) {
    return Blogs(
        objectId: json['objectId'] ?? '',
        postedAgo: json['postedAgo'] ?? '',
        content: json['content'] ?? '',
        hashtag: json['hashtag'] ?? '',
        createdBy: json['createdBy'],
        gender: json['gender'] ?? "",
        createdOn: json['createdOn'] ?? '',
        enableComments: json['enableComments'],
        likesCount: json['likesCount'] ?? 0,
        commentsCount: json['commentsCount'] ?? 0,
        image: json['image'] != null && json['image'] is List
            ? (json['image'] as List)
                .map((img) => ImageDetails.fromJson(img))
                .toList()
            : null,
        userFullName: json['userFullName'] ?? 'userName',
        userProfileImage: json['userProfileImage'] ?? '',
        userHasLiked: json['userHasLiked'] ?? '',
        isUserReported: json['isUserReported'] ?? false,
        isPinned: json['isPinned'] ?? false);
  }
}

class ImageDetails {
  final String name;
  final String aspectRatio;

  ImageDetails({
    required this.name,
    required this.aspectRatio,
  });

  factory ImageDetails.fromJson(Map<String, dynamic> json) {
    return ImageDetails(
      name: json['name'] ?? '',
      aspectRatio:
          json['aspectRatio'] ?? '1:1', // Default aspect ratio if missing
    );
  }
}
