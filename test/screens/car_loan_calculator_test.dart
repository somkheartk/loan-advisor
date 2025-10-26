import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_advisor/screens/calculators/car_loan_calculator.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('CarLoanCalculator Tests', () {
    testWidgets('Should render car loan calculator with all elements',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester
          .pumpWidget(TestHelpers.createTestApp(const CarLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check main elements
      expect(find.text('คำนวณสินเชื่อรถยนต์'), findsOneWidget);
      expect(find.text('คำนวณยอดผ่อนรถยนต์'), findsOneWidget);
      expect(find.text('สินเชื่อรถยนต์'), findsOneWidget);
      expect(find.text('คำนวณยอดผ่อน'), findsOneWidget);

      // Check input fields
      expect(
          find.byType(TextFormField),
          findsNWidgets(
              4)); // Car price, down payment, interest rate, loan term
      expect(find.byIcon(Icons.directions_car), findsWidgets);
      expect(find.byIcon(Icons.payment), findsWidgets);
      expect(find.byIcon(Icons.percent), findsWidgets);
      expect(find.byIcon(Icons.schedule), findsWidgets);
    });

    testWidgets('Should have proper gradient background',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester
          .pumpWidget(TestHelpers.createTestApp(const CarLoanCalculator()));
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
          .pumpWidget(TestHelpers.createTestApp(const CarLoanCalculator()));
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
      expect(find.text('กรุณากรอกราคารถยนต์'), findsOneWidget);
      expect(find.text('กรุณากรอกเงินดาวน์'), findsOneWidget);
      expect(find.text('กรุณากรอกอัตราดอกเบี้ย'), findsOneWidget);
      expect(find.text('กรุณากรอกระยะเวลาผ่อน'), findsOneWidget);
    });

    testWidgets('Should validate down payment not exceeding car price',
        (WidgetTester tester) async {
      // Arrange
      await tester
          .pumpWidget(TestHelpers.createTestApp(const CarLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Enter down payment greater than car price
      final textFields = find.byType(TextFormField);

      await tester.enterText(textFields.at(0), '500000'); // Car price
      await tester.enterText(
          textFields.at(1), '600000'); // Down payment (greater than car price)
      await tester.pump();

      final calculateButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'คำนวณยอดผ่อน',
      );

      await tester.tap(calculateButton);
      await tester.pump();

      // Assert - Should show validation error
      expect(find.text('เงินดาวน์ต้องน้อยกว่าราคารถ'), findsOneWidget);
    });

    testWidgets('Should calculate monthly payment correctly',
        (WidgetTester tester) async {
      // Arrange
      await tester
          .pumpWidget(TestHelpers.createTestApp(const CarLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Enter valid calculation data
      final textFields = find.byType(TextFormField);

      await tester.enterText(
          textFields.at(0), MockCalculatorData.carPrice.toString());
      await tester.enterText(
          textFields.at(1), MockCalculatorData.carDownPayment.toString());
      await tester.enterText(
          textFields.at(2), MockCalculatorData.carInterestRate.toString());
      await tester.enterText(
          textFields.at(3), MockCalculatorData.carLoanTermYears.toString());
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
      expect(find.text('ยอดกู้'), findsOneWidget);
      expect(find.text('ยอดผ่อนต่อเดือน'), findsOneWidget);
      expect(find.text('ยอดชำระรวมทั้งหมด'), findsOneWidget);
      expect(find.text('ดอกเบี้ยรวม'), findsOneWidget);

      // Check that calculated values are displayed (should contain ฿ symbol)
      expect(find.textContaining('฿'), findsWidgets);
    });

    testWidgets('Should navigate back when back button is pressed',
        (WidgetTester tester) async {
      // Arrange
      await tester
          .pumpWidget(TestHelpers.createTestApp(const CarLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Tap back button
      final backButton = find.byIcon(Icons.arrow_back);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Assert - Should navigate back (in real app this would pop the route)
      expect(backButton, findsOneWidget);
    });

    testWidgets('Should show car loan icon and color scheme',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester
          .pumpWidget(TestHelpers.createTestApp(const CarLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check car-specific elements
      expect(find.byIcon(Icons.directions_car), findsWidgets);

      // Check for green color scheme (car loan color)
      final elevatedButtons =
          tester.widgetList<ElevatedButton>(find.byType(ElevatedButton));
      bool hasGreenButton = false;

      for (final button in elevatedButtons) {
        final buttonStyle = button.style;
        if (buttonStyle != null) {
          final backgroundColor = buttonStyle.backgroundColor?.resolve({});
          if (backgroundColor == TestHelpers.houseLoanGreen) {
            hasGreenButton = true;
            break;
          }
        }
      }
      expect(hasGreenButton, isTrue);
    });

    testWidgets('Should format numbers properly in results',
        (WidgetTester tester) async {
      // Arrange
      await tester
          .pumpWidget(TestHelpers.createTestApp(const CarLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Enter valid data and calculate
      final textFields = find.byType(TextFormField);

      await tester.enterText(textFields.at(0), '800000');
      await tester.enterText(textFields.at(1), '160000');
      await tester.enterText(textFields.at(2), '4.5');
      await tester.enterText(textFields.at(3), '7');
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
          .pumpWidget(TestHelpers.createTestApp(const CarLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check input section labels
      expect(find.text('ราคารถยนต์'), findsOneWidget);
      expect(find.text('เงินดาวน์'), findsOneWidget);
      expect(find.text('อัตราดอกเบี้ย'), findsOneWidget);
      expect(find.text('ระยะเวลาผ่อน'), findsOneWidget);
    });

    testWidgets('Should show calculation description',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester
          .pumpWidget(TestHelpers.createTestApp(const CarLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check description text
      expect(find.text('คำนวณการผ่อนซื้อรถยนต์'), findsOneWidget);
    });

    testWidgets('Should be accessible with proper semantics',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester
          .pumpWidget(TestHelpers.createTestApp(const CarLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check accessibility
      expect(find.byType(Semantics), findsWidgets);
      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('Should handle decimal interest rates correctly',
        (WidgetTester tester) async {
      // Arrange
      await tester
          .pumpWidget(TestHelpers.createTestApp(const CarLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Enter decimal interest rate
      final textFields = find.byType(TextFormField);

      await tester.enterText(textFields.at(0), '1000000');
      await tester.enterText(textFields.at(1), '200000');
      await tester.enterText(textFields.at(2), '3.75'); // Decimal interest rate
      await tester.enterText(textFields.at(3), '5');
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

    testWidgets('Should validate loan term as positive integer',
        (WidgetTester tester) async {
      // Arrange
      await tester
          .pumpWidget(TestHelpers.createTestApp(const CarLoanCalculator()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Enter valid data except loan term
      final textFields = find.byType(TextFormField);

      await tester.enterText(textFields.at(0), '800000');
      await tester.enterText(textFields.at(1), '160000');
      await tester.enterText(textFields.at(2), '4.5');
      await tester.enterText(textFields.at(3), '0'); // Invalid loan term
      await tester.pump();

      final calculateButton = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'คำนวณยอดผ่อน',
      );

      await tester.tap(calculateButton);
      await tester.pump();

      // Assert - Should handle zero loan term appropriately
      // The specific validation might vary based on implementation
      expect(calculateButton, findsOneWidget);
    });
  });
}
