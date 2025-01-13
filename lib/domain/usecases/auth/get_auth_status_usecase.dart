import '../../repositories/firebase_repository.dart';

class GetAuthStatusUseCase {
  final FirebaseRepository _authRepository;

  GetAuthStatusUseCase(this._authRepository);

  bool execute() {
    return _authRepository.isUserLoggedIn();
  }
}
