# Loan Advisor App - Unit Tests

This directory contains comprehensive unit tests for the Loan Advisor Flutter application.

## Test Structure

```
test/
├── helpers/
│   └── test_helpers.dart          # Test utilities and mock data
├── screens/
│   ├── login_screen_test.dart     # Login functionality tests
│   ├── home_screen_test.dart      # Home screen navigation tests
│   ├── main_navigation_test.dart  # Bottom navigation tests
│   ├── house_loan_calculator_test.dart    # House loan calculator tests
│   ├── car_loan_calculator_test.dart      # Car loan calculator tests
│   ├── personal_loan_calculator_test.dart # Personal loan calculator tests
│   └── other_loan_calculator_test.dart    # Other loan calculator tests
├── integration/
│   └── app_integration_test.dart  # Full app flow integration tests
├── all_tests.dart                 # Main test suite runner
└── widget_test.dart              # Original widget tests
```

## Test Categories

### 1. Authentication Tests (`login_screen_test.dart`)
- **UI Rendering**: Verifies all login screen elements are displayed correctly
- **Gradient Background**: Ensures proper gradient theme implementation
- **Form Validation**: Tests empty field validation and email format checking
- **Auto-fill Functionality**: Tests demo credential auto-fill buttons
- **Navigation**: Verifies navigation to register screen
- **Loading States**: Tests loading indicators during login process
- **Password Visibility**: Tests password show/hide functionality
- **Accessibility**: Checks semantic labels and accessibility features

### 2. Navigation Tests
#### Home Screen (`home_screen_test.dart`)
- **UI Elements**: Calculator grid, quick amount buttons, bank selection
- **Navigation**: Tests navigation to all calculator sub-pages
- **Color Schemes**: Verifies consistent gradient backgrounds
- **Responsiveness**: Tests scrollable layout and spacing
- **User Interface**: Quick amount selection and user info sections

#### Main Navigation (`main_navigation_test.dart`)
- **Bottom Navigation**: 4-tab navigation system
- **Tab Switching**: Tests navigation between home, calculator, profile, settings
- **State Management**: Verifies tab state persistence
- **Accessibility**: Navigation accessibility features
- **Theme Consistency**: Color scheme across navigation

### 3. Calculator Tests

#### House Loan Calculator (`house_loan_calculator_test.dart`)
- **Form Rendering**: All input fields (price, down payment, interest, term)
- **Validation**: Empty fields, down payment validation
- **Calculations**: Monthly payment computation accuracy
- **Results Display**: Formatted number display with ฿ symbol
- **Navigation**: Back button functionality
- **Color Theme**: Green color scheme verification
- **Large Numbers**: Handling of large loan amounts

#### Car Loan Calculator (`car_loan_calculator_test.dart`)
- **Form Validation**: Car price and down payment validation
- **Calculation Logic**: Car loan specific calculations
- **Number Formatting**: Currency formatting in results
- **Decimal Handling**: Interest rate decimal input
- **Color Theme**: Green theme consistency
- **Input Labels**: Proper field labeling

#### Personal Loan Calculator (`personal_loan_calculator_test.dart`)
- **Simplified Form**: 3-field input (amount, interest, term)
- **High Interest Rates**: Validation for typical personal loan rates
- **Orange Theme**: Personal loan color scheme
- **Small Amounts**: Handling of smaller loan amounts
- **Result Highlighting**: Monthly payment emphasis
- **Validation**: Positive number validation

#### Other Loan Calculator (`other_loan_calculator_test.dart`)
- **Dropdown Selection**: Loan type dropdown with 6 options
- **Dynamic Results**: Loan type display in results
- **Yellow Theme**: Other loan color scheme
- **Multiple Loan Types**: Different calculation scenarios
- **Dropdown Navigation**: Proper dropdown functionality

### 4. Integration Tests (`app_integration_test.dart`)
- **Complete Flow**: Login → Home → Calculator → Results
- **Multi-Calculator**: Testing all calculator types in sequence
- **Multiple Calculations**: Sequential calculations across different loan types
- **State Persistence**: App state maintenance during navigation
- **Theme Consistency**: Consistent theming across entire app flow

## Test Data

### Mock Calculator Data (`test_helpers.dart`)
```dart
// House Loan
houseLoanPrice: 3,000,000 THB
houseLoanDownPayment: 600,000 THB
houseLoanInterestRate: 3.5%
houseLoanTermYears: 30 years

// Car Loan
carPrice: 800,000 THB
carDownPayment: 160,000 THB
carInterestRate: 4.5%
carLoanTermYears: 7 years

// Personal Loan
personalLoanAmount: 500,000 THB
personalInterestRate: 8.0%
personalLoanTermYears: 5 years

// Other Loan
otherLoanAmount: 200,000 THB
otherInterestRate: 6.0%
otherLoanTermYears: 3 years
```

### Color Constants
- **Primary Blue**: #4285F4 (Google Blue)
- **Primary Purple**: #8E24AA
- **House Loan Green**: #34A853
- **Personal Loan Orange**: #FF9800
- **Other Loan Yellow**: #FBBC04
- **Error Red**: #EA4335

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test Suite
```bash
# Run all tests
flutter test test/all_tests.dart

# Run individual test files
flutter test test/screens/login_screen_test.dart
flutter test test/screens/house_loan_calculator_test.dart
flutter test test/integration/app_integration_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Test Utilities

### TestHelpers Class
- **createTestApp()**: Wraps widgets with MaterialApp for testing
- **pumpAndSettleWithTimeout()**: Handles async operations with timeout
- **findTextAnywhere()**: Finds text that might be partially visible
- **enterTextByHint()**: Enters text by finding field with hint text
- **tapButtonByText()**: Taps buttons by their text content
- **verifyColorInWidget()**: Verifies color usage in widgets

## Test Coverage

### Areas Covered
✅ **Authentication Flow**: Login with validation and auto-fill  
✅ **Navigation**: Home screen and bottom navigation  
✅ **All Calculator Types**: House, Car, Personal, Other loans  
✅ **Form Validation**: Empty fields, format checking, business rules  
✅ **Calculations**: Financial computation accuracy  
✅ **UI/UX**: Gradient themes, color schemes, accessibility  
✅ **Integration**: End-to-end user flows  
✅ **Error Handling**: Validation messages and edge cases  

### Areas for Future Enhancement
- [ ] **Unit Tests for Domain Layer**: Use cases and entities
- [ ] **Repository Tests**: Data source and repository implementations
- [ ] **Mock Services**: API integration testing (when implemented)
- [ ] **Performance Tests**: Large dataset handling
- [ ] **Accessibility Tests**: Screen reader compatibility
- [ ] **Platform Tests**: iOS/Android specific behaviors

## Best Practices Followed

1. **Test Isolation**: Each test is independent and can run in any order
2. **Descriptive Names**: Test names clearly describe what is being tested
3. **AAA Pattern**: Arrange, Act, Assert structure in all tests
4. **Mock Data**: Consistent test data for reliable results
5. **Edge Cases**: Testing boundary conditions and error scenarios
6. **Accessibility**: Including accessibility testing in UI tests
7. **Integration**: Testing complete user workflows
8. **Maintainability**: Helper functions to reduce code duplication

## Test Statistics

- **Total Test Files**: 9
- **Total Test Cases**: ~120 individual tests
- **Coverage Areas**: Authentication, Navigation, Calculations, Integration
- **Test Types**: Unit tests, Widget tests, Integration tests
- **Validation Scenarios**: ~30 different validation cases
- **Calculator Scenarios**: ~40 calculation test cases

This comprehensive test suite ensures the Loan Advisor app maintains high quality, reliability, and user experience across all features and platforms.
