class CompaniesDataModel {
  final List<CompanyData>? companyData;
  final bool? hasResearchProduct;
  const CompaniesDataModel({this.companyData, this.hasResearchProduct});
  CompaniesDataModel copyWith(
      {List<CompanyData>? companyData, bool? hasResearchProduct}) {
    return CompaniesDataModel(
        companyData: companyData ?? this.companyData,
        hasResearchProduct: hasResearchProduct ?? this.hasResearchProduct);
  }

  Map<String, dynamic> toJson() {
    return {
      'companyData': companyData
          ?.map<Map<String, dynamic>>((data) => data.toJson())
          .toList(),
      'hasResearchProduct': hasResearchProduct
    };
  }

  static CompaniesDataModel fromJson(Map<String, dynamic> json) {
    return CompaniesDataModel(
        companyData: json['companyData'] == null
            ? null
            : (json['companyData'] as List)
                .map<CompanyData>((data) =>
                    CompanyData.fromJson(data as Map<String, dynamic>))
                .toList(),
        hasResearchProduct: json['hasResearchProduct'] == null
            ? null
            : json['hasResearchProduct'] as bool);
  }
}

class CompanyData {
  final int? id;
  final int? basketId;
  final bool? isFree;
  final String? name;
  final String? description;
  final String? chartImageUrl;
  final String? otherImage;
  final String? websiteUrl;
  final String? publishDate;
  final num? marketCap;
  final String? shortSummary;
  final num? pe;
  final String? companyStatus;

  // final int id;
  // final String name;
  final String? groupName;
  final double? price;
  final String? productName;
  final int? productId;

  final String? buyButtonText;

  final double? overAllRating;
  final int? heartsCount;
  final double? userRating;
  final bool? userHasHeart;
  final bool? isInMyBucket;

  final bool? isInValidity;
  final String? listImage;

  const CompanyData({
    this.id,
    this.basketId,
    this.name,
    this.description,
    this.chartImageUrl,
    this.otherImage,
    this.websiteUrl,
    this.publishDate,
    this.marketCap,
    this.shortSummary,
    this.pe,
    this.isFree,
    this.buyButtonText,
    this.productId,
    this.productName,
    this.companyStatus,
    //  this.name,
    this.price,
    this.overAllRating,
    this.heartsCount,
    this.userRating,
    this.userHasHeart,
    this.isInMyBucket,
    this.isInValidity,
    this.listImage,
    this.groupName,
  });
  CompanyData copyWith(
      {int? id,
      int? basketId,
      String? name,
      String? description,
      String? chartImageUrl,
      String? otherImage,
      String? websiteUrl,
      String? publishDate,
      num? marketCap,
      String? shortSummary,
      num? pe,
      bool? isFree,
      String? companyStatus,
      String? productName,
      int? productId,
      String? listImage,
      String? groupName,
      int? heartsCount,
      int? thumbsUpCount,
      bool? userHasHeart,
      bool? isInMyBucket,
      bool? isInValidity,
      double? overAllRating,
      String? buyButtonText,
      double? price}) {
    return CompanyData(
        id: id ?? this.id,
        basketId: basketId ?? this.basketId,
        name: name ?? this.name,
        description: description ?? this.description,
        chartImageUrl: chartImageUrl ?? this.chartImageUrl,
        otherImage: otherImage ?? this.otherImage,
        websiteUrl: websiteUrl ?? this.websiteUrl,
        publishDate: publishDate ?? this.publishDate,
        marketCap: marketCap ?? this.marketCap,
        shortSummary: shortSummary ?? this.shortSummary,
        pe: pe ?? this.pe,
        isFree: isFree ?? this.isFree,
        buyButtonText: buyButtonText ?? this.buyButtonText,
        price: price ?? this.price,
        listImage: listImage ?? this.listImage,
        heartsCount: heartsCount ?? this.heartsCount,
        userHasHeart: userHasHeart ?? this.userHasHeart,
        isInMyBucket: isInMyBucket ?? this.isInMyBucket,
        isInValidity: isInValidity ?? this.isInValidity,
        overAllRating: overAllRating ?? this.overAllRating,
        userRating: userRating,
        groupName: this.groupName,
        productId: productId ?? this.productId,
        companyStatus: companyStatus ?? this.companyStatus,
        productName: productName ?? this.productName);
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'basketId': basketId,
      'name': name,
      'description': description,
      'chartImageUrl': chartImageUrl,
      'otherImage': otherImage,
      'websiteUrl': websiteUrl,
      'publishDate': publishDate,
      'marketCap': marketCap,
      'shortSummary': shortSummary,
      'pe': pe,
      'isFree': isFree,
      'price': price,
      'overAllRating': overAllRating,
      'heartsCount': heartsCount,
      'userRating': userRating,
      'userHasHeart': userHasHeart,
      'isInMyBucket': isInMyBucket,
      'isInValidity': isInValidity,
      'listImage': listImage,
      'groupName': groupName,
      'productId': productId,
      'productName': productName,
      'buyButtonText': buyButtonText,
      'companyStatus': companyStatus,
    };
  }

  static CompanyData fromJson(Map<String, dynamic> json) {
    return CompanyData(
        id: json['id'] == null ? null : json['id'] as int,
        basketId: json['basketId'] == null ? null : json['basketId'] as int,
        name: json['name'] == null ? null : json['name'] as String,
        description:
            json['description'] == null ? null : json['description'] as String,
        chartImageUrl: json['chartImageUrl'] == null
            ? null
            : json['chartImageUrl'] as String,
        otherImage:
            json['otherImage'] == null ? null : json['otherImage'] as String,
        websiteUrl:
            json['websiteUrl'] == null ? null : json['websiteUrl'] as String,
        publishDate:
            json['publishDate'] == null ? null : json['createdOn'] as String,
        marketCap: json['marketCap'] == null ? null : json['marketCap'] as num,
        shortSummary: json['shortSummary'] == null
            ? null
            : json['shortSummary'] as String,
        pe: json['pe'] == null ? null : json['pe'] as num,
        isFree: json['isFree'] == null ? null : json['isFree'] as bool,
        buyButtonText: json['buyButtonText'],
        price: json['price'],
        groupName: json['groupName'],
        overAllRating: (json['overAllRating'] ?? 0.0).toDouble(),
        heartsCount: json['heartsCount'],
        listImage: json['listImage'] ?? "",
        userRating: (json['userRating'] ?? 0.0).toDouble(),
        userHasHeart: json['userHasHeart'] ?? false,
        isInMyBucket: json['isInMyBucket'] ?? false,
        isInValidity: json['isInValidity'] ?? false,
        productId: json['productId'],
        productName: json['productName'],
        companyStatus: json['companyStatus']);
  }
}
