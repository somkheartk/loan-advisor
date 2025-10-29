import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io' show Platform;

class SocialAuthDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<Map<String, String>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        return {
          'email': user.email ?? '',
          'name': user.displayName ?? user.email ?? 'Google User',
          'provider': 'google',
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, String>?> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = firebase_auth.OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);
      final user = userCredential.user;

      if (user != null) {
        String name = user.displayName ?? '';
        if (name.isEmpty && credential.givenName != null) {
          name = '${credential.givenName} ${credential.familyName ?? ''}'.trim();
        }
        if (name.isEmpty) {
          name = user.email ?? 'Apple User';
        }

        return {
          'email': user.email ?? '',
          'name': name,
          'provider': 'apple',
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, String>?> signInWithFacebook() async {
    // Facebook login would require additional setup with facebook_login package
    // For now, we'll return null indicating it's not implemented
    // In a real app, you would integrate Facebook Login SDK
    return null;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
