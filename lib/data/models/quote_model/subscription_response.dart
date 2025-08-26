class GetSubscriptionTopicsAndQuoteResponse {
  final String? discountName;
  final bool? discountStatus;
  final String? quote;
  final String? author;
  final String buttonText;
  final String imageUrl;
  final String actionUrl;
  final String? promotionUrl;

  const GetSubscriptionTopicsAndQuoteResponse({
    this.discountName,
    this.discountStatus,
    this.quote,
    this.author,
    required this.buttonText,
    required this.imageUrl,
    required this.actionUrl,
    required this.promotionUrl,
  });

  static GetSubscriptionTopicsAndQuoteResponse fromJson(
      Map<String, dynamic> json) {
    return GetSubscriptionTopicsAndQuoteResponse(
        discountName: json['discountName'] ?? '',
        discountStatus: json['discountStatus'] ?? false,
        quote: json['quote'] ?? '',
        author: json['author'] ?? '',
        buttonText: json['buttonText'] ?? '',
        imageUrl: json['imageUrl'] ?? "",
        actionUrl: json['actionUrl'] ?? '',
        promotionUrl: json['promotionUrl'] ?? '');
  }
}
