/// คลาสเก็บค่าคงที่ทั่วไปที่ใช้ในแอปพลิเคชัน
/// ใช้เพื่อจัดเก็บค่า configuration และค่าคงที่ที่ไม่เปลี่ยนแปลง
class AppConstants {
  // ป้องกันการสร้าง instance
  AppConstants._();

  // App Information
  static const String appVersion = '1.0.1';
  static const String appBuild = '2';

  // Validation Limits - ขีดจำกัดการตรวจสอบข้อมูล
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 100;

  // Loan Calculation Limits - ขีดจำกัดการคำนวณสินเชื่อ
  static const double minLoanAmount = 1000;
  static const double maxLoanAmount = 999999999;
  static const double minInterestRate = 0.01;
  static const double maxInterestRate = 99.99;
  static const int minLoanTermYears = 1;
  static const int maxLoanTermYears = 99;
  static const int minLoanTermMonths = 1;
  static const int maxLoanTermMonths = 1188; // 99 years * 12 months

  // Down Payment Limits - ขีดจำกัดเงินดาวน์
  static const double minDownPaymentPercent = 0;
  static const double maxDownPaymentPercent = 100;
  static const double minCarPrice = 10000;
  static const double maxCarPrice = 99999999;

  // Animation Durations - ระยะเวลาของ Animation (milliseconds)
  static const int animationDurationShort = 200;
  static const int animationDurationMedium = 300;
  static const int animationDurationLong = 500;

  // Date & Time Formats - รูปแบบวันที่และเวลา
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String timeFormat = 'HH:mm';

  // Number Formats - รูปแบบตัวเลข
  static const String currencyFormat = '#,##0.00';
  static const String numberFormat = '#,##0';
  static const String percentFormat = '0.00';

  // Currency - สกุลเงิน
  static const String currencySymbol = '฿';
  static const String currencyCode = 'THB';

  // SharedPreferences Keys - คีย์สำหรับเก็บข้อมูล
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserId = 'user_id';
  static const String keyUserName = 'user_name';
  static const String keyUserEmail = 'user_email';
  static const String keyUsers = 'users';

  // API Endpoints (สำหรับอนาคต)
  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = 'v1';

  // Error Messages
  static const String errorGeneral = 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง';
  static const String errorNetwork = 'ไม่สามารถเชื่อมต่อเครือข่ายได้';
  static const String errorTimeout = 'หมดเวลาการเชื่อมต่อ';

  // Calculation Constants - ค่าคงที่สำหรับการคำนวณ
  static const int monthsPerYear = 12;
  static const double percentToDivider = 100.0;
}
