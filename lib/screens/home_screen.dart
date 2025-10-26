import 'package:flutter/material.dart';
import '../domain/usecases/get_current_user_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/datasources/local_data_source.dart';
import 'house_loan_calculator.dart';
import 'car_loan_calculator.dart';
import 'personal_loan_calculator.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GetCurrentUserUseCase _getCurrentUserUseCase;
  late final LogoutUseCase _logoutUseCase;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    final dataSource = LocalDataSource();
    final repository = AuthRepositoryImpl(dataSource);
    _getCurrentUserUseCase = GetCurrentUserUseCase(repository);
    _logoutUseCase = LogoutUseCase(repository);
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final user = await _getCurrentUserUseCase.execute();
    if (user != null && mounted) {
      setState(() {
        _userName = user.name;
      });
    }
  }

  Future<void> _logout() async {
    await _logoutUseCase.execute();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Advisor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.person, size: 40),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'สวัสดี',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              _userName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'เครื่องมือคำนวณ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildCalculatorCard(
                context,
                title: 'คำนวณการผ่อนบ้าน',
                subtitle: 'คำนวณยอดผ่อนรายเดือนสำหรับสินเชื่อบ้าน',
                icon: Icons.home,
                color: Colors.blue,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HouseLoanCalculator(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildCalculatorCard(
                context,
                title: 'คำนวณการผ่อนรถ',
                subtitle: 'คำนวณยอดผ่อนรายเดือนสำหรับสินเชื่อรถยนต์',
                icon: Icons.directions_car,
                color: Colors.green,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CarLoanCalculator(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildCalculatorCard(
                context,
                title: 'คำนวณดอกเบี้ยส่วนบุคคล',
                subtitle: 'คำนวณดอกเบี้ยสำหรับสินเชื่อส่วนบุคคล',
                icon: Icons.account_balance_wallet,
                color: Colors.orange,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PersonalLoanCalculator(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalculatorCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
