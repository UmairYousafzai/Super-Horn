import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/firebase/fetch_user_usecase.dart';
import '../../domain/usecases/firebase/save_user_usecase.dart';
import 'firebase_provider.dart';

final saveUserUseCaseProvider = Provider<SaveUserUseCase>((ref) {
  final repository = ref.watch(firebaseRepositoryProvider);
  return SaveUserUseCase(repository);
});

final fetchUserUseCaseProvider = Provider<FetchUserUseCase>((ref) {
  final repository = ref.watch(firebaseRepositoryProvider);
  return FetchUserUseCase(repository);
});
