import 'package:research_mantra_official/data/models/learning_material.dart/learning_material_list.dart';

class IndicatorBindingDataModel {
  final String? heading;
  final String? bindedData;
  final List<LearningMaterialList>? data;
  final String? attachment;
  final String? attachmentDescription;
  final String? attachmentTitle;

  const IndicatorBindingDataModel(
      {this.heading,
      this.bindedData,
      this.data,
      this.attachment,
      this.attachmentDescription,
      this.attachmentTitle});
  IndicatorBindingDataModel copyWith(
      {String? heading,
      String? bindedData,
      List<LearningMaterialList>? data,
      String? attachment,
      String? attachmentDescription,
      String? attachmentTitle}) {
    return IndicatorBindingDataModel(
        heading: heading ?? this.heading,
        bindedData: bindedData ?? this.bindedData,
        data: data ?? this.data,
        attachment: attachment ?? this.attachment,
        attachmentDescription:
            attachmentDescription ?? this.attachmentDescription,
        attachmentTitle: attachmentTitle ?? this.attachmentTitle);
  }

  Map<String, dynamic> toJson() {
    return {
      'heading': heading,
      'bindedData': bindedData,
      'data': data?.map<Map<String, dynamic>>((data) => data.toJson()).toList()
    };
  }

  static IndicatorBindingDataModel fromJson(Map<String, dynamic> json) {
    return IndicatorBindingDataModel(
      heading: json['heading'] == null ? null : json['heading'] as String,
      bindedData:
          json['bindedData'] == null ? null : json['bindedData'] as String,
      data: json['data'] == null
          ? null
          : (json['data'] as List)
              .map<LearningMaterialList>((data) =>
                  LearningMaterialList.fromJson(data as Map<String, dynamic>))
              .toList(),
      attachment:
          json["attachmemt"] == null ? null : json["attachmemt"] as String,
      attachmentDescription: json["attachmentDescription"] == null
          ? null
          : json["attachmentDescription"] as String,
      attachmentTitle:
          json["attachmentTitle"],
    );
  }
}
