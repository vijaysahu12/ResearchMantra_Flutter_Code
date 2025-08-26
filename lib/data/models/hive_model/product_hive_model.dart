import 'package:hive/hive.dart';
part 'product_hive_model.g.dart';

@HiveType(typeId: 0)
class ProductHiveModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String listImage;

  @HiveField(4)
  final int? heartsCount;

  @HiveField(5)
  final bool userHasHeart;

  @HiveField(6)
  final String groupName;

  @HiveField(7)
  final double? overAllRating;

  ProductHiveModel({
    required this.id,
    required this.name,
    required this.description,
    required this.listImage,
    required this.heartsCount,
    required this.userHasHeart,
    required this.groupName,
    this.overAllRating,
  });
}
