import 'package:hive/hive.dart';
part 'promo_hive_model.g.dart';

@HiveType(typeId: 3)
class PromoHiveModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String mediaType;

  @HiveField(2)
  bool shouldDisplay;

  @HiveField(3)
  int maxDisplayCount;

  @HiveField(4)
  int displayFrequency;

  @HiveField(5)
  String lastShownAt;

  @HiveField(6)
  bool globalButtonAction;

  @HiveField(7)
  String target;

  @HiveField(8)
  String productName;

  @HiveField(9)
  int productId;

  @HiveField(10)
  String startDate;

  @HiveField(11)
  String endDate;

  @HiveField(12)
  List<MediaHiveItem> mediaItems;

  PromoHiveModel({
    required this.id,
    required this.mediaType,
    required this.shouldDisplay,
    required this.maxDisplayCount,
    required this.displayFrequency,
    required this.lastShownAt,
    required this.globalButtonAction,
    required this.target,
    required this.productName,
    required this.productId,
    required this.startDate,
    required this.endDate,
    required this.mediaItems,
  });

  PromoHiveModel copyWith({
    int? id,
    String? mediaType,
    bool? shouldDisplay,
    int? maxDisplayCount,
    int? displayFrequency,
    String? lastShownAt,
    bool? globalButtonAction,
    String? target,
    String? productName,
    int? productId,
    String? startDate,
    String? endDate,
    List<MediaHiveItem>? mediaItems,
  }) {
    return PromoHiveModel(
      id: id ?? this.id,
      mediaType: mediaType ?? this.mediaType,
      shouldDisplay: shouldDisplay ?? this.shouldDisplay,
      maxDisplayCount: maxDisplayCount ?? this.maxDisplayCount,
      displayFrequency: displayFrequency ?? this.displayFrequency,
      lastShownAt: lastShownAt ?? this.lastShownAt,
      globalButtonAction: globalButtonAction ?? this.globalButtonAction,
      target: target ?? this.target,
      productName: productName ?? this.productName,
      productId: productId ?? this.productId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      mediaItems: mediaItems ?? this.mediaItems,
    );
  }
}

@HiveType(typeId: 4)
class MediaHiveItem {
  @HiveField(0)
  String mediaUrl;

  @HiveField(1)
  List<ButtonHiveModel> buttons;

  MediaHiveItem({
    required this.mediaUrl,
    required this.buttons,
  });
}

@HiveType(typeId: 5)
class ButtonHiveModel {
  @HiveField(0)
  String buttonName;

  @HiveField(1)
  String actionUrl;

  @HiveField(2)
  String productName;

  @HiveField(3)
  int productId;

  ButtonHiveModel({
    required this.buttonName,
    required this.actionUrl,
    required this.productName,
    required this.productId,
  });
}
