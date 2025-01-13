import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../domain/repositories/firebase_repository.dart';
import '../models/local/user_model.dart';

class FirebaseAuthRepositoryImpl implements FirebaseRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthRepositoryImpl(this._firebaseAuth, this._firestore);

  @override
  Future<void> signUpWithEmailPassword(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("Error in signUpWithEmailPassword: ${e.message}");
      }
      throw e; // Re-throw the error to handle it in the notifier
    }
  }

  @override
  Future<void> signInWithEmailPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("Error in signInWithEmailPassword: ${e.message}");
      }
      throw e; // Re-throw the error to handle it in the notifier
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("Error in signOut: ${e.toString()}");
      }
      throw e; // Re-throw the error to handle it in the notifier
    }
  }

  @override
  bool isUserLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  @override
  Future<void> saveUserToBackend(UserModel user) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception("No authenticated user found");
    await _firestore.collection("users").doc(userId).set(user.toJson());
  }

  @override
  Future<UserModel> fetchUserFromBackend() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception("No authenticated user found");
    final doc = await _firestore.collection("users").doc(userId).get();
    if (!doc.exists) throw Exception("User not found");
    return UserModel.fromJson(doc.data()!);
  }
}
