import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'screens/login_screen_test.dart' as login_tests;
import 'screens/home_screen_test.dart' as home_tests;
import 'screens/main_navigation_test.dart' as navigation_tests;
import 'screens/house_loan_calculator_test.dart' as house_tests;
import 'screens/car_loan_calculator_test.dart' as car_tests;
import 'screens/personal_loan_calculator_test.dart' as personal_tests;
import 'screens/other_loan_calculator_test.dart' as other_tests;
import 'integration/app_integration_test.dart' as integration_tests;

void main() {
  group('Loan Advisor App - All Tests', () {
    group('Authentication Tests', () {
      login_tests.main();
    });

    group('Navigation Tests', () {
      navigation_tests.main();
      home_tests.main();
    });

    group('Calculator Tests', () {
      group('House Loan Calculator', () {
        house_tests.main();
      });

      group('Car Loan Calculator', () {
        car_tests.main();
      });

      group('Personal Loan Calculator', () {
        personal_tests.main();
      });

      group('Other Loan Calculator', () {
        other_tests.main();
      });
    });

    group('Integration Tests', () {
      integration_tests.main();
    });
  });
}
