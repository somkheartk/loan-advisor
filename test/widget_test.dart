import 'package:flutter_test/flutter_test.dart';
import 'package:loan_advisor/main.dart';

void main() {
  testWidgets('App starts and shows login screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LoanAdvisorApp());
    
    // Wait for async initialization
    await tester.pumpAndSettle();

    // Verify that login screen elements are present
    expect(find.text('Loan Advisor'), findsOneWidget);
    expect(find.text('คำนวณการผ่อนบ้าน รถ และดอกเบี้ย'), findsOneWidget);
    expect(find.text('เข้าสู่ระบบ'), findsOneWidget);
    expect(find.text('ยังไม่มีบัญชี? สมัครสมาชิก'), findsOneWidget);
  });

  testWidgets('Navigation to register screen works', (WidgetTester tester) async {
    await tester.pumpWidget(const LoanAdvisorApp());
    await tester.pumpAndSettle();

    // Find and tap the register button
    await tester.tap(find.text('ยังไม่มีบัญชี? สมัครสมาชิก'));
    await tester.pumpAndSettle();

    // Verify we're on the register screen
    expect(find.text('สมัครสมาชิก'), findsWidgets);
    expect(find.text('สร้างบัญชีใหม่'), findsOneWidget);
  });
}
