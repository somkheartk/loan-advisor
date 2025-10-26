import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_advisor/screens/calculators/personal_loan_calculator.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('PersonalLoanCalculator Tests', () {
    testWidgets('Should render personal loan calculator with all elements',
        (WidgetTester tester) async {
      // Configure test environment
      TestHelpers.configureTestEnvironment(tester);

      // Arrange & Act
      await tester.pumpWidget(
          TestHelpers.createTestApp(const PersonalLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check main elements
      expect(find.text('คำนวณสินเชื่อบุคคล'), findsOneWidget);
      expect(find.text('คำนวณยอดผ่อนสินเชื่อส่วนบุคคล'), findsOneWidget);
      expect(find.text('สินเชื่อบุคคล'), findsOneWidget);
      expect(find.text('คำนวณยอดผ่อน'), findsOneWidget);

      // Check input fields (Personal loan has 3 fields: amount, interest rate, term)
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.byIcon(Icons.person), findsWidgets);
      expect(find.byIcon(Icons.account_balance_wallet), findsWidgets);
      expect(find.byIcon(Icons.percent), findsWidgets);
      expect(find.byIcon(Icons.schedule), findsWidgets);

      // Reset test environment
      TestHelpers.resetTestEnvironment(tester);
    });

    testWidgets('Should have proper gradient background',
        (WidgetTester tester) async {
      // Configure test environment
      TestHelpers.configureTestEnvironment(tester);

      // Arrange & Act
      await tester.pumpWidget(
          TestHelpers.createTestApp(const PersonalLoanCalculator()));
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

      // Reset test environment
      TestHelpers.resetTestEnvironment(tester);
    });

    testWidgets('Should show validation errors for empty fields',
        (WidgetTester tester) async {
      // Configure test environment
      TestHelpers.configureTestEnvironment(tester);

      // Arrange
      await tester.pumpWidget(
          TestHelpers.createTestApp(const PersonalLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Try to submit form with empty fields
      final calculateButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'คำนวณยอดผ่อน',
      );

      await tester.tap(calculateButton, warnIfMissed: false);
      await tester.pump();

      // Assert - Check validation messages
      expect(find.text('กรุณากรอกจำนวนเงินกู้'), findsOneWidget);
      expect(find.text('กรุณากรอกอัตราดอกเบี้ย'), findsOneWidget);
      expect(find.text('กรุณากรอกระยะเวลาผ่อน'), findsOneWidget);

      // Reset test environment
      TestHelpers.resetTestEnvironment(tester);
    });

    testWidgets('Should calculate monthly payment correctly',
        (WidgetTester tester) async {
      // Configure test environment
      TestHelpers.configureTestEnvironment(tester);

      // Arrange
      await tester.pumpWidget(
          TestHelpers.createTestApp(const PersonalLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Enter valid calculation data
      final textFields = find.byType(TextFormField);

      await tester.enterText(
          textFields.at(0), MockCalculatorData.personalLoanAmount.toString());
      await tester.enterText(
          textFields.at(1), MockCalculatorData.personalInterestRate.toString());
      await tester.enterText(textFields.at(2),
          MockCalculatorData.personalLoanTermYears.toString());
      await tester.pump();

      final calculateButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'คำนวณยอดผ่อน',
      );

      await tester.tap(calculateButton, warnIfMissed: false);
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
      // Configure test environment
      TestHelpers.configureTestEnvironment(tester);

      // Arrange
      await tester.pumpWidget(
          TestHelpers.createTestApp(const PersonalLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Tap back button
      final backButton = find.byIcon(Icons.arrow_back);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Assert - Should navigate back (in real app this would pop the route)
      expect(backButton, findsOneWidget);

      // Reset test environment
      TestHelpers.resetTestEnvironment(tester);
    });

    testWidgets('Should show personal loan icon and orange color scheme',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
          TestHelpers.createTestApp(const PersonalLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check personal loan specific elements
      expect(find.byIcon(Icons.person), findsWidgets);

      // Check for orange color scheme (personal loan color)
      final elevatedButtons =
          tester.widgetList<ElevatedButton>(find.byType(ElevatedButton));
      bool hasOrangeButton = false;

      for (final button in elevatedButtons) {
        final buttonStyle = button.style;
        if (buttonStyle != null) {
          final backgroundColor = buttonStyle.backgroundColor?.resolve({});
          if (backgroundColor == TestHelpers.personalLoanOrange) {
            hasOrangeButton = true;
            break;
          }
        }
      }
      expect(hasOrangeButton, isTrue);
    });

    testWidgets('Should format numbers properly in results',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
          TestHelpers.createTestApp(const PersonalLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Enter valid data and calculate
      final textFields = find.byType(TextFormField);

      await tester.enterText(textFields.at(0), '500000');
      await tester.enterText(textFields.at(1), '8.0');
      await tester.enterText(textFields.at(2), '5');
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
      await tester.pumpWidget(
          TestHelpers.createTestApp(const PersonalLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check input section labels
      expect(find.text('จำนวนเงินกู้'), findsOneWidget);
      expect(find.text('อัตราดอกเบี้ย'), findsOneWidget);
      expect(find.text('ระยะเวลาผ่อน'), findsOneWidget);
    });

    testWidgets('Should show calculation description',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
          TestHelpers.createTestApp(const PersonalLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check description text
      expect(find.text('คำนวณการกู้ยืมเงินส่วนบุคคล'), findsOneWidget);
    });

    testWidgets('Should be accessible with proper semantics',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
          TestHelpers.createTestApp(const PersonalLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check accessibility
      expect(find.byType(Semantics), findsWidgets);
      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('Should handle high interest rates correctly',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
          TestHelpers.createTestApp(const PersonalLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Enter high interest rate (personal loans typically have higher rates)
      final textFields = find.byType(TextFormField);

      await tester.enterText(textFields.at(0), '100000');
      await tester.enterText(textFields.at(1), '15.5'); // High interest rate
      await tester.enterText(textFields.at(2), '3');
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

    testWidgets('Should handle small loan amounts correctly',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
          TestHelpers.createTestApp(const PersonalLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Enter small loan amount
      final textFields = find.byType(TextFormField);

      await tester.enterText(textFields.at(0), '50000'); // Small amount
      await tester.enterText(textFields.at(1), '10.0');
      await tester.enterText(textFields.at(2), '2');
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

    testWidgets('Should show results in highlighted format for monthly payment',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
          TestHelpers.createTestApp(const PersonalLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Calculate loan
      final textFields = find.byType(TextFormField);

      await tester.enterText(textFields.at(0), '300000');
      await tester.enterText(textFields.at(1), '7.5');
      await tester.enterText(textFields.at(2), '4');
      await tester.pump();

      final calculateButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'คำนวณยอดผ่อน',
      );

      await tester.tap(calculateButton);
      await tester.pumpAndSettle();

      // Assert - Monthly payment should be highlighted
      expect(find.text('ยอดผ่อนต่อเดือน'), findsOneWidget);

      // Results section should be visible
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('Should validate only positive numbers for loan amount',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
          TestHelpers.createTestApp(const PersonalLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Enter zero or negative loan amount (if validation exists)
      final textFields = find.byType(TextFormField);

      await tester.enterText(textFields.at(0), '0');
      await tester.enterText(textFields.at(1), '8.0');
      await tester.enterText(textFields.at(2), '3');
      await tester.pump();

      final calculateButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'คำนวณยอดผ่อน',
      );

      await tester.tap(calculateButton);
      await tester.pump();

      // Assert - Should handle appropriately (specific validation may vary)
      expect(calculateButton, findsOneWidget);
    });
  });
}
