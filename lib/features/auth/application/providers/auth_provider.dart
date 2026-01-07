import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:my_headspace/core/utils/auth_exceptions.dart';
import 'package:my_headspace/features/auth/application/enums/auth_results.dart';
import 'package:my_headspace/features/auth/application/providers/create_account_provider.dart';
import 'package:my_headspace/features/auth/domain/repository/auth_repository.dart';
import 'package:my_headspace/service/service_locator.dart';

class AuthProvider extends ChangeNotifier {
  AuthState _authState = AuthState.unknown();
  final AuthRepository _authRepo;
  final CreateAccountProvider _userData;
  final FirebaseAuth _firebaseAuth;
  String? _errorMessage;

  User? _user;

  bool get isLoading => _authState.isLoading;
  String? get userId => _user?.uid;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;

  AuthProvider({
    AuthRepository? authRepo,
    CreateAccountProvider? userDataProvider,
    FirebaseAuth? firebaseAuth,
  }) : _authRepo = authRepo ?? AuthRepository(),
       _userData =
           userDataProvider ?? serviceLocator.getIt<CreateAccountProvider>(),
       _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    _firebaseAuth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> loginUserWithEmail(String email, String password) async {
    try {
      _errorMessage = null;
      _authState = _authState.copyWith(isLoading: true);
      notifyListeners();

      final user = await _authRepo.loginUserWithEmail(
        email: email,
        password: password,
      );

      // Wait for the authStateChanges stream to emit the new user state
      if (user != null) {
        // Wait for _user to be set by the authStateChanges listener
        await _waitForAuthStateUpdate(user.uid);

        _authState = _authState.copyWith(
          result: AuthResult.authSuccess,
          isLoading: false,
          userId: user.uid,
        );
      }

      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = AuthExceptions.handleAuthException(e);
      _authState = _authState.copyWith(isLoading: false);
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _authState = _authState.copyWith(isLoading: false);
      notifyListeners();
      return false;
    }
  }

  /// Waits for the authStateChanges stream to update the _user field
  /// This ensures isAuthenticated returns true before navigation occurs
  Future<void> _waitForAuthStateUpdate(String expectedUserId) async {
    // If _user is already set with the correct ID, return immediately
    if (_user?.uid == expectedUserId) return;

    // Wait for up to 3 seconds for the auth state to update
    const maxWaitTime = Duration(seconds: 3);
    const checkInterval = Duration(milliseconds: 50);
    final startTime = DateTime.now();

    while (_user?.uid != expectedUserId) {
      if (DateTime.now().difference(startTime) > maxWaitTime) {
        // Timeout - force update from current user
        _user = _firebaseAuth.currentUser;
        break;
      }
      await Future.delayed(checkInterval);
    }
  }

  Future<bool> signupUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      _errorMessage = null;
      _authState = _authState.copyWith(isLoading: true);
      notifyListeners();

      final credential = await _authRepo.signupUserWithEmail(
        email: email,
        password: password,
      );

      if (credential != null) {
        final userDataProvider = serviceLocator.getIt<CreateAccountProvider>();
        final userData = userDataProvider.userData;

        await _authRepo.updateUser(data: userData, userid: credential.uid);

        // Wait for the authStateChanges stream to emit the new user state
        await _waitForAuthStateUpdate(credential.uid);
      }

      _authState = AuthState(
        result: AuthResult.authSuccess,
        isLoading: false,
        userId: credential?.uid,
      );
      notifyListeners();

      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = AuthExceptions.handleAuthException(e);
      _authState = _authState.copyWith(isLoading: false);
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _authState = _authState.copyWith(isLoading: false);
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
}
