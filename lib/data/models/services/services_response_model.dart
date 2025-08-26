class ServicesResponseModel {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String badge;

  ServicesResponseModel({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.badge,
  });

  factory ServicesResponseModel.fromJson(Map<String, dynamic> json) {
    return ServicesResponseModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      badge: json['badge'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'badge': badge,
    };
  }
}
