import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';


class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String? _errorMessage;

  bool get isAuthenticated => _user != null;
  User? get user => _user;
  String? get errorMessage => _errorMessage;

  // Check initial auth state
  Future<void> checkAuthState() async {
    _user = _auth.currentUser;
    notifyListeners();
  }

  // Listen to auth state changes
  void listenToAuthChanges() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // LOGIN with comprehensive error handling
  Future<bool> login(String email, String password) async {
    try {
      _errorMessage = null;
      
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _user = userCredential.user;
      notifyListeners();
      return true;
      
    } on FirebaseAuthException catch (e) {
      _errorMessage = _handleAuthException(e);
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      notifyListeners();
      return false;
    }
  }

  // SIGNUP with comprehensive error handling
  Future<bool> signup(String email, String password, String name) async {
    try {
      _errorMessage = null;
      
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _user = userCredential.user;
      
      // Update display name
      await _user?.updateDisplayName(name);
      await _user?.reload();
      _user = _auth.currentUser;
      
      notifyListeners();
      return true;
      
    } on FirebaseAuthException catch (e) {
      _errorMessage = _handleAuthException(e);
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      notifyListeners();
      return false;
    }
  }

  // PASSWORD RESET
  Future<bool> resetPassword(String email) async {
    try {
      _errorMessage = null;
      await _auth.sendPasswordResetEmail(email: email);
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _handleAuthException(e);
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Failed to send reset email. Please try again.';
      notifyListeners();
      return false;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  // REAUTHENTICATE (needed for sensitive operations)
  Future<bool> reauthenticate(String password) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) return false;

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _handleAuthException(e);
      notifyListeners();
      return false;
    }
  }

  // DELETE ACCOUNT
  Future<bool> deleteAccount() async {
    try {
      await _user?.delete();
      _user = null;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _handleAuthException(e);
      notifyListeners();
      return false;
    }
  }

  // COMPREHENSIVE EXCEPTION HANDLER
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
      
      // ============ PHONE AUTH ERRORS ============
      case 'invalid-phone-number':
        return 'The phone number format is invalid.';
      
      case 'missing-phone-number':
        return 'Please provide a phone number.';
      
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again later.';
      
      case 'captcha-check-failed':
        return 'reCAPTCHA verification failed. Please try again.';
      
      case 'invalid-verification-code':
        return 'The verification code is invalid.';
      
      case 'invalid-verification-id':
        return 'The verification ID is invalid.';
      
      case 'session-expired':
        return 'The SMS code has expired. Please request a new one.';
      
      // ============ MULTI-FACTOR AUTH ERRORS ============
      case 'multi-factor-auth-required':
        return 'Multi-factor authentication is required.';
      
      case 'invalid-multi-factor-session':
        return 'Invalid multi-factor session.';
      
      case 'missing-multi-factor-info':
        return 'Multi-factor information is missing.';
      
      case 'maximum-second-factor-count-exceeded':
        return 'Maximum number of second factors exceeded.';
      
      // ============ ADMIN & SECURITY ERRORS ============
      case 'admin-restricted-operation':
        return 'This operation is restricted to administrators only.';
      
      case 'app-not-authorized':
        return 'This app is not authorized to use Firebase Authentication.';
      
      case 'app-not-installed':
        return 'The requested app is not installed.';
      
      case 'internal-error':
        return 'An internal error occurred. Please try again.';
      
      // ============ DEFAULT ============
      default:
        if (kDebugMode) {
          print('Unhandled Firebase Auth Exception: ${e.code} - ${e.message}');
        }
        return 'An error occurred: ${e.message ?? 'Please try again.'}';
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

// ============================================
// USAGE EXAMPLE IN LOGIN SCREEN
// ============================================

/* 
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      // Navigation will be handled by AuthGuard
      // context.router.replaceAll([const HomeRoute()]);
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Login failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Navigate to forgot password screen
                },
                child: const Text('Forgot Password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 */
// ============================================
// PASSWORD VALIDATION HELPER
// ============================================

class PasswordValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    
    return null;
  }
  
  static bool isStrong(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }
}