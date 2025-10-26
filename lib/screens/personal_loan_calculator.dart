import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class PersonalLoanCalculator extends StatefulWidget {
  const PersonalLoanCalculator({super.key});

  @override
  State<PersonalLoanCalculator> createState() => _PersonalLoanCalculatorState();
}

class _PersonalLoanCalculatorState extends State<PersonalLoanCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _loanAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _loanTermController = TextEditingController();
  final _numberFormat = NumberFormat('#,##0.00', 'en_US');

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

    final loanAmount = double.parse(_loanAmountController.text.replaceAll(',', ''));
    final annualRate = double.parse(_interestRateController.text);
    final months = int.parse(_loanTermController.text);

    final monthlyRate = annualRate / 100 / 12;

    // Calculate monthly payment using the formula
    final monthlyPayment = loanAmount *
        (monthlyRate * pow(1 + monthlyRate, months)) /
        (pow(1 + monthlyRate, months) - 1);

    final totalPayment = monthlyPayment * months;
    final totalInterest = totalPayment - loanAmount;

    setState(() {
      _monthlyPayment = monthlyPayment;
      _totalPayment = totalPayment;
      _totalInterest = totalInterest;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('คำนวณดอกเบี้ยส่วนบุคคล'),
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
                          'ข้อมูลสินเชื่อส่วนบุคคล',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _loanAmountController,
                          decoration: const InputDecoration(
                            labelText: 'ยอดกู้ (บาท)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.monetization_on),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกยอดกู้';
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
                            labelText: 'ระยะเวลากู้ (เดือน)',
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
                    color: Colors.orange.shade50,
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
                            'ยอดผ่อนต่อเดือน',
                            '฿${_numberFormat.format(_monthlyPayment)}',
                            Colors.orange,
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
                          const SizedBox(height: 12),
                          _buildResultRow(
                            'อัตราดอกเบี้ยที่แท้จริง',
                            '${(_totalInterest / double.parse(_loanAmountController.text.replaceAll(',', '')) * 100).toStringAsFixed(2)}%',
                            Colors.red.shade700,
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
