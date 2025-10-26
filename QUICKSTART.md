# Quick Start Guide

## For Developers

### Prerequisites
```bash
# Check Flutter installation
flutter --version

# Minimum requirements:
# - Flutter SDK 3.0.0 or higher
# - Dart SDK 3.0.0 or higher
```

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/somkheartk/loan-advisor.git
cd loan-advisor
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
# For development
flutter run

# For specific device
flutter run -d <device-id>

# List available devices
flutter devices
```

### Building

#### Android APK
```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release

# The APK will be in: build/app/outputs/flutter-apk/
```

#### iOS (requires macOS and Xcode)
```bash
# Release build
flutter build ios --release

# The app will be in: build/ios/iphoneos/
```

### Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### Code Analysis

```bash
# Analyze code for issues
flutter analyze

# Format code
flutter format lib/

# Check for formatting issues
flutter format --set-exit-if-changed lib/
```

## For End Users

### Installation from Source

1. **Install Flutter** (if not already installed)
   - Visit: https://flutter.dev/docs/get-started/install
   - Follow instructions for your operating system

2. **Clone and Build**
```bash
git clone https://github.com/somkheartk/loan-advisor.git
cd loan-advisor
flutter pub get
flutter run
```

### Using the App

#### First Time Setup
1. Open the app
2. Tap "ยังไม่มีบัญชี? สมัครสมาชิก" (Don't have an account? Register)
3. Fill in your details:
   - Name
   - Email
   - Password (minimum 6 characters)
   - Confirm password
4. Tap "สมัครสมาชิก" (Register)
5. You'll be automatically logged in

#### Calculating Loans

##### House Loan
1. From home screen, tap "คำนวณการผ่อนบ้าน" (Calculate House Loan)
2. Enter:
   - Loan amount in Thai Baht (e.g., 3000000 for 3 million)
   - Annual interest rate (e.g., 4.5 for 4.5%)
   - Loan term in years (e.g., 30)
3. Tap "คำนวณ" (Calculate)
4. View results showing monthly payment, total payment, and interest

##### Car Loan
1. From home screen, tap "คำนวณการผ่อนรถ" (Calculate Car Loan)
2. Enter:
   - Car price in Thai Baht
   - Down payment amount
   - Annual interest rate
   - Loan term in years
3. Tap "คำนวณ" (Calculate)
4. View results including calculated loan amount

##### Personal Loan
1. From home screen, tap "คำนวณดอกเบี้ยส่วนบุคคล" (Calculate Personal Loan)
2. Enter:
   - Loan amount in Thai Baht
   - Annual interest rate
   - Loan term in months (not years!)
3. Tap "คำนวณ" (Calculate)
4. View results including effective interest rate

## Project Structure

```
loan-advisor/
├── lib/
│   ├── main.dart                           # App entry point
│   ├── screens/                            # UI screens
│   │   ├── login_screen.dart              # Login page
│   │   ├── register_screen.dart           # Registration page
│   │   ├── home_screen.dart               # Main dashboard
│   │   ├── house_loan_calculator.dart     # House loan calculator
│   │   ├── car_loan_calculator.dart       # Car loan calculator
│   │   ├── personal_loan_calculator.dart  # Personal loan calculator
│   │   └── profile_screen.dart            # User profile
│   └── services/
│       └── user_service.dart              # Authentication service
├── test/
│   └── widget_test.dart                   # Widget tests
├── pubspec.yaml                           # Dependencies
├── README.md                              # Main documentation
├── FEATURES.md                            # Feature details
├── ARCHITECTURE.md                        # Technical architecture
├── DESIGN.md                              # Design specifications
├── SHOWCASE.md                            # Project showcase
└── QUICKSTART.md                          # This file
```

## Configuration

### Dependencies (in pubspec.yaml)
- `flutter`: Flutter SDK
- `shared_preferences: ^2.2.2`: Local storage
- `intl: ^0.18.1`: Number formatting

### Supported Platforms
- ✅ Android (API 21+)
- ✅ iOS (iOS 11+)
- ⚠️ Web (basic support, needs testing)
- ❌ Desktop (not configured)

## Troubleshooting

### Common Issues

**Issue: "Waiting for another flutter command to release the startup lock"**
```bash
# Solution: Delete the lock file
rm -rf $FLUTTER_ROOT/bin/cache/lockfile
```

**Issue: "CocoaPods not installed"** (iOS)
```bash
# Solution: Install CocoaPods
sudo gem install cocoapods
```

**Issue: "Gradle build failed"** (Android)
```bash
# Solution: Clean and rebuild
flutter clean
flutter pub get
flutter run
```

**Issue: Dependencies not resolving**
```bash
# Solution: Clear pub cache and reinstall
flutter pub cache repair
flutter pub get
```

**Issue: Hot reload not working**
```bash
# Solution: Restart the app
# Press 'R' in terminal or
flutter run
```

## Tips & Tricks

### Development
- Use `flutter run --hot` for hot reload
- Press `r` to hot reload during development
- Press `R` to hot restart
- Press `p` to show performance overlay
- Press `q` to quit

### Debugging
- Use `print()` statements for simple debugging
- Use Flutter DevTools for advanced debugging
- Enable debug mode: `flutter run --debug`
- Check logs: `flutter logs`

### Performance
- Profile mode for testing: `flutter run --profile`
- Release mode for production: `flutter run --release`
- Check performance: `flutter run --profile` then press `P`

## Getting Help

- **Flutter Documentation**: https://flutter.dev/docs
- **GitHub Issues**: Create an issue in this repository
- **Flutter Community**: https://flutter.dev/community
- **Stack Overflow**: Tag questions with [flutter]

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Run tests: `flutter test`
5. Format code: `flutter format lib/`
6. Commit: `git commit -m "Description"`
7. Push: `git push origin feature-name`
8. Create a Pull Request

## Version History

- **v1.0.0** (Current) - Initial release
  - User authentication
  - House loan calculator
  - Car loan calculator
  - Personal loan calculator
  - Thai language support

## License

MIT License - see LICENSE file for details

---

Happy Coding! 🚀
