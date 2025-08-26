class AdvertisementResponseModel {
  final String? url;
  final String name;

  const AdvertisementResponseModel({this.url, required this.name});

  static AdvertisementResponseModel fromJson(Map<String, dynamic> json) {
    return AdvertisementResponseModel(
        url: json['url'] ?? "", name: json['name'] ?? "");
  }
}
