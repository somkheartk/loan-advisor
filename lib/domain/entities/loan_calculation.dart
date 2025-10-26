class LoanCalculation {
  final double principalAmount;
  final double annualInterestRate;
  final int termInMonths;
  final double? downPayment;

  LoanCalculation({
    required this.principalAmount,
    required this.annualInterestRate,
    required this.termInMonths,
    this.downPayment,
  });
}
