import '../../repositories/firebase_repository.dart';

class LoginUseCase {
  final FirebaseRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<void> execute(String email, String password) async {
    await _authRepository.signInWithEmailPassword(email, password);
  }
}
