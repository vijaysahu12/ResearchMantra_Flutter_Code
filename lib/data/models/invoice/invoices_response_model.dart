class GetInvoicesModel {
  final String? transactionId;
  final String? transasctionReference;
  final String? couponCode;
  final String? clientName;

  final String? startDate;
  final String? endDate;
  final String? createdOn;
  final String? paymentDate;
  final String? productName;
  final double? paidAmount;
  final String? downloadUrl;
  const GetInvoicesModel(
      {this.transactionId,
      this.transasctionReference,
      this.couponCode,
      this.clientName,
      this.startDate,
      this.endDate,
      this.createdOn,
      this.paymentDate,
      this.productName,
      this.paidAmount,
      this.downloadUrl});

  Map<String, Object?> toJson() {
    return {
      'transactionId': transactionId,
      'transasctionReference': transasctionReference,
      'couponCode': couponCode,
      'clientName': clientName,
      'startDate': startDate,
      'endDate': endDate,
      'createdOn': createdOn,
      'paymentDate': paymentDate,
      'productName': productName,
      'paidAmount': paidAmount,
      'downloadUrl': downloadUrl
    };
  }

  static GetInvoicesModel fromJson(Map<String, dynamic> json) {
    return GetInvoicesModel(
        transactionId: json['transactionId'] ?? '',
        transasctionReference: json['transasctionReference'] ?? '',
        couponCode: json['couponCode'] ?? '',
        clientName: json['clientName'] ?? '',
        startDate: json['startDate'] ?? '',
        endDate: json['endDate'] ?? '',
        createdOn: json['createdOn'] ?? '',
        paymentDate: json['paymentDate'] ?? '',
        productName: json['productName'] ?? '',
        paidAmount: json['paidAmount'] ?? 0.0,
        downloadUrl: json['downloadUrl'] ?? '');
  }
}
