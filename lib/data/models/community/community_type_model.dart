class CommunityTypeModel {
  final List<Product>? data;
  final List<PostType>? postTypeData;

  CommunityTypeModel({this.data, this.postTypeData});

  factory CommunityTypeModel.fromJson(Map<String, dynamic> json) {
    return CommunityTypeModel(
      data: (json['data'] as List<dynamic>?)?.map((e) => Product.fromJson(e)).toList(),
      postTypeData: (json['postTypeData'] as List<dynamic>?)?.map((e) => PostType.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((e) => e.toJson()).toList(),
      'postTypeData': postTypeData?.map((e) => e.toJson()).toList(),
    };
  }
}

class Product {
  final int? productId;
  final String? productName;
  final String? productCode;

  Product({this.productId, this.productName, this.productCode});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'] as int?,
      productName: json['productName'] as String?,
      productCode: json['productCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productCode': productCode,
    };
  }
}

class PostType {
  final int? id;
  final String? name;

  PostType({this.id, this.name});

  factory PostType.fromJson(Map<String, dynamic> json) {
    return PostType(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
