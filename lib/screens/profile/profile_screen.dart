import 'package:flutter/material.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/local_data_source.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final GetCurrentUserUseCase _getCurrentUserUseCase;
  late final LogoutUseCase _logoutUseCase;
  String _userName = '';
  String _userEmail = '';

  // Hardcode version info from pubspec.yaml
  final String _appVersion = '1.0.1';
  final String _buildNumber = '2';

  @override
  void initState() {
    super.initState();
    final dataSource = LocalDataSource();
    final repository = AuthRepositoryImpl(dataSource);
    _getCurrentUserUseCase = GetCurrentUserUseCase(repository);
    _logoutUseCase = LogoutUseCase(repository);
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

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ออกจากระบบ'),
        content: const Text('คุณต้องการออกจากระบบหรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('ออกจากระบบ'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await _logoutUseCase.execute();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ถ้ากด back ให้กลับไปหน้าที่มาก่อนหน้า หรือหน้า home
        if (Navigator.of(context).canPop()) {
          Navigator.pop(context);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        }
        return false;
      },
      child: Scaffold(
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
                      // Back button
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).canPop()
                              ? Navigator.pop(context)
                              : Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/', (route) => false);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'โปรไฟล์',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: _logout,
                        tooltip: 'ออกจากระบบ',
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
                      child: Column(
                        children: [
                          // Profile Avatar Section
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFF4285F4).withOpacity(0.1),
                                  const Color(0xFF8E24AA).withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF4285F4).withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF4285F4),
                                        Color(0xFF8E24AA)
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _userName.isNotEmpty ? _userName : 'ผู้ใช้',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _userEmail.isNotEmpty
                                      ? _userEmail
                                      : 'user@example.com',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Personal Information Section
                          _buildInfoSection(
                            title: 'ข้อมูลส่วนตัว',
                            icon: Icons.person_outline,
                            children: [
                              _buildInfoTile(
                                icon: Icons.badge,
                                title: 'ชื่อ-นามสกุล',
                                subtitle: _userName.isNotEmpty
                                    ? _userName
                                    : 'ไม่ระบุ',
                                onTap: () => _showEditDialog('name'),
                              ),
                              _buildInfoTile(
                                icon: Icons.email_outlined,
                                title: 'อีเมล',
                                subtitle: _userEmail.isNotEmpty
                                    ? _userEmail
                                    : 'ไม่ระบุ',
                                onTap: () => _showEditDialog('email'),
                              ),
                              _buildInfoTile(
                                icon: Icons.phone_outlined,
                                title: 'เบอร์โทรศัพท์',
                                subtitle: 'ยังไม่ได้ระบุ',
                                onTap: () => _showEditDialog('phone'),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // App Information Section
                          _buildInfoSection(
                            title: 'เกี่ยวกับแอป',
                            icon: Icons.info_outline,
                            children: [
                              _buildInfoTile(
                                icon: Icons.apps,
                                title: 'เวอร์ชันแอป',
                                subtitle: _appVersion.isNotEmpty
                                    ? '$_appVersion (Build $_buildNumber)'
                                    : 'กำลังโหลด...',
                                onTap: null,
                              ),
                              _buildInfoTile(
                                icon: Icons.description_outlined,
                                title: 'เกี่ยวกับ Loan Advisor',
                                subtitle: 'ข้อมูลเพิ่มเติมเกี่ยวกับแอป',
                                onTap: _showAboutDialog,
                              ),
                              _buildInfoTile(
                                icon: Icons.help_outline,
                                title: 'วิธีใช้งาน',
                                subtitle: 'คำแนะนำการใช้งานแอป',
                                onTap: _showHelpDialog,
                              ),
                              _buildInfoTile(
                                icon: Icons.privacy_tip_outlined,
                                title: 'นโยบายความเป็นส่วนตัว',
                                subtitle: 'อ่านนโยบายความเป็นส่วนตัว',
                                onTap: _showPrivacyDialog,
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Logout Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _logout,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEA4335),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.logout, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'ออกจากระบบ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 100), // Bottom padding for navigation
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ), // ปิด Scaffold
    ); // ปิด WillPopScope
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
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
                  color: const Color(0xFF4285F4).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: const Color(0xFF4285F4),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: const Color(0xFF666666),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
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
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Color(0xFF999999),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(String type) {
    String title;
    String currentValue;

    switch (type) {
      case 'name':
        title = 'แก้ไขชื่อ-นามสกุล';
        currentValue = _userName;
        break;
      case 'email':
        title = 'แก้ไขอีเมล';
        currentValue = _userEmail;
        break;
      case 'phone':
        title = 'เพิ่มเบอร์โทรศัพท์';
        currentValue = '';
        break;
      default:
        return;
    }

    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'กรุณากรอก$title',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement update functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ฟังก์ชันนี้จะพัฒนาในอนาคต'),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.calculate,
              color: Color(0xFF4285F4),
              size: 28,
            ),
            SizedBox(width: 8),
            Text('Loan Advisor'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Loan Advisor เป็นแอปพลิเคชันที่ช่วยให้คุณคำนวณสินเชื่อประเภทต่างๆ อย่างง่ายดาย',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'ฟีเจอร์หลัก:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text('• คำนวณสินเชื่อบ้าน'),
              const Text('• คำนวณสินเชื่อรถยนต์'),
              const Text('• คำนวณสินเชื่อส่วนบุคคล'),
              const Text('• คำนวณสินเชื่อประเภทอื่นๆ'),
              const SizedBox(height: 16),
              const Text(
                'ช่วยให้คุณวางแผนการเงินและเตรียมตัวก่อนทำสินเชื่อจริง',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ข้อมูลแอปพลิเคชัน:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'เวอร์ชัน: ${_appVersion.isNotEmpty ? _appVersion : "กำลังโหลด..."}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Build: ${_buildNumber.isNotEmpty ? _buildNumber : "กำลังโหลด..."}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const Text(
                      'พัฒนาโดย: Flutter Development Team',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('วิธีใช้งาน'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'วิธีใช้งาน Loan Advisor:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text('1. เลือกประเภทสินเชื่อที่ต้องการคำนวณ'),
              Text(
                  '2. กรอกข้อมูลที่จำเป็น เช่น จำนวนเงิน อัตราดอกเบี้ย ระยะเวลา'),
              Text('3. กดปุ่ม "คำนวณ" เพื่อดูผลลัพธ์'),
              Text('4. ผลลัพธ์จะแสดงยอดผ่อนรายเดือนและข้อมูลที่เกี่ยวข้อง'),
              SizedBox(height: 12),
              Text(
                'เคล็ดลับ:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('• ตรวจสอบอัตราดอกเบี้ยจากธนาคารก่อนคำนวณ'),
              Text('• พิจารณาค่าใช้จ่ายอื่นๆ ที่เกี่ยวข้อง'),
              Text('• เปรียบเทียบผลการคำนวณจากหลายแหล่ง'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('เข้าใจแล้ว'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('นโยบายความเป็นส่วนตัว'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Loan Advisor ให้ความสำคัญกับความเป็นส่วนตัวของผู้ใช้',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text('การเก็บข้อมูล:'),
              Text('• ข้อมูลการเข้าสู่ระบบ (อีเมล, รหัสผ่าน)'),
              Text('• ข้อมูลการคำนวณ (เฉพาะในเครื่อง)'),
              SizedBox(height: 8),
              Text('การใช้ข้อมูล:'),
              Text('• เพื่อการเข้าสู่ระบบและใช้งานแอป'),
              Text('• เพื่อการคำนวณสินเชื่อ'),
              SizedBox(height: 8),
              Text('การรักษาความปลอดภัย:'),
              Text('• ข้อมูลเก็บไว้ในเครื่องเท่านั้น'),
              Text('• ไม่มีการส่งข้อมูลออกนอกเครื่อง'),
              Text('• ไม่มีการเก็บข้อมูลการเงินจริง'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('รับทราบ'),
          ),
        ],
      ),
    );
  }
}
