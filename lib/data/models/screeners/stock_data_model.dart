class Stock {
  final int? id;
  final int? screenerId;
  final String? logo;
  final String? symbol;
  final String? name;
  final double? triggerPrice;
  final double? percentageChange;// aditional
  final double? netChange;
  final String? chartUrl;
  final String ?modifiedOn;



  Stock(
    {
    this.id,
    this.netChange, 
    this.screenerId,
    this.logo,
    this.symbol,
    this.name,
    this.triggerPrice,
    this.percentageChange,
    this.chartUrl,
     this.modifiedOn,
  });

  // Factory method to create a Stock from JSON
  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'],
      screenerId: json['screenerId'],
      logo: json['logo'],
      symbol: json['symbol'],
      name: json['name'],
      triggerPrice: json['triggerPrice']?.toDouble(),
      percentageChange: json['percentageChange']?.toDouble(),
      netChange: json['netChange']?.toDouble(),
      chartUrl: json['chartUrl'],
      modifiedOn: json['modifiedOn'],
    );
  }

  // Convert Stock object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'screenerId': screenerId,
      'logo': logo,
      'symbol': symbol,
      'name': name,
      'triggerPrice': triggerPrice,
      'percentageChange': percentageChange,
      'netChange': netChange,
      //'profitPercent': profitPercent,
      'chartUrl': chartUrl,
      'modifiedOn':modifiedOn
    };
  }
}
