import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_headspace/features/auth/application/enums/auth_results.dart';
import 'package:my_headspace/features/auth/domain/repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthState _authState = AuthState.unknown();
  final AuthRepository _authRepo;

  User? _user;

  bool get isLoading => _authState.isLoading;
  String? get userId => _user?.uid;
  bool get isAuthenticated => _user != null;

  AuthProvider(this._authRepo) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> loginUserWithEmail(String email, String password) async {
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
  }

  Future<void> signupUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
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
  }

  Future<void> logOutUser() async {
    _authState = AuthState.unknown();
    await _authRepo.logOut();
  }
}
