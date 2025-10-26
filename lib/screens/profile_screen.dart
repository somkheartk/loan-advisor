import 'package:flutter/material.dart';
import '../domain/usecases/get_current_user_usecase.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/datasources/local_data_source.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final GetCurrentUserUseCase _getCurrentUserUseCase;
  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    final dataSource = LocalDataSource();
    final repository = AuthRepositoryImpl(dataSource);
    _getCurrentUserUseCase = GetCurrentUserUseCase(repository);
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final user = await _getCurrentUserUseCase.execute();
    if (user != null && mounted) {
      setState(() {
        _userName = user.name;
        _userEmail = user.email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const CircleAvatar(
                radius: 60,
                child: Icon(Icons.person, size: 60),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ข้อมูลส่วนตัว',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 24),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('ชื่อ'),
                        subtitle: Text(_userName),
                      ),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('อีเมล'),
                        subtitle: Text(_userEmail),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'เกี่ยวกับแอป',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 24),
                      const ListTile(
                        leading: Icon(Icons.info),
                        title: Text('เวอร์ชัน'),
                        subtitle: Text('1.0.0'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.description),
                        title: const Text('คำอธิบาย'),
                        subtitle: const Text(
                          'แอปพลิเคชันช่วยคำนวณการผ่อนบ้าน รถ และดอกเบี้ยส่วนบุคคล',
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('เกี่ยวกับ Loan Advisor'),
                              content: const Text(
                                'Loan Advisor เป็นแอปพลิเคชันที่ช่วยให้คุณคำนวณ:\n\n'
                                '• ยอดผ่อนบ้านรายเดือน\n'
                                '• ยอดผ่อนรถรายเดือน\n'
                                '• ดอกเบี้ยสินเชื่อส่วนบุคคล\n\n'
                                'ช่วยให้คุณวางแผนการเงินได้ง่ายขึ้น',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('ปิด'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
