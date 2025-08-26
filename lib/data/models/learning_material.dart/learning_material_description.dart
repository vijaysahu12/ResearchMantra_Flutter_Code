class LearningMaterialDescription {
  final String? attachmentTitle;
  final String? description;
  final String? thumbnailImage;
  final String? listImage;
  final String? attachmentType;
  final String? attachment;
  final String? title;

  final String? attachmentDescription;
  final int? id;
  const LearningMaterialDescription(
      {this.attachmentTitle,
      this.description,
      this.thumbnailImage,
      this.listImage,
      this.attachmentType,
      this.id,
      this.attachmentDescription,
      this.title,
      this.attachment});
  LearningMaterialDescription copyWith({
    int? descId,
    String? heading,
    String? imageUrlOne,
    String? aboutDescription,
    String? imageUrlTwo,
    String? formationofPattern,
    String? importantPoints,
    String? attachmentTitle,
    String? description,
    String? thumbnailImage,
    String? listImage,
    String? attachmentType,
    String? attachment,
    String? attachmentDescription,
    int? id,
    String? title,
  }) {
    return LearningMaterialDescription(
        attachmentTitle: attachmentTitle ?? this.attachmentTitle,
        description: description ?? this.description,
        thumbnailImage: thumbnailImage ?? this.thumbnailImage,
        listImage: listImage ?? this.listImage,
        attachmentType: attachmentType ?? this.attachmentType,
        attachment: attachment ?? this.attachment,
        id: id,
        attachmentDescription: aboutDescription,
        title: title);
  }

  Map<String, dynamic> toJson() {
    return {
      'attachmentDescription': attachmentDescription,
    };
  }

  static LearningMaterialDescription fromJson(Map<String, dynamic> json) {
    return LearningMaterialDescription(
        attachmentTitle: json['attachmentTitle'] ?? "",
        description: json['description'] ?? "",
        thumbnailImage: json['thumbnailImage'] ?? "",
        listImage: json['listImage'] ?? "",
        attachmentType: json['attachmentType'] ?? "",
        attachment: json['attachment'] ?? "",
        attachmentDescription: json['attachmentDescription'],
        title: json['title']);
  }
}
