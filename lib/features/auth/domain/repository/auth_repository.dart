import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_headspace/features/auth/application/enums/auth_results.dart';
import 'package:my_headspace/features/auth/data/datasources/auth_remote_datasources.dart';

class AuthRepository {
  AuthRepository() : _authRemoteDatasources = AuthRemoteDatasources();

  final AuthRemoteDatasources _authRemoteDatasources;

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
    } catch (_) {}
    return null;
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
    } catch (_) {}
    return null;
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

  // ~ Initiate Loading
  AuthState copiedWithIsLoading(bool isLoading) =>
      AuthState(result: result, isLoading: isLoading, userId: userId);

  @override
  bool operator ==(covariant AuthState other) =>
      identical(this, other) ||
      (result == other.result &&
          isLoading == other.isLoading &&
          userId == other.userId);

  @override
  int get hashCode => Object.hash(result, isLoading, userId);
}
