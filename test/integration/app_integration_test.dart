import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_advisor/main.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Loan Advisor App Integration Tests', () {
    testWidgets('Should complete full app flow from login to calculation',
        (WidgetTester tester) async {
      // Arrange - Start the app
      await tester.pumpWidget(const LoanAdvisorApp());
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Should start with login screen
      expect(find.text('Loan Advisor'), findsOneWidget);
      expect(find.text('เข้าสู่ระบบ'), findsWidgets);

      // Act - Login with demo credentials
      await tester.tap(find.text('Demo (demo/demo)'));
      await tester.pump();

      final loginButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'เข้าสู่ระบบ',
      );

      await tester.tap(loginButton);
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Should navigate to home screen
      expect(find.text('ยินดีต้อนรับสู่ Loan Advisor'), findsOneWidget);
      expect(find.text('คำนวณสินเชื่อ'), findsOneWidget);

      // Act - Navigate to house loan calculator
      final houseCardFinder = find.ancestor(
        of: find.text('บ้าน'),
        matching: find.byType(GestureDetector),
      );

      await tester.tap(houseCardFinder.first);
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Should be in house loan calculator
      expect(find.text('คำนวณสินเชื่อบ้าน'), findsOneWidget);
      expect(find.text('สินเชื่อบ้าน'), findsOneWidget);

      // Act - Fill in loan calculation data
      final textFields = find.byType(TextFormField);

      await tester.enterText(textFields.at(0), '3000000'); // House price
      await tester.enterText(textFields.at(1), '600000'); // Down payment
      await tester.enterText(textFields.at(2), '3.5'); // Interest rate
      await tester.enterText(textFields.at(3), '30'); // Loan term
      await tester.pump();

      // Act - Calculate loan
      final calculateButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'คำนวณยอดผ่อน',
      );

      await tester.tap(calculateButton);
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Should show calculation results
      expect(find.text('ผลการคำนวณ'), findsOneWidget);
      expect(find.text('ยอดกู้'), findsOneWidget);
      expect(find.text('ยอดผ่อนต่อเดือน'), findsOneWidget);
      expect(find.textContaining('฿'), findsWidgets);

      // Act - Navigate back to home
      final backButton = find.byIcon(Icons.arrow_back);
      await tester.tap(backButton);
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Should be back to home screen
      expect(find.text('ยินดีต้อนรับสู่ Loan Advisor'), findsOneWidget);
    });

    testWidgets('Should navigate through all calculator types',
        (WidgetTester tester) async {
      // Arrange - Start logged in
      await tester.pumpWidget(const LoanAdvisorApp());
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Login
      await tester.tap(find.text('Demo (demo/demo)'));
      await tester.pump();

      final loginButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'เข้าสู่ระบบ',
      );

      await tester.tap(loginButton);
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Test Car Calculator
      final carCardFinder = find.ancestor(
        of: find.text('รถ'),
        matching: find.byType(GestureDetector),
      );

      await tester.tap(carCardFinder.first);
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      expect(find.text('คำนวณสินเชื่อรถยนต์'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Test Personal Calculator
      final personalCardFinder = find.ancestor(
        of: find.text('บุคคล'),
        matching: find.byType(GestureDetector),
      );

      await tester.tap(personalCardFinder.first);
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      expect(find.text('คำนวณสินเชื่อบุคคล'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Test Other Calculator
      final otherCardFinder = find.ancestor(
        of: find.text('อื่นๆ'),
        matching: find.byType(GestureDetector),
      );

      await tester.tap(otherCardFinder.first);
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      expect(find.text('คำนวณสินเชื่ออื่นๆ'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Should be back to home
      expect(find.text('ยินดีต้อนรับสู่ Loan Advisor'), findsOneWidget);
    });

    testWidgets('Should handle multiple calculations correctly',
        (WidgetTester tester) async {
      // Arrange - Start logged in
      await tester.pumpWidget(const LoanAdvisorApp());
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Login
      await tester.tap(find.text('Demo (demo/demo)'));
      await tester.pump();

      final loginButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'เข้าสู่ระบบ',
      );

      await tester.tap(loginButton);
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // First calculation - Personal Loan
      final personalCardFinder = find.ancestor(
        of: find.text('บุคคล'),
        matching: find.byType(GestureDetector),
      );

      await tester.tap(personalCardFinder.first);
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Fill personal loan data
      final personalFields = find.byType(TextFormField);
      await tester.enterText(personalFields.at(0), '500000');
      await tester.enterText(personalFields.at(1), '8.0');
      await tester.enterText(personalFields.at(2), '5');
      await tester.pump();

      // Calculate
      final personalCalcButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'คำนวณยอดผ่อน',
      );

      await tester.tap(personalCalcButton);
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Verify results
      expect(find.text('ผลการคำนวณ'), findsOneWidget);

      // Go back to home
      await tester.tap(find.byIcon(Icons.arrow_back));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Second calculation - Car Loan
      final carCardFinder = find.ancestor(
        of: find.text('รถ'),
        matching: find.byType(GestureDetector),
      );

      await tester.tap(carCardFinder.first);
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Fill car loan data
      final carFields = find.byType(TextFormField);
      await tester.enterText(carFields.at(0), '800000');
      await tester.enterText(carFields.at(1), '160000');
      await tester.enterText(carFields.at(2), '4.5');
      await tester.enterText(carFields.at(3), '7');
      await tester.pump();

      // Calculate
      final carCalcButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'คำนวณยอดผ่อน',
      );

      await tester.tap(carCalcButton);
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Verify results
      expect(find.text('ผลการคำนวณ'), findsOneWidget);
      expect(find.text('ยอดกู้'), findsOneWidget);
    });

    testWidgets('Should maintain app state during navigation',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const LoanAdvisorApp());
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Complete login process
      await tester.tap(find.text('Admin (admin/password)'));
      await tester.pump();

      final loginButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'เข้าสู่ระบบ',
      );

      await tester.tap(loginButton);
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Should maintain login state
      expect(find.text('ยินดีต้อนรับสู่ Loan Advisor'), findsOneWidget);

      // Navigate through various screens and return
      final houseCardFinder = find.ancestor(
        of: find.text('บ้าน'),
        matching: find.byType(GestureDetector),
      );

      await tester.tap(houseCardFinder.first);
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Should still be logged in and show home
      expect(find.text('ยินดีต้อนรับสู่ Loan Advisor'), findsOneWidget);
    });

    testWidgets('Should handle app theme consistency',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const LoanAdvisorApp());
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check theme consistency
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(
          materialApp.theme?.textTheme.bodyLarge?.fontFamily, equals('Kanit'));

      // Check for consistent Material Design usage
      expect(find.byType(Material), findsWidgets);

      // Test theme across different screens
      await tester.tap(find.text('Demo (demo/demo)'));
      await tester.pump();

      final loginButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'เข้าสู่ระบบ',
      );

      await tester.tap(loginButton);
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Navigate to calculator to check theme consistency
      final houseCardFinder = find.ancestor(
        of: find.text('บ้าน'),
        matching: find.byType(GestureDetector),
      );

      await tester.tap(houseCardFinder.first);
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Should maintain consistent theming
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });
  });
}
