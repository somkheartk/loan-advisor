/// ตัวอย่างการใช้งาน Constants
/// ไฟล์นี้แสดงวิธีการใช้ constants ที่ถูกต้องในแอปพลิเคชัน
/// 
/// วิธีใช้งาน:
/// 1. Import constants.dart
/// 2. ใช้ค่าคงที่แทนการ hardcode
/// 3. ทำให้ code สะอาดและบำรุงรักษาได้ง่าย

import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

/// ตัวอย่างหน้าจอที่ใช้ Constants อย่างถูกต้อง
class ConstantsExampleScreen extends StatelessWidget {
  const ConstantsExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'ตัวอย่างการใช้ Constants',
          style: AppTextStyles.title,
        ),
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.paddingAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ตัวอย่างการใช้ Text Styles
            Text(
              'ตัวอย่างการใช้ Text Styles',
              style: AppTextStyles.heading1,
            ),
            SizedBox(height: AppDimensions.spacingM),
            
            Text(
              'Heading 2',
              style: AppTextStyles.heading2,
            ),
            SizedBox(height: AppDimensions.spacingS),
            
            Text(
              'Body Text - Lorem ipsum dolor sit amet',
              style: AppTextStyles.bodyMedium,
            ),
            SizedBox(height: AppDimensions.spacingXl),
            
            // ตัวอย่างการใช้ Colors
            Text(
              'ตัวอย่างการใช้ Colors',
              style: AppTextStyles.heading2,
            ),
            SizedBox(height: AppDimensions.spacingM),
            
            Row(
              children: [
                _buildColorBox('House Loan', AppColors.houseLoan),
                SizedBox(width: AppDimensions.spacingM),
                _buildColorBox('Car Loan', AppColors.carLoan),
                SizedBox(width: AppDimensions.spacingM),
                _buildColorBox('Personal', AppColors.personalLoan),
                SizedBox(width: AppDimensions.spacingM),
                _buildColorBox('Other', AppColors.otherLoan),
              ],
            ),
            SizedBox(height: AppDimensions.spacingXl),
            
            // ตัวอย่างการใช้ Dimensions
            Text(
              'ตัวอย่างการใช้ Dimensions',
              style: AppTextStyles.heading2,
            ),
            SizedBox(height: AppDimensions.spacingM),
            
            Container(
              padding: AppDimensions.paddingAll,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppDimensions.borderRadiusL,
                border: Border.all(
                  color: AppColors.border,
                  width: AppDimensions.borderWidthThin,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card with Standard Padding',
                    style: AppTextStyles.labelLarge,
                  ),
                  SizedBox(height: AppDimensions.spacingS),
                  Text(
                    'Using AppDimensions.paddingAll and borderRadiusL',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppDimensions.spacingXl),
            
            // ตัวอย่างการใช้ Strings
            Text(
              'ตัวอย่างการใช้ Strings',
              style: AppTextStyles.heading2,
            ),
            SizedBox(height: AppDimensions.spacingM),
            
            ListTile(
              leading: Icon(
                Icons.calculate,
                color: AppColors.primary,
                size: AppDimensions.iconSizeL,
              ),
              title: Text(
                AppStrings.loanTypes,
                style: AppTextStyles.labelLarge,
              ),
              subtitle: Text(
                '${AppStrings.houseLoan}, ${AppStrings.carLoan}, ${AppStrings.personalLoan}',
                style: AppTextStyles.bodySmall,
              ),
            ),
            SizedBox(height: AppDimensions.spacingXl),
            
            // ตัวอย่างปุ่ม
            Text(
              'ตัวอย่างปุ่ม',
              style: AppTextStyles.heading2,
            ),
            SizedBox(height: AppDimensions.spacingM),
            
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeightM,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppDimensions.borderRadiusM,
                  ),
                ),
                onPressed: () {},
                child: Text(
                  AppStrings.calculate,
                  style: AppTextStyles.button,
                ),
              ),
            ),
            SizedBox(height: AppDimensions.spacingM),
            
            // ตัวอย่างการแสดงตัวเลขเงิน
            Container(
              padding: AppDimensions.paddingAllL,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: AppDimensions.borderRadiusL,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.monthlyPayment,
                    style: AppTextStyles.labelMedium,
                  ),
                  SizedBox(height: AppDimensions.spacingS),
                  Text(
                    '฿ 15,000.00',
                    style: AppTextStyles.currencyLarge,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppDimensions.spacingXl),
            
            // Code Examples
            Container(
              padding: AppDimensions.paddingAll,
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: AppDimensions.borderRadiusM,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '// ตัวอย่าง Code',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacingS),
                  Text(
                    'color: AppColors.primary,\n'
                    'style: AppTextStyles.heading1,\n'
                    'padding: AppDimensions.paddingAll,\n'
                    'borderRadius: AppDimensions.borderRadiusL,',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorBox(String label, Color color) {
    return Expanded(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: color,
          borderRadius: AppDimensions.borderRadiusM,
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textOnPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
