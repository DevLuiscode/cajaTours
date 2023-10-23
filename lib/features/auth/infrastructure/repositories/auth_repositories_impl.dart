import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

import '../../domain/domain.dart';

class AuthRepositoriesImpl extends AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoriesImpl({
    AuthDataSource? dataSource,
  }) : dataSource = dataSource ?? AuthDataSourceImple();

  @override
  Future<User> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return dataSource.login(email, password);
  }

  @override
  Future<User> register(String name, String lastName, String email,
      String password, String confirPassword) {
    return dataSource.register(name, lastName, email, password, confirPassword);
  }
}
