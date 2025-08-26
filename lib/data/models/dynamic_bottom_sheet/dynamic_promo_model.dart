class PromoModel {
  final int id;
  final String mediaType;
  final bool shouldDisplay;
  final int maxDisplayCount;
  final int displayFrequency;
  final String lastShownAt;
  final bool globalButtonAction;
  final String target;
  final String productName;
  final int productId;
  final String startDate;
  final String endDate;
  final List<MediaItems> mediaItems;
  const PromoModel(
      {required this.id,
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
      required this.mediaItems});

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'mediaType': mediaType,
      'shouldDisplay': shouldDisplay,
      'maxDisplayCount': maxDisplayCount,
      'displayFrequency': displayFrequency,
      'lastShownAt': lastShownAt,
      'globalButtonAction': globalButtonAction,
      'target': target,
      'productName': productName,
      'productId': productId,
      'startDate': startDate,
      'endDate': endDate,
      'mediaItems':
          mediaItems.map<Map<String, dynamic>>((data) => data.toJson()).toList()
    };
  }

  static PromoModel fromJson(Map<String, dynamic> json) {
    return PromoModel(
        id: json['id'] ?? 0,
        mediaType: json['mediaType'] ?? '',
        shouldDisplay: json['shouldDisplay'] ?? '',
        maxDisplayCount: json['maxDisplayCount'] ?? 0,
        displayFrequency: json['displayFrequency'] ?? 0,
        lastShownAt: json['lastShownAt'] ?? '',
        globalButtonAction: json['globalButtonAction'] ?? '',
        target: json['target'] ?? '',
        productName: json['productName'] ?? '',
        productId: json['productId'] ?? 0,
        startDate: json['startDate'] ?? '',
        endDate: json['endDate'] ?? '',
        mediaItems: (json['mediaItems'] as List)
            .map<MediaItems>(
                (data) => MediaItems.fromJson(data as Map<String, Object?>))
            .toList());
  }
}

class MediaItems {
  final String mediaUrl;
  final List<Buttons> buttons;
  const MediaItems({required this.mediaUrl, required this.buttons});

  Map<String, Object?> toJson() {
    return {
      'mediaUrl': mediaUrl,
      'buttons':
          buttons.map<Map<String, dynamic>>((data) => data.toJson()).toList()
    };
  }

  static MediaItems fromJson(Map<String, dynamic> json) {
    return MediaItems(
      mediaUrl: json['mediaUrl'] ?? '',
      buttons: (json['buttons'] as List)
          .map<Buttons>(
              (data) => Buttons.fromJson(data as Map<String, Object?>))
          .toList(),
    );
  }
}

class Buttons {
  final String buttonName;
  final String actionUrl;
  final String productName;
  final int productId;
  const Buttons(
      {required this.buttonName,
      required this.actionUrl,
      required this.productName,
      required this.productId});

  Map<String, Object?> toJson() {
    return {
      'buttonName': buttonName,
      'actionUrl': actionUrl,
      'productName': productName,
      'productId': productId
    };
  }

  static Buttons fromJson(Map<String, dynamic> json) {
    return Buttons(
      buttonName: json['buttonName'] ?? '',
      actionUrl: json['actionUrl'] ?? '',
      productName: json['productName'] ?? '',
      productId: json['productId'] ?? 0,
    );
  }
}
