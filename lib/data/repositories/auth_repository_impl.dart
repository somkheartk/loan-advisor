import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local_data_source.dart';
import '../datasources/social_auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalDataSource dataSource;
  final SocialAuthDataSource socialAuthDataSource;

  AuthRepositoryImpl(this.dataSource, this.socialAuthDataSource);

  @override
  Future<bool> register(String email, String password, String name) {
    return dataSource.saveUser(email, password, name);
  }

  @override
  Future<bool> login(String email, String password) {
    return dataSource.authenticateUser(email, password);
  }

  @override
  Future<User?> loginWithGoogle() async {
    final userData = await socialAuthDataSource.signInWithGoogle();
    if (userData == null) return null;

    // Save the social user to local storage
    await dataSource.saveUser(
      userData['email']!,
      'social_auth_${userData['provider']}',
      userData['name']!,
    );

    // Set as current user
    await dataSource.authenticateUser(
      userData['email']!,
      'social_auth_${userData['provider']}',
    );

    return User(
      email: userData['email']!,
      name: userData['name']!,
    );
  }

  @override
  Future<User?> loginWithFacebook() async {
    final userData = await socialAuthDataSource.signInWithFacebook();
    if (userData == null) return null;

    // Save the social user to local storage
    await dataSource.saveUser(
      userData['email']!,
      'social_auth_${userData['provider']}',
      userData['name']!,
    );

    // Set as current user
    await dataSource.authenticateUser(
      userData['email']!,
      'social_auth_${userData['provider']}',
    );

    return User(
      email: userData['email']!,
      name: userData['name']!,
    );
  }

  @override
  Future<User?> loginWithApple() async {
    final userData = await socialAuthDataSource.signInWithApple();
    if (userData == null) return null;

    // Save the social user to local storage
    await dataSource.saveUser(
      userData['email']!,
      'social_auth_${userData['provider']}',
      userData['name']!,
    );

    // Set as current user
    await dataSource.authenticateUser(
      userData['email']!,
      'social_auth_${userData['provider']}',
    );

    return User(
      email: userData['email']!,
      name: userData['name']!,
    );
  }

  @override
  Future<void> logout() async {
    await socialAuthDataSource.signOut();
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
