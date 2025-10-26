import '../entities/loan_calculation.dart';
import '../entities/loan_result.dart';
import 'dart:math';

class CalculateLoanUseCase {
  LoanResult execute(LoanCalculation calculation) {
    final loanAmount = calculation.principalAmount - (calculation.downPayment ?? 0);
    final monthlyRate = calculation.annualInterestRate / 100 / 12;
    final numberOfPayments = calculation.termInMonths;

    // Calculate monthly payment using the formula: M = P × [r(1 + r)^n] / [(1 + r)^n - 1]
    final monthlyPayment = loanAmount *
        (monthlyRate * pow(1 + monthlyRate, numberOfPayments)) /
        (pow(1 + monthlyRate, numberOfPayments) - 1);

    final totalPayment = monthlyPayment * numberOfPayments;
    final totalInterest = totalPayment - loanAmount;

    return LoanResult(
      monthlyPayment: monthlyPayment,
      totalPayment: totalPayment,
      totalInterest: totalInterest,
      loanAmount: loanAmount,
    );
  }
}
