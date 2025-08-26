
class BlogCommentReplyModel {
  final String objectId;
  final String commentId;
  final String content;
  final String mention;
  final String createdBy;
  final String createdOn;
  final String postedAgo;
  final String gender;
  final String blogId;
  final String userFullName;
  final String userProfileImage;

  const BlogCommentReplyModel(
      {required this.objectId,
      required this.commentId,
      required this.blogId,
      required this.content,
      required this.gender,
      required this.mention,
      required this.createdBy,
      required this.createdOn,
      required this.postedAgo,
      required this.userFullName,
      required this.userProfileImage});
  BlogCommentReplyModel copyWith(
      {String? objectId,
      String? commentId,
      String? blogId,
      String? content,
      String? mention,
      String? createdBy,
      String? createdOn,
      String? postedAgo,
      String? gender,
      String? userFullName,
      String? userProfileImage}) {
    return BlogCommentReplyModel(
        objectId: objectId ?? this.objectId,
        blogId: blogId ?? this.blogId,
        commentId: commentId ?? this.commentId,
        content: content ?? this.content,
        mention: mention ?? this.mention,
        createdBy: createdBy ?? this.createdBy,
        createdOn: createdOn ?? this.createdOn,
        postedAgo: postedAgo ?? this.postedAgo,
        gender:gender?? this.gender,
        userFullName: userFullName ?? this.userFullName,
        userProfileImage: userProfileImage ?? this.userProfileImage);
  }

  Map<String, dynamic> toJson() {
    return {
      'objectId': objectId,
      'commentId': commentId,
      'content': content,
      'mention': mention,
      'createdBy': createdBy,
      'createdOn': createdOn,
      'postedAgo': postedAgo,
      'blogId': blogId,
      'gender':gender,
      'userFullName': userFullName,
      'userProfileImage': userProfileImage
    };
  }

  static BlogCommentReplyModel fromJson(Map<String, dynamic> json) {
    return BlogCommentReplyModel(
        objectId: json['objectId'],
        blogId: json['blogId'],
        commentId: json['commentId'],
        content: json['content'],
        mention: json['mention'],
        gender:json['gender'],
        createdBy: json['createdBy'],
        createdOn: json['createdOn'],
        postedAgo: json['postedAgo'],
        userFullName: json['userFullName'],
        userProfileImage: json['userProfileImage'] ?? '');
  }
}
