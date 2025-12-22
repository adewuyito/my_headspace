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
      _errorMessage = AuthExceptions.handleAuthException(e);
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

      final credential = await _authRepo.signupUserWithEmail(
        email: email,
        password: password,
      );

      if (credential != null) {
        final userDataProvider = serviceLocator.getIt<CreateAccountProvider>();
        final userData = userDataProvider.userData;

        await _authRepo.updateUser(data: userData, userid: credential.uid);
      }

      _authState = AuthState(
        result: AuthResult.authSuccess,
        isLoading: false,
        userId: credential?.uid,
      );
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 100));

      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = AuthExceptions.handleAuthException(e);
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

  Future<void> logOutUser() async {
    _authState = AuthState.unknown();
    _user = null;
    _errorMessage = null;
    await _authRepo.logOut();
    notifyListeners();
  }
}
