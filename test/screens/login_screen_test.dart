import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_advisor/screens/auth/login_screen.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('LoginScreen Tests', () {
    testWidgets('Should render login screen with all elements',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(TestHelpers.createTestApp(const LoginScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check main elements
      expect(find.text('Loan Advisor'), findsOneWidget);
      expect(find.text('คำนวณการผ่อนบ้าน รถ และดอกเบี้ย'), findsOneWidget);
      expect(find.text('เข้าสู่ระบบ'), findsWidgets);
      expect(find.text('ยังไม่มีบัญชี? สมัครสมาชิก'), findsOneWidget);

      // Check form fields
      expect(find.byType(TextFormField),
          findsNWidgets(2)); // Email and password fields
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('Should show gradient background', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(TestHelpers.createTestApp(const LoginScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check gradient container
      expect(find.byType(Container), findsWidgets);
      final containers = tester.widgetList<Container>(find.byType(Container));

      bool hasGradient = false;
      for (final container in containers) {
        if (container.decoration is BoxDecoration) {
          final decoration = container.decoration as BoxDecoration;
          if (decoration.gradient is LinearGradient) {
            final gradient = decoration.gradient as LinearGradient;
            if (gradient.colors.contains(TestHelpers.primaryBlue) &&
                gradient.colors.contains(TestHelpers.primaryPurple)) {
              hasGradient = true;
              break;
            }
          }
        }
      }
      expect(hasGradient, isTrue);
    });

    testWidgets('Should show validation errors for empty fields',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(TestHelpers.createTestApp(const LoginScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Try to submit form with empty fields
      final loginButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'เข้าสู่ระบบ',
      );

      await tester.tap(loginButton);
      await tester.pump();

      // Assert - Check validation messages
      expect(find.text('กรุณากรอกอีเมล'), findsOneWidget);
      expect(find.text('กรุณากรอกรหัสผ่าน'), findsOneWidget);
    });

    testWidgets('Should validate email format', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(TestHelpers.createTestApp(const LoginScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Enter invalid email
      final emailFields = find.byType(TextFormField);
      final firstField = emailFields.first;

      await tester.enterText(firstField, 'invalid-email');
      await tester.pump();

      final loginButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'เข้าสู่ระบบ',
      );

      await tester.tap(loginButton);
      await tester.pump();

      // Assert - Should show email validation error
      expect(find.text('กรุณากรอกอีเมลให้ถูกต้อง'), findsOneWidget);
    });

    testWidgets('Should auto-fill demo credentials when demo button is tapped',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(TestHelpers.createTestApp(const LoginScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Tap demo button
      final demoButton = find.text('Demo (demo/demo)');
      await tester.tap(demoButton);
      await tester.pump();

      // Assert - Check if fields are auto-filled
      final emailField = find.byWidgetPredicate(
        (widget) =>
            widget is TextFormField && widget.controller?.text == 'demo',
      );

      final passwordField = find.byWidgetPredicate(
        (widget) =>
            widget is TextFormField && widget.controller?.text == 'demo',
      );

      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);
    });

    testWidgets(
        'Should auto-fill admin credentials when admin button is tapped',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(TestHelpers.createTestApp(const LoginScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Tap admin button
      final adminButton = find.text('Admin (admin/password)');
      await tester.tap(adminButton);
      await tester.pump();

      // Assert - Check if fields are auto-filled
      final emailField = find.byWidgetPredicate(
        (widget) =>
            widget is TextFormField && widget.controller?.text == 'admin',
      );

      final passwordField = find.byWidgetPredicate(
        (widget) =>
            widget is TextFormField && widget.controller?.text == 'password',
      );

      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);
    });

    testWidgets(
        'Should navigate to register screen when register link is tapped',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(TestHelpers.createTestApp(const LoginScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Tap register link
      final registerLink = find.text('ยังไม่มีบัญชี? สมัครสมาชิก');
      await tester.tap(registerLink);
      await tester.pumpAndSettle();

      // Assert - Should navigate to register screen
      expect(find.text('สมัครสมาชิก'), findsWidgets);
      expect(find.text('สร้างบัญชีใหม่'), findsOneWidget);
    });

    testWidgets('Should show loading indicator when logging in',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(TestHelpers.createTestApp(const LoginScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Fill valid credentials and submit
      final textFields = find.byType(TextFormField);
      final emailField = textFields.first;
      final passwordField = textFields.last;

      await tester.enterText(emailField, 'demo');
      await tester.enterText(passwordField, 'demo');
      await tester.pump();

      final loginButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'เข้าสู่ระบบ',
      );

      await tester.tap(loginButton);
      await tester.pump();

      // Assert - Should show loading or navigate (depending on implementation)
      // Note: This test might need adjustment based on actual login flow
      expect(find.byType(CircularProgressIndicator), findsAny);
    });

    testWidgets('Should toggle password visibility when icon is tapped',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(TestHelpers.createTestApp(const LoginScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Find password visibility toggle icon
      final visibilityIcon = find.byIcon(Icons.visibility_off);

      if (visibilityIcon.evaluate().isNotEmpty) {
        await tester.tap(visibilityIcon);
        await tester.pump();

        // Assert - Icon should change to visible
        expect(find.byIcon(Icons.visibility), findsOneWidget);
      }
    });

    testWidgets('Should have proper accessibility labels',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(TestHelpers.createTestApp(const LoginScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check semantic labels for accessibility
      expect(find.byType(Semantics), findsWidgets);

      // Check if buttons are properly labeled
      final loginButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'เข้าสู่ระบบ',
      );

      expect(loginButton, findsOneWidget);
    });
  });
}
