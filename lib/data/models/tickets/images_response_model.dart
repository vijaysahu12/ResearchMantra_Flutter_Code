class Images {
  final String? name;
  final String? aspectRatio;
  const Images({this.name, this.aspectRatio});
  Images copyWith({String? name, String? aspectRatio}) {
    return Images(
        name: name ?? this.name, aspectRatio: aspectRatio ?? this.aspectRatio);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'aspectRatio': aspectRatio};
  }

  static Images fromJson(Map<String, dynamic> json) {
    return Images(
        name: json['name'] == null ? null : json['name'] as String,
        aspectRatio:
            json['aspectRatio'] == null ? null : json['aspectRatio'] as String);
  }
}
