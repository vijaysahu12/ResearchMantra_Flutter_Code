
class SipRequestModel {
  final double monthlyInvestment;
  final int investmentPeriod;
  final double annualReturns;
  final int incrementalRate;
 

  SipRequestModel( {
    required this.monthlyInvestment,
    required this.investmentPeriod,
    required this.annualReturns,
    required this.incrementalRate,
  
  });

  //To JSON
  Map<String, dynamic> toJson() => {
        "monthlyInvestment": monthlyInvestment,
        "investmentPeriod": investmentPeriod,
        "annualReturns": annualReturns,
        "incrementalRate": incrementalRate,
      };

  //String toRawJson() => jsonEncode(toJson());
}
