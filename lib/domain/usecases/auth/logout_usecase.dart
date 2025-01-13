import '../../repositories/firebase_repository.dart';

class LogoutUseCase {
  final FirebaseRepository _authRepository;

  LogoutUseCase(this._authRepository);

  Future<void> execute() async {
    await _authRepository.signOut();
  }
}
