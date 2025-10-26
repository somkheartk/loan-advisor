import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_advisor/screens/main/main_navigation.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('MainNavigation Tests', () {
    testWidgets('Should render main navigation with bottom navigation bar',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester
          .pumpWidget(TestHelpers.createTestApp(const MainNavigation()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check bottom navigation bar
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Should have 4 navigation tabs', (WidgetTester tester) async {
      // Arrange & Act
      await tester
          .pumpWidget(TestHelpers.createTestApp(const MainNavigation()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check navigation items
      final bottomNavBar =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNavBar.items.length, equals(4));

      // Check navigation icons
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.calculate), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('Should show home screen by default',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester
          .pumpWidget(TestHelpers.createTestApp(const MainNavigation()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Should display home content by default
      expect(find.text('ยินดีต้อนรับสู่ Loan Advisor'), findsOneWidget);
    });

    testWidgets('Should navigate between tabs when tapped',
        (WidgetTester tester) async {
      // Arrange
      await tester
          .pumpWidget(TestHelpers.createTestApp(const MainNavigation()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Tap on profile tab
      await tester.tap(find.byIcon(Icons.person));
      await tester.pump();

      // Assert - Should navigate to profile (implementation may vary)
      final bottomNavBar =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNavBar.currentIndex, equals(2)); // Profile tab index
    });

    testWidgets('Should maintain selected tab state',
        (WidgetTester tester) async {
      // Arrange
      await tester
          .pumpWidget(TestHelpers.createTestApp(const MainNavigation()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Tap calculator tab
      await tester.tap(find.byIcon(Icons.calculate));
      await tester.pump();

      // Assert - Calculator tab should be selected
      final bottomNavBar =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNavBar.currentIndex, equals(1)); // Calculator tab index
    });

    testWidgets('Should handle tab switching correctly',
        (WidgetTester tester) async {
      // Arrange
      await tester
          .pumpWidget(TestHelpers.createTestApp(const MainNavigation()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Switch between multiple tabs
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.home));
      await tester.pump();

      // Assert - Should return to home tab
      final bottomNavBar =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNavBar.currentIndex, equals(0)); // Home tab index
    });

    testWidgets('Should be accessible with proper semantics',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester
          .pumpWidget(TestHelpers.createTestApp(const MainNavigation()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check accessibility
      expect(find.byType(Semantics), findsWidgets);

      // Navigation should be accessible
      final bottomNavBar =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNavBar.type, isNotNull);
    });

    testWidgets('Should use consistent theme colors',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester
          .pumpWidget(TestHelpers.createTestApp(const MainNavigation()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Check for consistent Material Design
      expect(find.byType(Material), findsWidgets);

      final bottomNavBar =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNavBar.selectedItemColor, isNotNull);
      expect(bottomNavBar.unselectedItemColor, isNotNull);
    });

    testWidgets('Should handle rapid tab switching',
        (WidgetTester tester) async {
      // Arrange
      await tester
          .pumpWidget(TestHelpers.createTestApp(const MainNavigation()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Rapidly switch tabs
      await tester.tap(find.byIcon(Icons.calculate));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.person));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.home));
      await tester.pump();

      // Assert - Should handle rapid switching without issues
      final bottomNavBar =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNavBar.currentIndex, equals(0)); // Should end on home
    });

    testWidgets('Should preserve navigation state during rebuilds',
        (WidgetTester tester) async {
      // Arrange
      await tester
          .pumpWidget(TestHelpers.createTestApp(const MainNavigation()));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Act - Select tab and trigger rebuild
      await tester.tap(find.byIcon(Icons.calculate));
      await tester.pump();

      // Trigger rebuild
      await tester
          .pumpWidget(TestHelpers.createTestApp(const MainNavigation()));
      await tester.pump();

      // Assert - Navigation should remain functional
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.calculate), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });
  });
}
