class CalculateMyFuturePlanModel {
  final int currentAge;
  final double inflationRate;
  final String currentMonthlyExpense;
  final String futureMonthlyExpenseAtAgeOf60;
  final String capitalNeededAt60;
  final String anyCurrentInvestment;
  final List<InvestmentPlans> investmentPlansWithExistingInvestment;
  final List<InvestmentPlans> investmentPlansWithoutAnyExistingInvestment;

  final String? summaryLabel1;
  final String? summaryLabel2;
  final bool allowPdf;

  const CalculateMyFuturePlanModel({
    required this.currentAge,
    required this.inflationRate,
    required this.currentMonthlyExpense,
    required this.futureMonthlyExpenseAtAgeOf60,
    required this.capitalNeededAt60,
    required this.anyCurrentInvestment,
    required this.investmentPlansWithExistingInvestment,
    required this.investmentPlansWithoutAnyExistingInvestment,
    this.summaryLabel1,
    this.summaryLabel2,
    required this.allowPdf,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentAge': currentAge,
      'inflationRate': inflationRate,
      'currentMonthlyExpense': currentMonthlyExpense,
      'futureMonthlyExpenseAtAgeOf60': futureMonthlyExpenseAtAgeOf60,
      'capitalNeededAt60': capitalNeededAt60,
      'anyCurrentInvestment': anyCurrentInvestment,
      'investmentPlansWithExistingInvestment':
          investmentPlansWithExistingInvestment
              .map((plan) => plan.toJson())
              .toList(),
      'investmentPlansWithoutAnyExistingInvestment':
          investmentPlansWithoutAnyExistingInvestment
              .map((plan) => plan.toJson())
              .toList(),
      'summaryLabel1': summaryLabel1,
      'summaryLabel2': summaryLabel2,
      'allowPdf': allowPdf,
    };
  }

  factory CalculateMyFuturePlanModel.fromJson(Map<String, dynamic> json) {
    return CalculateMyFuturePlanModel(
      currentAge: json['currentAge'] as int? ?? 0,
      inflationRate: (json['inflationRate'] as num?)?.toDouble() ?? 0.0,
      currentMonthlyExpense: json['currentMonthlyExpense']?.toString() ?? '0',
      futureMonthlyExpenseAtAgeOf60:
          json['futureMonthlyExpenseAtAgeOf60']?.toString() ?? '0',
      capitalNeededAt60: json['capitalNeededAt60']?.toString() ?? '0',
      anyCurrentInvestment: json['anyCurrentInvestment']?.toString() ?? '0',
      investmentPlansWithExistingInvestment:
          (json['investmentPlansWithExistingInvestment'] as List<dynamic>?)
                  ?.map((plan) =>
                      InvestmentPlans.fromJson(plan as Map<String, dynamic>))
                  .toList() ??
              [],
      investmentPlansWithoutAnyExistingInvestment:
          (json['investmentPlansWithoutAnyExistingInvestment']
                      as List<dynamic>?)
                  ?.map((plan) =>
                      InvestmentPlans.fromJson(plan as Map<String, dynamic>))
                  .toList() ??
              [],
      summaryLabel1: json['summaryLabel1']?.toString(),
      summaryLabel2: json['summaryLabel2']?.toString(),
      allowPdf: json['allowPdf'] as bool? ?? false,
    );
  }
}

class InvestmentPlans {
  final String planName;
  final double interestRate;
  final String monthlySipAmount;
  final List<ProjectedGrowths> projectedGrowths;

  const InvestmentPlans({
    required this.planName,
    required this.interestRate,
    required this.monthlySipAmount,
    required this.projectedGrowths,
  });

  InvestmentPlans copyWith({
    String? planName,
    double? interestRate,
    String? monthlySipAmount,
    List<ProjectedGrowths>? projectedGrowths,
  }) {
    return InvestmentPlans(
      planName: planName ?? this.planName,
      interestRate: interestRate ?? this.interestRate,
      monthlySipAmount: monthlySipAmount ?? this.monthlySipAmount,
      projectedGrowths: projectedGrowths ?? this.projectedGrowths,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planName': planName,
      'interestRate': interestRate,
      'monthlySipAmount': monthlySipAmount,
      'projectedGrowths':
          projectedGrowths.map((growth) => growth.toJson()).toList(),
    };
  }

  factory InvestmentPlans.fromJson(Map<String, dynamic> json) {
    return InvestmentPlans(
      planName: json['planName']?.toString() ?? '',
      interestRate: (json['interestRate'] as num?)?.toDouble() ?? 0.0,
      monthlySipAmount: json['monthlySipAmount']?.toString() ?? '0',
      projectedGrowths: (json['projectedGrowths'] as List<dynamic>?)
              ?.map((growth) =>
                  ProjectedGrowths.fromJson(growth as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ProjectedGrowths {
  final int year;
  final int amount;

  const ProjectedGrowths({
    required this.year,
    required this.amount,
  });

  ProjectedGrowths copyWith({
    int? year,
    int? amount,
  }) {
    return ProjectedGrowths(
      year: year ?? this.year,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'amount': amount,
    };
  }

  factory ProjectedGrowths.fromJson(Map<String, dynamic> json) {
    return ProjectedGrowths(
      year: json['year'] as int? ?? 0,
      amount: json['amount'] as int? ?? 0,
    );
  }
}
