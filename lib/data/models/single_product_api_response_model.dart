import 'dart:convert';

import 'package:research_mantra_official/data/models/product_api_response_model.dart';

class SingleProductApiResponseModel {
  final int id;
  final String name;
  final String code;
  final int? communityId;
  final String? communityName;
  final String description;
  final String buyButtonText;
  final int categoryId;
  final int contentCount;
  final int videoCount;
  final int daysToGo;
  final String? category;
  final double price;
  final double paidAmount;
  final String landscapeImage;
  final String descriptionTitle;
  final String? couponCode;
  final String? discount;
  final String userRating;
  final String liked;
  final String? enableSubscription;
  final bool isHeart;
  final bool isThumbsUp;
  final String subscriptionData;
  final dynamic extraBenefits;
  final bool isInMyBucket;
  final bool isInValidity;
  final bool isQueryFormEnabled;
  final bool ? accessToScanner;
  final dynamic content;
  final List<BonusProduct> bonusProducts;              
final String  ?scannerBonusProductId;
  const SingleProductApiResponseModel({
    required this.id,
    required this.daysToGo,
    required this.name,
    required this.code,
    required this.description,
    required this.descriptionTitle,
    required this.buyButtonText,
    required this.categoryId,
    required this.category,
    required this.price,
    required this.contentCount,
    required this.videoCount,
    required this.landscapeImage,
    this.couponCode,
    this.discount,
    required this.paidAmount,
    required this.userRating,
    required this.liked,
    this.enableSubscription,
    required this.isHeart,
    required this.isThumbsUp,
    required this.subscriptionData,
    this.extraBenefits,
    required this.isInMyBucket,
    required this.isInValidity,
    required this.isQueryFormEnabled,
    required this.bonusProducts,
    this.content,
    this.communityId,
    this.communityName,
    this.accessToScanner,
    this.scannerBonusProductId ,
  });
  SingleProductApiResponseModel copyWith({
    int? id,
    String? name,
    String? description,
    String? descriptionTitle,
    String? buyButtonText,
    int? categoryId,
    int? contentCount,
    int? videoCount,
    int? daysToGo,
    String? category,
    double? price,
    double? paidAmount,
    String? landscapeImage,
    String? couponCode,
    String? discount,
    String? userRating,
    String? liked,
    String? enableSubscription,
    bool? isHeart,
    bool? isThumbsUp,
    String? subscriptionData,
    dynamic extraBenefits,
    bool? isInMyBucket,
    bool? isInValidity,
    bool? isQueryFormEnabled,
    String? content,
    List<BonusProduct>? bonusProducts,
    String? code,
    int? communityId,
    String? communityName,
    bool ? accessToScanner,
     String  ?scannerBonusProductId,
  }) {
    return SingleProductApiResponseModel(
        id: id ?? this.id,
        contentCount: contentCount ?? this.contentCount,
        descriptionTitle: descriptionTitle ?? this.descriptionTitle,
        videoCount: videoCount ?? this.videoCount,
        buyButtonText: buyButtonText ?? this.buyButtonText,
        name: name ?? this.name,
        description: description ?? this.description,
        categoryId: categoryId ?? this.categoryId,
        category: category ?? this.category,
        price: price ?? this.price,
        landscapeImage: landscapeImage ?? this.landscapeImage,
        couponCode: couponCode ?? this.couponCode,
        discount: discount ?? this.discount,
        userRating: userRating ?? this.userRating,
        liked: liked ?? this.liked,
        paidAmount: paidAmount ?? this.paidAmount,
        enableSubscription: enableSubscription ?? this.enableSubscription,
        isHeart: isHeart ?? this.isHeart,
        isThumbsUp: isThumbsUp ?? this.isThumbsUp,
        subscriptionData: subscriptionData ?? this.subscriptionData,
        extraBenefits: extraBenefits ?? this.extraBenefits,
        isInMyBucket: isInMyBucket ?? this.isInMyBucket,
        isInValidity: isInValidity ?? this.isInValidity,
        daysToGo: daysToGo ?? this.daysToGo,
        content: content ?? this.content,
        bonusProducts: bonusProducts ?? this.bonusProducts,
        code: code ?? this.code,
        communityId: communityId ?? this.communityId,
        communityName: communityName ?? this.communityName,
        isQueryFormEnabled: isQueryFormEnabled ?? this.isQueryFormEnabled,
        accessToScanner: accessToScanner ?? this.accessToScanner,
        scannerBonusProductId: scannerBonusProductId ?? this.scannerBonusProductId,
        
        );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      "buyButtonText": buyButtonText,
      'contentCount': contentCount,
      'videoCount': videoCount,
      'description': description,
      'categoryId': categoryId,
      "descriptionTitle": descriptionTitle,
      'category': category,
      'price': price,
      'landscapeImage': landscapeImage,
      'couponCode': couponCode,
      'discount': discount,
      'userRating': userRating,
      'liked': liked,
      'enableSubscription': enableSubscription,
      'isHeart': isHeart,
      'isThumbsUp': isThumbsUp,
      'subscriptionData': subscriptionData,
      'extraBenefits': extraBenefits,
      'isInMyBucket': isInMyBucket,
      'isInValidity': isInValidity,
      'content': content,
      'paidAmount': paidAmount,
      'daysToGo': daysToGo,
      'bonusProducts': bonusProducts,
      'code': code,
      'communityId': communityId,
      'communityName': communityName,
      'isQueryFormEnabled': isQueryFormEnabled,
      'accessToScanner': accessToScanner,
      'scannerBonusProductId': scannerBonusProductId,
    };
  }

  factory SingleProductApiResponseModel.fromJson(Map<String, dynamic> json) {
    // Decode the bonusProducts string into a list of BonusProduct objects
    List<BonusProduct> bonusProductsList = [];
    if (json['bonusProducts'] != null) {
      // Decode the JSON string to List
      var decodedBonusProducts = jsonDecode(json['bonusProducts']);
      if (decodedBonusProducts is List) {
        bonusProductsList = decodedBonusProducts
            .map((item) => BonusProduct.fromJson(item))
            .toList();
      }
    }
    return SingleProductApiResponseModel(
      id: json['id'],
      descriptionTitle: json['descriptionTitle'] ?? '',
      name: json['name'] ?? "",
      code: json['code'] ?? "",
      contentCount: json['contentCount'] ?? "",
      videoCount: json['videoCount'] ?? "",
      description: json['description'] ?? "",
      categoryId: json['categoryId'] ?? "",
      category: json['category'] ?? "",
      buyButtonText: json['buyButtonText'] ?? "",
      price: json['price'] ?? "",
      paidAmount: json['paidAmount'] ?? 0.0,
      landscapeImage: json['landscapeImage'] ?? "",
      couponCode:
          json['couponCode'] == null ? null : json['couponCode'] as String,
      discount: json['discount'] == null ? null : json['discount'] as String,
      userRating: json['userRating'] ?? "",
      liked: json['liked'] ?? "",
      enableSubscription: json['enableSubscription'] == null
          ? null
          : json['enableSubscription'] as String,
      isHeart: json['isHeart'],
      isThumbsUp: json['isThumbsUp'],
      subscriptionData: json['subscriptionData'] ?? '',
      extraBenefits: (json['extraBenefits'] == null
          ? []
          : json['extraBenefits'] as dynamic),
      isInMyBucket: json['isInMyBucket'],
      isInValidity: json['isInValidity'],
      daysToGo: json['daysToGo'] ?? 0,
      content: json['content'] == null ? null : json['content'] as String,
      bonusProducts: bonusProductsList,
      communityId:
          json['communityId'] == null ? null : json['communityId'] as int,
      communityName: json['communityName'] == null
          ? null
          : json['communityName'] as String,
      isQueryFormEnabled: json['isQueryFormEnabled'] ?? false,
      accessToScanner: json['accessToScanner'] == null
          ? null
          : json['accessToScanner'] as bool,
          scannerBonusProductId: json['scannerBonusProductId'] == null
          ? null
          : json['scannerBonusProductId'] as String,
    );
  }
}
