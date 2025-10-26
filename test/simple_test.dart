import 'package:flutter_test/flutter_test.dart';
import 'package:loan_advisor/main.dart';

void main() {
  group('Simple App Tests', () {
    testWidgets('App should build without crashing',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const LoanAdvisorApp());

      // Give time for the app to load
      await tester.pumpAndSettle();

      // Verify that login screen shows up
      expect(find.text('เข้าสู่ระบบ'), findsOneWidget);
    });

    testWidgets('Login screen should have basic elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(const LoanAdvisorApp());
      await tester.pumpAndSettle();

      // Check for login form elements
      expect(find.text('อีเมล'), findsOneWidget);
      expect(find.text('รหัสผ่าน'), findsOneWidget);
      expect(find.text('เข้าสู่ระบบ'), findsAtLeastNWidgets(1));
      expect(find.text('สมัครสมาชิก'), findsOneWidget);
    });
  });
}
