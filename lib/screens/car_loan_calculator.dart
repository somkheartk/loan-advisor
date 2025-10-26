import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class CarLoanCalculator extends StatefulWidget {
  const CarLoanCalculator({super.key});

  @override
  State<CarLoanCalculator> createState() => _CarLoanCalculatorState();
}

class _CarLoanCalculatorState extends State<CarLoanCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _carPriceController = TextEditingController();
  final _downPaymentController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _loanTermController = TextEditingController();

  double _monthlyPayment = 0;
  double _totalPayment = 0;
  double _totalInterest = 0;
  double _loanAmount = 0;

  @override
  void dispose() {
    _carPriceController.dispose();
    _downPaymentController.dispose();
    _interestRateController.dispose();
    _loanTermController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4285F4), // Google Blue
              Color(0xFF8E24AA), // Purple
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
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'คำนวณสินเชื่อรถยนต์',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'คำนวณยอดผ่อนรถยนต์',
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
                          // Car Icon and Title
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF34A853).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.directions_car,
                                  size: 24,
                                  color: Color(0xFF34A853),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'สินเชื่อรถยนต์',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  Text(
                                    'คำนวณการผ่อนซื้อรถยนต์',
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

                          // Car Price Input
                          _buildInputSection(
                            title: 'ราคารถยนต์',
                            controller: _carPriceController,
                            hintText: 'ระบุราคารถยนต์',
                            suffixText: 'บาท',
                            icon: Icons.directions_car,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกราคารถยนต์';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Down Payment Input
                          _buildInputSection(
                            title: 'เงินดาวน์',
                            controller: _downPaymentController,
                            hintText: 'ระบุจำนวนเงินดาวน์',
                            suffixText: 'บาท',
                            icon: Icons.payment,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกเงินดาวน์';
                              }
                              final downPayment =
                                  double.parse(value.replaceAll(',', ''));
                              final carPrice = double.tryParse(
                                    _carPriceController.text
                                        .replaceAll(',', ''),
                                  ) ??
                                  0;
                              if (downPayment >= carPrice) {
                                return 'เงินดาวน์ต้องน้อยกว่าราคารถ';
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
                            keyboardType: const TextInputType.numberWithOptions(
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
                                backgroundColor: const Color(0xFF34A853),
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
    );
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final carPrice =
          double.parse(_carPriceController.text.replaceAll(',', ''));
      final downPayment =
          double.parse(_downPaymentController.text.replaceAll(',', ''));
      final interestRate = double.parse(_interestRateController.text);
      final loanTermYears = int.parse(_loanTermController.text);

      setState(() {
        _loanAmount = carPrice - downPayment;

        final monthlyInterestRate = interestRate / 100 / 12;
        final numberOfPayments = loanTermYears * 12;

        _monthlyPayment = _loanAmount *
            (monthlyInterestRate *
                math.pow(1 + monthlyInterestRate, numberOfPayments)) /
            (math.pow(1 + monthlyInterestRate, numberOfPayments) - 1);

        _totalPayment = _monthlyPayment * numberOfPayments;
        _totalInterest = _totalPayment - _loanAmount;
      });
    }
  }

  Widget _buildInputSection({
    required String title,
    required TextEditingController controller,
    required String hintText,
    required String suffixText,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.grey.shade50,
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: Icon(icon, color: const Color(0xFF34A853)),
              suffixText: suffixText,
              suffixStyle: const TextStyle(
                color: Color(0xFF666666),
                fontWeight: FontWeight.w500,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
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
            const Color(0xFF34A853).withOpacity(0.1),
            const Color(0xFF4285F4).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF34A853).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF34A853),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calculate,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'ผลการคำนวณ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildResultItem(
            'ยอดกู้',
            '฿${NumberFormat('#,##0.00', 'en_US').format(_loanAmount)}',
            Icons.money,
            const Color(0xFF666666),
          ),
          const Divider(height: 24, color: Color(0xFFE0E0E0)),
          _buildResultItem(
            'ยอดผ่อนต่อเดือน',
            '฿${NumberFormat('#,##0.00', 'en_US').format(_monthlyPayment)}',
            Icons.payment,
            const Color(0xFF34A853),
            isHighlight: true,
          ),
          const Divider(height: 24, color: Color(0xFFE0E0E0)),
          _buildResultItem(
            'ยอดชำระรวมทั้งหมด',
            '฿${NumberFormat('#,##0.00', 'en_US').format(_totalPayment)}',
            Icons.account_balance_wallet,
            const Color(0xFF666666),
          ),
          const Divider(height: 24, color: Color(0xFFE0E0E0)),
          _buildResultItem(
            'ดอกเบี้ยรวม',
            '฿${NumberFormat('#,##0.00', 'en_US').format(_totalInterest)}',
            Icons.trending_up,
            const Color(0xFFEA4335),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(
    String label,
    String value,
    IconData icon,
    Color color, {
    bool isHighlight = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF666666),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: isHighlight ? 18 : 16,
                  fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
