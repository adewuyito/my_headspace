import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDatasources {
  AuthRemoteDatasources();

  final FirebaseAuth firebaseInstance = FirebaseAuth.instance;

  // ~ Login User
  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await firebaseInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // ~ Create user
  Future<UserCredential> signupWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await firebaseInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // ~ Logout User
  Future<void> logOut() async {
    await firebaseInstance.signOut();
  }
}

typedef UserId = String;
