class BankOffer {
  final int bankId;
  final String bankName;
  final double monthlyPayment;
  final double rate;
  final int duration; // years

  const BankOffer({
    required this.bankId,
    required this.bankName,
    required this.monthlyPayment,
    required this.rate,
    required this.duration,
  });

  factory BankOffer.fromJson(Map<String, dynamic> json) {
    return BankOffer(
      bankId: json['bank_id'] as int,
      bankName: json['bank_name'] as String,
      monthlyPayment: (json['monthly_payment'] as num).toDouble(),
      rate: (json['rate'] as num).toDouble(),
      duration: json['duration'] as int,
    );
  }
}

class SimulationResult {
  final int id;
  final double appliedRate;
  final double calculatedMonthlyPayment;
  final double totalFinanceCost;
  final double debtRatio;
  final double islamicProfitRate;
  final double islamicMonthlyPayment;
  final double islamicTotalMargin;
  final int requestedDuration;
  final String state;

  const SimulationResult({
    required this.id,
    required this.appliedRate,
    required this.calculatedMonthlyPayment,
    required this.totalFinanceCost,
    required this.debtRatio,
    required this.islamicProfitRate,
    required this.islamicMonthlyPayment,
    required this.islamicTotalMargin,
    required this.requestedDuration,
    required this.state,
  });

  factory SimulationResult.fromJson(Map<String, dynamic> json) {
    return SimulationResult(
      id: json['id'] as int,
      appliedRate: (json['applied_rate'] as num).toDouble(),
      calculatedMonthlyPayment:
          (json['calculated_monthly_payment'] as num).toDouble(),
      totalFinanceCost: (json['total_finance_cost'] as num).toDouble(),
      debtRatio: (json['debt_ratio'] as num).toDouble(),
      islamicProfitRate: (json['islamic_profit_rate'] as num).toDouble(),
      islamicMonthlyPayment: (json['islamic_monthly_payment'] as num).toDouble(),
      islamicTotalMargin: (json['islamic_total_margin'] as num).toDouble(),
      requestedDuration: json['requested_duration'] as int,
      state: json['state'] as String? ?? '',
    );
  }

  double get costGap => islamicTotalMargin - totalFinanceCost;
  bool get debtCapacityExceeded => debtRatio > 33.33;
}
