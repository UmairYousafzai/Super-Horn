import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/firebase_repository_impl.dart';
import '../../../domain/repositories/firebase_repository.dart';

final firebaseRepositoryProvider = Provider<FirebaseRepository>((ref) {
  return FirebaseAuthRepositoryImpl(
      FirebaseAuth.instance, FirebaseFirestore.instance);
});
