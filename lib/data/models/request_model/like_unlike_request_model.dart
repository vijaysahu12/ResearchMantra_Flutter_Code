class LikeUnlikeRequestModel {
  final String productId;
  final int likeId;
  final String createdBy;
  final String action;

  LikeUnlikeRequestModel({
    required this.productId,
    required this.likeId,
    required this.createdBy,
    required this.action,
  });

  // Convert the model to a Map
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'likeId': likeId,
      'createdBy': createdBy,
      'action': action
    };
  }
}
