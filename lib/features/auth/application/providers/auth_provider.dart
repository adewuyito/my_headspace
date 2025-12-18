import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:my_headspace/features/auth/application/enums/auth_results.dart';
import 'package:my_headspace/features/auth/domain/repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthState _authState = AuthState.unknown();
  final AuthRepository _authRepo = AuthRepository();
  String? _errorMessage;

  User? _user;

  bool get isLoading => _authState.isLoading;
  String? get userId => _user?.uid;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> loginUserWithEmail(String email, String password) async {
    try {
      _errorMessage = null;
      _authState = _authState.copiedWithIsLoading(true);
      notifyListeners();

      final user = await _authRepo.loginUserWithEmail(
        email: email,
        password: password,
      );

      // ~ Update The AuthState
      if (user != null) {
        _authState = AuthState(
          result: AuthResult.authSuccess,
          isLoading: false,
          userId: user.uid,
        );
      }

      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 100));

      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _handleAuthException(e);
      _authState = _authState.copiedWithIsLoading(false);
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _authState = _authState.copiedWithIsLoading(false);
      notifyListeners();
      return false;
    }
  }

  Future<bool> signupUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      _errorMessage = null;
      _authState = _authState.copiedWithIsLoading(true);
      notifyListeners();

      final user = await _authRepo.signupUserWithEmail(
        email: email,
        password: password,
      );

      // ~ Update The AuthState
      if (user != null) {
        _authState = AuthState(
          result: AuthResult.authSuccess,
          isLoading: false,
          userId: user.uid,
        );
      }

      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 100));

      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _handleAuthException(e);
      _authState = _authState.copiedWithIsLoading(false);
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _authState = _authState.copiedWithIsLoading(false);
      notifyListeners();
      return false;
    }
  }

  Future<void> logOutUser() async {
    _authState = AuthState.unknown();
    _user = null;
    _errorMessage = null;
    await _authRepo.logOut();
    notifyListeners();
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      // ============ LOGIN ERRORS ============
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

      // ============ SIGNUP ERRORS ============
      case 'email-already-in-use':
        return 'An account already exists with this email address.';

      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';

      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled. Please contact support.';

      // ============ NETWORK & CONNECTION ERRORS ============
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';

      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';

      // ============ TOKEN & SESSION ERRORS ============
      case 'user-token-expired':
        return 'Your session has expired. Please sign in again.';

      case 'invalid-user-token':
        return 'Invalid session. Please sign in again.';

      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please sign in again.';

      // ============ PASSWORD RESET ERRORS ============
      case 'expired-action-code':
        return 'This reset link has expired. Please request a new one.';

      case 'invalid-action-code':
        return 'This reset link is invalid. Please request a new one.';

      // ============ ACCOUNT MANAGEMENT ERRORS ============
      case 'credential-already-in-use':
        return 'This credential is already associated with another account.';

      case 'email-already-exists':
        return 'This email is already in use by another account.';

      // ============ VERIFICATION ERRORS ============
      case 'unverified-email':
        return 'Please verify your email address before continuing.';

      // ============ PROVIDER ERRORS (Google, Apple, etc.) ============
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
