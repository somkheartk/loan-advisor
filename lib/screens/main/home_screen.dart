import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/local_data_source.dart';
import '../calculators/house_loan_calculator.dart';
import '../calculators/car_loan_calculator.dart';
import '../calculators/personal_loan_calculator.dart';
import '../calculators/other_loan_calculator.dart';
import '../profile/profile_screen.dart';
import '../../widgets/app_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const HomeScreenContent();
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  late final GetCurrentUserUseCase _getCurrentUserUseCase;
  String _userName = '';

  // Controllers for input fields
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _interestRateController = TextEditingController();
  final TextEditingController _loanTermController = TextEditingController();

  // Calculation results
  double _monthlyPayment = 0.0;
  double _totalPayment = 0.0;
  double _totalInterest = 0.0;
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    final dataSource = LocalDataSource();
    final repository = AuthRepositoryImpl(dataSource);
    _getCurrentUserUseCase = GetCurrentUserUseCase(repository);
    _loadUserName();
  }

  @override
  void dispose() {
    _loanAmountController.dispose();
    _interestRateController.dispose();
    _loanTermController.dispose();
    super.dispose();
  }

  Future<void> _loadUserName() async {
    final user = await _getCurrentUserUseCase.execute();
    if (user != null && mounted) {
      setState(() {
        _userName = user.name;
      });
    }
  }

  void _calculateLoan() {
    // ตรวจสอบว่าทุกช่องมีข้อมูล
    if (_loanAmountController.text.trim().isEmpty ||
        _interestRateController.text.trim().isEmpty ||
        _loanTermController.text.trim().isEmpty) {
      setState(() {
        _showResults = false;
      });
      return;
    }

    final double principal =
        double.tryParse(_loanAmountController.text.replaceAll(',', '')) ?? 0;
    final double annualRate =
        double.tryParse(_interestRateController.text) ?? 0;
    final int years = int.tryParse(_loanTermController.text) ?? 0;

    // ตรวจสอบค่าที่เป็นไปได้
    if (principal <= 0 ||
        principal >
            999999999 || // จำนวนเงินต้องมากกว่า 0 และไม่เกิน 999,999,999
        annualRate < 0 ||
        annualRate > 99.99 || // อัตราดอกเบี้ยต้องอยู่ระหว่าง 0-99.99%
        years <= 0 ||
        years > 99) {
      // ระยะเวลาต้องอยู่ระหว่าง 1-99 ปี
      setState(() {
        _showResults = false;
      });
      return;
    }

    final double monthlyRate = annualRate / 100 / 12;
    final int totalPayments = years * 12;

    if (monthlyRate == 0) {
      // กรณีไม่มีดอกเบี้ย
      _monthlyPayment = principal / totalPayments;
    } else {
      // สูตรการคำนวณการผ่อนชำระ
      _monthlyPayment = principal *
          (monthlyRate * math.pow(1 + monthlyRate, totalPayments)) /
          (math.pow(1 + monthlyRate, totalPayments) - 1);
    }

    _totalPayment = _monthlyPayment * totalPayments;
    _totalInterest = _totalPayment - principal;

    setState(() {
      _showResults = true;
    });
  }

  void _clearFields() {
    setState(() {
      _loanAmountController.clear();
      _interestRateController.clear();
      _loanTermController.clear();
      _showResults = false;
    });
  }

  String _formatCurrency(double amount) {
    return '฿${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        )}';
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
              // Header with user info and profile icon
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        AppIcon(
                          size: 32,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          iconColor: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Loan Advisor',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'คำนวณเงินกู้ง่ายๆ ในมือถือ',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const ProfileScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Main Content with ScrollView
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Greeting
                        const Text(
                          'ประเภทสินเชื่อ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Calculator Cards Grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.2,
                          children: [
                            _buildCalculatorGridCard(
                              title: 'บ้าน',
                              loanType: LoanType.house,
                              color: const Color(0xFF4285F4),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const HouseLoanCalculator(),
                                  ),
                                );
                              },
                            ),
                            _buildCalculatorGridCard(
                              title: 'รถยนต์',
                              loanType: LoanType.car,
                              color: const Color(0xFF34A853),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CarLoanCalculator(),
                                  ),
                                );
                              },
                            ),
                            _buildCalculatorGridCard(
                              title: 'บุคคล',
                              loanType: LoanType.personal,
                              color: const Color(0xFFEA4335),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PersonalLoanCalculator(),
                                  ),
                                );
                              },
                            ),
                            _buildCalculatorGridCard(
                              title: 'อื่นๆ',
                              loanType: LoanType.other,
                              color: const Color(0xFFFBBC04),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const OtherLoanCalculator(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // User info section
                        _buildUserInfoSection(),

                        const SizedBox(height: 16),

                        // Loan amount input
                        _buildLoanAmountSection(),

                        const SizedBox(height: 20),

                        // Calculate button
                        _buildCalculateButton(),

                        const SizedBox(
                            height: 80), // Bottom padding for navigation
                      ],
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

  Widget _buildCalculatorGridCard({
    required String title,
    required LoanType loanType,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoanTypeIcon(
              type: loanType,
              size: 48,
              color: color,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF4285F4),
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName.isNotEmpty ? _userName : 'ผู้ใช้งาน',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const Text(
                  'สมาชิกทั่วไป',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoanAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'จำนวนเงินกู้',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _loanAmountController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          decoration: InputDecoration(
            labelText: 'จำนวนเงินกู้ (บาท)',
            hintText: 'กรุณากรอกจำนวนเงินกู้',
            suffixText: 'บาท',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF4285F4)),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _interestRateController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}(\.\d{0,2})?$')),
          ],
          decoration: InputDecoration(
            labelText: 'อัตราดอกเบี้ย (%)',
            hintText: 'กรุณากรอกอัตราดอกเบี้ย (เช่น 3.5)',
            suffixText: '%',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF4285F4)),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _loanTermController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
          decoration: InputDecoration(
            labelText: 'ระยะเวลาผ่อน (ปี)',
            hintText: 'กรุณากรอกระยะเวลาผ่อน (เช่น 30)',
            suffixText: 'ปี',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF4285F4)),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),

        // Results section
        if (_showResults) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF4285F4).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: const Color(0xFF4285F4).withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ผลการคำนวณ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                _buildResultRow(
                    'ยอดผ่อนต่อเดือน', _formatCurrency(_monthlyPayment)),
                const SizedBox(height: 6),
                _buildResultRow(
                    'ยอดรวมที่ต้องจ่าย', _formatCurrency(_totalPayment)),
                const SizedBox(height: 6),
                _buildResultRow('ดอกเบี้ยรวม', _formatCurrency(_totalInterest)),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  Widget _buildCalculateButton() {
    return Column(
      children: [
        // Calculate Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _calculateLoan,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4285F4),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'คำนวณ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        // Clear Button - Show only when results are visible
        if (_showResults) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _clearFields,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red.shade700,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.red.shade200),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.clear, size: 16, color: Colors.red.shade700),
                  const SizedBox(width: 6),
                  const Text(
                    'เคลียร์ข้อมูล',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
