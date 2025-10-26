import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_advisor/main.dart' as app;

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const app.LoanAdvisorApp());
    await tester.pump();

    // Verify app builds without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App has scaffold structure', (WidgetTester tester) async {
    await tester.pumpWidget(const app.LoanAdvisorApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Check for basic Material Design structure
    expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
  });

  testWidgets('App eventually shows content', (WidgetTester tester) async {
    await tester.pumpWidget(const app.LoanAdvisorApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Should have basic structure
    final scaffolds = find.byType(Scaffold);
    final materialApps = find.byType(MaterialApp);

    expect(materialApps.evaluate().length, greaterThanOrEqualTo(1));
    expect(scaffolds.evaluate().length, greaterThanOrEqualTo(1));
  });
}
