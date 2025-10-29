# Social Login Setup Guide

## Overview

This application now supports social login with Google, Facebook, and Apple. This document explains how to configure each authentication provider.

## Prerequisites

Before setting up social login, you need:
- A Firebase project
- Developer accounts for the authentication providers you want to use

## Firebase Setup

### 1. Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or select an existing project
3. Follow the setup wizard

### 2. Add Firebase to Your Flutter App

#### For Android:

1. In Firebase Console, go to Project Settings
2. Click "Add app" and select Android
3. Register your app with package name: `com.example.loan_advisor` (or your actual package name)
4. Download `google-services.json`
5. Place it in `android/app/` directory
6. Update `android/build.gradle`:
```gradle
buildscript {
    dependencies {
        // Add this line
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```
7. Update `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'
```

#### For iOS:

1. In Firebase Console, go to Project Settings
2. Click "Add app" and select iOS
3. Register your app with Bundle ID (found in `ios/Runner.xcodeproj`)
4. Download `GoogleService-Info.plist`
5. Open `ios/Runner.xcworkspace` in Xcode
6. Drag `GoogleService-Info.plist` into the `Runner` folder in Xcode
7. Make sure "Copy items if needed" is checked

## Google Sign-In Setup

### 1. Enable Google Sign-In in Firebase

1. Go to Firebase Console > Authentication
2. Click "Get Started" if not already enabled
3. Select "Sign-in method" tab
4. Click "Google" and enable it
5. Set support email
6. Click "Save"

### 2. Android Configuration

1. Get SHA-1 fingerprint:
```bash
cd android
./gradlew signingReport
```
2. Copy the SHA-1 from the debug variant
3. In Firebase Console > Project Settings > Your Apps > Android
4. Add the SHA-1 fingerprint
5. Download the updated `google-services.json`

### 3. iOS Configuration

1. In Firebase Console, get the iOS Client ID
2. Open `ios/Runner/Info.plist`
3. Add the following:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- Reversed client ID from GoogleService-Info.plist -->
            <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
        </array>
    </dict>
</array>
```

## Apple Sign-In Setup

### 1. Enable Apple Sign-In in Firebase

1. Go to Firebase Console > Authentication > Sign-in method
2. Click "Apple" and enable it
3. Follow the instructions to configure Apple Sign-In

### 2. iOS Configuration

1. Open `ios/Runner.xcodeproj` in Xcode
2. Select the Runner target
3. Go to "Signing & Capabilities" tab
4. Click "+ Capability"
5. Add "Sign in with Apple"

### 3. Update Service ID

1. Go to [Apple Developer Portal](https://developer.apple.com)
2. Go to "Certificates, Identifiers & Profiles"
3. Create a Service ID for your app
4. Enable "Sign in with Apple"
5. Configure Return URLs using Firebase URLs

### 4. Android Configuration (Optional)

Apple Sign-In on Android requires additional setup:
1. Follow Firebase documentation for Apple Sign-In on Android
2. Configure OAuth redirect URI

## Facebook Sign-In Setup (Optional)

Note: Facebook login is currently not fully implemented in the code. To implement it:

1. Create a Facebook App at [Facebook Developers](https://developers.facebook.com)
2. Add Facebook Login product
3. Configure OAuth redirect URIs
4. Add `flutter_facebook_auth` package to `pubspec.yaml`
5. Update `SocialAuthDataSource.signInWithFacebook()` method
6. Enable Facebook in Firebase Console > Authentication

## Testing Social Login

### Development Testing

The app is configured to handle Firebase initialization failures gracefully, allowing development without full Firebase setup.

### Test on Real Devices

1. Google Sign-In: Test on both Android and iOS devices
2. Apple Sign-In: Test on iOS devices only (iOS 13+)
3. Check that user data is properly saved and persists

## Troubleshooting

### Common Issues

1. **"PlatformException: sign_in_failed"**
   - Check SHA-1 fingerprint is added in Firebase Console
   - Verify `google-services.json` is in the correct location
   - Clean and rebuild the app

2. **"Firebase not initialized"**
   - Ensure Firebase configuration files are added
   - Check that Firebase.initializeApp() is called before runApp()

3. **Apple Sign-In not working**
   - Verify "Sign in with Apple" capability is added in Xcode
   - Check Bundle ID matches in all configurations
   - Ensure device is running iOS 13+

4. **Google Sign-In on iOS not working**
   - Check reversed client ID is correctly added to Info.plist
   - Verify GoogleService-Info.plist is added to Xcode project

### Debug Mode

To see detailed error messages:
1. Run app from IDE with debugger attached
2. Check console logs for Firebase and authentication errors
3. Use `flutter logs` command to see device logs

## Security Considerations

1. **Never commit Firebase configuration files to public repositories**
   - Add to `.gitignore`: `google-services.json`, `GoogleService-Info.plist`
   
2. **Use proper OAuth scopes**
   - Only request necessary user information
   
3. **Validate tokens on backend**
   - For production, validate authentication tokens on a secure backend

4. **Enable App Check**
   - Add Firebase App Check to prevent abuse

## Next Steps

1. Set up Firebase project for your app
2. Configure authentication providers
3. Test on real devices
4. Implement backend validation (recommended for production)
5. Consider adding more providers (Facebook, Twitter, etc.)

## Support

For issues or questions:
- Check [Firebase Documentation](https://firebase.google.com/docs)
- Review [Flutter Firebase Documentation](https://firebase.flutter.dev)
- Check package documentation for specific providers
