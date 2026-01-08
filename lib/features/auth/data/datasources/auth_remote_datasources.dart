import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_headspace/features/auth/data/models/user_data_model.dart';

class AuthRemoteDatasources {
  AuthRemoteDatasources();

  final FirebaseAuth authInstance = FirebaseAuth.instance;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  Future<void> saveUserDataAfterLogin(UserData data, UserId userid) async {
    try {
      await firestoreInstance
          .collection(FirebaseCollectionName.userCollection)
          .doc(userid)
          .set(data.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  // ~ Login User
  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await authInstance.signInWithEmailAndPassword(
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
      return await authInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // ~ Logout User
  Future<void> logOut() async {
    await authInstance.signOut();
  }
}

typedef UserId = String;
