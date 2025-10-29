import 'package:flutter/material.dart';
import '../domain/usecases/get_current_user_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/datasources/local_data_source.dart';
import 'calculators/house_loan_calculator.dart';
import 'calculators/car_loan_calculator.dart';
import 'calculators/personal_loan_calculator.dart';
import 'calculators/other_loan_calculator.dart';
import 'profile/profile_screen.dart';
import 'auth/login_screen.dart';

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
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'คำนวณเงินกู้',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'คำนวณเงินกู้ง่ายๆ ในมือถือ',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Greeting
                        const Text(
                          'ประเภทสินเชื่อ',
                          style: TextStyle(
                            fontSize: 18,
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
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 2.5,
                          children: [
                            _buildCalculatorGridCard(
                              title: 'บ้าน',
                              icon: Icons.home,
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
                              icon: Icons.directions_car,
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
                              icon: Icons.person,
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
                              icon: Icons.more_horiz,
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

                        const SizedBox(height: 20),

                        // Quick Info Section (สั้นๆ แทนของเยอะ)
                        _buildQuickInfoSection(),

                        const SizedBox(
                            height: 40), // Bottom padding for navigation
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
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 16,
                color: color,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFF4285F4),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _userName.isNotEmpty
                      ? 'สวัสดี $_userName'
                      : 'สวัสดีผู้ใช้งาน',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
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
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickStat('อัตราดอกเบี้ย', '3.5%'),
              _buildQuickStat('จำนวนสูงสุด', '5M'),
              _buildQuickStat('ระยะเวลา', '30 ปี'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4285F4),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
