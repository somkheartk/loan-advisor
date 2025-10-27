import 'package:flutter/material.dart';

/// คลาสเก็บค่าสีที่ใช้ในแอปพลิเคชัน
/// ใช้เพื่อให้สีต่างๆ เป็นมาตรฐานและง่ายต่อการจัดการ
class AppColors {
  // ป้องกันการสร้าง instance
  AppColors._();

  // สีหลักของแอป
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFFBBDEFB);

  // สีพื้นหลัง
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;

  // สีข้อความ
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);
  static const Color textOnPrimary = Colors.white;

  // สีสำหรับประเภทสินเชื่อ
  static const Color houseLoan = Color(0xFF4285F4); // น้ำเงิน - บ้าน
  static const Color carLoan = Color(0xFF34A853);   // เขียว - รถยนต์
  static const Color personalLoan = Color(0xFFEA4335); // แดง - บุคคล
  static const Color otherLoan = Color(0xFFFBBC04);  // เหลือง - อื่นๆ

  // สีสถานะ
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // สีเส้นขอบและตัวแบ่ง
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);

  // สีเงา
  static const Color shadow = Color(0x1A000000);
}
