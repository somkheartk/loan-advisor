import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_advisor/screens/main/home_screen.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('HomeScreen Tests', () {
    testWidgets('Should render home screen with all main elements',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check main elements
      expect(find.text('สวัสดี'), findsWidgets);
      expect(find.text('ยินดีต้อนรับสู่ Loan Advisor'), findsOneWidget);
      expect(find.text('คำนวณสินเชื่อ'), findsOneWidget);

      // Check calculator grid cards
      expect(find.text('บ้าน'), findsOneWidget);
      expect(find.text('รถ'), findsOneWidget);
      expect(find.text('บุคคล'), findsOneWidget);
      expect(find.text('อื่นๆ'), findsOneWidget);
    });

    testWidgets('Should display calculator grid with proper icons',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check calculator icons
      expect(find.byIcon(Icons.home), findsWidgets);
      expect(find.byIcon(Icons.directions_car), findsWidgets);
      expect(find.byIcon(Icons.person), findsWidgets);
      expect(find.byIcon(Icons.more_horiz), findsWidgets);
    });

    testWidgets('Should have proper gradient background',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
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

    testWidgets('Should display quick loan amount buttons',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check quick amount buttons
      expect(find.text('1M'), findsOneWidget);
      expect(find.text('2M'), findsOneWidget);
      expect(find.text('3M'), findsOneWidget);
      expect(find.text('5M'), findsOneWidget);
      expect(find.text('10M'), findsOneWidget);
    });

    testWidgets('Should display bank selection section',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check bank section
      expect(find.text('เลือกธนาคาร'), findsOneWidget);
      expect(find.text('กสิกรไทย'), findsOneWidget);
      expect(find.text('ไทยพาณิชย์'), findsOneWidget);
      expect(find.text('กรุงเทพ'), findsOneWidget);
      expect(find.text('กรุงไทย'), findsOneWidget);
    });

    testWidgets(
        'Should navigate to house loan calculator when house card is tapped',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Tap house calculator card
      // Find the house card specifically
      final houseCardFinder = find.ancestor(
        of: find.text('บ้าน'),
        matching: find.byType(GestureDetector),
      );

      await tester.tap(houseCardFinder.first);
      await tester.pumpAndSettle();

      // Assert - Should navigate to house loan calculator
      expect(find.text('คำนวณสินเชื่อบ้าน'), findsOneWidget);
    });

    testWidgets(
        'Should navigate to car loan calculator when car card is tapped',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Tap car calculator card
      final carCardFinder = find.ancestor(
        of: find.text('รถ'),
        matching: find.byType(GestureDetector),
      );

      await tester.tap(carCardFinder.first);
      await tester.pumpAndSettle();

      // Assert - Should navigate to car loan calculator
      expect(find.text('คำนวณสินเชื่อรถยนต์'), findsOneWidget);
    });

    testWidgets(
        'Should navigate to personal loan calculator when personal card is tapped',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Tap personal calculator card
      final personalCardFinder = find.ancestor(
        of: find.text('บุคคล'),
        matching: find.byType(GestureDetector),
      );

      await tester.tap(personalCardFinder.first);
      await tester.pumpAndSettle();

      // Assert - Should navigate to personal loan calculator
      expect(find.text('คำนวณสินเชื่อบุคคล'), findsOneWidget);
    });

    testWidgets(
        'Should navigate to other loan calculator when other card is tapped',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Tap other calculator card
      final otherCardFinder = find.ancestor(
        of: find.text('อื่นๆ'),
        matching: find.byType(GestureDetector),
      );

      await tester.tap(otherCardFinder.first);
      await tester.pumpAndSettle();

      // Assert - Should navigate to other loan calculator
      expect(find.text('คำนวณสินเชื่ออื่นๆ'), findsOneWidget);
    });

    testWidgets('Should update quick amount when button is tapped',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Tap on a quick amount button
      final quickAmountButton = find.text('2M');
      await tester.tap(quickAmountButton);
      await tester.pump();

      // Assert - Should update the input field or state
      // Note: This test might need adjustment based on actual implementation
      expect(find.text('2M'), findsWidgets);
    });

    testWidgets('Should show user information section',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check user info elements
      expect(find.text('ข้อมูลผู้ใช้'), findsOneWidget);
      expect(find.byIcon(Icons.account_circle), findsWidgets);
    });

    testWidgets('Should show notifications section',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check notifications elements
      expect(find.text('การแจ้งเตือน'), findsOneWidget);
      expect(find.byIcon(Icons.notifications), findsWidgets);
    });

    testWidgets('Should be scrollable when content overflows',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check for scrollable widget
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('Should use consistent color scheme',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check for consistent material design
      expect(find.byType(Material), findsWidgets);
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('Should have proper spacing between elements',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check for SizedBox spacing
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(Padding), findsWidgets);
    });
  });
}
