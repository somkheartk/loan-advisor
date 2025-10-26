import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math';

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
  final _numberFormat = NumberFormat('#,##0.00', 'en_US');

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

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final carPrice = double.parse(_carPriceController.text.replaceAll(',', ''));
    final downPayment = double.parse(_downPaymentController.text.replaceAll(',', ''));
    final annualRate = double.parse(_interestRateController.text);
    final years = int.parse(_loanTermController.text);

    final loanAmount = carPrice - downPayment;
    final monthlyRate = annualRate / 100 / 12;
    final numberOfPayments = years * 12;

    // Calculate monthly payment using the formula
    final monthlyPayment = loanAmount *
        (monthlyRate * pow(1 + monthlyRate, numberOfPayments)) /
        (pow(1 + monthlyRate, numberOfPayments) - 1);

    final totalPayment = monthlyPayment * numberOfPayments;
    final totalInterest = totalPayment - loanAmount;

    setState(() {
      _loanAmount = loanAmount;
      _monthlyPayment = monthlyPayment;
      _totalPayment = totalPayment;
      _totalInterest = totalInterest;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('คำนวณการผ่อนรถ'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ข้อมูลสินเชื่อรถยนต์',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _carPriceController,
                          decoration: const InputDecoration(
                            labelText: 'ราคารถ (บาท)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.directions_car),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกราคารถ';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _downPaymentController,
                          decoration: const InputDecoration(
                            labelText: 'เงินดาวน์ (บาท)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกเงินดาวน์';
                            }
                            final downPayment = double.parse(value.replaceAll(',', ''));
                            final carPrice = double.tryParse(
                              _carPriceController.text.replaceAll(',', ''),
                            ) ?? 0;
                            if (downPayment >= carPrice) {
                              return 'เงินดาวน์ต้องน้อยกว่าราคารถ';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _interestRateController,
                          decoration: const InputDecoration(
                            labelText: 'อัตราดอกเบี้ยต่อปี (%)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.percent),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกอัตราดอกเบี้ย';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _loanTermController,
                          decoration: const InputDecoration(
                            labelText: 'ระยะเวลากู้ (ปี)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกระยะเวลากู้';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _calculate,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'คำนวณ',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_monthlyPayment > 0) ...[
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ผลการคำนวณ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(height: 24),
                          _buildResultRow(
                            'ยอดกู้',
                            '฿${_numberFormat.format(_loanAmount)}',
                            Colors.black87,
                          ),
                          const SizedBox(height: 12),
                          _buildResultRow(
                            'ยอดผ่อนต่อเดือน',
                            '฿${_numberFormat.format(_monthlyPayment)}',
                            Colors.green,
                            isBold: true,
                          ),
                          const SizedBox(height: 12),
                          _buildResultRow(
                            'ยอดชำระรวมทั้งหมด',
                            '฿${_numberFormat.format(_totalPayment)}',
                            Colors.black87,
                          ),
                          const SizedBox(height: 12),
                          _buildResultRow(
                            'ดอกเบี้ยรวม',
                            '฿${_numberFormat.format(_totalInterest)}',
                            Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color color, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 20 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }
}
