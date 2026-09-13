import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SocialAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Google Sign In
  Future<String?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return 'Google sign in was cancelled';
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        return null; // Success
      }
      
      return 'Failed to sign in with Google';
    } catch (e) {
      if (kDebugMode) {
        print('Google Sign In Error: $e');
      }
      return 'Google sign in failed: ${e.toString()}';
    }
  }

  // Facebook Sign In
  Future<String?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.cancelled) {
        return 'Facebook sign in was cancelled';
      }

      if (result.status == LoginStatus.failed) {
        return 'Facebook sign in failed: ${result.message}';
      }

      // Create a credential from the access token
      final OAuthCredential credential = FacebookAuthProvider.credential(
        result.accessToken!.token,
      );

      // Sign in with Firebase
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        return null; // Success
      }
      
      return 'Failed to sign in with Facebook';
    } catch (e) {
      if (kDebugMode) {
        print('Facebook Sign In Error: $e');
      }
      return 'Facebook sign in failed: ${e.toString()}';
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
    await _firebaseAuth.signOut();
  }

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;
}
