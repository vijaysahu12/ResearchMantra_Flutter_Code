import 'package:hive/hive.dart';
part 'blog_hive_model.g.dart';

@HiveType(typeId: 1)
class BlogsHiveModel extends HiveObject {
  @HiveField(0)
  final String objectId;
  @HiveField(1)
  late final String content;
  @HiveField(2)
  final String gender;
  @HiveField(3)
  final String hashtag;
  @HiveField(4)
  final String createdBy;
  @HiveField(5)
  final String createdOn;
  @HiveField(6)
  final String postedAgo;
  @HiveField(7)
  final bool enableComments;
  @HiveField(8)
  final int likesCount;
  @HiveField(9)
  late final int commentsCount;
  @HiveField(10)
  final List<String>? image;
  @HiveField(11)
  final String? userFullName;
  @HiveField(12)
  final bool userHasLiked;

  BlogsHiveModel({
    required this.objectId,
    required this.enableComments,
    required this.postedAgo,
    required this.content,
    required this.hashtag,
    required this.createdBy,
    required this.gender,
    required this.createdOn,
    required this.likesCount,
    required this.commentsCount,
    required this.image,
    this.userFullName,
    required this.userHasLiked,
  });
}
