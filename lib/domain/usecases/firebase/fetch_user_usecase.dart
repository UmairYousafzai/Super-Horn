import '../../../data/models/local/user_model.dart';
import '../../repositories/firebase_repository.dart';

class FetchUserUseCase {
  final FirebaseRepository firebaseRepository;

  FetchUserUseCase(this.firebaseRepository);

  Future<UserModel> execute() {
    return firebaseRepository.fetchUserFromBackend();
  }
}
