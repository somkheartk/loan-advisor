import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../profile/profile_screen.dart';
import '../calculators/house_loan_calculator.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreenContent(),
    const HouseLoanCalculator(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF4285F4),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 20, // ทำให้ icon เล็กลง
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'หน้าหลัก',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate),
              label: 'คำนวณ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'โปรไฟล์',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'ตั้งค่า',
            ),
          ],
        ),
      ),
    );
  }
}

// Settings Screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                    const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'ตั้งค่า',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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
                        // App Settings Section
                        _buildSettingsSection(
                          context,
                          title: 'การตั้งค่าแอป',
                          icon: Icons.app_settings_alt,
                          children: [
                            _buildSettingsTile(
                              context,
                              icon: Icons.language,
                              title: 'ภาษา',
                              subtitle: 'ภาษาไทย',
                              onTap: () => _showLanguageDialog(context),
                            ),
                            _buildSettingsTile(
                              context,
                              icon: Icons.dark_mode,
                              title: 'โหมดมืด',
                              subtitle: 'ปิด',
                              onTap: () => _showThemeDialog(context),
                            ),
                            _buildSettingsTile(
                              context,
                              icon: Icons.notifications,
                              title: 'การแจ้งเตือน',
                              subtitle: 'เปิด',
                              onTap: () => _showNotificationDialog(context),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Calculator Settings Section
                        _buildSettingsSection(
                          context,
                          title: 'การตั้งค่าการคำนวณ',
                          icon: Icons.calculate,
                          children: [
                            _buildSettingsTile(
                              context,
                              icon: Icons.currency_exchange,
                              title: 'สกุลเงิน',
                              subtitle: 'บาท (THB)',
                              onTap: () => _showCurrencyDialog(context),
                            ),
                            _buildSettingsTile(
                              context,
                              icon: Icons.precision_manufacturing,
                              title: 'ทศนิยม',
                              subtitle: '2 ตำแหน่ง',
                              onTap: () => _showDecimalDialog(context),
                            ),
                            _buildSettingsTile(
                              context,
                              icon: Icons.bookmark,
                              title: 'บันทึกการคำนวณ',
                              subtitle: 'เปิด',
                              onTap: () => _showSaveCalculationDialog(context),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Support Section
                        _buildSettingsSection(
                          context,
                          title: 'การสนับสนุน',
                          icon: Icons.support,
                          children: [
                            _buildSettingsTile(
                              context,
                              icon: Icons.help_center,
                              title: 'ศูนย์ช่วยเหลือ',
                              subtitle: 'คำถามที่พบบ่อยและคำแนะนำ',
                              onTap: () => _showHelpCenter(context),
                            ),
                            _buildSettingsTile(
                              context,
                              icon: Icons.feedback,
                              title: 'ส่งความคิดเห็น',
                              subtitle: 'แจ้งปัญหาหรือข้อเสนอแนะ',
                              onTap: () => _showFeedbackDialog(context),
                            ),
                            _buildSettingsTile(
                              context,
                              icon: Icons.star_rate,
                              title: 'ให้คะแนนแอป',
                              subtitle: 'ให้คะแนนใน App Store',
                              onTap: () => _showRateAppDialog(context),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // About Section
                        _buildSettingsSection(
                          context,
                          title: 'เกี่ยวกับ',
                          icon: Icons.info,
                          children: [
                            _buildSettingsTile(
                              context,
                              icon: Icons.info_outline,
                              title: 'เวอร์ชันแอป',
                              subtitle: 'v1.0.0 (Build 1)',
                              onTap: null,
                            ),
                            _buildSettingsTile(
                              context,
                              icon: Icons.update,
                              title: 'ตรวจสอบอัปเดต',
                              subtitle: 'ตรวจสอบเวอร์ชันใหม่',
                              onTap: () => _showUpdateDialog(context),
                            ),
                            _buildSettingsTile(
                              context,
                              icon: Icons.privacy_tip,
                              title: 'นโยบายความเป็นส่วนตัว',
                              subtitle: 'อ่านนโยบายการใช้งาน',
                              onTap: () => _showPrivacyPolicy(context),
                            ),
                            _buildSettingsTile(
                              context,
                              icon: Icons.gavel,
                              title: 'เงื่อนไขการใช้งาน',
                              subtitle: 'ข้อกำหนดและเงื่อนไข',
                              onTap: () => _showTermsOfService(context),
                            ),
                          ],
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
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, {
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

  Widget _buildSettingsTile(
    BuildContext context, {
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

  // Dialog methods
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('เลือกภาษา'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('ภาษาไทย'),
              value: 'th',
              groupValue: 'th',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: 'th',
              onChanged: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ฟีเจอร์นี้จะพัฒนาในอนาคต')),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('เลือกธีม'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('โหมดสว่าง'),
              value: 'light',
              groupValue: 'light',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: const Text('โหมดมืด'),
              value: 'dark',
              groupValue: 'light',
              onChanged: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ฟีเจอร์นี้จะพัฒนาในอนาคต')),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('การแจ้งเตือน'),
        content: const Text('การตั้งค่าการแจ้งเตือนจะพัฒนาในอนาคต'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('เลือกสกุลเงิน'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('บาท (THB)'),
              value: 'THB',
              groupValue: 'THB',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: const Text('ดอลลาร์ (USD)'),
              value: 'USD',
              groupValue: 'THB',
              onChanged: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ฟีเจอร์นี้จะพัฒนาในอนาคต')),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDecimalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('จำนวนทศนิยม'),
        content: const Text('การตั้งค่าจำนวนทศนิยมจะพัฒนาในอนาคต'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  void _showSaveCalculationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('บันทึกการคำนวณ'),
        content: const Text('ฟีเจอร์การบันทึกประวัติการคำนวณจะพัฒนาในอนาคต'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  void _showHelpCenter(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ศูนย์ช่วยเหลือ'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'คำถามที่พบบ่อย:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Q: วิธีคำนวณสินเชื่อบ้าน?'),
              Text(
                  'A: เลือกเมนูสินเชื่อบ้าน กรอกราคาบ้าน เงินดาวน์ อัตราดอกเบี้ย และระยะเวลา'),
              SizedBox(height: 8),
              Text('Q: ผลการคำนวณแม่นยำแค่ไหน?'),
              Text(
                  'A: ผลการคำนวณเป็นการประมาณการเบื้องต้น ควรสอบถามธนาคารสำหรับข้อมูลที่แม่นยำ'),
              SizedBox(height: 8),
              Text('Q: สามารถบันทึกผลการคำนวณได้หรือไม่?'),
              Text('A: ฟีเจอร์นี้จะพัฒนาในเวอร์ชันถัดไป'),
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

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ส่งความคิดเห็น'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'กรุณาแชร์ความคิดเห็นของคุณ...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ขอบคุณสำหรับความคิดเห็น!')),
              );
              Navigator.pop(context);
            },
            child: const Text('ส่ง'),
          ),
        ],
      ),
    );
  }

  void _showRateAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ให้คะแนนแอป'),
        content: const Text(
            'หากคุณชอบแอปนี้ กรุณาให้คะแนนใน App Store เพื่อสนับสนุนเรา'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ไว้ครั้งหน้า'),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ขอบคุณสำหรับการสนับสนุน!')),
              );
              Navigator.pop(context);
            },
            child: const Text('ให้คะแนน'),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ตรวจสอบอัปเดต'),
        content: const Text('คุณใช้เวอร์ชันล่าสุดแล้ว!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('นโยบายความเป็นส่วนตัว'),
        content: const SingleChildScrollView(
          child: Text(
            'Loan Advisor เคารพความเป็นส่วนตัวของผู้ใช้ ข้อมูลทั้งหมดจะถูกเก็บไว้ในเครื่องเท่านั้น ไม่มีการส่งข้อมูลออกไปยังเซิร์ฟเวอร์ภายนอก\n\n'
            'ข้อมูลที่เก็บ:\n'
            '- ข้อมูลการเข้าสู่ระบบ\n'
            '- การตั้งค่าแอป\n'
            '- ประวัติการคำนวณ (หากเปิดใช้งาน)\n\n'
            'เราไม่เก็บข้อมูลการเงินจริงของคุณ',
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

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('เงื่อนไขการใช้งาน'),
        content: const SingleChildScrollView(
          child: Text(
            'การใช้งาน Loan Advisor:\n\n'
            '1. แอปนี้ให้บริการคำนวณสินเชื่อเพื่อการประมาณการเท่านั้น\n'
            '2. ผลการคำนวณไม่ใช่คำแนะนำทางการเงิน\n'
            '3. ควรปรึกษาที่ปรึกษาทางการเงินก่อนตัดสินใจ\n'
            '4. ผู้พัฒนาไม่รับผิดชอบต่อความเสียหายจากการใช้งาน\n'
            '5. การใช้งานแอปถือว่ายอมรับเงื่อนไขนี้\n\n'
            'อัปเดตล่าสุด: ตุลาคม 2025',
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
