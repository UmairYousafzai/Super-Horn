import '../../repositories/firebase_repository.dart';

class SignUpUseCase {
  final FirebaseRepository _authRepository;

  SignUpUseCase(this._authRepository);

  Future<void> execute(String email, String password) async {
    await _authRepository.signUpWithEmailPassword(email, password);
  }
}
