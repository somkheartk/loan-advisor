# Quick Firebase Setup for Social Login

## Quick Start (5 minutes)

This guide will help you quickly set up Firebase for development testing.

### Step 1: Create Firebase Project (2 minutes)

1. Go to https://console.firebase.google.com/
2. Click "Add project"
3. Enter project name: `loan-advisor-dev`
4. Disable Google Analytics (optional for dev)
5. Click "Create project"

### Step 2: Add Android App (1 minute)

1. Click Android icon in Firebase Console
2. Package name: Check `android/app/build.gradle` for `applicationId`
3. Download `google-services.json`
4. Place in `android/app/` folder

### Step 3: Add iOS App (1 minute)

1. Click iOS icon in Firebase Console
2. Bundle ID: Open `ios/Runner.xcodeproj` and check Bundle Identifier
3. Download `GoogleService-Info.plist`
4. Open `ios/Runner.xcworkspace` in Xcode
5. Drag file into Runner folder (check "Copy items if needed")

### Step 4: Enable Authentication (1 minute)

1. Go to Authentication → Get Started
2. Click "Sign-in method" tab
3. Enable "Google"
4. Set support email
5. Save

### Step 5: Test

```bash
flutter clean
flutter pub get
flutter run
```

## Minimal Android Configuration

Edit `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'
```

Edit `android/build.gradle`:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

## Get SHA-1 for Google Sign-In (Android)

```bash
cd android
./gradlew signingReport
```

Copy SHA-1 from output and add to Firebase Console → Project Settings → Your Apps → SHA certificate fingerprints

## iOS Configuration for Google Sign-In

1. Open `ios/Runner/Info.plist`
2. Find `REVERSED_CLIENT_ID` in `GoogleService-Info.plist`
3. Add to `Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID_HERE</string>
        </array>
    </dict>
</array>
```

## Apple Sign-In (iOS Only)

1. Open `ios/Runner.xcodeproj` in Xcode
2. Select Runner target
3. Signing & Capabilities → Add Capability → Sign in with Apple
4. Done!

## Troubleshooting

**"FirebaseError: No Firebase App"**
- Make sure config files are in correct location
- Run `flutter clean && flutter pub get`

**"Google Sign-In failed"**
- Add SHA-1 to Firebase Console
- Verify `google-services.json` is latest version

**"Pod install failed" (iOS)**
```bash
cd ios
pod install --repo-update
cd ..
```

## Files to .gitignore

Add these to `.gitignore`:
```
# Firebase config
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```

## Testing Without Firebase

The app will work without Firebase setup:
- Email/password login works (local only)
- Social login buttons will show error messages
- All calculator features work normally

## Full Documentation

See [SOCIAL_LOGIN_SETUP.md](SOCIAL_LOGIN_SETUP.md) for complete setup guide including:
- Apple Sign-In configuration
- Facebook Login setup
- Production deployment
- Security considerations
