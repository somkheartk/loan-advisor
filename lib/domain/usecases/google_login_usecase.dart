import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GoogleLoginUseCase {
  final AuthRepository repository;

  GoogleLoginUseCase(this.repository);

  Future<User?> execute() {
    return repository.loginWithGoogle();
  }
}
