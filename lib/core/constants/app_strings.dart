/// คลาสเก็บข้อความที่ใช้ในแอปพลิเคชัน
/// ใช้เพื่อให้ข้อความเป็นมาตรฐานและง่ายต่อการจัดการ / แปลภาษา
class AppStrings {
  // ป้องกันการสร้าง instance
  AppStrings._();

  // ชื่อแอป
  static const String appName = 'Loan Advisor';
  static const String appTitle = 'คำนวณสินเชื่อ';

  // Authentication - การเข้าสู่ระบบ
  static const String login = 'เข้าสู่ระบบ';
  static const String register = 'สมัครสมาชิก';
  static const String logout = 'ออกจากระบบ';
  static const String email = 'อีเมล';
  static const String password = 'รหัสผ่าน';
  static const String confirmPassword = 'ยืนยันรหัสผ่าน';
  static const String name = 'ชื่อ-นามสกุล';
  static const String forgotPassword = 'ลืมรหัสผ่าน?';
  static const String dontHaveAccount = 'ยังไม่มีบัญชี?';
  static const String alreadyHaveAccount = 'มีบัญชีอยู่แล้ว?';

  // Loan Types - ประเภทสินเชื่อ
  static const String loanTypes = 'ประเภทสินเชื่อ';
  static const String houseLoan = 'บ้าน';
  static const String carLoan = 'รถยนต์';
  static const String personalLoan = 'บุคคล';
  static const String otherLoan = 'อื่นๆ';

  // Calculator - เครื่องคำนวณ
  static const String calculate = 'คำนวณ';
  static const String reset = 'รีเซ็ต';
  static const String loanAmount = 'จำนวนเงินกู้';
  static const String interestRate = 'อัตราดอกเบี้ย';
  static const String loanTerm = 'ระยะเวลากู้';
  static const String downPayment = 'เงินดาวน์';
  static const String carPrice = 'ราคารถ';
  static const String downPaymentPercent = 'เปอร์เซ็นต์เงินดาวน์';

  // Results - ผลลัพธ์
  static const String results = 'ผลการคำนวณ';
  static const String monthlyPayment = 'ค่าผ่อนต่อเดือน';
  static const String totalPayment = 'ยอดชำระรวม';
  static const String totalInterest = 'ดอกเบี้ยรวม';
  static const String totalLoan = 'ยอดกู้รวม';

  // Units - หน่วย
  static const String baht = 'บาท';
  static const String years = 'ปี';
  static const String months = 'เดือน';
  static const String percent = '%';
  static const String perYear = '% ต่อปี';

  // Actions - การกระทำ
  static const String save = 'บันทึก';
  static const String cancel = 'ยกเลิก';
  static const String edit = 'แก้ไข';
  static const String delete = 'ลบ';
  static const String confirm = 'ยืนยัน';
  static const String back = 'กลับ';

  // Profile - โปรไฟล์
  static const String profile = 'โปรไฟล์';
  static const String editProfile = 'แก้ไขโปรไฟล์';
  static const String settings = 'ตั้งค่า';
  static const String about = 'เกี่ยวกับ';

  // Messages - ข้อความ
  static const String welcome = 'ยินดีต้อนรับ';
  static const String greeting = 'สวัสดี';
  static const String loading = 'กำลังโหลด...';
  static const String noData = 'ไม่มีข้อมูล';
  static const String error = 'เกิดข้อผิดพลาด';
  static const String success = 'สำเร็จ';

  // Error Messages - ข้อความแสดงข้อผิดพลาด
  static const String errorInvalidEmail = 'อีเมลไม่ถูกต้อง';
  static const String errorPasswordTooShort = 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
  static const String errorPasswordNotMatch = 'รหัสผ่านไม่ตรงกัน';
  static const String errorFieldRequired = 'กรุณากรอกข้อมูล';
  static const String errorInvalidNumber = 'กรุณากรอกตัวเลขที่ถูกต้อง';
  static const String errorLoginFailed = 'เข้าสู่ระบบไม่สำเร็จ';
  static const String errorRegisterFailed = 'สมัครสมาชิกไม่สำเร็จ';

  // Validation Messages
  static const String validationEmailRequired = 'กรุณากรอกอีเมล';
  static const String validationPasswordRequired = 'กรุณากรอกรหัสผ่าน';
  static const String validationNameRequired = 'กรุณากรอกชื่อ';
  static const String validationLoanAmountRequired = 'กรุณากรอกจำนวนเงินกู้';
  static const String validationInterestRateRequired = 'กรุณากรอกอัตราดอกเบี้ย';
  static const String validationLoanTermRequired = 'กรุณากรอกระยะเวลากู้';

  // Hints - คำแนะนำ
  static const String hintEmail = 'example@email.com';
  static const String hintPassword = 'อย่างน้อย 6 ตัวอักษร';
  static const String hintName = 'กรอกชื่อ-นามสกุล';
  static const String hintLoanAmount = 'เช่น 1000000';
  static const String hintInterestRate = 'เช่น 3.5';
  static const String hintLoanTerm = 'เช่น 20';
}
