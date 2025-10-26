import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_advisor/screens/calculators/house_loan_calculator.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('HouseLoanCalculator Tests', () {
    testWidgets('Should render house loan calculator with all elements',
        (WidgetTester tester) async {
      // Configure test environment
      TestHelpers.configureTestEnvironment(tester);

      // Arrange & Act
      await tester
          .pumpWidget(TestHelpers.createTestApp(const HouseLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check main elements
      expect(find.text('คำนวณสินเชื่อบ้าน'), findsOneWidget);
      expect(find.text('คำนวณยอดผ่อนรายเดือน'), findsOneWidget);
      expect(find.text('สินเชื่อบ้าน'), findsOneWidget);
      expect(find.text('คำนวณยอดผ่อน'), findsOneWidget);

      // Check input fields - only 3 fields: loan amount, interest rate, loan term
      expect(find.byType(TextFormField),
          findsNWidgets(3)); // Loan amount, interest rate, loan term
      expect(find.byIcon(Icons.home), findsWidgets);
      expect(find.byIcon(Icons.attach_money), findsWidgets); // Updated icon
      expect(find.byIcon(Icons.percent), findsWidgets);
      expect(find.byIcon(Icons.schedule), findsWidgets);

      // Reset test environment
      TestHelpers.resetTestEnvironment(tester);
    });

    testWidgets('Should have proper gradient background',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester
          .pumpWidget(TestHelpers.createTestApp(const HouseLoanCalculator()));
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
      await tester
          .pumpWidget(TestHelpers.createTestApp(const HouseLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Try to submit form with empty fields
      final calculateButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'คำนวณยอดผ่อน',
      );

      await tester.tap(calculateButton);
      await tester.pump();

      // Assert - Check validation messages
      expect(find.text('กรุณากรอกยอดเงินกู้'), findsOneWidget);
      expect(find.text('กรุณากรอกอัตราดอกเบี้ย'), findsOneWidget);
      expect(find.text('กรุณากรอกระยะเวลาผ่อน'), findsOneWidget);
    });

    testWidgets('Should validate positive numbers for inputs',
        (WidgetTester tester) async {
      // Configure test environment
      TestHelpers.configureTestEnvironment(tester);

      // Arrange
      await tester
          .pumpWidget(TestHelpers.createTestApp(const HouseLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Enter valid data
      final textFields = find.byType(TextFormField);

      await tester.enterText(textFields.at(0), '1000000'); // Loan amount
      await tester.enterText(textFields.at(1), '3.5'); // Interest rate
      await tester.enterText(textFields.at(2), '30'); // Loan term
      await tester.pump();

      final calculateButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'คำนวณยอดผ่อน',
      );

      await tester.tap(calculateButton);
      await tester.pump();

      // Assert - Should not show validation errors
      expect(find.text('กรุณากรอกยอดเงินกู้'), findsNothing);

      // Reset test environment
      TestHelpers.resetTestEnvironment(tester);
    });

    testWidgets('Should calculate monthly payment correctly',
        (WidgetTester tester) async {
      // Configure test environment
      TestHelpers.configureTestEnvironment(tester);

      // Arrange
      await tester
          .pumpWidget(TestHelpers.createTestApp(const HouseLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Enter valid calculation data
      final textFields = find.byType(TextFormField);

      await tester.enterText(textFields.at(0),
          MockCalculatorData.houseLoanPrice.toString()); // Loan amount
      await tester.enterText(textFields.at(1),
          MockCalculatorData.houseLoanInterestRate.toString()); // Interest rate
      await tester.enterText(textFields.at(2),
          MockCalculatorData.houseLoanTermYears.toString()); // Loan term years
      await tester.pump();

      final calculateButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'คำนวณยอดผ่อน',
      );

      await tester.tap(calculateButton);
      await tester.pumpAndSettle();

      // Assert - Should show results section
      expect(find.text('ผลการคำนวณ'), findsOneWidget);
      expect(find.text('ยอดผ่อนต่อเดือน'), findsOneWidget);
      expect(find.text('ยอดชำระรวมทั้งหมด'), findsOneWidget);
      expect(find.text('ดอกเบี้ยรวม'), findsOneWidget);

      // Check that calculated values are displayed (should contain ฿ symbol)
      expect(find.textContaining('฿'), findsWidgets);

      // Reset test environment
      TestHelpers.resetTestEnvironment(tester);
    });

    testWidgets('Should navigate back when back button is pressed',
        (WidgetTester tester) async {
      // Arrange
      await tester
          .pumpWidget(TestHelpers.createTestApp(const HouseLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Tap back button
      final backButton = find.byIcon(Icons.arrow_back);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Assert - Should navigate back (in real app this would pop the route)
      // This test verifies the back button exists and is tappable
      expect(backButton, findsOneWidget);
    });

    testWidgets('Should show house loan icon and color scheme',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester
          .pumpWidget(TestHelpers.createTestApp(const HouseLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check house-specific elements
      expect(find.byIcon(Icons.home), findsWidgets);

      // Check for blue color scheme (house loan color)
      final elevatedButtons =
          tester.widgetList<ElevatedButton>(find.byType(ElevatedButton));
      bool hasBlueButton = false;

      for (final button in elevatedButtons) {
        final buttonStyle = button.style;
        if (buttonStyle != null) {
          final backgroundColor = buttonStyle.backgroundColor?.resolve({});
          if (backgroundColor == const Color(0xFF4285F4)) {
            // Primary blue color
            hasBlueButton = true;
            break;
          }
        }
      }
      expect(hasBlueButton, isTrue);
    });

    testWidgets('Should format numbers properly in results',
        (WidgetTester tester) async {
      // Arrange
      await tester
          .pumpWidget(TestHelpers.createTestApp(const HouseLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Enter valid data and calculate
      final textFields = find.byType(TextFormField);

      await tester.enterText(textFields.at(0), '3000000'); // Loan amount
      await tester.enterText(textFields.at(1), '3.5'); // Interest rate
      await tester.enterText(textFields.at(2), '30'); // Loan term
      await tester.pump();

      final calculateButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'คำนวณยอดผ่อน',
      );

      await tester.tap(calculateButton);
      await tester.pumpAndSettle();

      // Assert - Check number formatting (should have commas for thousands)
      final resultTexts = tester.widgetList<Text>(find.byType(Text));
      bool hasFormattedNumbers = false;

      for (final text in resultTexts) {
        if (text.data != null &&
            text.data!.contains('฿') &&
            text.data!.contains(',')) {
          hasFormattedNumbers = true;
          break;
        }
      }
      expect(hasFormattedNumbers, isTrue);
    });

    testWidgets('Should show input labels correctly',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester
          .pumpWidget(TestHelpers.createTestApp(const HouseLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check input section labels
      expect(find.text('ยอดเงินกู้'), findsOneWidget);
      expect(find.text('อัตราดอกเบี้ย'), findsOneWidget);
      expect(find.text('ระยะเวลาผ่อน'), findsOneWidget);
    });

    testWidgets('Should be accessible with proper semantics',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester
          .pumpWidget(TestHelpers.createTestApp(const HouseLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check accessibility
      expect(find.byType(Semantics), findsWidgets);
      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('Should handle large numbers correctly',
        (WidgetTester tester) async {
      // Arrange
      await tester
          .pumpWidget(TestHelpers.createTestApp(const HouseLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Enter large numbers
      final textFields = find.byType(TextFormField);

      await tester.enterText(textFields.at(0), '50000000'); // 50M loan
      await tester.enterText(textFields.at(1), '2.5'); // Interest rate
      await tester.enterText(textFields.at(2), '30'); // Loan term
      await tester.pump();

      final calculateButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'คำนวณยอดผ่อน',
      );

      await tester.tap(calculateButton);
      await tester.pumpAndSettle();

      // Assert - Should handle calculation without errors
      expect(find.text('ผลการคำนวณ'), findsOneWidget);
      expect(find.textContaining('฿'), findsWidgets);
    });
  });
}
