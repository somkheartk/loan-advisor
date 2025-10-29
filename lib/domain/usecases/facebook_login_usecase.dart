import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class FacebookLoginUseCase {
  final AuthRepository repository;

  FacebookLoginUseCase(this.repository);

  Future<User?> execute() {
    return repository.loginWithFacebook();
  }
}
