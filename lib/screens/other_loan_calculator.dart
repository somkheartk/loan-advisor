import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../domain/entities/loan_calculation.dart';
import '../domain/usecases/calculate_loan_usecase.dart';

class OtherLoanCalculator extends StatefulWidget {
  const OtherLoanCalculator({super.key});

  @override
  State<OtherLoanCalculator> createState() => _OtherLoanCalculatorState();
}

class _OtherLoanCalculatorState extends State<OtherLoanCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _loanAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _loanTermController = TextEditingController();
  final _numberFormat = NumberFormat('#,##0.00', 'en_US');
  final _calculateLoanUseCase = CalculateLoanUseCase();

  double _monthlyPayment = 0;
  double _totalPayment = 0;
  double _totalInterest = 0;

  @override
  void dispose() {
    _loanAmountController.dispose();
    _interestRateController.dispose();
    _loanTermController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final loanAmount =
        double.parse(_loanAmountController.text.replaceAll(',', ''));
    final annualRate = double.parse(_interestRateController.text);
    final years = int.parse(_loanTermController.text);

    final calculation = LoanCalculation(
      principalAmount: loanAmount,
      annualInterestRate: annualRate,
      termInMonths: years * 12,
    );

    final result = _calculateLoanUseCase.execute(calculation);

    setState(() {
      _monthlyPayment = result.monthlyPayment;
      _totalPayment = result.totalPayment;
      _totalInterest = result.totalInterest;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true; // อนุญาตให้กลับได้
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFBBC04), // Yellow
                Color(0xFFFF9800), // Orange
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'คำนวณสินเชื่ออื่นๆ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'คำนวณยอดผ่อนรายเดือน',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Loan Icon and Title
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFBBC04)
                                        .withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.more_horiz,
                                    size: 24,
                                    color: Color(0xFFFBBC04),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'สินเชื่ออื่นๆ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                    Text(
                                      'คำนวณการผ่อนสินเชื่อทั่วไป',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Loan Amount Input
                            _buildInputSection(
                              title: 'ยอดเงินกู้',
                              controller: _loanAmountController,
                              hintText: 'ระบุจำนวนเงินที่ต้องการกู้',
                              suffixText: 'บาท',
                              icon: Icons.attach_money,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกยอดเงินกู้';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // Interest Rate Input
                            _buildInputSection(
                              title: 'อัตราดอกเบี้ย',
                              controller: _interestRateController,
                              hintText: 'ระบุอัตราดอกเบี้ยต่อปี',
                              suffixText: '%',
                              icon: Icons.percent,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกอัตราดอกเบี้ย';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // Loan Term Input
                            _buildInputSection(
                              title: 'ระยะเวลาผ่อน',
                              controller: _loanTermController,
                              hintText: 'ระบุจำนวนปีที่ผ่อน',
                              suffixText: 'ปี',
                              icon: Icons.schedule,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกระยะเวลาผ่อน';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 32),

                            // Calculate Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _calculate,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFBBC04),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child: const Text(
                                  'คำนวณยอดผ่อน',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Results Section
                            if (_monthlyPayment > 0) _buildResultsSection(),

                            const SizedBox(
                                height: 100), // Bottom padding for navigation
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection({
    required String title,
    required TextEditingController controller,
    required String hintText,
    required String suffixText,
    required IconData icon,
    required TextInputType keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            suffixText: suffixText,
            prefixIcon: Icon(icon, color: const Color(0xFFFBBC04)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFFBBC04)),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }

  Widget _buildResultsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFBBC04).withOpacity(0.1),
            const Color(0xFFFF9800).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFBBC04).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBBC04).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calculate,
                  size: 20,
                  color: Color(0xFFFBBC04),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'ผลการคำนวณ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildResultRow(
            'ยอดผ่อนต่อเดือน',
            '฿${_numberFormat.format(_monthlyPayment)}',
            const Color(0xFFFBBC04),
            isBold: true,
            isHighlight: true,
          ),
          const SizedBox(height: 12),
          _buildResultRow(
            'ยอดชำระรวมทั้งหมด',
            '฿${_numberFormat.format(_totalPayment)}',
            const Color(0xFF333333),
          ),
          const SizedBox(height: 12),
          _buildResultRow(
            'ดอกเบี้ยรวม',
            '฿${_numberFormat.format(_totalInterest)}',
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color color,
      {bool isBold = false, bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: isHighlight
          ? BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: const Color(0xFF333333),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 18 : 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
