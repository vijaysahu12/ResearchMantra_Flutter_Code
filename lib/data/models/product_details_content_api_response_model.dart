import 'package:research_mantra_official/data/models/blogs/blog_api_response_model.dart';

class ProductDetailsItemApiResponseModel {
  final String? title;
  final String? description;
  final String? thumbnailImage;
  final String? listImage;
  final String? attachmentType;
  final String? attachment;
  final int? duration;
  final String? language;
  final int? allVideoDuration;
  final int? totalVideoCount;
  final int? totalChapters;
  final List<ImageDetails>? screenshotList;
  const ProductDetailsItemApiResponseModel(
      {this.title,
      this.description,
      this.thumbnailImage,
      this.listImage,
      this.attachmentType,
      this.attachment,
      this.duration,
      this.language,
      this.allVideoDuration,
      this.totalVideoCount,
      this.totalChapters,
      this.screenshotList});

  factory ProductDetailsItemApiResponseModel.fromJson(
      Map<String, dynamic> json) {
    return ProductDetailsItemApiResponseModel(
      title: json['title'] ?? "N/A",
      description: json['description'] ?? "N/A",
      thumbnailImage: json['thumbnailImage'] ?? "",
      listImage: json['listImage'] ?? "N/A",
      attachmentType: json['attachmentType'] ?? "N/A",
      attachment: json['attachment'] ?? "N/A",
      duration: json['duration'] ?? 0,
      language: json['language'] ?? "N/A",
      allVideoDuration: json['allVideoDuration'] ?? 0,
      totalVideoCount: json['totalVideoCount'] ?? 0,
      totalChapters: json['totalChapters'] ?? 0,
      screenshotList:
          json['screenshotList'] != null && json['screenshotList'] is List
              ? (json['screenshotList'] as List)
                  .map((img) => ImageDetails.fromJson(img))
                  .toList()
              : null,
    );
  }
}
