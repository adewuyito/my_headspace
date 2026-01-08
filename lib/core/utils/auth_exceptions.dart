import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthExceptions {
  const AuthExceptions._();
  static String handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email address.';

      case 'wrong-password':
        return 'Incorrect password. Please try again.';

      case 'invalid-email':
        return 'The email address is not valid.';

      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';

      case 'invalid-credential':
        return 'The credentials provided are invalid or expired.';

      case 'email-already-in-use':
        return 'An account already exists with this email address.';

      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';

      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled. Please contact support.';

      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';

      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';

      case 'user-token-expired':
        return 'Your session has expired. Please sign in again.';

      case 'invalid-user-token':
        return 'Invalid session. Please sign in again.';

      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please sign in again.';

      case 'expired-action-code':
        return 'This reset link has expired. Please request a new one.';

      case 'invalid-action-code':
        return 'This reset link is invalid. Please request a new one.';

      case 'credential-already-in-use':
        return 'This credential is already associated with another account.';

      case 'email-already-exists':
        return 'This email is already in use by another account.';

      case 'unverified-email':
        return 'Please verify your email address before continuing.';

      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email but different sign-in method.';

      case 'popup-closed-by-user':
        return 'Sign-in popup was closed before completion.';

      case 'popup-blocked':
        return 'Sign-in popup was blocked by the browser.';

      case 'unauthorized-domain':
        return 'This domain is not authorized for OAuth operations.';

      // ============ DEFAULT ============
      default:
        if (kDebugMode) {
          print('Unhandled Firebase Auth Exception: ${e.code} - ${e.message}');
        }
        return 'An error occurred: ${e.message ?? 'Please try again.'}';
    }
  }
}


