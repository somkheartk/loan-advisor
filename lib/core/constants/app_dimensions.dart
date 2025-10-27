import 'package:flutter/material.dart';

/// คลาสเก็บค่าขนาดและระยะห่างที่ใช้ในแอปพลิเคชัน
/// ใช้เพื่อให้การจัดวาง layout เป็นมาตรฐานและสอดคล้องกันทั่วทั้งแอป
class AppDimensions {
  // ป้องกันการสร้าง instance
  AppDimensions._();

  // Spacing - ระยะห่างพื้นฐาน
  static const double spacingXs = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXl = 20.0;
  static const double spacingXxl = 24.0;
  static const double spacingXxxl = 32.0;

  // Padding - ขอบภายใน
  static const double paddingXs = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 12.0;
  static const double paddingL = 16.0;
  static const double paddingXl = 20.0;
  static const double paddingXxl = 24.0;

  // Padding EdgeInsets
  static const EdgeInsets paddingAll = EdgeInsets.all(paddingL);
  static const EdgeInsets paddingAllS = EdgeInsets.all(paddingS);
  static const EdgeInsets paddingAllM = EdgeInsets.all(paddingM);
  static const EdgeInsets paddingAllL = EdgeInsets.all(paddingL);
  static const EdgeInsets paddingAllXl = EdgeInsets.all(paddingXl);

  static const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(horizontal: paddingL);
  static const EdgeInsets paddingVertical = EdgeInsets.symmetric(vertical: paddingL);

  // Border Radius - มุมโค้ง
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusXxl = 20.0;
  static const double radiusRound = 50.0;

  // Border Radius Objects
  static const BorderRadius borderRadiusS = BorderRadius.all(Radius.circular(radiusS));
  static const BorderRadius borderRadiusM = BorderRadius.all(Radius.circular(radiusM));
  static const BorderRadius borderRadiusL = BorderRadius.all(Radius.circular(radiusL));
  static const BorderRadius borderRadiusXl = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius borderRadiusXxl = BorderRadius.all(Radius.circular(radiusXxl));

  // Border Radius - Top only
  static const BorderRadius borderRadiusTopL = BorderRadius.only(
    topLeft: Radius.circular(radiusXxl),
    topRight: Radius.circular(radiusXxl),
  );

  // Icon Sizes - ขนาดไอคอน
  static const double iconSizeXs = 16.0;
  static const double iconSizeS = 20.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXl = 48.0;
  static const double iconSizeXxl = 64.0;

  // Button Heights - ความสูงปุ่ม
  static const double buttonHeightS = 40.0;
  static const double buttonHeightM = 48.0;
  static const double buttonHeightL = 56.0;

  // Input Field Heights - ความสูงช่องกรอกข้อมูล
  static const double inputHeightM = 48.0;
  static const double inputHeightL = 56.0;

  // Card Elevation - เงาของ Card
  static const double elevationNone = 0.0;
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  static const double elevationXl = 16.0;

  // App Bar Height
  static const double appBarHeight = 56.0;

  // Grid - ขนาดสำหรับ Grid
  static const double gridSpacing = 10.0;
  static const double gridAspectRatio = 1.2;

  // Divider - เส้นแบ่ง
  static const double dividerThickness = 1.0;
  static const double dividerIndent = paddingL;

  // Border Width - ความหนาของเส้นขอบ
  static const double borderWidthThin = 1.0;
  static const double borderWidthMedium = 2.0;
  static const double borderWidthThick = 3.0;
}
