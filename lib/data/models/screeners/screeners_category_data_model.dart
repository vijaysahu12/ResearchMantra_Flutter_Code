// Define a class for Screener
class Screener {
  final int? id;
  final String? name;
  final String? code;
  final String? screenerDescription;
  final String? icon;
  final String? backgroundColor;

  Screener({
    this.id,
    this.name,
    this.code,
    this.screenerDescription,
    this.icon,
    this.backgroundColor,
  });

  // Factory method to create a Screener from JSON
  factory Screener.fromJson(Map<String, dynamic> json) {
    return Screener(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      screenerDescription: json['screenerDescription'],
      icon: json['icon'],
      backgroundColor: json['backgroundColor'],
    );
  }

  // Convert Screener object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'screenerDescription': screenerDescription,
      'icon': icon,
      'backgroundColor': backgroundColor,
    };
  }
}

// Define a class for Category
class Category {
  final int? categoryId;
  final String? categoryName;
  final String? categoryDescription;
  final bool? subscriptionStatus;
  final String? image;
  final String? backgroundColor;
  final List<Screener>? screeners;

  Category({
    this.categoryId,
    this.categoryName,
    this.categoryDescription,
    this.subscriptionStatus,
    this.image,
    this.backgroundColor,
    this.screeners,
  });

  // Factory method to create a Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    var list = json['screeners'] as List?;
    List<Screener>? screenersList =
        list?.map((i) => Screener.fromJson(i)).toList();

    return Category(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      categoryDescription: json['categoryDescription'],
      subscriptionStatus: json['subscriptionStatus'],
      image: json['image'],
      backgroundColor: json['backgroundColor'],
      screeners: screenersList,
    );
  }

  // Convert Category object to JSON
  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryDescription': categoryDescription,
      'subscriptionStatus': subscriptionStatus,
      'image': image,
      'backgroundColor': backgroundColor,
      'screeners': screeners?.map((screener) => screener.toJson()).toList(),
    };
  }
}

// Define a class for the CategoryDataModel (previously ResponseData)
class CategoryDataModel {
  final List<Category>? data;

  CategoryDataModel({this.data});

  // Factory method to create a CategoryDataModel from JSON
  factory CategoryDataModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?;
    List<Category>? categoriesList =
        list?.map((i) => Category.fromJson(i)).toList();

    return CategoryDataModel(data: categoriesList);
  }

  // Convert CategoryDataModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((category) => category.toJson()).toList(),
    };
  }
}
