class CommonApiResponse {
  final int statusCode;
  final String message;
  final dynamic data;

  CommonApiResponse(
      {required this.statusCode, required this.message, required this.data});

  factory CommonApiResponse.fromJson(Map<String, dynamic> json) {
    return CommonApiResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] ?? '',
      data: json['data'] as dynamic,
    );
  }
}

//common Helper response Model
class CommonHelperResponseModel {
  final bool status;
  final String message;
  final dynamic data;

  CommonHelperResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory CommonHelperResponseModel.fromJson(CommonApiResponse json) {
    return CommonHelperResponseModel(
      status: json.statusCode == 200 ? true : false,
      message: json.message,
      data: json.data,
    );
  }
}

//coomon No content response model
class NoContentResponse {
  final bool status;
  final String message;
  final dynamic data;

  NoContentResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory NoContentResponse.fromJson(CommonApiResponse json) {
    return NoContentResponse(
      status: json.statusCode == 204 ? true : false,
      message: json.message,
      data: json.data,
    );
  }
}
