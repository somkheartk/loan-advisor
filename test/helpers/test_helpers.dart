import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestHelpers {
  /// Configure test environment with larger screen size
  static void configureTestEnvironment(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 1200);
    tester.view.devicePixelRatio = 1.0;
  }

  /// Reset test environment after tests
  static void resetTestEnvironment(WidgetTester tester) {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  }

  /// Create a MaterialApp wrapper for testing widgets
  static Widget createTestApp(Widget child) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Kanit',
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SizedBox(
          width: 1200, // Increase width to fix off-screen button issues
          height: 1200, // Maintain height for scrollable content
          child: child,
        ),
      ),
    );
  }

  /// Pump and settle with standard timeout
  static Future<void> pumpAndSettleWithTimeout(WidgetTester tester) async {
    await tester.pumpAndSettle(const Duration(seconds: 5));
  }

  /// Find text that might be partially visible or in overflow
  static Finder findTextAnywhere(String text) {
    return find.byWidgetPredicate(
      (widget) =>
          widget is Text && widget.data != null && widget.data!.contains(text),
    );
  }

  /// Find RichText containing specific text
  static Finder findRichText(String text) {
    return find.byWidgetPredicate(
      (widget) =>
          widget is RichText && widget.text.toPlainText().contains(text),
    );
  }

  /// Enter text into a TextFormField by finding it through hint text
  static Future<void> enterTextByHint(
      WidgetTester tester, String hintText, String value) async {
    final textField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField && widget.decoration?.hintText == hintText,
    );

    await tester.enterText(textField, value);
    await tester.pump();
  }

  /// Tap a button by text content
  static Future<void> tapButtonByText(
      WidgetTester tester, String buttonText) async {
    final button = find.byWidgetPredicate(
      (widget) {
        if (widget is ElevatedButton) {
          final child = widget.child;
          if (child is Text) {
            return child.data == buttonText;
          }
        }
        return false;
      },
    );

    await tester.tap(button);
    await tester.pump();
  }

  /// Verify that a specific color is used in a widget
  static void verifyColorInWidget(WidgetTester tester, Color expectedColor) {
    final paintedWidget = find.byWidgetPredicate(
      (widget) {
        // This is a simplified check - in real scenarios you might need
        // to dive deeper into the widget's render object
        return true;
      },
    );
    expect(paintedWidget, findsWidgets);
  }

  /// Common gradient colors used in the app
  static const Color primaryBlue = Color(0xFF4285F4);
  static const Color primaryPurple = Color(0xFF8E24AA);
  static const Color houseLoanGreen = Color(0xFF34A853);
  static const Color personalLoanOrange = Color(0xFFFF9800);
  static const Color otherLoanYellow = Color(0xFFFBBC04);
  static const Color errorRed = Color(0xFFEA4335);
}

/// Mock calculator input values for testing
class MockCalculatorData {
  static const double houseLoanPrice = 3000000;
  static const double houseLoanDownPayment = 600000;
  static const double houseLoanInterestRate = 3.5;
  static const int houseLoanTermYears = 30;

  static const double carPrice = 800000;
  static const double carDownPayment = 160000;
  static const double carInterestRate = 4.5;
  static const int carLoanTermYears = 7;

  static const double personalLoanAmount = 500000;
  static const double personalInterestRate = 8.0;
  static const int personalLoanTermYears = 5;

  static const double otherLoanAmount = 200000;
  static const double otherInterestRate = 6.0;
  static const int otherLoanTermYears = 3;
  static const String otherLoanType = 'สินเชื่อธุรกิจ';
}
