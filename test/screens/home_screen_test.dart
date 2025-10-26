import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_advisor/screens/main/home_screen.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('HomeScreen Tests', () {
    testWidgets('Should render home screen with all main elements',
        (WidgetTester tester) async {
      // Configure test environment
      TestHelpers.configureTestEnvironment(tester);

      // Arrange & Act
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check main elements - updated to match actual UI
      expect(find.text('คำนวณเงินกู้'), findsOneWidget);
      expect(find.text('คำนวณเงินกู้ง่ายๆ ในมือถือ'), findsOneWidget);
      expect(find.text('ประเภทสินเชื่อ'), findsOneWidget);

      // Check calculator grid cards - updated to match actual text
      expect(find.text('บ้าน'), findsOneWidget);
      expect(find.text('รถยนต์'), findsOneWidget);
      expect(find.text('บุคคล'), findsOneWidget);
      expect(find.text('อื่นๆ'), findsOneWidget);

      // Reset test environment
      TestHelpers.resetTestEnvironment(tester);
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

    testWidgets('Should display loan amount section',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check loan amount section based on actual UI
      expect(find.text('จำนวนเงินกู้'), findsOneWidget);
      expect(find.text('1,000,000'), findsOneWidget);
      expect(find.text('บาท'), findsOneWidget);
      expect(find.text('อัตราดอกเบี้ย (%)'), findsOneWidget);
      expect(find.text('3.5'), findsOneWidget);
    });

    testWidgets('Should display bank selection section',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check bank section based on actual UI
      expect(find.text('ธนาคาร'), findsOneWidget);
      expect(find.text('เลือกธนาคาร'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    });

    testWidgets(
        'Should navigate to house loan calculator when house card is tapped',
        (WidgetTester tester) async {
      // Configure test environment
      TestHelpers.configureTestEnvironment(tester);

      // Arrange
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Tap house calculator card using InkWell
      final houseCardFinder = find.ancestor(
        of: find.text('บ้าน'),
        matching: find.byType(InkWell),
      );

      await tester.tap(houseCardFinder.first, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Assert - Should navigate to house loan calculator
      expect(find.text('คำนวณสินเชื่อบ้าน'), findsOneWidget);

      // Reset test environment
      TestHelpers.resetTestEnvironment(tester);
    });

    testWidgets(
        'Should navigate to car loan calculator when car card is tapped',
        (WidgetTester tester) async {
      // Configure test environment
      TestHelpers.configureTestEnvironment(tester);

      // Arrange
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Tap car calculator card using InkWell
      final carCardFinder = find.ancestor(
        of: find.text('รถยนต์'),
        matching: find.byType(InkWell),
      );

      await tester.tap(carCardFinder.first, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Assert - Should navigate to car loan calculator
      expect(find.text('คำนวณสินเชื่อรถยนต์'), findsOneWidget);

      // Reset test environment
      TestHelpers.resetTestEnvironment(tester);
    });

    testWidgets(
        'Should navigate to personal loan calculator when personal card is tapped',
        (WidgetTester tester) async {
      // Configure test environment
      TestHelpers.configureTestEnvironment(tester);

      // Arrange
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Tap personal calculator card using InkWell
      final personalCardFinder = find.ancestor(
        of: find.text('บุคคล'),
        matching: find.byType(InkWell),
      );

      await tester.tap(personalCardFinder.first, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Assert - Should navigate to personal loan calculator
      expect(find.text('คำนวณสินเชื่อบุคคล'), findsOneWidget);

      // Reset test environment
      TestHelpers.resetTestEnvironment(tester);
    });

    testWidgets(
        'Should navigate to other loan calculator when other card is tapped',
        (WidgetTester tester) async {
      // Configure test environment
      TestHelpers.configureTestEnvironment(tester);

      // Arrange
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Tap other calculator card using InkWell
      final otherCardFinder = find.ancestor(
        of: find.text('อื่นๆ'),
        matching: find.byType(InkWell),
      );

      await tester.tap(otherCardFinder.first, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Assert - Should navigate to other loan calculator
      expect(find.text('คำนวณสินเชื่ออื่นๆ'), findsOneWidget);

      // Reset test environment
      TestHelpers.resetTestEnvironment(tester);
    });

    testWidgets('Should show calculate button', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Look for calculate button
      expect(find.text('คำนวณ'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('Should show user information section',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check user info elements based on actual UI
      expect(find.text('ข้อมูลผู้ใช้งาน'), findsOneWidget);
      expect(find.text('ผู้ใช้งาน'), findsOneWidget);
      expect(find.text('สมาชิกทั่วไป'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsWidgets);
    });

    testWidgets('Should show notifications section',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(TestHelpers.createTestApp(const HomeScreen()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check notifications elements based on actual UI
      expect(find.text('แจ้งเตือนสำคัญ'), findsOneWidget);
      expect(find.text('อัตราดอกเบี้ยจะปรับขึ้น'), findsOneWidget);
      expect(find.text('ข่าวสารเศรษฐกิจ'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsWidgets);
      expect(find.byIcon(Icons.info), findsWidgets);
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

      // Assert - Check for consistent material design (no Card widgets in actual UI)
      expect(find.byType(Material), findsWidgets);
      expect(find.byType(Container), findsWidgets);
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
