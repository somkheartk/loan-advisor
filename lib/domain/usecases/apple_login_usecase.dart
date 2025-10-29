import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class AppleLoginUseCase {
  final AuthRepository repository;

  AppleLoginUseCase(this.repository);

  Future<User?> execute() {
    return repository.loginWithApple();
  }
}
