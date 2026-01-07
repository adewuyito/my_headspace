import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_headspace/features/auth/application/enums/auth_results.dart';
import 'package:my_headspace/features/auth/data/datasources/auth_remote_datasources.dart';
import 'package:my_headspace/features/auth/data/models/user_data_model.dart';

class AuthRepository {
  AuthRepository() : _authRemoteDatasources = AuthRemoteDatasources();

  final AuthRemoteDatasources _authRemoteDatasources;

  Future<void> updateUser({
    required UserData data,
    required UserId userid,
  }) async {
    try {
      await _authRemoteDatasources.saveUserDataAfterLogin(data, userid);
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> loginUserWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCred;
      userCred = await _authRemoteDatasources.loginWithEmail(
        email: email,
        password: password,
      );

      return userCred.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signupUserWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCred;
      userCred = await _authRemoteDatasources.signupWithEmail(
        email: email,
        password: password,
      );

      return userCred.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    await _authRemoteDatasources.logOut();
  }
}

class AuthState {
  final AuthResult result;
  final bool isLoading;
  final UserId? userId;

  const AuthState({
    required this.result,
    required this.isLoading,
    required this.userId,
  });

  // ~ Initial Unknown State
  AuthState.unknown()
    : result = AuthResult.authunknown,
      isLoading = false,
      userId = null;

  AuthState copyWith({AuthResult? result, UserId? userId, bool? isLoading}) =>
      AuthState(
        result: result ?? this.result,
        isLoading: isLoading ?? this.isLoading,
        userId: userId ?? this.userId,
      );

  @override
  bool operator ==(covariant AuthState other) =>
      identical(this, other) ||
      (result == other.result &&
          isLoading == other.isLoading &&
          userId == other.userId);

  @override
  int get hashCode => Object.hash(result, isLoading, userId);
}
