

import 'package:research_mantra_official/data/models/blogs/blog_comment_reply_api_response_model.dart';

class BlogCommentsModel {
  final String objectId;
  final String blogId;
  final String content;
  final String mention;
  final String createdOn;
  final String postedAgo;
  final String createdBy;
  final String? userFullName;
  final String gender;
  int? replyCount;
  final String userProfileImage;
  bool isRepliesLoading = false;
  List<BlogCommentReplyModel>? commentsReplies = [];

  BlogCommentsModel(
      {required this.objectId,
      required this.blogId,
      required this.content,
      required this.mention,
      this.replyCount,
      required this.gender,
      required this.createdOn,
      required this.postedAgo,
      required this.createdBy,
      required this.userFullName,
      required this.userProfileImage,
      this.commentsReplies});

  BlogCommentsModel copyWith({
    String? objectId,
    String? blogId,
    String? content,
    int? replyCount,
    String? gender,
    String? mention,
    String? userFullName,
    String? userProfileImage,
    String? createdOn,
    String? postedAgo,
    String? createdBy,
  }) {
    return BlogCommentsModel(
      objectId: objectId ?? this.objectId,
      blogId: blogId ?? this.blogId,
      replyCount: replyCount ?? this.replyCount,
      content: content ?? this.content,
      mention: mention ?? this.mention,
      gender: gender ?? this.gender,
      createdOn: createdOn ?? this.createdOn,
      postedAgo: postedAgo ?? this.postedAgo,
      createdBy: createdBy ?? this.createdBy,
      userFullName: userFullName ?? this.userFullName,
      userProfileImage: userProfileImage ?? this.userProfileImage,
    );
  }

  static BlogCommentsModel fromJson(Map<String, dynamic> json) {
    return BlogCommentsModel(
      objectId: json['objectId'] ?? '',
      blogId: json['blogId'] ?? '',
      replyCount: json['replyCount'] ?? 0,
      content: json['content'] ?? '',
      mention: json['mention'] ?? '',
      createdOn: json['createdOn'] ?? '',
      postedAgo: json['postedAgo'] ?? '',
      createdBy: json['createdBy'] ?? '',
      gender: json['gender'] ?? '',
      // createdOn: json['createdOn'] ?? '',
      userFullName: json['userFullName'] ?? 'userName',
      userProfileImage: json['userProfileImage'] ?? '',
    );
  }
}
