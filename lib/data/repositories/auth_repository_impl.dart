import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<bool> register(String email, String password, String name) {
    return dataSource.saveUser(email, password, name);
  }

  @override
  Future<bool> login(String email, String password) {
    return dataSource.authenticateUser(email, password);
  }

  @override
  Future<void> logout() {
    return dataSource.clearCurrentUser();
  }

  @override
  Future<User?> getCurrentUser() async {
    final userData = await dataSource.getCurrentUser();
    if (userData == null) return null;
    
    return User(
      email: userData['email']!,
      name: userData['name']!,
    );
  }
}
