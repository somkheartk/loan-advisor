import 'package:flutter/material.dart';

/// # AppIcon Widget
///
/// ไอคอนหลักของแอปพลิเคชัน Loan Advisor
///
/// แสดงเป็นเครื่องคิดเลข (calculator) พร้อมสัญลักษณ์เงินบาท (฿)
/// ใช้เป็นโลโก้หรือไอคอนของแอปในส่วนต่างๆ
///
/// ## ตัวอย่างการใช้งาน:
/// ```dart
/// // ขนาดมาตรฐาน
/// AppIcon()
///
/// // ขนาดใหญ่พร้อมสีกำหนดเอง
/// AppIcon(
///   size: 64,
///   backgroundColor: Colors.blue,
///   iconColor: Colors.white,
/// )
/// ```
class AppIcon extends StatelessWidget {
  /// ขนาดของไอคอน (กว้าง x สูง)
  final double size;

  /// สีพื้นหลังของไอคอน (default: Theme.primaryColor)
  final Color? backgroundColor;

  /// สีของไอคอนเครื่องคิดเลข (default: Colors.white)
  final Color? iconColor;

  const AppIcon({
    Key? key,
    this.size = 24,
    this.backgroundColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(size * 0.15), // มุมมน 15% ของขนาด
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: size * 0.1,
            offset: Offset(0, size * 0.05),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ไอคอนเครื่องคิดเลขตรงกลาง
          Icon(
            Icons.calculate,
            size: size * 0.6, // 60% ของขนาดทั้งหมด
            color: iconColor ?? Colors.white,
          ),
          // วงกลมแสดงสัญลักษณ์บาทด้านบนขวา
          Positioned(
            top: size * 0.15,
            right: size * 0.15,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                color: Colors.amber, // สีเหลืองทอง
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: size * 0.02,
                ),
              ),
              child: Center(
                child: Text(
                  '฿', // สัญลักษณ์เงินบาท
                  style: TextStyle(
                    fontSize: size * 0.15,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// # LoanTypeIcon Widget
///
/// ไอคอนแสดงประเภทของสินเชื่อ
///
/// แต่ละประเภทมีไอคอนและสีที่แตกต่างกัน:
/// - house (บ้าน): ไอคอนบ้าน, สีส้ม
/// - car (รถ): ไอคอนรถ, สีน้ำเงิน
/// - personal (ส่วนบุคคล): ไอคอนคน, สีเขียว
/// - other (อื่นๆ): ไอคอนธนาคาร, สีม่วง
///
/// ## ตัวอย่างการใช้งาน:
/// ```dart
/// // ไอคอนสินเชื่อบ้าน
/// LoanTypeIcon(type: LoanType.house)
///
/// // ไอคอนสินเชื่อรถขนาดใหญ่
/// LoanTypeIcon(
///   type: LoanType.car,
///   size: 48,
/// )
///
/// // กำหนดสีเอง
/// LoanTypeIcon(
///   type: LoanType.personal,
///   color: Colors.purple,
/// )
/// ```
class LoanTypeIcon extends StatelessWidget {
  /// ประเภทของสินเชื่อ (house, car, personal, other)
  final LoanType type;

  /// ขนาดของไอคอน (default: 24)
  final double size;

  /// สีของไอคอน (default: ตามประเภทสินเชื่อ)
  final Color? color;

  const LoanTypeIcon({
    Key? key,
    required this.type,
    this.size = 24,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor = color ?? Theme.of(context).primaryColor;

    // เลือกไอคอนและสีตามประเภทสินเชื่อ
    switch (type) {
      case LoanType.house:
        iconData = Icons.home;
        iconColor = color ?? Colors.orange; // สีส้มสำหรับสินเชื่อบ้าน
        break;
      case LoanType.car:
        iconData = Icons.directions_car;
        iconColor = color ?? Colors.blue; // สีน้ำเงินสำหรับสินเชื่อรถ
        break;
      case LoanType.personal:
        iconData = Icons.person;
        iconColor = color ?? Colors.green; // สีเขียวสำหรับสินเชื่อส่วนบุคคล
        break;
      case LoanType.other:
        iconData = Icons.account_balance;
        iconColor = color ?? Colors.purple; // สีม่วงสำหรับสินเชื่ออื่นๆ
        break;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1), // พื้นหลังสีอ่อน 10%
        borderRadius: BorderRadius.circular(size * 0.2), // มุมมน 20%
      ),
      child: Icon(
        iconData,
        size: size * 0.6, // ไอคอน 60% ของขนาด
        color: iconColor,
      ),
    );
  }
}

/// # LoanType Enum
///
/// ประเภทของสินเชื่อที่รองรับในแอป
///
/// - `house`: สินเชื่อบ้าน (Home Loan)
/// - `car`: สินเชื่อรถยนต์ (Car Loan)
/// - `personal`: สินเชื่อส่วนบุคคล (Personal Loan)
/// - `other`: สินเชื่อประเภทอื่นๆ (Other Loans)
enum LoanType {
  house,      // สินเชื่อบ้าน
  car,        // สินเชื่อรถยนต์
  personal,   // สินเชื่อส่วนบุคคล
  other,      // สินเชื่ออื่นๆ
}

/// # CalculatorIcon Widget
///
/// ไอคอนเครื่องคิดเลขที่มีรายละเอียด
///
/// แสดงเป็นเครื่องคิดเลขที่มี:
/// - หน้าจอแสดงผลสีดำ แสดงตัวเลข "฿15,000"
/// - ปุ่มกด 16 ปุ่ม (4x4 grid)
/// - ปุ่มตัวเลขสีเทา, ปุ่มฟังก์ชันสีส้ม, ปุ่มเท่ากับสีเขียว
///
/// ## ตัวอย่างการใช้งาน:
/// ```dart
/// // ขนาดมาตรฐาน
/// CalculatorIcon()
///
/// // ขนาดใหญ่
/// CalculatorIcon(size: 100)
///
/// // กำหนดสีพื้นหลัง
/// CalculatorIcon(
///   size: 80,
///   backgroundColor: Colors.white,
/// )
/// ```
class CalculatorIcon extends StatelessWidget {
  /// ขนาดของไอคอนเครื่องคิดเลข (default: 24)
  final double size;

  /// สีพื้นหลังของเครื่องคิดเลข (default: Colors.grey[100])
  final Color? backgroundColor;

  const CalculatorIcon({
    Key? key,
    this.size = 24,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[100],
        borderRadius: BorderRadius.circular(size * 0.1), // มุมมน 10%
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // หน้าจอแสดงผลด้านบน
          Container(
            width: size * 0.8,
            height: size * 0.2,
            margin: EdgeInsets.only(top: size * 0.1),
            decoration: BoxDecoration(
              color: Colors.black87, // หน้าจอสีดำ
              borderRadius: BorderRadius.circular(size * 0.05),
            ),
            child: Center(
              child: Text(
                '฿15,000', // แสดงตัวเลขตัวอย่าง
                style: TextStyle(
                  fontSize: size * 0.08,
                  color: Colors.green, // ตัวเลขสีเขียว
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // ปุ่มกด 4x4 grid
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(size * 0.1),
              child: GridView.count(
                crossAxisCount: 4, // 4 คอลัมน์
                mainAxisSpacing: size * 0.02,
                crossAxisSpacing: size * 0.02,
                children: List.generate(16, (index) {
                  Color buttonColor = Colors.grey[200]!; // ปุ่มตัวเลขสีเทา
                  if (index % 4 == 3) {
                    // คอลัมน์ขวาสุด (ปุ่มฟังก์ชัน)
                    buttonColor =
                        index == 15 ? Colors.green[200]! : Colors.orange[200]!;
                    // ปุ่มล่างสุดสีเขียว (=), ที่เหลือสีส้ม (+,-,×,÷)
                  }
                  return Container(
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(size * 0.02),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
