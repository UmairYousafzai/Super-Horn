import '../../../data/models/local/user_model.dart';
import '../../repositories/firebase_repository.dart';

class SaveUserUseCase {
  final FirebaseRepository firebaseRepository;

  SaveUserUseCase(this.firebaseRepository);

  Future<void> execute(UserModel user) {
    return firebaseRepository.saveUserToBackend(user);
  }
}
