import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:my_headspace/core/utils/auth_exceptions.dart';
import 'package:my_headspace/features/auth/application/enums/auth_results.dart';
import 'package:my_headspace/features/auth/application/providers/create_account_provider.dart';
import 'package:my_headspace/features/auth/domain/repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthState _authState = AuthState.unknown();
  final AuthRepository _authRepo;
  final CreateAccountProvider _userData;
  final FirebaseAuth _firebaseAuth;
  String? _errorMessage;

  Stream<AuthState> get user =>
      _firebaseAuth.authStateChanges().map(_userFromFirebase);

  bool get isLoading => _authState.isLoading;
  String? get userId => _authState.userId;
  bool get isAuthenticated => _authState.result == AuthResult.authSuccess;
  String? get errorMessage => _errorMessage;

  AuthProvider({
    required AuthRepository authRepo,
    required CreateAccountProvider userDataProvider,
    required FirebaseAuth firebaseAuth,
  }) : _authRepo = authRepo,
       _userData = userDataProvider,
       _firebaseAuth = firebaseAuth {
    _firebaseAuth.authStateChanges().listen(onAuthStateChanged);
  }

  AuthState _userFromFirebase(User? user) {
    if (user == null) {
      return AuthState.unknown();
    }

    return AuthState(
      result: AuthResult.authSuccess,
      isLoading: false,
      userId: user.uid,
    );
  }

  Future<void> onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _authState = AuthState.unknown();
    } else {
      _authState = _userFromFirebase(firebaseUser);
    }
    notifyListeners();
  }

  Future<bool> loginUserWithEmail(String email, String password) async {
    try {
      _errorMessage = null;
      _authState = _authState.copyWith(isLoading: true);
      notifyListeners();

      await _authRepo.loginUserWithEmail(email: email, password: password);

      _authState = _authState.copyWith(isLoading: false);
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
        final userData = _userData.userData;

        await _authRepo.updateUser(data: userData, userid: credential.uid);
      }

      _authState = _authState.copyWith(isLoading: false);
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
    _errorMessage = null;
    await _authRepo.logOut();
    notifyListeners();
  }
}
