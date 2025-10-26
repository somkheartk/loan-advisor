import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_advisor/screens/auth/login_screen.dart';

void main() {
  group('Basic Widget Tests', () {
    testWidgets('LoginScreen should render correctly',
        (WidgetTester tester) async {
      // Build the LoginScreen widget directly
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginScreen(),
        ),
      );

      // Give time for the widget to render completely
      await tester.pump();

      // Check for basic elements
      expect(find.text('เข้าสู่ระบบ'), findsAtLeastNWidgets(1));
      expect(find.text('Loan Calculator'), findsOneWidget);
      expect(find.text('คำนวณเงินกู้ง่ายๆ ในมือถือ'), findsOneWidget);
    });

    testWidgets('LoginScreen should have input fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginScreen(),
        ),
      );

      await tester.pump();

      // Check for form fields by hint text
      expect(find.text('อีเมล'), findsAtLeastNWidgets(1));
      expect(find.text('รหัสผ่าน'), findsAtLeastNWidgets(1));
    });
  });
}
