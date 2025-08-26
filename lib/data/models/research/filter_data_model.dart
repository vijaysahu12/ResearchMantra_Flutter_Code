class FilterDataModel {
  final List<Data>? data;
  const FilterDataModel({this.data});
  FilterDataModel copyWith({List<Data>? data}) {
    return FilterDataModel(data: data ?? this.data);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map<Map<String, dynamic>>((data) => data.toJson()).toList()
    };
  }

  static FilterDataModel fromJson(Map<String, dynamic> json) {
    return FilterDataModel(
        data: json['data'] == null
            ? null
            : (json['data'] as List)
                .map<Data>(
                    (data) => Data.fromJson(data as Map<String, dynamic>))
                .toList());
  }
}

class Data {
  final String? name;
  final List<FilterData>? filterData;
  const Data({this.name, this.filterData});
  Data copyWith({String? name, List<FilterData>? filterData}) {
    return Data(
        name: name ?? this.name, filterData: filterData ?? this.filterData);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'filterData': filterData
          ?.map<Map<String, dynamic>>((data) => data.toJson())
          .toList()
    };
  }

  static Data fromJson(Map<String, dynamic> json) {
    return Data(
        name: json['name'] == null ? null : json['name'] as String,
        filterData: json['filterData'] == null
            ? null
            : (json['filterData'] as List)
                .map<FilterData>(
                    (data) => FilterData.fromJson(data as Map<String, dynamic>))
                .toList());
  }
}

class FilterData {
  final String? displayName;
  final String? code;
  bool? isSelected;
  FilterData({this.displayName, this.code, this.isSelected});
  FilterData copyWith({String? displayName, String? code, bool? isSelected}) {
    return FilterData(
        displayName: displayName ?? this.displayName,
        code: code ?? this.code,
        isSelected: isSelected ?? this.isSelected);
  }

  Map<String, dynamic> toJson() {
    return {'displayName': displayName, 'code': code, 'isSelected': isSelected};
  }

  static FilterData fromJson(Map<String, dynamic> json) {
    return FilterData(
        displayName:
            json['displayName'] == null ? null : json['displayName'] as String,
        code: json['code'] == null ? null : json['code'] as String,
        isSelected:
            json['isSelected'] == null ? null : json['isSelected'] as bool);
  }
}
