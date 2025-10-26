import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_advisor/main.dart';

void main() {
  group('Simple App Tests', () {
    testWidgets('App builds without crashing', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const LoanAdvisorApp());
      await tester.pump();

      // Verify basic app structure exists
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App shows loading or login screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(const LoanAdvisorApp());
      await tester.pump();

      // Should show either loading indicator or login screen
      final hasLoading =
          find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
      final hasScaffold = find.byType(Scaffold).evaluate().isNotEmpty;

      // One of these should be true
      expect(hasLoading || hasScaffold, true);
    });

    testWidgets('App renders basic structure', (WidgetTester tester) async {
      await tester.pumpWidget(const LoanAdvisorApp());
      await tester.pump();

      // Wait for auth check to complete
      await tester.pump(const Duration(milliseconds: 100));

      // Should have basic Material app structure
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    });
  });
}
