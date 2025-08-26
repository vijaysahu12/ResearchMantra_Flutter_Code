class LearningMaterialList {
  final int? id;
  final String? imageUrl;
  final String? name;
  final String? description;

  final bool? isLiked;
  final int? likeCount;
  const LearningMaterialList(
      {this.id,
      this.imageUrl,
      this.name,
      this.isLiked,
      this.likeCount,
      this.description});
  LearningMaterialList copyWith(
      {int? id,
      String? imageUrl,
      String? name,
      String? description,
      bool? isLiked,
      int? likeCount}) {
    return LearningMaterialList(
        id: id ?? this.id,
        imageUrl: imageUrl ?? this.imageUrl,
        name: name ?? this.name,
        isLiked: isLiked ?? this.isLiked,
        likeCount: likeCount ?? this.likeCount,
        description: description ?? this.description);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'name': name,
      'isLiked': isLiked,
      'likeCount': likeCount,
      'description': description
    };
  }

  static LearningMaterialList fromJson(Map<String, dynamic> json) {
    return LearningMaterialList(
        id: json['id'] == null ? null : json['id'] as int,
        imageUrl: json['imageUrl'] == null ? null : json['imageUrl'] as String,
        name: json['name'] == null ? null : json['name'] as String,
        isLiked: json['isLiked'] == null ? null : json['isLiked'] as bool,
        description: json['description'] ?? '',
        likeCount: json['likeCount'] == null ? null : json['likeCount'] as int);
  }
}
