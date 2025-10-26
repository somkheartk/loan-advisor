import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<bool> execute(String email, String password, String name) {
    return repository.register(email, password, name);
  }
}
