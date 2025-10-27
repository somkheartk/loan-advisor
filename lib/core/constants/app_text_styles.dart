import 'package:flutter/material.dart';
import 'app_colors.dart';

/// คลาสเก็บสไตล์ข้อความที่ใช้ในแอปพลิเคชัน
/// ใช้เพื่อให้การแสดงผลข้อความเป็นมาตรฐานและสอดคล้องกันทั่วทั้งแอป
class AppTextStyles {
  // ป้องกันการสร้าง instance
  AppTextStyles._();

  // ฟอนต์หลักของแอป
  static const String fontFamily = 'Kanit';

  // Headings - หัวข้อใหญ่
  static const TextStyle heading1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // Body Text - ข้อความทั่วไป
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  // Label - ป้ายข้อความ
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Button Text - ข้อความบนปุ่ม
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnPrimary,
  );

  // Caption - คำอธิบายเล็กๆ
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textHint,
  );

  // Title - ชื่อเรื่อง
  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textOnPrimary,
  );

  // Subtitle - ชื่อเรื่องรอง
  static const TextStyle subtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Currency - ตัวเลขเงิน
  static const TextStyle currency = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle currencyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  // Error Text - ข้อความแสดงข้อผิดพลาด
  static const TextStyle error = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.error,
  );
}
