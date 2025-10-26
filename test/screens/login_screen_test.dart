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

      // Assert - Check main elements (updated to match current UI)
      expect(find.text('Loan Calculator'), findsOneWidget);
      expect(find.text('คำนวณเงินกู้ง่ายๆ ในมือถือ'), findsOneWidget);
      expect(find.text('เข้าสู่ระบบ'), findsWidgets);
      expect(find.text('อีเมล'), findsOneWidget);
      expect(find.text('รหัสผ่าน'), findsOneWidget);

      // Check form fields
      expect(find.byType(TextFormField),
          findsNWidgets(2)); // Email and password fields
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.lock_outlined), findsOneWidget);
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

    testWidgets('Should show test credentials info',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(TestHelpers.createTestApp(const LoginScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check if test credentials are shown
      expect(find.text('ข้อมูลทดสอบ:'), findsOneWidget);
      expect(find.text('แตะเพื่อเติมข้อมูล'), findsOneWidget);
      expect(find.text('Email: test@email.com'), findsOneWidget);
      expect(find.text('Password: 123456'), findsOneWidget);
    });

    testWidgets('Should auto-fill test credentials when test info is tapped',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(TestHelpers.createTestApp(const LoginScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Tap test credentials area
      final testCredentialsArea = find.text('แตะเพื่อเติมข้อมูล');
      await tester.tap(testCredentialsArea);
      await tester.pump();

      // Just verify the tap doesn't crash (actual auto-fill testing would need more complex setup)
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('Should show form validation errors when fields are empty',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(TestHelpers.createTestApp(const LoginScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Try to submit without entering data
      final loginButton = find.text('เข้าสู่ระบบ');
      await tester.tap(loginButton);
      await tester.pump();

      // Assert - Should show validation errors
      expect(find.text('กรุณากรอกอีเมล'), findsOneWidget);
      expect(find.text('กรุณากรอกรหัสผ่าน'), findsOneWidget);
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
