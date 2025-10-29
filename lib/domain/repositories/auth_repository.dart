import '../entities/user.dart';

abstract class AuthRepository {
  Future<bool> register(String email, String password, String name);
  Future<bool> login(String email, String password);
  Future<User?> loginWithGoogle();
  Future<User?> loginWithFacebook();
  Future<User?> loginWithApple();
  Future<void> logout();
  Future<User?> getCurrentUser();
}
